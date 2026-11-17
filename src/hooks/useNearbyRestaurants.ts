/**
 * useNearbyRestaurants
 * --------------------
 * Master hook that orchestrates:
 *   location → Google Places → HomeBite partner matching → combined result
 */

import { useState, useEffect, useCallback, useRef } from 'react';
import { useApp } from '../context/AppContext';
import { searchNearbyRestaurants, NearbyRestaurant } from '../services/placesService';
import { getHomeBitePartners, HomeBitePartner, PartnerMenuItem } from '../services/restaurantPartnerService';
import { haversineKm } from '../lib/geoService';
import type { LatLon } from '../lib/geoService';

export interface CombinedRestaurant extends NearbyRestaurant {
  isHomeBitePartner: boolean;
  partnerData?: HomeBitePartner;
  menuItems?: PartnerMenuItem[];
}

export interface UseNearbyRestaurantsReturn {
  restaurants: CombinedRestaurant[];
  isLoading: boolean;
  error: string | null;
  needsApiKey: boolean;
  locationDenied: boolean;
  refresh: () => void;
  radiusMeters: number;
  setRadiusMeters: (r: number) => void;
}

const DEFAULT_RADIUS = 5000; // 5 km

export function useNearbyRestaurants(): UseNearbyRestaurantsReturn {
  const { userCoords } = useApp();

  const [restaurants, setRestaurants] = useState<CombinedRestaurant[]>([]);
  const [isLoading, setIsLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [needsApiKey, setNeedsApiKey] = useState(false);
  const [locationDenied, setLocationDenied] = useState(false);
  const [radiusMeters, setRadiusMeters] = useState(DEFAULT_RADIUS);
  const [refreshTick, setRefreshTick] = useState(0);

  // Track last fetched coords to avoid duplicate calls within 100m
  const lastFetchedCoords = useRef<LatLon | null>(null);
  const lastFetchedRadius = useRef<number | null>(null);

  // Cache: coords key → result
  const cache = useRef<Map<string, CombinedRestaurant[]>>(new Map());

  const fetchRestaurants = useCallback(async (coords: LatLon, radius: number) => {
    // Debounce: skip if coords haven't moved more than ~100m AND radius is the same
    if (lastFetchedCoords.current && lastFetchedRadius.current === radius) {
      const distMoved = haversineKm(lastFetchedCoords.current, coords) * 1000; // metres
      if (distMoved < 100) return;
    }

    const cacheKey = `${coords.lat.toFixed(4)},${coords.lon.toFixed(4)},${radius}`;
    if (cache.current.has(cacheKey)) {
      setRestaurants(cache.current.get(cacheKey)!);
      lastFetchedCoords.current = coords;
      lastFetchedRadius.current = radius;
      return;
    }

    setIsLoading(true);
    setError(null);
    setNeedsApiKey(false);

    try {
      // 1. Fetch nearby restaurants from Google Places (via backend proxy)
      const { restaurants: nearby, error: placesError } = await searchNearbyRestaurants(
        coords.lat,
        coords.lon,
        radius
      );

      if (placesError) {
        if (placesError.needsKey) {
          setNeedsApiKey(true);
          setError('Google Places API key not configured. Restaurant discovery is unavailable.');
        } else {
          setError(placesError.message);
        }
        setIsLoading(false);
        return;
      }

      // 2. Extract place IDs and check which are HomeBite partners
      const placeIds = nearby.map((r) => r.placeId).filter(Boolean);
      const partners = await getHomeBitePartners(placeIds);

      const partnerMap = new Map<string, HomeBitePartner>();
      for (const p of partners) {
        partnerMap.set(p.googlePlaceId, p);
      }

      // 3. Merge: combine place data with partner data
      const combined: CombinedRestaurant[] = nearby.map((restaurant) => {
        const partner = partnerMap.get(restaurant.placeId);
        return {
          ...restaurant,
          isHomeBitePartner: Boolean(partner),
          partnerData: partner,
          menuItems: partner?.menuItems,
        };
      });

      // 4. Sort: HomeBite partners first, then by distance
      combined.sort((a, b) => {
        if (a.isHomeBitePartner && !b.isHomeBitePartner) return -1;
        if (!a.isHomeBitePartner && b.isHomeBitePartner) return 1;
        return a.distanceKm - b.distanceKm;
      });

      cache.current.set(cacheKey, combined);
      lastFetchedCoords.current = coords;
      lastFetchedRadius.current = radius;
      setRestaurants(combined);
    } catch (err: any) {
      setError(err?.message || 'Failed to load nearby restaurants');
    } finally {
      setIsLoading(false);
    }
  }, []);

  useEffect(() => {
    if (!userCoords) {
      // If navigator.geolocation exists but no coords yet, it may still be loading
      // We detect location denial separately via AppContext's detectAndSetLocation
      return;
    }

    fetchRestaurants(userCoords, radiusMeters);
  }, [userCoords, radiusMeters, refreshTick, fetchRestaurants]);

  // If userCoords is null and geolocation is not supported or denied
  useEffect(() => {
    if (!userCoords && typeof navigator !== 'undefined' && !navigator.geolocation) {
      setLocationDenied(true);
    }
  }, [userCoords]);

  const refresh = useCallback(() => {
    // Bust cache for current coords and re-fetch
    if (userCoords) {
      const cacheKey = `${userCoords.lat.toFixed(4)},${userCoords.lon.toFixed(4)},${radiusMeters}`;
      cache.current.delete(cacheKey);
    }
    lastFetchedCoords.current = null;
    setRefreshTick((t) => t + 1);
  }, [userCoords, radiusMeters]);

  const handleSetRadiusMeters = useCallback((r: number) => {
    // Bust cache so new radius triggers a fresh fetch
    lastFetchedRadius.current = null;
    setRadiusMeters(r);
  }, []);

  return {
    restaurants,
    isLoading,
    error,
    needsApiKey,
    locationDenied,
    refresh,
    radiusMeters,
    setRadiusMeters: handleSetRadiusMeters,
  };
}

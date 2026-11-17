/**
 * HomeBite Places Service
 * -----------------------
 * Secure wrapper around the backend proxy for Google Places API.
 * NEVER call Google Places directly — always go through /api/places/nearby
 */
import { haversineKm } from '../lib/geoService';
const API_BASE = 'http://localhost:5000';
export async function searchNearbyRestaurants(lat, lon, radiusMeters) {
    try {
        const res = await fetch(`${API_BASE}/api/places/nearby`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ lat, lon, radiusMeters }),
        });
        const data = await res.json();
        if (!res.ok || !data.success) {
            const error = {
                message: data.error || 'Failed to fetch nearby restaurants',
                needsKey: data.needsKey === true,
            };
            return { restaurants: [], error };
        }
        const userLatLon = { lat, lon };
        const restaurants = (data.places || []).map((place) => {
            const placeLat = place.location?.latitude ?? 0;
            const placeLon = place.location?.longitude ?? 0;
            const distanceKm = haversineKm(userLatLon, { lat: placeLat, lon: placeLon });
            return {
                placeId: place.id ?? '',
                name: place.displayName?.text ?? place.displayName ?? '',
                address: place.formattedAddress ?? '',
                lat: placeLat,
                lon: placeLon,
                rating: place.rating ?? null,
                userRatingCount: place.userRatingCount ?? null,
                googleMapsUri: place.googleMapsUri ?? null,
                photoName: place.photos?.[0]?.name ?? null,
                distanceKm: Number(distanceKm.toFixed(2)),
            };
        });
        // Sort by distance ascending
        restaurants.sort((a, b) => a.distanceKm - b.distanceKm);
        return { restaurants, error: null };
    }
    catch (err) {
        return {
            restaurants: [],
            error: { message: err?.message || 'Network error — is the server running?' },
        };
    }
}
export async function locationAutocomplete(query) {
    if (!query || query.trim().length < 2)
        return [];
    try {
        const res = await fetch(`${API_BASE}/api/places/autocomplete?q=${encodeURIComponent(query.trim())}`);
        const data = await res.json();
        if (!res.ok || !data.success)
            return [];
        return (data.results || []).map((r) => ({
            displayName: r.displayName,
            lat: Number(r.lat),
            lon: Number(r.lon),
        }));
    }
    catch {
        return [];
    }
}

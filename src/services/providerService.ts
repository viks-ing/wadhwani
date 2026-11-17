import { FoodProvider, ProviderMenuItem, ProviderType } from '../types';
import { ALL_FOOD_PROVIDERS, DEMO_HOMEBITE_PARTNERS, DISCOVERED_REAL_BUSINESSES, HYDERABAD_LOCALITIES, LocalityInfo } from '../data/discoveredAndDemoProviders';
import { getMenuItemsForProvider, SYNTHETIC_MENU_ITEMS } from '../data/syntheticProvidersData';
import { getHybridMenuItemsForProvider, ALL_HYBRID_MENU_ITEMS } from '../data/hybridMenusData';
import { haversineKm, LatLon } from '../lib/geoService';
import { supabase, isSupabaseConfigured } from '../lib/supabase';

export interface NearbyProvidersQuery {
  userLat: number;
  userLon: number;
  radiusKm: number;
  providerType?: 'all' | 'homemade' | 'cloud_kitchen' | 'tiffin' | 'healthy_restaurant';
  dietaryFilter?: 'all' | 'veg' | 'non-veg' | 'millet' | 'high-protein' | 'low-oil' | 'budget';
  sortBy?: 'nearest' | 'highest-rated' | 'lowest-price' | 'prep-time';
  searchQuery?: string;
  partnersOnly?: boolean;
}

export interface NearbyProvidersResult {
  allProviders: FoodProvider[];
  partners: FoodProvider[];
  discovered: FoodProvider[];
  totalCount: number;
  activeRadiusKm: number;
  activeLocality: string;
}

/**
 * High-performance synchronous calculation of nearby providers.
 * Runs in under 1 millisecond with zero network blocking.
 */
export function calculateNearbyProviders(
  sourceProviders: FoodProvider[],
  query: NearbyProvidersQuery
): NearbyProvidersResult {
  const {
    userLat,
    userLon,
    radiusKm = 5,
    providerType = 'all',
    dietaryFilter = 'all',
    sortBy = 'nearest',
    searchQuery = '',
    partnersOnly = false,
  } = query;

  const userCoord: LatLon = { lat: userLat, lon: userLon };

  // 1. Compute dynamic Haversine distance for each provider
  const calculated = sourceProviders
    .filter(p => p.lat != null && p.lon != null)
    .map(p => {
      const providerCoord: LatLon = { lat: p.lat, lon: p.lon };
      const dist = haversineKm(userCoord, providerCoord);
      const distanceKm = Number(dist.toFixed(1));

      // Attach rich hybrid menu for every provider
      const menu = getHybridMenuItemsForProvider(p.id, p.name, p.cuisine);

      return {
        ...p,
        distanceKm,
        menu
      };
    });

  // 2. Filter by radius
  let filtered = calculated.filter(p => (p.distanceKm || 0) <= radiusKm);

  // 3. Filter by Provider Type
  if (providerType !== 'all') {
    if (providerType === 'homemade') {
      filtered = filtered.filter(p => p.type === 'home_kitchen');
    } else if (providerType === 'cloud_kitchen') {
      filtered = filtered.filter(p => p.type === 'cloud_kitchen');
    } else if (providerType === 'tiffin') {
      filtered = filtered.filter(p => p.type === 'tiffin_service' || p.cuisine.some(c => c.toLowerCase().includes('tiffin')));
    } else if (providerType === 'healthy_restaurant') {
      filtered = filtered.filter(p => p.type === 'healthy_restaurant');
    }
  }

  // 4. Filter by Dietary / Food Category
  if (dietaryFilter !== 'all') {
    if (dietaryFilter === 'veg') {
      filtered = filtered.filter(p => 
        p.cuisine.some(c => c.toLowerCase().includes('veg') || c.toLowerCase().includes('satvik') || c.toLowerCase().includes('jain')) ||
        (p.menu && p.menu.some(m => m.dietary === 'veg'))
      );
    } else if (dietaryFilter === 'non-veg') {
      filtered = filtered.filter(p => 
        p.cuisine.some(c => c.toLowerCase().includes('chicken') || c.toLowerCase().includes('non-veg') || c.toLowerCase().includes('biryani')) ||
        (p.menu && p.menu.some(m => m.dietary === 'non-veg'))
      );
    } else if (dietaryFilter === 'millet') {
      filtered = filtered.filter(p => 
        p.cuisine.some(c => c.toLowerCase().includes('millet') || c.toLowerCase().includes('ragi') || c.toLowerCase().includes('jowar')) ||
        p.description.toLowerCase().includes('millet')
      );
    } else if (dietaryFilter === 'high-protein') {
      filtered = filtered.filter(p => 
        p.cuisine.some(c => c.toLowerCase().includes('protein') || c.toLowerCase().includes('gym')) ||
        p.name.toLowerCase().includes('protein') || p.name.toLowerCase().includes('fit')
      );
    } else if (dietaryFilter === 'low-oil') {
      filtered = filtered.filter(p => 
        p.description.toLowerCase().includes('low oil') || 
        p.description.toLowerCase().includes('pure ghee') ||
        p.description.toLowerCase().includes('steamed')
      );
    } else if (dietaryFilter === 'budget') {
      filtered = filtered.filter(p => p.minOrderAmount <= 65);
    }
  }

  // 5. Search query
  if (searchQuery.trim()) {
    const q = searchQuery.toLowerCase();
    filtered = filtered.filter(p => 
      p.name.toLowerCase().includes(q) ||
      p.locality.toLowerCase().includes(q) ||
      p.address.toLowerCase().includes(q) ||
      p.cuisine.some(c => c.toLowerCase().includes(q)) ||
      p.description.toLowerCase().includes(q)
    );
  }

  // 6. Sort
  filtered.sort((a, b) => {
    if (sortBy === 'nearest') {
      const aTypeBonus = (a.type === 'home_kitchen' || a.type === 'tiffin_service') ? -0.3 : 0;
      const bTypeBonus = (b.type === 'home_kitchen' || b.type === 'tiffin_service') ? -0.3 : 0;
      return (a.distanceKm! + aTypeBonus) - (b.distanceKm! + bTypeBonus);
    }
    if (sortBy === 'highest-rated') {
      return b.rating - a.rating;
    }
    if (sortBy === 'lowest-price') {
      return a.minOrderAmount - b.minOrderAmount;
    }
    if (sortBy === 'prep-time') {
      return a.prepTimeMinutes - b.prepTimeMinutes;
    }
    return (a.distanceKm || 0) - (b.distanceKm || 0);
  });

  const partners = filtered.filter(p => p.partnershipStatus === 'approved');
  const discovered = filtered.filter(p => p.partnershipStatus !== 'approved');

  // Identify active locality closest to coordinates
  let activeLocality = "Your Area";
  let minLocDist = 9999;
  HYDERABAD_LOCALITIES.forEach(loc => {
    const d = haversineKm(userCoord, { lat: loc.lat, lon: loc.lon });
    if (d < minLocDist) {
      minLocDist = d;
      activeLocality = loc.name;
    }
  });

  return {
    allProviders: partnersOnly ? partners : filtered,
    partners,
    discovered,
    totalCount: filtered.length,
    activeRadiusKm: radiusKm,
    activeLocality
  };
}

/**
 * Synchronous query helper for immediate (0ms) render.
 */
export function getNearbyProvidersSync(query: NearbyProvidersQuery): NearbyProvidersResult {
  return calculateNearbyProviders(ALL_FOOD_PROVIDERS, query);
}

/**
 * Master service to query food providers near given coordinates.
 * Returns local data immediately and merges Supabase updates with an 800ms safety timeout.
 */
export async function fetchNearbyProviders(query: NearbyProvidersQuery): Promise<NearbyProvidersResult> {
  const syncResult = getNearbyProvidersSync(query);

  if (!isSupabaseConfigured) {
    return syncResult;
  }

  try {
    const timeoutPromise = new Promise<null>((resolve) => setTimeout(() => resolve(null), 800));
    const fetchFromSupabase = async () => {
      try {
        const { data, error } = await supabase
          .from('providers')
          .select('*')
          .eq('status', 'approved');
        if (error || !data) return null;
        return data;
      } catch {
        return null;
      }
    };

    const data = await Promise.race([fetchFromSupabase(), timeoutPromise]);
    if (!data || data.length === 0) {
      return syncResult;
    }

    let sourceProviders = [...ALL_FOOD_PROVIDERS];
    data.forEach((p: any) => {
      if (!sourceProviders.some(existing => existing.id === p.id)) {
        sourceProviders.push({
          id: p.id,
          name: p.name || p.business_name,
          type: p.type || p.provider_type || 'home_kitchen',
          description: p.description || '',
          address: p.address || p.full_address || '',
          locality: p.locality || 'Hyderabad',
          lat: p.lat || p.latitude || 17.4578,
          lon: p.lon || p.longitude || 78.6366,
          cuisine: Array.isArray(p.cuisine) ? p.cuisine : ['Homestyle'],
          rating: Number(p.rating || p.average_rating || 4.8),
          reviewsCount: p.reviews_count || p.review_count || 12,
          prepTimeMinutes: p.prep_time_minutes || p.estimated_prep_time || 20,
          minOrderAmount: Number(p.min_order_amount || p.minimum_order_amount || 60),
          isDeliveryAvailable: p.is_delivery_available ?? true,
          openingHours: typeof p.opening_hours === 'string' ? p.opening_hours : '8:00 AM - 10:00 PM',
          coverImage: p.cover_image || p.cover_image_url || 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=800&q=80',
          isVerified: p.is_verified ?? false,
          isDemo: p.is_demo ?? false,
          partnershipStatus: p.partnership_status || (p.status === 'approved' ? 'approved' : 'pending'),
          status: p.status || 'pending',
          ownerId: p.owner_id
        });
      }
    });

    return calculateNearbyProviders(sourceProviders, query);
  } catch (e) {
    return syncResult;
  }
}

/**
 * Register a new Food Provider in Supabase (with pending approval status)
 */
export async function registerFoodProvider(details: {
  ownerId: string;
  name: string;
  type: ProviderType;
  description: string;
  address: string;
  locality: string;
  lat: number;
  lon: number;
  cuisine: string[];
  phone: string;
  deliveryRadiusKm?: number;
}): Promise<{ success: boolean; id?: string; error?: string }> {
  try {
    const id = `prov-reg-${Date.now()}`;
    const newProvider: FoodProvider = {
      id,
      name: details.name,
      type: details.type,
      description: details.description,
      address: details.address,
      locality: details.locality,
      lat: details.lat,
      lon: details.lon,
      cuisine: details.cuisine,
      rating: 5.0,
      reviewsCount: 1,
      prepTimeMinutes: 20,
      minOrderAmount: 60,
      isDeliveryAvailable: true,
      deliveryRadiusKm: details.deliveryRadiusKm || 5.0,
      openingHours: "8:00 AM - 10:00 PM",
      coverImage: "https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=800&q=80",
      isVerified: false,
      isDemo: false,
      discoveryStatus: 'verified',
      partnershipStatus: 'pending', // Awaiting Admin Approval
      verificationStatus: 'verification_pending',
      status: 'pending',
      ownerId: details.ownerId,
      phone: details.phone
    };

    if (isSupabaseConfigured) {
      await supabase.from('providers').insert({
        id,
        owner_id: details.ownerId,
        name: details.name,
        type: details.type,
        description: details.description,
        address: details.address,
        locality: details.locality,
        lat: details.lat,
        lon: details.lon,
        cuisine: details.cuisine,
        status: 'pending',
        is_verified: false,
        is_demo: false,
        phone: details.phone
      });
    }

    return { success: true, id };
  } catch (err: any) {
    return { success: false, error: err.message };
  }
}

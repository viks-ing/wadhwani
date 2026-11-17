/**
 * HomeBite Restaurant Partner Service
 * ------------------------------------
 * Checks which Google Place IDs are registered HomeBite partners in Supabase.
 * Falls back gracefully if the Supabase tables don't exist yet.
 */

import { supabase } from '../lib/supabase';

export interface HomeBitePartner {
  id: string;
  googlePlaceId: string;
  businessName: string;
  businessAddress: string;
  status: 'pending' | 'approved' | 'rejected';
  ownerId: string;
  menuItems?: PartnerMenuItem[];
}

export interface PartnerMenuItem {
  id: string;
  name: string;
  description: string;
  price: number;
  imageUrl: string | null;
  category: string;
  isAvailable: boolean;
}

export interface RegisterRestaurantData {
  googlePlaceId: string;
  businessName: string;
  businessAddress: string;
  ownerName: string;
  ownerEmail: string;
  ownerPhone: string;
  fssaiLicenseNumber?: string;
}

/**
 * Returns approved HomeBite partner records for the given Google Place IDs.
 * Returns [] if the Supabase table doesn't exist yet or on any error.
 */
export async function getHomeBitePartners(placeIds: string[]): Promise<HomeBitePartner[]> {
  if (!placeIds.length) return [];

  try {
    const { data: restaurants, error } = await supabase
      .from('restaurants')
      .select('*')
      .in('google_place_id', placeIds)
      .eq('status', 'approved');

    if (error) {
      // Table may not exist yet — fail silently
      console.warn('[HomeBite] restaurants table not ready:', error.message);
      return [];
    }

    if (!restaurants || restaurants.length === 0) return [];

    // Fetch menu items for all approved partners in one query
    const restaurantIds = restaurants.map((r: any) => r.id);
    const { data: menuItems, error: menuError } = await supabase
      .from('menu_items')
      .select('*')
      .in('restaurant_id', restaurantIds)
      .eq('is_available', true);

    if (menuError) {
      console.warn('[HomeBite] menu_items table not ready:', menuError.message);
    }

    const menuByRestaurantId = new Map<string, PartnerMenuItem[]>();
    for (const item of menuItems || []) {
      const list = menuByRestaurantId.get(item.restaurant_id) || [];
      list.push({
        id: item.id,
        name: item.name,
        description: item.description ?? '',
        price: Number(item.price),
        imageUrl: item.image_url ?? null,
        category: item.category ?? 'Main Course',
        isAvailable: item.is_available ?? true,
      });
      menuByRestaurantId.set(item.restaurant_id, list);
    }

    return restaurants.map((r: any): HomeBitePartner => ({
      id: r.id,
      googlePlaceId: r.google_place_id,
      businessName: r.business_name,
      businessAddress: r.business_address,
      status: r.status as 'pending' | 'approved' | 'rejected',
      ownerId: r.owner_id,
      menuItems: menuByRestaurantId.get(r.id) || [],
    }));
  } catch (err) {
    console.warn('[HomeBite] getHomeBitePartners error:', err);
    return [];
  }
}

/**
 * Fetches the menu items for a specific HomeBite restaurant.
 */
export async function getRestaurantMenu(restaurantId: string): Promise<PartnerMenuItem[]> {
  try {
    const { data, error } = await supabase
      .from('menu_items')
      .select('*')
      .eq('restaurant_id', restaurantId)
      .eq('is_available', true)
      .order('category', { ascending: true });

    if (error) {
      console.warn('[HomeBite] getRestaurantMenu error:', error.message);
      return [];
    }

    return (data || []).map((item: any): PartnerMenuItem => ({
      id: item.id,
      name: item.name,
      description: item.description ?? '',
      price: Number(item.price),
      imageUrl: item.image_url ?? null,
      category: item.category ?? 'Main Course',
      isAvailable: item.is_available ?? true,
    }));
  } catch (err) {
    console.warn('[HomeBite] getRestaurantMenu catch:', err);
    return [];
  }
}

/**
 * Registers a restaurant as a HomeBite partner (creates a pending application).
 */
export async function registerRestaurant(
  data: RegisterRestaurantData
): Promise<{ success: boolean; error?: string }> {
  try {
    const { error } = await supabase.from('restaurants').insert({
      google_place_id: data.googlePlaceId,
      business_name: data.businessName,
      business_address: data.businessAddress,
      owner_name: data.ownerName,
      owner_email: data.ownerEmail,
      owner_phone: data.ownerPhone,
      fssai_license_number: data.fssaiLicenseNumber ?? null,
      status: 'pending',
    });

    if (error) {
      return { success: false, error: error.message };
    }

    return { success: true };
  } catch (err: any) {
    return { success: false, error: err?.message || 'Unknown error' };
  }
}

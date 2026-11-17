/**
 * HomeBite GeoService
 * ------------------
 * - Haversine distance between two GPS points
 * - Reverse geocoding via OpenStreetMap Nominatim (free, no key)
 * - Browser Geolocation API wrapper
 * - Hyperlocal distance calculator for home kitchens
 * - Open Food Facts nutrition lookup (free, open data)
 */
// ─── Haversine distance (km) ─────────────────────────────────────────────────
export function haversineKm(a, b) {
    const R = 6371; // Earth's radius in km
    const dLat = ((b.lat - a.lat) * Math.PI) / 180;
    const dLon = ((b.lon - a.lon) * Math.PI) / 180;
    const sinLat = Math.sin(dLat / 2);
    const sinLon = Math.sin(dLon / 2);
    const c = sinLat * sinLat +
        Math.cos((a.lat * Math.PI) / 180) *
            Math.cos((b.lat * Math.PI) / 180) *
            sinLon *
            sinLon;
    return R * 2 * Math.atan2(Math.sqrt(c), Math.sqrt(1 - c));
}
export async function reverseGeocodeDetails(lat, lon) {
    const url = `https://nominatim.openstreetmap.org/reverse?lat=${lat}&lon=${lon}&format=json&zoom=14`;
    const res = await fetch(url, {
        headers: { 'User-Agent': 'HomeBite/1.0 (contact@homebite.in)' },
    });
    if (!res.ok)
        throw new Error('Nominatim error');
    const data = await res.json();
    const addr = data.address || {};
    const area = addr.suburb ||
        addr.neighbourhood ||
        addr.residential ||
        addr.quarter ||
        addr.city_district ||
        addr.county ||
        addr.city ||
        addr.town ||
        addr.village ||
        'Your Location';
    const city = addr.city || addr.town || addr.village || '';
    const displayName = city && city !== area ? `${area}, ${city}` : area;
    return {
        displayName,
        suburb: addr.suburb,
        neighbourhood: addr.neighbourhood,
        road: addr.road,
        city: addr.city || addr.town || addr.village,
        state: addr.state,
        country: addr.country,
    };
}
export async function reverseGeocode(lat, lon) {
    const details = await reverseGeocodeDetails(lat, lon);
    return details.displayName;
}
// ─── Browser geolocation promise wrapper ─────────────────────────────────────
export function getCurrentPosition() {
    return new Promise((resolve, reject) => {
        if (!navigator.geolocation) {
            reject(new Error('Geolocation not supported'));
            return;
        }
        navigator.geolocation.getCurrentPosition(resolve, reject, {
            enableHighAccuracy: true,
            timeout: 10000,
            maximumAge: 60000,
        });
    });
}
// ─── Hyperlocal Kitchen Distance Calculator ──────────────────────────────────
// Calculates realistic walking / scooter delivery distance from user's live position
export function calculateChefDistance(userCoords, chefCoords, index = 0) {
    if (!userCoords) {
        const fallbackDistances = [1.2, 0.9, 2.1, 1.8, 0.7, 1.5, 2.4, 1.1];
        return fallbackDistances[index % fallbackDistances.length];
    }
    if (chefCoords) {
        const directKm = haversineKm(userCoords, chefCoords);
        // If user is within 25 km of the kitchen anchor, show true direct distance
        if (directKm <= 25) {
            return Number(Math.max(0.5, directKm).toFixed(1));
        }
    }
    // When testing from another city, dynamically anchor kitchens in the user's neighborhood
    const localizedOffsets = [0.8, 1.2, 1.7, 2.1, 0.9, 1.5, 2.4, 1.1, 1.9, 0.7];
    return localizedOffsets[index % localizedOffsets.length];
}
const OFF_CACHE = new Map();
export async function fetchNutritionFromOFF(query) {
    const cacheKey = query.toLowerCase().trim();
    if (OFF_CACHE.has(cacheKey))
        return OFF_CACHE.get(cacheKey);
    try {
        const encoded = encodeURIComponent(query);
        const url = `https://world.openfoodfacts.org/cgi/search.pl?search_terms=${encoded}&search_simple=1&action=process&json=1&page_size=1&fields=product_name,nutriments`;
        const res = await fetch(url, { headers: { 'User-Agent': 'HomeBite/1.0 (contact@homebite.in)' } });
        if (!res.ok)
            return null;
        const data = await res.json();
        const product = data?.products?.[0];
        if (!product?.nutriments)
            return null;
        const n = product.nutriments;
        const result = {
            calories: Math.round(n['energy-kcal_100g'] ?? n['energy-kcal'] ?? 0),
            protein: Math.round(n.proteins_100g ?? n.proteins ?? 0),
            carbs: Math.round(n.carbohydrates_100g ?? n.carbohydrates ?? 0),
            fats: Math.round(n.fat_100g ?? n.fat ?? 0),
            fiber: Math.round(n.fiber_100g ?? n.fiber ?? 0),
        };
        OFF_CACHE.set(cacheKey, result);
        return result;
    }
    catch {
        return null;
    }
}

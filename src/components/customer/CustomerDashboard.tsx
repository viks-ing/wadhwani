import React, { useState, useEffect, useMemo, useCallback } from 'react';
import { useApp } from '../../context/AppContext';
import { FoodProvider } from '../../types';
import { fetchNearbyProviders, getNearbyProvidersSync, NearbyProvidersResult } from '../../services/providerService';
import { LocationSelector } from './LocationSelector';
import { RadiusFilter } from './RadiusFilter';
import { FoodProviderCard } from './FoodProviderCard';
import { 
  Search, 
  MapPin, 
  Star, 
  Clock, 
  ShieldCheck, 
  Flame, 
  ArrowUpDown,
  Filter,
  Sparkles,
  RefreshCw,
  Compass,
  CheckCircle2,
  AlertCircle
} from 'lucide-react';

export const CustomerDashboard: React.FC = () => {
  const { currentCampus, userCoords, setUserCoords, setCurrentCampus, isLocating, addToast } = useApp();

  // Selected Location (defaulting to SNIST Yamnampet if not yet set)
  const activeLat = userCoords?.lat ?? 17.4578;
  const activeLon = userCoords?.lon ?? 78.6366;

  // Filters State
  const [selectedRadiusKm, setSelectedRadiusKm] = useState<number>(5);
  const [providerType, setProviderType] = useState<'all' | 'homemade' | 'cloud_kitchen' | 'tiffin' | 'healthy_restaurant'>('all');
  const [dietaryFilter, setDietaryFilter] = useState<'all' | 'veg' | 'non-veg' | 'millet' | 'high-protein' | 'low-oil' | 'budget'>('all');
  const [sortBy, setSortBy] = useState<'nearest' | 'highest-rated' | 'lowest-price' | 'prep-time'>('nearest');
  const [searchQuery, setSearchQuery] = useState('');
  const [showPartnersOnly, setShowPartnersOnly] = useState(false);

  // Data Result State - Initialized synchronously for instant (0ms) feed render
  const [isLoading, setIsLoading] = useState(false);
  const [providersData, setProvidersData] = useState<NearbyProvidersResult>(() => {
    return getNearbyProvidersSync({
      userLat: activeLat,
      userLon: activeLon,
      radiusKm: selectedRadiusKm,
      providerType,
      dietaryFilter,
      sortBy,
      searchQuery,
      partnersOnly: showPartnersOnly
    });
  });

  // Default campus initialization
  useEffect(() => {
    if (!currentCampus) {
      setCurrentCampus("SNIST Campus, Yamnampet");
      setUserCoords({ lat: 17.4578, lon: 78.6366 });
    }
  }, [currentCampus, setCurrentCampus, setUserCoords]);

  // Load nearby providers dynamically whenever coordinates, radius, or filters change
  const loadProviders = useCallback(async () => {
    // 1. Instant synchronous update (zero-lag 60fps response)
    const syncRes = getNearbyProvidersSync({
      userLat: activeLat,
      userLon: activeLon,
      radiusKm: selectedRadiusKm,
      providerType,
      dietaryFilter,
      sortBy,
      searchQuery,
      partnersOnly: showPartnersOnly
    });
    setProvidersData(syncRes);

    // 2. Background check if Supabase has newly registered approved providers
    try {
      const res = await fetchNearbyProviders({
        userLat: activeLat,
        userLon: activeLon,
        radiusKm: selectedRadiusKm,
        providerType,
        dietaryFilter,
        sortBy,
        searchQuery,
        partnersOnly: showPartnersOnly
      });
      setProvidersData(res);
    } catch (err) {
      // Graceful fallback
    }
  }, [activeLat, activeLon, selectedRadiusKm, providerType, dietaryFilter, sortBy, searchQuery, showPartnersOnly]);

  useEffect(() => {
    loadProviders();
  }, [loadProviders]);

  const displayedProviders = useMemo(() => {
    if (!providersData) return [];
    return providersData.allProviders;
  }, [providersData]);

  const partnersCount = providersData?.partners.length || 0;
  const discoveredCount = providersData?.discovered.length || 0;

  return (
    <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8 space-y-8 animate-fadeIn">
      
      {/* Location & Delivery Hub Banner */}
      <div className="bg-gradient-to-r from-hb-green-800 via-hb-green-700 to-hb-green-900 rounded-3xl p-6 sm:p-8 text-white shadow-soft relative overflow-hidden">
        <div className="absolute top-0 right-0 -mr-16 -mt-16 w-72 h-72 rounded-full bg-white/10 pointer-events-none filter blur-2xl"></div>

        <div className="relative z-10 flex flex-col lg:flex-row lg:items-center justify-between gap-6">
          <div className="space-y-3">
            <div className="inline-flex items-center gap-2 px-3.5 py-1.5 rounded-full bg-white/20 backdrop-blur-md text-white text-xs font-semibold">
              <MapPin className="w-3.5 h-3.5 text-hb-orange flex-shrink-0" />
              <span>Current Delivery Zone: <strong className="text-amber-200">{currentCampus || "SNIST Campus, Yamnampet"}</strong></span>
            </div>

            <h1 className="text-2xl sm:text-3xl lg:text-4xl font-black font-display tracking-tight leading-tight">
              Homemade Food & Cloud Kitchens Near You
            </h1>

            <p className="text-xs sm:text-sm text-hb-cream-200 max-w-2xl leading-relaxed">
              Discover authentic home cooks, tiffin services, and healthy food providers within {selectedRadiusKm} km of your campus. Hot, wholesome, hygienic, and pocket-friendly meals.
            </p>
          </div>

          {/* Quick Metrics Capsule */}
          <div className="flex items-center gap-4 bg-white/10 backdrop-blur-md p-4 rounded-2xl border border-white/20 flex-shrink-0">
            <div className="text-center px-2">
              <span className="text-[11px] text-hb-cream-300 block font-semibold">In {selectedRadiusKm} km</span>
              <span className="text-2xl font-black text-white">{displayedProviders.length}</span>
              <span className="text-[10px] text-hb-cream-300 block">Providers</span>
            </div>
            <div className="w-px h-10 bg-white/20"></div>
            <div className="text-center px-2">
              <span className="text-[11px] text-hb-cream-300 block font-semibold">HomeBite</span>
              <span className="text-2xl font-black text-emerald-300">{partnersCount}</span>
              <span className="text-[10px] text-hb-cream-300 block">Partners</span>
            </div>
            <div className="w-px h-10 bg-white/20"></div>
            <div className="text-center px-2">
              <span className="text-[11px] text-hb-cream-300 block font-semibold">Discovered</span>
              <span className="text-2xl font-black text-amber-300">{discoveredCount}</span>
              <span className="text-[10px] text-hb-cream-300 block">Candidates</span>
            </div>
          </div>
        </div>
      </div>

      {/* Control Station: Location Selector & Radius Filter */}
      <div className="bg-white rounded-3xl p-5 border border-hb-green-100 shadow-soft space-y-4">
        
        {/* Row 1: Location Dropdown + Search + Sort */}
        <div className="flex flex-col lg:flex-row items-stretch lg:items-center justify-between gap-3">
          
          {/* Location Selector Dropdown */}
          <div className="flex-shrink-0">
            <LocationSelector />
          </div>

          {/* Search Bar */}
          <div className="relative flex-1">
            <Search className="w-4 h-4 text-gray-400 absolute left-3.5 top-1/2 -translate-y-1/2" />
            <input
              type="text"
              value={searchQuery}
              onChange={(e) => setSearchQuery(e.target.value)}
              placeholder="Search Rajma, Millets, High Protein, Harini, Sreenidhi Tiffins..."
              className="w-full pl-10 pr-4 py-2.5 rounded-2xl border border-gray-200 text-xs sm:text-sm focus:border-hb-green-500 focus:ring-1 focus:ring-hb-green-500 outline-none text-gray-800 bg-gray-50/50"
            />
          </div>

          {/* Sort Dropdown */}
          <div className="flex items-center gap-1.5 flex-shrink-0">
            <ArrowUpDown className="w-3.5 h-3.5 text-gray-400 hidden sm:block" />
            <select
              value={sortBy}
              onChange={(e) => setSortBy(e.target.value as any)}
              className="w-full sm:w-auto text-xs py-2.5 px-3 rounded-2xl border border-gray-200 bg-gray-50/50 text-gray-700 outline-none font-bold"
            >
              <option value="nearest">Sort: Nearest First (Default)</option>
              <option value="highest-rated">Sort: Highest Rated</option>
              <option value="lowest-price">Sort: Lowest Price</option>
              <option value="prep-time">Sort: Fastest Preparation</option>
            </select>
          </div>
        </div>

        {/* Row 2: Search Radius Filter */}
        <div className="pt-2 border-t border-gray-100 flex flex-col sm:flex-row items-start sm:items-center justify-between gap-3">
          <RadiusFilter
            selectedRadiusKm={selectedRadiusKm}
            onRadiusChange={(km) => {
              setSelectedRadiusKm(km);
              addToast(`🔍 Search radius set to ${km} km`, 'info');
            }}
          />

          {/* HomeBite Partners Only Toggle */}
          <div className="flex items-center gap-2 bg-gray-50 p-1.5 rounded-xl border border-gray-200/80 flex-shrink-0">
            <button
              type="button"
              onClick={() => setShowPartnersOnly(false)}
              className={`px-3 py-1 rounded-lg text-xs font-bold transition ${
                !showPartnersOnly ? 'bg-white text-gray-900 shadow-2xs' : 'text-gray-500 hover:text-gray-800'
              }`}
            >
              All Providers ({providersData?.totalCount || 0})
            </button>
            <button
              type="button"
              onClick={() => setShowPartnersOnly(true)}
              className={`px-3 py-1 rounded-lg text-xs font-bold transition flex items-center gap-1 ${
                showPartnersOnly ? 'bg-hb-green-600 text-white shadow-2xs' : 'text-gray-500 hover:text-hb-green-700'
              }`}
            >
              <ShieldCheck className="w-3.5 h-3.5" />
              <span>Partners Only ({partnersCount})</span>
            </button>
          </div>
        </div>

        {/* Row 3: Provider Type Tabs */}
        <div className="pt-2 border-t border-gray-100 flex items-center gap-2 overflow-x-auto pb-1 scrollbar-none">
          <button
            onClick={() => setProviderType('all')}
            className={`px-3.5 py-2 rounded-xl text-xs font-bold transition flex items-center gap-1.5 flex-shrink-0 ${
              providerType === 'all'
                ? 'bg-gray-900 text-white shadow-sm'
                : 'bg-gray-50 hover:bg-gray-100 text-gray-700 border border-gray-200'
            }`}
          >
            <span>🍽️</span>
            <span>All Providers</span>
          </button>

          <button
            onClick={() => setProviderType('homemade')}
            className={`px-3.5 py-2 rounded-xl text-xs font-bold transition flex items-center gap-1.5 flex-shrink-0 ${
              providerType === 'homemade'
                ? 'bg-emerald-700 text-white shadow-sm'
                : 'bg-emerald-50/60 hover:bg-emerald-100 text-emerald-900 border border-emerald-200'
            }`}
          >
            <span>🏡</span>
            <span>Home Kitchens</span>
          </button>

          <button
            onClick={() => setProviderType('cloud_kitchen')}
            className={`px-3.5 py-2 rounded-xl text-xs font-bold transition flex items-center gap-1.5 flex-shrink-0 ${
              providerType === 'cloud_kitchen'
                ? 'bg-indigo-700 text-white shadow-sm'
                : 'bg-indigo-50/60 hover:bg-indigo-100 text-indigo-900 border border-indigo-200'
            }`}
          >
            <span>☁️</span>
            <span>Cloud Kitchens</span>
          </button>

          <button
            onClick={() => setProviderType('tiffin')}
            className={`px-3.5 py-2 rounded-xl text-xs font-bold transition flex items-center gap-1.5 flex-shrink-0 ${
              providerType === 'tiffin'
                ? 'bg-amber-600 text-white shadow-sm'
                : 'bg-amber-50/60 hover:bg-amber-100 text-amber-900 border border-amber-200'
            }`}
          >
            <span>🍲</span>
            <span>Tiffin Services</span>
          </button>

          <button
            onClick={() => setProviderType('healthy_restaurant')}
            className={`px-3.5 py-2 rounded-xl text-xs font-bold transition flex items-center gap-1.5 flex-shrink-0 ${
              providerType === 'healthy_restaurant'
                ? 'bg-teal-700 text-white shadow-sm'
                : 'bg-teal-50/60 hover:bg-teal-100 text-teal-900 border border-teal-200'
            }`}
          >
            <span>🥗</span>
            <span>Healthy Restaurants</span>
          </button>
        </div>

        {/* Row 4: Dietary / Nutrition Quick Filters */}
        <div className="flex items-center gap-2 overflow-x-auto pb-1 scrollbar-none text-xs">
          <span className="text-[10px] font-bold text-gray-500 uppercase tracking-wider flex-shrink-0">
            Dietary:
          </span>

          {[
            { key: 'all', label: 'All Diets' },
            { key: 'veg', label: '🌱 Veg Only' },
            { key: 'non-veg', label: '🍗 Non-Veg' },
            { key: 'millet', label: '🌾 Millet Meals' },
            { key: 'high-protein', label: '💪 High Protein' },
            { key: 'low-oil', label: '🥗 Low Oil & Sattvic' },
            { key: 'budget', label: '💰 Student Pocket (< ₹65)' },
          ].map((d) => (
            <button
              key={d.key}
              onClick={() => setDietaryFilter(d.key as any)}
              className={`px-2.5 py-1 rounded-lg text-xs font-semibold transition flex-shrink-0 ${
                dietaryFilter === d.key
                  ? 'bg-hb-green-700 text-white shadow-xs'
                  : 'bg-gray-100 hover:bg-gray-200 text-gray-700'
              }`}
            >
              {d.label}
            </button>
          ))}
        </div>

      </div>

      {/* Results Header */}
      <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-2">
        <div>
          <h2 className="text-xl sm:text-2xl font-black text-gray-900 flex items-center gap-2 font-display">
            <span>Discovered Food Providers</span>
            <span className="px-2.5 py-0.5 rounded-full bg-hb-cream text-hb-green-800 text-xs font-bold border border-hb-green-200">
              {displayedProviders.length} Nearby
            </span>
          </h2>
          <p className="text-xs text-gray-500 mt-0.5">
            Showing food providers within <strong>{selectedRadiusKm} km</strong> of <strong>{currentCampus || "SNIST Campus"}</strong>.
          </p>
        </div>

        <button
          onClick={loadProviders}
          className="self-start sm:self-auto px-3 py-1.5 rounded-xl border border-gray-200 hover:border-hb-green-500 bg-white text-gray-700 hover:text-hb-green-700 text-xs font-bold transition flex items-center gap-1.5 shadow-xs"
        >
          <RefreshCw className={`w-3.5 h-3.5 ${isLoading ? 'animate-spin text-hb-green-600' : ''}`} />
          <span>Refresh Feed</span>
        </button>
      </div>

      {/* Main Grid View */}
      {isLoading && displayedProviders.length === 0 ? (
        /* Loading Skeleton */
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6">
          {[1, 2, 3, 4, 5, 6].map((n) => (
            <div key={n} className="bg-white rounded-3xl border border-gray-200 p-4 space-y-3 animate-pulse">
              <div className="h-44 bg-gray-200 rounded-2xl w-full"></div>
              <div className="h-4 bg-gray-200 rounded-md w-3/4"></div>
              <div className="h-3 bg-gray-200 rounded-md w-1/2"></div>
              <div className="h-10 bg-gray-100 rounded-xl w-full"></div>
            </div>
          ))}
        </div>
      ) : displayedProviders.length === 0 ? (
        /* Empty State */
        <div className="bg-white rounded-3xl p-12 text-center border border-hb-green-100 shadow-soft max-w-lg mx-auto space-y-4">
          <div className="w-16 h-16 rounded-3xl bg-hb-cream text-hb-green-700 flex items-center justify-center text-3xl mx-auto shadow-sm">
            🔍
          </div>
          <div>
            <h3 className="text-lg font-bold text-gray-900">
              No food providers found within {selectedRadiusKm} km
            </h3>
            <p className="text-xs text-gray-500 mt-1 max-w-sm mx-auto">
              Try expanding your search radius to <strong>10 km</strong> or <strong>15 km</strong>, or select a different locality like <strong>Ghatkesar Town</strong> or <strong>Uppal</strong>.
            </p>
          </div>
          <div className="flex flex-wrap items-center justify-center gap-2 pt-2">
            <button
              onClick={() => setSelectedRadiusKm(10)}
              className="px-4 py-2 bg-hb-green-600 hover:bg-hb-green-700 text-white font-bold rounded-xl text-xs transition"
            >
              Expand to 10 km Radius
            </button>
            <button
              onClick={() => {
                setProviderType('all');
                setDietaryFilter('all');
                setSearchQuery('');
                setShowPartnersOnly(false);
              }}
              className="px-4 py-2 border border-gray-300 text-gray-700 hover:bg-gray-50 font-bold rounded-xl text-xs transition"
            >
              Reset Filters
            </button>
          </div>
        </div>
      ) : (
        /* Providers Cards Grid */
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6">
          {displayedProviders.map((provider) => (
            <FoodProviderCard key={provider.id} provider={provider} />
          ))}
        </div>
      )}

      {/* Transparent Information Footer */}
      <div className="bg-hb-cream/60 rounded-3xl p-6 border border-hb-green-100 text-xs text-gray-600 space-y-2">
        <div className="flex items-center gap-2 font-black text-hb-green-900">
          <ShieldCheck className="w-4 h-4 text-hb-green-600" />
          <span>HomeBite Location Discovery & Verification Standard</span>
        </div>
        <p className="leading-relaxed">
          HomeBite clearly separates <strong>Approved HomeBite Partners</strong> (verified home kitchens with active menu ordering and delivery) from <strong>Discovered Local Candidates</strong> (real local businesses identified in Telangana research). Only approved partners can receive online orders.
        </p>
      </div>

    </div>
  );
};

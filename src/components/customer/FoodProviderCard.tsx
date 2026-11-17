import React, { useState } from 'react';
import { FoodProvider, ProviderMenuItem, Meal } from '../../types';
import { useApp } from '../../context/AppContext';
import { 
  Star, 
  MapPin, 
  Clock, 
  ShieldCheck, 
  Plus, 
  Check, 
  ChevronDown, 
  ChevronUp, 
  ExternalLink, 
  Info,
  Flame,
  Sparkles,
  ShoppingBag
} from 'lucide-react';

interface FoodProviderCardProps {
  provider: FoodProvider;
}

export const FoodProviderCard: React.FC<FoodProviderCardProps> = ({ provider }) => {
  const { addToCart, currentCampus, addToast } = useApp();
  const [isMenuExpanded, setIsMenuExpanded] = useState(false);
  const [addedItemIds, setAddedItemIds] = useState<Record<string, boolean>>({});

  const isPartner = provider.partnershipStatus === 'approved';

  // Helper to map ProviderMenuItem to HomeBite Cart Meal
  const handleAddItemToCart = (item: ProviderMenuItem) => {
    if (!isPartner) {
      addToast('Ordering is only available for verified HomeBite partners.', 'warning');
      return;
    }

    const meal: Meal = {
      id: item.id,
      chefId: provider.id,
      chefName: provider.name,
      chefAvatar: '',
      kitchenName: provider.name,
      isChefVerified: provider.isVerified,
      name: item.name,
      description: item.description,
      category: item.category,
      dietary: item.dietary,
      price: item.price,
      originalPrice: Math.round(item.price * 1.25),
      rating: provider.rating,
      reviewsCount: provider.reviewsCount,
      prepTimeMinutes: provider.prepTimeMinutes,
      imageUrl: item.imageUrl,
      ingredients: item.tags,
      nutrition: {
        calories: item.calories || 450,
        protein: item.protein || 15,
        carbs: 55,
        fats: 10,
        fiber: 5,
      },
      isAvailable: item.isAvailable,
      tags: item.tags,
      spiceLevel: 'Medium',
      servingSize: '1 Portion',
      campusDistanceKm: provider.distanceKm || 1.2,
    };

    addToCart(meal, 1);
    setAddedItemIds(prev => ({ ...prev, [item.id]: true }));
    setTimeout(() => {
      setAddedItemIds(prev => ({ ...prev, [item.id]: false }));
    }, 1800);
  };

  const getProviderTypeBadge = (type: string) => {
    switch (type) {
      case 'home_kitchen':
        return { label: '🏡 Home Kitchen', color: 'bg-emerald-700 text-white' };
      case 'cloud_kitchen':
        return { label: '☁️ Cloud Kitchen', color: 'bg-indigo-700 text-white' };
      case 'tiffin_service':
        return { label: '🍲 Tiffin Service', color: 'bg-amber-600 text-white' };
      case 'healthy_restaurant':
        return { label: '🥗 Healthy Restaurant', color: 'bg-teal-700 text-white' };
      default:
        return { label: '🍽️ Food Provider', color: 'bg-gray-700 text-white' };
    }
  };

  const typeBadge = getProviderTypeBadge(provider.type);

  return (
    <div className={`bg-white rounded-3xl border transition-all duration-300 overflow-hidden flex flex-col justify-between group shadow-soft hover:shadow-card ${
      isPartner ? 'border-hb-green-200' : 'border-gray-200/80 bg-gray-50/20'
    }`}>
      <div>
        
        {/* Cover Image & Badges */}
        <div className="relative h-48 overflow-hidden bg-gray-100">
          <img
            src={provider.coverImage}
            alt={provider.name}
            className="w-full h-full object-cover group-hover:scale-105 transition-transform duration-500"
          />

          {/* Top Badges */}
          <div className="absolute top-3 left-3 flex flex-wrap items-center gap-1.5">
            <span className={`px-2.5 py-1 rounded-xl text-[10px] font-black shadow-sm ${typeBadge.color}`}>
              {typeBadge.label}
            </span>

            {isPartner ? (
              <span className="px-2.5 py-1 rounded-xl bg-hb-green-600 text-white text-[10px] font-extrabold flex items-center gap-1 shadow-sm">
                <ShieldCheck className="w-3 h-3 text-emerald-200" />
                <span>HomeBite Partner</span>
              </span>
            ) : (
              <span className="px-2.5 py-1 rounded-xl bg-gray-900/85 backdrop-blur-md text-amber-200 text-[10px] font-bold flex items-center gap-1 shadow-sm">
                <Info className="w-3 h-3" />
                <span>Discovered Candidate</span>
              </span>
            )}
          </div>

          {/* Rating */}
          <div className="absolute top-3 right-3 bg-white/95 backdrop-blur px-2.5 py-1 rounded-xl text-xs font-black text-gray-900 flex items-center gap-1 shadow-sm">
            <Star className="w-3.5 h-3.5 text-amber-500 fill-amber-500" />
            <span>{provider.rating.toFixed(1)}</span>
            <span className="text-[10px] text-gray-400 font-normal">({provider.reviewsCount})</span>
          </div>

          {/* Distance Pill */}
          <div className="absolute bottom-3 left-3 bg-black/75 backdrop-blur-md text-white text-[10px] font-semibold px-2.5 py-1 rounded-lg flex items-center gap-1.5 shadow-sm">
            <MapPin className="w-3 h-3 text-hb-orange" />
            <span>
              <strong>{provider.distanceKm} km</strong> from {currentCampus ? currentCampus.split(',')[0].trim() : 'SNIST'}
            </span>
          </div>

          {/* Prep Time Pill */}
          <div className="absolute bottom-3 right-3 bg-black/75 backdrop-blur-md text-white text-[10px] font-semibold px-2.5 py-1 rounded-lg flex items-center gap-1 shadow-sm">
            <Clock className="w-3 h-3 text-emerald-400" />
            <span>~{provider.prepTimeMinutes} mins</span>
          </div>
        </div>

        {/* Content Body */}
        <div className="p-5 space-y-3">
          
          <div>
            <div className="flex items-start justify-between gap-2">
              <h3 className="text-base font-extrabold text-gray-900 group-hover:text-hb-green-700 transition leading-snug">
                {provider.name}
              </h3>
            </div>
            <p className="text-xs text-gray-500 flex items-center gap-1 mt-0.5">
              <MapPin className="w-3 h-3 text-gray-400 flex-shrink-0" />
              <span className="truncate">{provider.address}</span>
            </p>
          </div>

          <p className="text-xs text-gray-600 line-clamp-2 leading-relaxed">
            {provider.description}
          </p>

          {/* Cuisine Pills */}
          <div className="flex flex-wrap items-center gap-1">
            {provider.cuisine.map((c, i) => (
              <span key={i} className="px-2 py-0.5 rounded-lg bg-hb-cream text-hb-green-800 text-[10px] font-semibold border border-hb-green-100">
                {c}
              </span>
            ))}
          </div>

        </div>
      </div>

      {/* Card Footer & Ordering Action */}
      <div className="p-5 pt-0">
        
        {isPartner ? (
          /* PARTNER: ORDERING AVAILABLE */
          <div className="space-y-3 pt-3 border-t border-gray-100">
            <div className="flex items-center justify-between">
              <div>
                <span className="text-[10px] text-gray-500 uppercase tracking-wider block font-bold">
                  Starts From
                </span>
                <span className="text-base font-black text-gray-900">
                  ₹{provider.minOrderAmount}
                </span>
              </div>

              <button
                type="button"
                onClick={() => setIsMenuExpanded(!isMenuExpanded)}
                className="px-3 py-1.5 rounded-xl bg-hb-green-50 text-hb-green-700 hover:bg-hb-green-100 text-xs font-bold transition flex items-center gap-1.5"
              >
                <span>{isMenuExpanded ? 'Hide Menu' : `View Menu (${provider.menu?.length || 4})`}</span>
                {isMenuExpanded ? <ChevronUp className="w-3.5 h-3.5" /> : <ChevronDown className="w-3.5 h-3.5" />}
              </button>
            </div>

            {/* Expandable Menu Items */}
            {isMenuExpanded && provider.menu && (
              <div className="space-y-2 pt-2 border-t border-hb-green-100 animate-fadeIn">
                <div className="text-[10px] font-black text-hb-green-800 uppercase tracking-wider">
                  Available Homemade Dishes
                </div>

                <div className="space-y-2">
                  {provider.menu.map((item) => {
                    const isAdded = addedItemIds[item.id];

                    return (
                      <div
                        key={item.id}
                        className="p-2.5 rounded-2xl bg-hb-cream/40 border border-hb-green-100 flex items-center justify-between gap-3 hover:bg-hb-cream/80 transition"
                      >
                        <div className="flex items-center gap-2.5 min-w-0">
                          <img
                            src={item.imageUrl}
                            alt={item.name}
                            className="w-12 h-12 rounded-xl object-cover flex-shrink-0"
                          />
                          <div className="min-w-0">
                            <div className="flex items-center gap-1.5 truncate">
                              <span className={`w-2 h-2 rounded-full flex-shrink-0 ${
                                item.dietary === 'veg' ? 'bg-emerald-500' : 'bg-rose-500'
                              }`}></span>
                              <span className="text-xs font-bold text-gray-900 truncate">
                                {item.name}
                              </span>
                            </div>

                            <div className="flex items-center gap-2 mt-0.5 text-[10px] text-gray-500">
                              <span className="font-extrabold text-gray-900">₹{item.price}</span>
                              {item.protein && (
                                <>
                                  <span>•</span>
                                  <span className="text-emerald-700 font-bold">{item.protein}g protein</span>
                                </>
                              )}
                              {item.calories && (
                                <>
                                  <span>•</span>
                                  <span>{item.calories} kcal</span>
                                </>
                              )}
                            </div>
                          </div>
                        </div>

                        <button
                          type="button"
                          onClick={() => handleAddItemToCart(item)}
                          className={`px-3 py-1.5 rounded-xl text-xs font-black transition flex items-center gap-1 flex-shrink-0 ${
                            isAdded
                              ? 'bg-emerald-600 text-white'
                              : 'bg-hb-green-600 hover:bg-hb-green-700 text-white shadow-xs'
                          }`}
                        >
                          {isAdded ? (
                            <>
                              <Check className="w-3.5 h-3.5" />
                              <span>Added</span>
                            </>
                          ) : (
                            <>
                              <Plus className="w-3.5 h-3.5" />
                              <span>Add</span>
                            </>
                          )}
                        </button>
                      </div>
                    );
                  })}
                </div>
              </div>
            )}
          </div>
        ) : (
          /* NON-PARTNER: EXTERNAL DISCOVERY LISTING */
          <div className="space-y-2 pt-3 border-t border-gray-100">
            <div className="p-2.5 rounded-xl bg-amber-50/80 border border-amber-200 text-amber-900 text-[11px] leading-snug flex items-start gap-1.5">
              <Info className="w-3.5 h-3.5 text-amber-600 flex-shrink-0 mt-0.5" />
              <span>
                <strong>External Discovery Listing:</strong> Discovered food business candidate. Not yet a verified HomeBite partner. Online ordering is currently disabled.
              </span>
            </div>

            <a
              href={`https://www.google.com/maps/search/?api=1&query=${encodeURIComponent(`${provider.name} ${provider.address}`)}`}
              target="_blank"
              rel="noopener noreferrer"
              className="w-full py-2 px-3 rounded-xl border border-gray-300 hover:border-gray-400 bg-white text-gray-700 hover:text-gray-900 text-xs font-bold transition flex items-center justify-center gap-1.5 shadow-2xs"
            >
              <span>View Locality on Maps</span>
              <ExternalLink className="w-3 h-3 text-gray-400" />
            </a>
          </div>
        )}

      </div>
    </div>
  );
};

import React, { useState, useMemo } from 'react';
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
  ShoppingBag,
  Search,
  AlertTriangle
} from 'lucide-react';

interface FoodProviderCardProps {
  provider: FoodProvider;
}

export const FoodProviderCard: React.FC<FoodProviderCardProps> = ({ provider }) => {
  const { addToCart, currentCampus, addToast } = useApp();
  const [isMenuExpanded, setIsMenuExpanded] = useState(false);
  const [addedItemIds, setAddedItemIds] = useState<Record<string, boolean>>({});
  const [menuSearchQuery, setMenuSearchQuery] = useState('');
  const [selectedCategory, setSelectedCategory] = useState<string>('all');

  const isPartner = provider.partnershipStatus === 'approved';
  const menuItems: ProviderMenuItem[] = provider.menu || [];

  // Filtered menu items by category and search
  const filteredMenuItems = useMemo(() => {
    return menuItems.filter(item => {
      const matchesCategory = selectedCategory === 'all' || item.category === selectedCategory;
      const matchesSearch = !menuSearchQuery || 
        item.name.toLowerCase().includes(menuSearchQuery.toLowerCase()) ||
        item.description.toLowerCase().includes(menuSearchQuery.toLowerCase()) ||
        item.tags.some(t => t.toLowerCase().includes(menuSearchQuery.toLowerCase()));
      return matchesCategory && matchesSearch;
    });
  }, [menuItems, selectedCategory, menuSearchQuery]);

  // Distinct categories available in this menu
  const availableCategories = useMemo(() => {
    const cats = new Set<string>();
    menuItems.forEach(i => {
      if (i.category) cats.add(i.category);
    });
    return Array.from(cats);
  }, [menuItems]);

  // Overall menu status badge determination
  const menuStatusBadge = useMemo(() => {
    const firstItem = menuItems[0];
    const status = firstItem?.menuStatus || (isPartner ? 'verified' : 'sample');

    switch (status) {
      case 'verified':
        return {
          label: 'Restaurant Menu',
          subLabel: 'Official Verified Menu',
          className: 'bg-emerald-100 text-emerald-900 border-emerald-300',
          dotColor: 'bg-emerald-600',
          icon: ShieldCheck
        };
      case 'unverified':
        return {
          label: 'Menu – Awaiting Confirmation',
          subLabel: 'Preliminary Menu',
          className: 'bg-amber-100 text-amber-900 border-amber-300',
          dotColor: 'bg-amber-600',
          icon: Clock
        };
      case 'sample':
      default:
        return {
          label: 'Sample Menu – Illustrative Items',
          subLabel: 'Synthetic Sample Catalog',
          className: 'bg-purple-100 text-purple-900 border-purple-300',
          dotColor: 'bg-purple-600',
          icon: Sparkles
        };
    }
  }, [menuItems, isPartner]);

  // Helper to map ProviderMenuItem to HomeBite Cart Meal with Ordering Safeguards
  const handleAddItemToCart = (item: ProviderMenuItem) => {
    // ORDERING SAFEGUARD:
    // Do not allow customers to place real orders using synthetic menu items.
    // Allow ordering only from confirmed/verified restaurant partners.
    if (!isPartner || item.menuStatus === 'sample' || item.isDemo) {
      addToast(
        `Sample Menu: "${item.name}" is an illustrative preview item for ${provider.name}. Online ordering is enabled only for verified HomeBite partners.`,
        'warning'
      );
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
      category: (item.category as any) || 'lunch',
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
  const StatusIcon = menuStatusBadge.icon;

  return (
    <div className={`bg-white rounded-3xl border transition-all duration-300 overflow-hidden flex flex-col justify-between group shadow-soft hover:shadow-card ${
      isPartner ? 'border-hb-green-200' : 'border-gray-200/90 bg-gray-50/20'
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
      <div className="p-5 pt-0 space-y-3">
        
        {/* Price & Expand Accordion Row */}
        <div className="flex items-center justify-between pt-3 border-t border-gray-100">
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
            className="px-3.5 py-1.5 rounded-xl bg-hb-green-50 hover:bg-hb-green-100 text-hb-green-800 text-xs font-black transition flex items-center gap-1.5 border border-hb-green-200 shadow-2xs"
          >
            <span>{isMenuExpanded ? 'Hide Menu' : `View Menu (${menuItems.length})`}</span>
            {isMenuExpanded ? <ChevronUp className="w-3.5 h-3.5" /> : <ChevronDown className="w-3.5 h-3.5" />}
          </button>
        </div>

        {/* Expandable Menu Items Section */}
        {isMenuExpanded && (
          <div className="space-y-3 pt-3 border-t border-hb-green-100 animate-fadeIn">
            
            {/* Header: Menu Status Badge */}
            <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-2 p-2.5 rounded-2xl bg-hb-cream/60 border border-hb-green-200/80">
              <div className="flex items-center gap-2">
                <span className={`inline-flex items-center gap-1.5 px-3 py-1 rounded-full text-[11px] font-black border shadow-2xs ${menuStatusBadge.className}`}>
                  <StatusIcon className="w-3.5 h-3.5" />
                  <span>{menuStatusBadge.label}</span>
                </span>
              </div>
              <span className="text-[10px] text-gray-500 font-medium">
                {menuItems.length} Food Listings Available
              </span>
            </div>

            {/* Ordering Safeguard Alert for Sample Menus */}
            {(!isPartner || menuItems[0]?.menuStatus === 'sample') && (
              <div className="p-2.5 rounded-xl bg-amber-50/90 border border-amber-200 text-amber-900 text-[11px] leading-snug flex items-start gap-2">
                <AlertTriangle className="w-4 h-4 text-amber-600 flex-shrink-0 mt-0.5" />
                <div>
                  <span className="font-bold block">Ordering Safeguard Notice</span>
                  <p className="text-[10px] text-amber-800 mt-0.5">
                    This sample menu showcases typical dishes from {provider.name}. Real orders and delivery are reserved for approved HomeBite partner kitchens.
                  </p>
                </div>
              </div>
            )}

            {/* Menu Search Bar */}
            <div className="relative">
              <Search className="w-3.5 h-3.5 absolute left-3 top-1/2 -translate-y-1/2 text-gray-400" />
              <input
                type="text"
                value={menuSearchQuery}
                onChange={(e) => setMenuSearchQuery(e.target.value)}
                placeholder={`Search dishes in ${provider.name}...`}
                className="w-full pl-8 pr-3 py-1.5 text-xs rounded-xl bg-white border border-gray-200 focus:outline-none focus:ring-2 focus:ring-hb-green-500 text-gray-800 placeholder-gray-400"
              />
            </div>

            {/* Category Filter Pills */}
            {availableCategories.length > 1 && (
              <div className="flex flex-wrap items-center gap-1.5 text-[10px]">
                <button
                  type="button"
                  onClick={() => setSelectedCategory('all')}
                  className={`px-2.5 py-1 rounded-lg font-bold transition ${
                    selectedCategory === 'all'
                      ? 'bg-hb-green-700 text-white shadow-2xs'
                      : 'bg-gray-100 text-gray-600 hover:bg-gray-200'
                  }`}
                >
                  All ({menuItems.length})
                </button>
                {availableCategories.map((cat) => (
                  <button
                    key={cat}
                    type="button"
                    onClick={() => setSelectedCategory(cat)}
                    className={`px-2.5 py-1 rounded-lg font-bold uppercase transition ${
                      selectedCategory === cat
                        ? 'bg-hb-green-700 text-white shadow-2xs'
                        : 'bg-gray-100 text-gray-600 hover:bg-gray-200'
                    }`}
                  >
                    {cat}
                  </button>
                ))}
              </div>
            )}

            {/* Menu Item Cards */}
            <div className="space-y-2 max-h-80 overflow-y-auto pr-1">
              {filteredMenuItems.length === 0 ? (
                <div className="text-center py-4 text-xs text-gray-500">
                  No dishes matched "{menuSearchQuery}".
                </div>
              ) : (
                filteredMenuItems.map((item) => {
                  const isAdded = addedItemIds[item.id];
                  const isSample = !isPartner || item.menuStatus === 'sample' || item.isDemo;

                  return (
                    <div
                      key={item.id}
                      className="p-2.5 rounded-2xl bg-hb-cream/30 border border-hb-green-100/80 flex items-center justify-between gap-3 hover:bg-hb-cream/60 transition group/item"
                    >
                      <div className="flex items-center gap-2.5 min-w-0">
                        <img
                          src={item.imageUrl}
                          alt={item.name}
                          className="w-13 h-13 rounded-xl object-cover flex-shrink-0 border border-hb-green-100"
                        />
                        <div className="min-w-0">
                          <div className="flex items-center gap-1.5 truncate">
                            {/* Veg / Non-Veg Indicator */}
                            <span 
                              className={`w-3 h-3 rounded-xs flex items-center justify-center border p-0.5 flex-shrink-0 ${
                                item.dietary === 'veg'
                                  ? 'border-emerald-600 bg-white'
                                  : 'border-rose-600 bg-white'
                              }`}
                              title={item.dietary === 'veg' ? 'Vegetarian' : 'Non-Vegetarian'}
                            >
                              <span className={`w-1.5 h-1.5 rounded-full ${
                                item.dietary === 'veg' ? 'bg-emerald-600' : 'bg-rose-600'
                              }`}></span>
                            </span>

                            <span className="text-xs font-bold text-gray-900 truncate">
                              {item.name}
                            </span>
                          </div>

                          <p className="text-[10px] text-gray-500 line-clamp-1 mt-0.5">
                            {item.description}
                          </p>

                          <div className="flex items-center gap-2 mt-1 text-[10px] text-gray-500">
                            <span className="font-black text-gray-900 text-xs">₹{item.price}</span>
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

                      {/* Add to Cart or Sample Safeguard Button */}
                      <button
                        type="button"
                        onClick={() => handleAddItemToCart(item)}
                        className={`px-3 py-1.5 rounded-xl text-xs font-black transition flex items-center gap-1 flex-shrink-0 ${
                          isAdded
                            ? 'bg-emerald-600 text-white'
                            : isSample
                            ? 'bg-gray-100 hover:bg-gray-200 text-gray-700 border border-gray-200 shadow-2xs'
                            : 'bg-hb-green-600 hover:bg-hb-green-700 text-white shadow-xs'
                        }`}
                        title={isSample ? 'Sample Menu Item (Orders disabled)' : 'Add to HomeBite Cart'}
                      >
                        {isAdded ? (
                          <>
                            <Check className="w-3.5 h-3.5" />
                            <span>Added</span>
                          </>
                        ) : isSample ? (
                          <>
                            <Plus className="w-3.5 h-3.5 text-gray-500" />
                            <span>Sample</span>
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
                })
              )}
            </div>

          </div>
        )}

        {/* External Discovery Listing Extra Action */}
        {!isPartner && (
          <div className="pt-2 border-t border-gray-100 flex items-center justify-between gap-2">
            <span className="text-[10px] text-gray-500 flex items-center gap-1">
              <Info className="w-3 h-3 text-amber-500 flex-shrink-0" />
              <span>External candidate restaurant</span>
            </span>

            <a
              href={`https://www.google.com/maps/search/?api=1&query=${encodeURIComponent(`${provider.name} ${provider.address}`)}`}
              target="_blank"
              rel="noopener noreferrer"
              className="py-1 px-2.5 rounded-lg border border-gray-200 bg-white hover:bg-gray-50 text-gray-700 text-[10px] font-bold transition flex items-center gap-1 shadow-2xs"
            >
              <span>Google Maps</span>
              <ExternalLink className="w-2.5 h-2.5 text-gray-400" />
            </a>
          </div>
        )}

      </div>
    </div>
  );
};

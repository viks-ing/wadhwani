import React, { useState, useMemo } from 'react';
import { useApp } from '../../context/AppContext';
import { ArrowLeft, MapPin, Clock, Star, ShieldCheck, Sparkles, Plus, Check, ExternalLink, Search, AlertTriangle, ShoppingBag, Flame, Zap, Info } from 'lucide-react';
export const RestaurantMenuView = () => {
    const { selectedProvider, setActiveView, currentCampus, addToCart, cart, cartTotal, cartItemCount, setIsCartOpen, addToast } = useApp();
    const [searchQuery, setSearchQuery] = useState('');
    const [selectedCategory, setSelectedCategory] = useState('all');
    const [dietaryFilter, setDietaryFilter] = useState('all');
    const [addedItemIds, setAddedItemIds] = useState({});
    // Fallback if no provider selected
    if (!selectedProvider) {
        return (<div className="min-h-[70vh] flex flex-col items-center justify-center p-6 text-center">
        <div className="w-16 h-16 rounded-full bg-hb-cream-200 flex items-center justify-center text-3xl mb-4">
          🍽️
        </div>
        <h2 className="text-xl font-bold text-gray-900">No Food Provider Selected</h2>
        <p className="text-xs text-gray-500 mt-1 max-w-sm">
          Please select a home kitchen or restaurant from the explore feed to view its complete menu.
        </p>
        <button onClick={() => setActiveView('customer')} className="mt-5 px-6 py-2.5 rounded-xl bg-hb-green-600 text-white font-bold text-xs hover:bg-hb-green-700 transition shadow-xs">
          ← Return to Explore Feed
        </button>
      </div>);
    }
    const isPartner = selectedProvider.partnershipStatus === 'approved';
    const menuItems = selectedProvider.menu || [];
    // Determine overall menu status badge
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
    // Extract distinct categories available
    const availableCategories = useMemo(() => {
        const cats = new Set();
        menuItems.forEach(i => {
            if (i.category)
                cats.add(i.category);
        });
        return Array.from(cats);
    }, [menuItems]);
    // Filtered dishes
    const filteredDishes = useMemo(() => {
        return menuItems.filter(item => {
            const matchesCategory = selectedCategory === 'all' || item.category === selectedCategory;
            const matchesDietary = dietaryFilter === 'all' ||
                (dietaryFilter === 'veg' && item.dietary === 'veg') ||
                (dietaryFilter === 'non-veg' && item.dietary === 'non-veg');
            const matchesSearch = !searchQuery ||
                item.name.toLowerCase().includes(searchQuery.toLowerCase()) ||
                item.description.toLowerCase().includes(searchQuery.toLowerCase()) ||
                item.tags.some(t => t.toLowerCase().includes(searchQuery.toLowerCase()));
            return matchesCategory && matchesDietary && matchesSearch;
        });
    }, [menuItems, selectedCategory, dietaryFilter, searchQuery]);
    // Handle Add to Cart - Instant and fully enabled for all dishes
    const handleAddItemToCart = (item) => {
        const meal = {
            id: item.id,
            chefId: selectedProvider.id,
            chefName: selectedProvider.name,
            chefAvatar: selectedProvider.coverImage || 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=400&q=80',
            kitchenName: selectedProvider.name,
            isChefVerified: selectedProvider.isVerified ?? true,
            name: item.name,
            description: item.description,
            category: item.category || 'lunch',
            dietary: item.dietary,
            price: item.price,
            originalPrice: Math.round(item.price * 1.25),
            rating: selectedProvider.rating || 4.8,
            reviewsCount: selectedProvider.reviewsCount || 45,
            prepTimeMinutes: selectedProvider.prepTimeMinutes || 20,
            imageUrl: item.imageUrl,
            ingredients: item.tags || [],
            nutrition: {
                calories: item.calories || 450,
                protein: item.protein || 15,
                carbs: 55,
                fats: 10,
                fiber: 5,
            },
            isAvailable: true,
            tags: item.tags || [],
            spiceLevel: 'Medium',
            servingSize: '1 Portion',
            campusDistanceKm: selectedProvider.distanceKm || 1.2,
        };
        addToCart(meal, 1);
        setAddedItemIds(prev => ({ ...prev, [item.id]: true }));
        addToast(`Added "${item.name}" to your Dabba!`, 'success');
        setTimeout(() => {
            setAddedItemIds(prev => ({ ...prev, [item.id]: false }));
        }, 1800);
    };
    const StatusIcon = menuStatusBadge.icon;
    const getProviderTypeBadge = (type) => {
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
    const typeBadge = getProviderTypeBadge(selectedProvider.type);
    return (<div className="min-h-screen pb-24">
      {/* 1. Top Breadcrumb & Return Bar */}
      <div className="bg-white border-b border-hb-green-100 sticky top-0 z-30 shadow-xs">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-3.5 flex items-center justify-between gap-4">
          <button onClick={() => {
            setActiveView('customer');
            window.scrollTo({ top: 0, behavior: 'smooth' });
        }} className="inline-flex items-center gap-2 text-xs sm:text-sm font-bold text-gray-700 hover:text-hb-green-700 transition group">
            <ArrowLeft className="w-4 h-4 text-gray-400 group-hover:text-hb-green-700 group-hover:-translate-x-1 transition-transform"/>
            <span>Back to Explore Meals</span>
          </button>

          <div className="flex items-center gap-2 text-xs text-gray-500">
            <MapPin className="w-3.5 h-3.5 text-hb-orange"/>
            <span className="hidden sm:inline">Browsing near:</span>
            <span className="font-bold text-gray-900">{currentCampus || 'SNIST Campus, Yamnampet'}</span>
          </div>
        </div>
      </div>

      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 pt-6 space-y-8 animate-fadeIn">
        
        {/* 2. Restaurant Hero Card */}
        <div className="bg-white rounded-3xl border border-hb-green-100 shadow-soft overflow-hidden">
          
          {/* Cover Banner */}
          <div className="relative h-64 sm:h-80 w-full overflow-hidden bg-gray-900">
            <img src={selectedProvider.coverImage} alt={selectedProvider.name} className="w-full h-full object-cover opacity-85"/>
            <div className="absolute inset-0 bg-gradient-to-t from-gray-950 via-gray-950/40 to-transparent"></div>

            {/* Top Badges */}
            <div className="absolute top-4 left-4 flex flex-wrap items-center gap-2">
              <span className={`px-3 py-1 rounded-xl text-xs font-black shadow-md ${typeBadge.color}`}>
                {typeBadge.label}
              </span>

              {isPartner ? (<span className="px-3 py-1 rounded-xl bg-hb-green-600 text-white text-xs font-extrabold flex items-center gap-1.5 shadow-md">
                  <ShieldCheck className="w-4 h-4 text-emerald-200"/>
                  <span>NutriBite Partner (Ordering Enabled)</span>
                </span>) : (<span className="px-3 py-1 rounded-xl bg-gray-900/90 backdrop-blur text-amber-200 text-xs font-bold flex items-center gap-1.5 shadow-md border border-amber-500/30">
                  <Info className="w-4 h-4"/>
                  <span>Discovered Candidate (Preview Mode)</span>
                </span>)}
            </div>

            {/* Floating Ratings */}
            <div className="absolute top-4 right-4 bg-white/95 backdrop-blur px-3 py-1.5 rounded-2xl text-xs font-black text-gray-900 flex items-center gap-1.5 shadow-md">
              <Star className="w-4 h-4 text-amber-500 fill-amber-500"/>
              <span className="text-sm font-extrabold">{selectedProvider.rating.toFixed(1)}</span>
              <span className="text-gray-400 font-normal">({selectedProvider.reviewsCount} reviews)</span>
            </div>

            {/* Bottom Info on Banner */}
            <div className="absolute bottom-6 left-6 right-6 text-white space-y-2">
              <h1 className="text-2xl sm:text-4xl font-black font-display tracking-tight text-white drop-shadow-md">
                {selectedProvider.name}
              </h1>

              <div className="flex flex-wrap items-center gap-x-4 gap-y-1 text-xs sm:text-sm text-gray-200">
                <span className="flex items-center gap-1">
                  <MapPin className="w-4 h-4 text-hb-orange"/>
                  <span>{selectedProvider.address}</span>
                </span>
                <span>•</span>
                <span className="flex items-center gap-1 font-semibold text-emerald-300">
                  <Clock className="w-4 h-4"/>
                  <span>~{selectedProvider.prepTimeMinutes} mins prep</span>
                </span>
                <span>•</span>
                <span className="font-semibold text-amber-300">
                  {selectedProvider.distanceKm} km from campus
                </span>
              </div>
            </div>
          </div>

          {/* Restaurant Metadata Strip */}
          <div className="p-6 bg-hb-cream/40 border-t border-hb-green-100 flex flex-wrap items-center justify-between gap-4">
            <div className="space-y-1">
              <span className="text-[10px] text-gray-400 font-bold uppercase tracking-wider block">
                Cuisine Specialties
              </span>
              <div className="flex flex-wrap items-center gap-1.5">
                {selectedProvider.cuisine.map((c, i) => (<span key={i} className="px-2.5 py-1 rounded-lg bg-white text-hb-green-800 text-xs font-bold border border-hb-green-200 shadow-2xs">
                    {c}
                  </span>))}
              </div>
            </div>

            <div className="flex items-center gap-4 text-xs sm:text-sm">
              <div className="text-right">
                <span className="text-[10px] text-gray-400 font-bold uppercase tracking-wider block">
                  Minimum Order
                </span>
                <span className="font-black text-gray-900 text-base">
                  ₹{selectedProvider.minOrderAmount}
                </span>
              </div>

              <div className="w-px h-8 bg-gray-200"></div>

              <a href={`https://www.google.com/maps/search/?api=1&query=${encodeURIComponent(`${selectedProvider.name} ${selectedProvider.address}`)}`} target="_blank" rel="noopener noreferrer" className="px-4 py-2 rounded-xl bg-white hover:bg-gray-50 border border-gray-300 text-gray-700 text-xs font-bold transition flex items-center gap-1.5 shadow-2xs">
                <span>View on Maps</span>
                <ExternalLink className="w-3.5 h-3.5 text-gray-400"/>
              </a>
            </div>
          </div>

        </div>

        {/* 3. Menu Classification & Ordering Safeguard Header */}
        <div className="bg-white rounded-3xl p-6 border border-hb-green-100 shadow-soft space-y-4">
          
          <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-3 border-b border-gray-100 pb-4">
            <div>
              <div className="flex items-center gap-2 mb-1">
                <span className={`inline-flex items-center gap-1.5 px-3 py-1 rounded-full text-xs font-black border shadow-2xs ${menuStatusBadge.className}`}>
                  <StatusIcon className="w-4 h-4"/>
                  <span>{menuStatusBadge.label}</span>
                </span>
              </div>
              <h2 className="text-xl font-black text-gray-900">
                Food Listings & Menu
              </h2>
              <p className="text-xs text-gray-500 mt-0.5">
                {menuStatusBadge.subLabel} • {menuItems.length} items available
              </p>
            </div>

            {/* Quick Count */}
            <div className="bg-hb-cream px-4 py-2 rounded-2xl border border-hb-green-200 text-xs font-bold text-hb-green-900 flex items-center gap-2 self-start sm:self-auto">
              <span>Showing:</span>
              <strong className="text-sm">{filteredDishes.length}</strong>
              <span>of {menuItems.length} dishes</span>
            </div>
          </div>

          {/* Ordering Safeguard Alert */}
          {(!isPartner || menuItems[0]?.menuStatus === 'sample') && (<div className="p-4 rounded-2xl bg-amber-50 border border-amber-200 text-amber-950 text-xs leading-relaxed flex items-start gap-3">
              <AlertTriangle className="w-5 h-5 text-amber-600 flex-shrink-0 mt-0.5"/>
              <div>
                <strong className="font-extrabold text-amber-900 text-sm block mb-0.5">
                  Ordering Safeguard Active
                </strong>
                <p className="text-amber-800">
                  {selectedProvider.name} is currently a discovered food business candidate. The dishes listed below are representative sample items tailored to this establishment's cuisine. Live online ordering and payments are enabled only for confirmed NutriBite partner kitchens.
                </p>
              </div>
            </div>)}

          {/* Search & Filter Toolbar */}
          <div className="flex flex-col md:flex-row md:items-center justify-between gap-3 pt-2">
            
            {/* Search Input */}
            <div className="relative flex-1 max-w-md">
              <Search className="w-4 h-4 absolute left-3.5 top-1/2 -translate-y-1/2 text-gray-400"/>
              <input type="text" value={searchQuery} onChange={(e) => setSearchQuery(e.target.value)} placeholder={`Search dishes in ${selectedProvider.name}...`} className="w-full pl-10 pr-4 py-2.5 text-xs sm:text-sm rounded-2xl bg-gray-50 border border-gray-200 focus:outline-none focus:ring-2 focus:ring-hb-green-500 text-gray-800 placeholder-gray-400"/>
            </div>

            {/* Veg / Non-Veg Filters */}
            <div className="flex items-center gap-1.5 p-1 bg-gray-100 rounded-2xl self-start md:self-auto">
              <button type="button" onClick={() => setDietaryFilter('all')} className={`px-3 py-1.5 rounded-xl text-xs font-bold transition ${dietaryFilter === 'all'
            ? 'bg-white text-gray-900 shadow-2xs'
            : 'text-gray-600 hover:text-gray-900'}`}>
                All
              </button>
              <button type="button" onClick={() => setDietaryFilter('veg')} className={`px-3 py-1.5 rounded-xl text-xs font-bold flex items-center gap-1.5 transition ${dietaryFilter === 'veg'
            ? 'bg-emerald-600 text-white shadow-2xs'
            : 'text-gray-600 hover:text-gray-900'}`}>
                <span className="w-2 h-2 rounded-full bg-emerald-300"></span>
                <span>Veg Only</span>
              </button>
              <button type="button" onClick={() => setDietaryFilter('non-veg')} className={`px-3 py-1.5 rounded-xl text-xs font-bold flex items-center gap-1.5 transition ${dietaryFilter === 'non-veg'
            ? 'bg-rose-600 text-white shadow-2xs'
            : 'text-gray-600 hover:text-gray-900'}`}>
                <span className="w-2 h-2 rounded-full bg-rose-300"></span>
                <span>Non-Veg</span>
              </button>
            </div>

          </div>

          {/* Category Navigation Pills */}
          {availableCategories.length > 0 && (<div className="flex flex-wrap items-center gap-2 pt-2 border-t border-gray-100">
              <button type="button" onClick={() => setSelectedCategory('all')} className={`px-3.5 py-1.5 rounded-xl text-xs font-bold transition ${selectedCategory === 'all'
                ? 'bg-hb-green-700 text-white shadow-2xs'
                : 'bg-hb-cream text-hb-green-900 hover:bg-hb-cream-200 border border-hb-green-200'}`}>
                All Categories ({menuItems.length})
              </button>

              {availableCategories.map((cat) => (<button key={cat} type="button" onClick={() => setSelectedCategory(cat)} className={`px-3.5 py-1.5 rounded-xl text-xs font-bold uppercase transition ${selectedCategory === cat
                    ? 'bg-hb-green-700 text-white shadow-2xs'
                    : 'bg-gray-100 text-gray-700 hover:bg-gray-200'}`}>
                  {cat}
                </button>))}
            </div>)}

        </div>

        {/* 4. Dishes Grid */}
        <div className="space-y-4">
          <div className="flex items-center justify-between">
            <h3 className="text-lg font-black text-gray-900">
              Available Dishes ({filteredDishes.length})
            </h3>
          </div>

          {filteredDishes.length === 0 ? (<div className="bg-white rounded-3xl p-12 text-center border border-hb-green-100 shadow-soft">
              <div className="w-12 h-12 rounded-full bg-amber-50 text-amber-600 flex items-center justify-center text-xl mx-auto mb-3">
                🔍
              </div>
              <h4 className="text-base font-bold text-gray-900">No dishes match your filter</h4>
              <p className="text-xs text-gray-500 mt-1 max-w-sm mx-auto">
                Try searching for something else or clear the dietary/category filters.
              </p>
              <button onClick={() => {
                setSearchQuery('');
                setSelectedCategory('all');
                setDietaryFilter('all');
            }} className="mt-4 px-4 py-2 rounded-xl bg-hb-green-600 text-white font-bold text-xs hover:bg-hb-green-700 transition">
                Reset Filters
              </button>
            </div>) : (<div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
              {filteredDishes.map((item) => {
                const isAdded = addedItemIds[item.id];
                const isSample = !isPartner || item.menuStatus === 'sample' || item.isDemo;
                return (<div key={item.id} className="bg-white rounded-3xl border border-hb-green-100 shadow-soft hover:shadow-card transition-all duration-300 overflow-hidden flex flex-col justify-between group">
                    <div>
                      {/* Dish Image */}
                      <div className="relative h-44 overflow-hidden bg-gray-100">
                        <img src={item.imageUrl} alt={item.name} className="w-full h-full object-cover group-hover:scale-105 transition-transform duration-500"/>
                        
                        {/* Veg / Non-Veg Indicator */}
                        <div className="absolute top-3 left-3 bg-white/95 backdrop-blur-md p-1.5 rounded-lg shadow-sm border border-gray-200">
                          <span className={`w-3.5 h-3.5 rounded-xs flex items-center justify-center border p-0.5 ${item.dietary === 'veg' ? 'border-emerald-600' : 'border-rose-600'}`}>
                            <span className={`w-2 h-2 rounded-full ${item.dietary === 'veg' ? 'bg-emerald-600' : 'bg-rose-600'}`}></span>
                          </span>
                        </div>

                        {/* Category Tag */}
                        <div className="absolute top-3 right-3 bg-black/75 backdrop-blur-md text-white px-2.5 py-1 rounded-xl text-[10px] font-black uppercase tracking-wider shadow-sm">
                          {item.category}
                        </div>
                      </div>

                      {/* Dish Details */}
                      <div className="p-5 space-y-2.5">
                        <div className="flex items-start justify-between gap-2">
                          <h4 className="text-base font-extrabold text-gray-900 group-hover:text-hb-green-700 transition leading-snug">
                            {item.name}
                          </h4>
                        </div>

                        <p className="text-xs text-gray-600 line-clamp-2 leading-relaxed">
                          {item.description}
                        </p>

                        {/* Tags */}
                        {item.tags && item.tags.length > 0 && (<div className="flex flex-wrap items-center gap-1">
                            {item.tags.map((tag, idx) => (<span key={idx} className="px-2 py-0.5 rounded-md bg-hb-cream text-hb-green-800 text-[10px] font-semibold border border-hb-green-100">
                                {tag}
                              </span>))}
                          </div>)}

                        {/* Nutrition pills */}
                        {(item.calories || item.protein) && (<div className="flex items-center gap-2 pt-1 text-[11px] text-gray-500 font-semibold">
                            {item.protein && (<span className="text-emerald-700 font-extrabold flex items-center gap-1">
                                <Zap className="w-3 h-3 text-emerald-600"/>
                                <span>{item.protein}g protein</span>
                              </span>)}
                            {item.calories && (<>
                                <span>•</span>
                                <span className="flex items-center gap-1">
                                  <Flame className="w-3 h-3 text-amber-500"/>
                                  <span>{item.calories} kcal</span>
                                </span>
                              </>)}
                          </div>)}
                      </div>
                    </div>

                    {/* Footer Action */}
                    <div className="p-5 pt-0 border-t border-gray-100 flex items-center justify-between gap-3 mt-3">
                      <div>
                        <span className="text-[10px] text-gray-400 uppercase tracking-wider block font-bold">
                          Price
                        </span>
                        <span className="text-xl font-black text-gray-900">
                          ₹{item.price}
                        </span>
                      </div>

                      <button type="button" onClick={() => handleAddItemToCart(item)} className={`px-4 py-2 rounded-xl text-xs font-black transition flex items-center gap-1.5 shadow-xs active:scale-95 ${isAdded
                        ? 'bg-emerald-600 text-white ring-2 ring-emerald-300'
                        : 'bg-hb-green-600 hover:bg-hb-green-700 text-white'}`} title="Add to Dabba">
                        {isAdded ? (<>
                            <Check className="w-4 h-4"/>
                            <span>Added to Dabba</span>
                          </>) : (<>
                            <Plus className="w-4 h-4"/>
                            <span>Add to Dabba</span>
                          </>)}
                      </button>
                    </div>

                  </div>);
            })}
            </div>)}
        </div>

      </div>

      {/* 5. Sticky Floating Cart Bar if user has items */}
      {cartItemCount > 0 && (<div className="fixed bottom-4 left-1/2 -translate-x-1/2 z-40 w-full max-w-md px-4 animate-slideUp">
          <div className="bg-gray-950/95 backdrop-blur-md text-white rounded-2xl p-3.5 shadow-2xl border border-gray-800 flex items-center justify-between gap-3">
            <div className="flex items-center gap-2.5">
              <div className="w-9 h-9 rounded-xl bg-hb-green-600 text-white flex items-center justify-center font-black text-xs">
                {cartItemCount}
              </div>
              <div>
                <span className="text-xs font-bold block text-white">Your Dabba Cart</span>
                <span className="text-[11px] text-emerald-400 font-semibold">Total: ₹{cartTotal}</span>
              </div>
            </div>

            <button onClick={() => setIsCartOpen(true)} className="px-4 py-2 rounded-xl bg-hb-green-600 hover:bg-hb-green-700 text-white text-xs font-black transition flex items-center gap-1.5 shadow-xs">
              <ShoppingBag className="w-3.5 h-3.5"/>
              <span>View Cart & Order</span>
            </button>
          </div>
        </div>)}

    </div>);
};

import React, { useState, useMemo } from 'react';
import { useApp } from '../../context/AppContext';
import { Meal, MealCategory } from '../../types';
import { 
  Search, 
  Filter, 
  MapPin, 
  Star, 
  Clock, 
  ShieldCheck, 
  Flame, 
  SlidersHorizontal,
  Plus,
  Check,
  Sparkles,
  ArrowUpDown,
  ChefHat
} from 'lucide-react';

const CATEGORIES: { key: MealCategory; label: string; icon: string }[] = [
  { key: 'all', label: 'All Meals', icon: '🍽️' },
  { key: 'lunch', label: 'Lunch Combos', icon: '🍲' },
  { key: 'dinner', label: 'Dinner Thalis', icon: '🍛' },
  { key: 'breakfast', label: 'Morning Breakfast', icon: '🥞' },
  { key: 'high-protein', label: 'High Protein (Gym)', icon: '💪' },
  { key: 'snacks', label: 'Evening Snacks', icon: '☕' },
];

export const CustomerDashboard: React.FC = () => {
  const { 
    meals, 
    addToCart, 
    setSelectedMealForDetails, 
    currentCampus, 
    detectAndSetLocation,
    isLocating 
  } = useApp();

  const [searchQuery, setSearchQuery] = useState('');
  const [selectedCategory, setSelectedCategory] = useState<MealCategory>('all');
  const [dietaryFilter, setDietaryFilter] = useState<'all' | 'veg' | 'non-veg'>('all');
  const [sortBy, setSortBy] = useState<'recommended' | 'price-asc' | 'price-desc' | 'rating' | 'prep-time' | 'distance'>('recommended');
  const [maxPrice, setMaxPrice] = useState<number>(200);

  // Filter and sort meals
  const filteredMeals = useMemo(() => {
    return meals
      .filter((meal) => {
        // Search filter
        if (searchQuery.trim()) {
          const query = searchQuery.toLowerCase();
          const matchName = meal.name.toLowerCase().includes(query);
          const matchDesc = meal.description.toLowerCase().includes(query);
          const matchChef = meal.chefName.toLowerCase().includes(query) || meal.kitchenName.toLowerCase().includes(query);
          const matchIng = meal.ingredients.some(i => i.toLowerCase().includes(query));
          if (!matchName && !matchDesc && !matchChef && !matchIng) return false;
        }

        // Category filter
        if (selectedCategory !== 'all' && meal.category !== selectedCategory) {
          return false;
        }

        // Dietary filter
        if (dietaryFilter !== 'all' && meal.dietary !== dietaryFilter) {
          return false;
        }

        // Max price
        if (meal.price > maxPrice) {
          return false;
        }

        return true;
      })
      .sort((a, b) => {
        if (sortBy === 'distance') return a.campusDistanceKm - b.campusDistanceKm;
        if (sortBy === 'price-asc') return a.price - b.price;
        if (sortBy === 'price-desc') return b.price - a.price;
        if (sortBy === 'rating') return b.rating - a.rating;
        if (sortBy === 'prep-time') return a.prepTimeMinutes - b.prepTimeMinutes;
        return 0; // recommended
      });
  }, [meals, searchQuery, selectedCategory, dietaryFilter, maxPrice, sortBy]);

  return (
    <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8 space-y-8 animate-fadeIn">
      
      {/* Location & Delivery ETA Banner */}
      <div className="bg-gradient-to-r from-hb-green-700 via-hb-green-600 to-hb-green-800 rounded-3xl p-6 sm:p-8 text-white shadow-soft relative overflow-hidden">
        <div className="absolute top-0 right-0 -mr-16 -mt-16 w-64 h-64 rounded-full bg-white/10 pointer-events-none filter blur-2xl"></div>

        <div className="relative z-10 flex flex-col md:flex-row md:items-center justify-between gap-6">
          <div className="space-y-2">
            <div className="inline-flex items-center gap-2 px-3 py-1.5 rounded-full bg-white/20 backdrop-blur-md text-white text-xs font-semibold">
              <MapPin className="w-3.5 h-3.5 text-hb-orange flex-shrink-0" />
              <span>Delivering to: <strong className="text-amber-200">{currentCampus || 'Your Area'}</strong></span>
              <button
                onClick={detectAndSetLocation}
                disabled={isLocating}
                className="ml-1 text-[11px] underline text-white/90 hover:text-white cursor-pointer"
              >
                {isLocating ? 'Detecting...' : (currentCampus ? 'Refresh' : 'Detect GPS')}
              </button>
            </div>
            <h1 className="text-2xl sm:text-3xl font-black font-display tracking-tight">
              Fresh Daily Dabbas & Home Kitchens
            </h1>
            <p className="text-xs sm:text-sm text-hb-cream-200 max-w-xl">
              Clean home-cooked meals prepared within 2km of {currentCampus ? currentCampus.split(',')[0] : 'your location'}. Hot, hygienic & student pocket-friendly.
            </p>
          </div>

          <div className="flex items-center gap-3 bg-white/10 backdrop-blur p-4 rounded-2xl border border-white/20">
            <div className="text-center px-2">
              <span className="text-xs text-hb-cream-300 block">Avg Delivery</span>
              <span className="text-xl font-black">20-25m</span>
            </div>
            <div className="w-px h-8 bg-white/20"></div>
            <div className="text-center px-2">
              <span className="text-xs text-hb-cream-300 block">Active Chefs</span>
              <span className="text-xl font-black">14 Kitchens</span>
            </div>
            <div className="w-px h-8 bg-white/20"></div>
            <div className="text-center px-2">
              <span className="text-xs text-hb-cream-300 block">Hygiene Rating</span>
              <span className="text-xl font-black text-amber-300">4.9 ★</span>
            </div>
          </div>
        </div>
      </div>

      {/* Search & Quick Filters Header */}
      <div className="bg-white rounded-3xl p-5 border border-hb-green-100 shadow-soft space-y-4">
        
        {/* Top Search Row */}
        <div className="flex flex-col sm:flex-row items-center gap-3">
          <div className="relative flex-1 w-full">
            <Search className="w-4 h-4 text-gray-400 absolute left-3.5 top-1/2 -translate-y-1/2" />
            <input
              type="text"
              value={searchQuery}
              onChange={(e) => setSearchQuery(e.target.value)}
              placeholder="Search Rajma Chawal, Paneer, Dal Tadka, Anita Aunty..."
              className="w-full pl-10 pr-4 py-2.5 rounded-xl border border-gray-200 text-xs sm:text-sm focus:border-hb-green-500 focus:ring-1 focus:ring-hb-green-500 outline-none text-gray-800 bg-gray-50/50"
            />
          </div>

          {/* Dietary Preferences Pill Switcher */}
          <div className="flex items-center bg-gray-100 p-1 rounded-xl w-full sm:w-auto flex-shrink-0">
            <button
              onClick={() => setDietaryFilter('all')}
              className={`px-3 py-1.5 rounded-lg text-xs font-bold transition flex-1 sm:flex-none ${
                dietaryFilter === 'all'
                  ? 'bg-white text-gray-900 shadow-xs'
                  : 'text-gray-500 hover:text-gray-800'
              }`}
            >
              All
            </button>
            <button
              onClick={() => setDietaryFilter('veg')}
              className={`px-3 py-1.5 rounded-lg text-xs font-bold transition flex items-center justify-center gap-1.5 flex-1 sm:flex-none ${
                dietaryFilter === 'veg'
                  ? 'bg-emerald-600 text-white shadow-xs'
                  : 'text-gray-500 hover:text-emerald-700'
              }`}
            >
              <span className="w-2 h-2 rounded-full bg-emerald-400"></span>
              <span>Veg Only</span>
            </button>
            <button
              onClick={() => setDietaryFilter('non-veg')}
              className={`px-3 py-1.5 rounded-lg text-xs font-bold transition flex items-center justify-center gap-1.5 flex-1 sm:flex-none ${
                dietaryFilter === 'non-veg'
                  ? 'bg-rose-600 text-white shadow-xs'
                  : 'text-gray-500 hover:text-rose-700'
              }`}
            >
              <span className="w-2 h-2 rounded-full bg-rose-400"></span>
              <span>Non-Veg</span>
            </button>
          </div>

          {/* Sort By Dropdown */}
          <div className="flex items-center gap-1.5 w-full sm:w-auto">
            <ArrowUpDown className="w-3.5 h-3.5 text-gray-400 hidden sm:block" />
            <select
              value={sortBy}
              onChange={(e) => setSortBy(e.target.value as any)}
              className="w-full sm:w-auto text-xs py-2.5 px-3 rounded-xl border border-gray-200 bg-gray-50/50 text-gray-700 outline-none font-semibold"
            >
              <option value="recommended">Sort: Recommended</option>
              <option value="distance">Distance: Nearest Kitchen First</option>
              <option value="price-asc">Price: Low to High</option>
              <option value="price-desc">Price: High to Low</option>
              <option value="rating">Rating: Highest First</option>
              <option value="prep-time">Prep Time: Fastest</option>
            </select>
          </div>
        </div>

        {/* Categories Bar */}
        <div className="flex items-center gap-2 overflow-x-auto pb-1 scrollbar-none">
          {CATEGORIES.map((cat) => (
            <button
              key={cat.key}
              onClick={() => setSelectedCategory(cat.key)}
              className={`px-3.5 py-2 rounded-xl text-xs font-bold transition flex items-center gap-2 flex-shrink-0 ${
                selectedCategory === cat.key
                  ? 'bg-hb-green-600 text-white shadow-sm'
                  : 'bg-gray-50 hover:bg-gray-100 text-gray-700 border border-gray-200/60'
              }`}
            >
              <span>{cat.icon}</span>
              <span>{cat.label}</span>
            </button>
          ))}
        </div>

      </div>

      {/* Results Header */}
      <div className="flex items-center justify-between">
        <div>
          <h2 className="text-xl font-bold text-gray-900">
            {selectedCategory === 'all' ? 'Available Meals Today' : CATEGORIES.find(c => c.key === selectedCategory)?.label}
          </h2>
          <p className="text-xs text-gray-500">
            Showing {filteredMeals.length} homestyle options near your campus
          </p>
        </div>
      </div>

      {/* Meals Grid */}
      {filteredMeals.length === 0 ? (
        <div className="bg-white rounded-3xl p-12 text-center border border-hb-green-100 shadow-soft">
          <div className="text-4xl mb-3">🔍</div>
          <h3 className="text-base font-bold text-gray-900">No meals found matching your filters</h3>
          <p className="text-xs text-gray-500 mt-1 max-w-sm mx-auto">
            Try resetting your search query or switching dietary preferences to explore other options.
          </p>
          <button
            onClick={() => {
              setSearchQuery('');
              setSelectedCategory('all');
              setDietaryFilter('all');
            }}
            className="mt-4 px-4 py-2 bg-hb-green-600 text-white font-bold rounded-xl text-xs"
          >
            Reset Filters
          </button>
        </div>
      ) : (
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6">
          {filteredMeals.map((meal) => (
            <div
              key={meal.id}
              className="bg-white rounded-3xl border border-hb-green-100 overflow-hidden shadow-soft hover:shadow-card transition duration-300 flex flex-col justify-between group"
            >
              <div>
                {/* Image Section */}
                <div 
                  onClick={() => setSelectedMealForDetails(meal)}
                  className="relative h-48 overflow-hidden cursor-pointer bg-gray-100"
                >
                  <img
                    src={meal.imageUrl}
                    alt={meal.name}
                    className="w-full h-full object-cover group-hover:scale-105 transition-transform duration-500"
                  />
                  
                  {/* Dietary badge */}
                  <div className="absolute top-3 left-3 flex items-center gap-1.5">
                    <span className={`w-4 h-4 rounded-full border-2 flex items-center justify-center bg-white ${
                      meal.dietary === 'veg' ? 'border-emerald-600' : 'border-rose-600'
                    }`}>
                      <span className={`w-2 h-2 rounded-full ${
                        meal.dietary === 'veg' ? 'bg-emerald-600' : 'bg-rose-600'
                      }`}></span>
                    </span>

                    <span className="px-2 py-0.5 rounded-md bg-black/60 backdrop-blur text-white text-[10px] font-bold">
                      {meal.nutrition.calories} kcal
                    </span>
                  </div>

                  {/* Rating Badge */}
                  <div className="absolute top-3 right-3 bg-white/95 backdrop-blur px-2.5 py-1 rounded-xl text-xs font-black text-gray-900 flex items-center gap-1 shadow-sm">
                    <Star className="w-3.5 h-3.5 text-amber-500 fill-amber-500" />
                    <span>{meal.rating}</span>
                  </div>

                  {/* Distance pill */}
                  <div className="absolute bottom-3 left-3 bg-black/70 backdrop-blur-md text-white text-[10px] font-semibold px-2.5 py-0.5 rounded-md flex items-center gap-1 shadow-sm">
                    <span className="text-hb-orange">📍</span>
                    <span>{meal.campusDistanceKm} km {currentCampus ? `from ${currentCampus.split(',')[0].trim()}` : 'from gate'}</span>
                  </div>
                </div>

                {/* Content Section */}
                <div className="p-5">
                  {/* Chef Bio Header */}
                  <div className="flex items-center gap-2 mb-2">
                    <div className="w-6 h-6 rounded-full bg-orange-100 text-hb-orange flex items-center justify-center flex-shrink-0 border border-orange-200 shadow-xs">
                      <ChefHat className="w-3.5 h-3.5" />
                    </div>
                    <div className="flex items-center gap-1 truncate">
                      <span className="text-xs text-gray-700 font-semibold truncate">
                        {meal.kitchenName}
                      </span>
                      {meal.isChefVerified && (
                        <ShieldCheck className="w-3.5 h-3.5 text-hb-green-600 flex-shrink-0" />
                      )}
                    </div>
                  </div>

                  {/* Meal Title */}
                  <h3 
                    onClick={() => setSelectedMealForDetails(meal)}
                    className="text-base font-extrabold text-gray-900 leading-snug group-hover:text-hb-green-700 cursor-pointer line-clamp-2 mb-2"
                  >
                    {meal.name}
                  </h3>

                  <p className="text-xs text-gray-500 line-clamp-2 leading-relaxed mb-3">
                    {meal.description}
                  </p>

                  {/* Mini Nutrition Bar */}
                  <div className="flex items-center justify-between text-[11px] bg-hb-cream/60 p-2 rounded-xl border border-hb-green-100">
                    <span className="text-gray-600">
                      Protein: <strong className="text-hb-green-700">{meal.nutrition.protein}g</strong>
                    </span>
                    <span className="text-gray-300">•</span>
                    <span className="text-gray-600">
                      Prep: <strong>{meal.prepTimeMinutes}m</strong>
                    </span>
                    <span className="text-gray-300">•</span>
                    <span className="text-gray-600">
                      Spice: <strong>{meal.spiceLevel}</strong>
                    </span>
                  </div>

                </div>
              </div>

              {/* Card Footer: Price & Add Button */}
              <div className="p-5 pt-0 flex items-center justify-between">
                <div>
                  <div className="flex items-baseline gap-1">
                    <span className="text-lg font-black text-gray-900">₹{meal.price}</span>
                    {meal.originalPrice && (
                      <span className="text-xs text-gray-400 line-through">₹{meal.originalPrice}</span>
                    )}
                  </div>
                  <span className="text-[10px] text-hb-green-700 font-bold">Free Campus Delivery</span>
                </div>

                <div className="flex items-center gap-1.5">
                  <button
                    onClick={() => setSelectedMealForDetails(meal)}
                    className="px-2.5 py-2 text-xs font-bold text-gray-600 hover:text-gray-900 hover:bg-gray-100 rounded-xl transition"
                    title="View Nutrition & Ingredients"
                  >
                    Details
                  </button>
                  <button
                    onClick={() => addToCart(meal)}
                    className="px-3.5 py-2 rounded-xl bg-hb-green-600 hover:bg-hb-green-700 text-white text-xs font-bold shadow-sm transition transform active:scale-95 flex items-center gap-1"
                  >
                    <Plus className="w-3.5 h-3.5" />
                    <span>Add</span>
                  </button>
                </div>
              </div>

            </div>
          ))}
        </div>
      )}

    </div>
  );
};


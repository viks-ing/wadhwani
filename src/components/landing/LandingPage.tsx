import React, { useState } from 'react';
import { useApp } from '../../context/AppContext';
import { 
  Search, 
  MapPin, 
  Sparkles, 
  ShieldCheck, 
  Heart, 
  Clock, 
  ArrowRight, 
  CheckCircle, 
  XCircle, 
  Star, 
  TrendingUp,
  Award,
  Users,
  UtensilsCrossed,
  Flame,
  ChevronRight,
  LocateFixed,
  Loader2,
  ChefHat
} from 'lucide-react';

export const LandingPage: React.FC = () => {
  const { 
    setActiveView, 
    setCurrentCampus, 
    currentCampus,
    detectAndSetLocation,
    isLocating,
    meals, 
    addToCart, 
    setSelectedMealForDetails,
    openLoginModal,
    openRegisterModal,
    loginAsSandbox 
  } = useApp();

  const [searchQuery, setSearchQuery] = useState('');

  const selectCampusAndExplore = (campusName?: string) => {
    if (campusName?.trim()) {
      setCurrentCampus(campusName.trim());
    }
    setActiveView('customer');
  };

  const featuredMeals = meals.slice(0, 4);

  return (
    <div className="min-h-screen bg-hb-cream flex flex-col">
      {/* 1. HERO SECTION */}
      <section className="relative overflow-hidden pt-8 pb-16 lg:pt-16 lg:pb-24 border-b border-hb-green-100">
        <div className="absolute top-0 right-0 -mr-20 -mt-20 w-96 h-96 rounded-full bg-hb-green-100/60 filter blur-3xl pointer-events-none"></div>
        <div className="absolute bottom-0 left-0 -ml-20 -mb-20 w-80 h-80 rounded-full bg-hb-orange/15 filter blur-3xl pointer-events-none"></div>

        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 relative z-10">
          <div className="grid grid-cols-1 lg:grid-cols-12 gap-12 items-center">
            
            {/* Left Content */}
            <div className="lg:col-span-7 space-y-6 text-center lg:text-left">
              {/* Trust Pill */}
              <div className="inline-flex items-center gap-2 px-3.5 py-1.5 rounded-full bg-hb-green-50 border border-hb-green-200 text-hb-green-800 text-xs font-semibold shadow-sm">
                <span className="flex h-2 w-2 relative">
                  <span className="animate-ping absolute inline-flex h-full w-full rounded-full bg-hb-green-500 opacity-75"></span>
                  <span className="relative inline-flex rounded-full h-2 w-2 bg-hb-green-600"></span>
                </span>
                <span>Hyperlocal Homemade Food for Campuses & Workplaces</span>
              </div>

              <h1 className="text-4xl sm:text-5xl lg:text-6xl font-extrabold text-gray-900 tracking-tight leading-[1.12]">
                Homemade Goodness, <br className="hidden sm:inline" />
                <span className="text-hb-green-600 underline decoration-hb-orange/60 decoration-wavy decoration-2">
                  Delivered Daily.
                </span>
              </h1>

              <p className="text-lg sm:text-xl text-gray-600 max-w-2xl mx-auto lg:mx-0 font-normal leading-relaxed">
                Affordable, healthy, and hygienic home-cooked meals prepared with love by verified neighborhood home chefs. Fresh hot dabbas delivered directly to your hostel gate or office desk.
              </p>

              {/* Location Search Bar */}
              <div className="bg-white p-2.5 sm:p-3 rounded-2xl shadow-card border border-hb-green-200 max-w-xl mx-auto lg:mx-0">
                <div className="flex flex-col sm:flex-row items-center gap-2">
                  <div className="flex items-center gap-2.5 px-3 py-2 w-full flex-grow">
                    <MapPin className="w-5 h-5 text-hb-green-600 flex-shrink-0" />
                    <input
                      type="text"
                      value={searchQuery}
                      onChange={(e) => setSearchQuery(e.target.value)}
                      placeholder="Enter college, hostel, or workplace..."
                      className="w-full text-sm text-gray-800 placeholder-gray-400 focus:outline-none bg-transparent"
                    />
                  </div>
                  <button
                    onClick={() => selectCampusAndExplore(searchQuery || currentCampus)}
                    className="w-full sm:w-auto px-6 py-3 bg-hb-green-600 hover:bg-hb-green-700 text-white rounded-xl font-bold text-sm shadow-md transition flex items-center justify-center gap-2 flex-shrink-0"
                  >
                    <span>Find Meals</span>
                    <ArrowRight className="w-4 h-4" />
                  </button>
                </div>
              </div>

              {/* CTAs */}
              <div className="flex flex-col sm:flex-row items-center justify-center lg:justify-start gap-4 pt-2">
                <button
                  onClick={() => setActiveView('customer')}
                  className="w-full sm:w-auto px-8 py-3.5 bg-hb-green-600 hover:bg-hb-green-700 text-white font-bold rounded-xl shadow-lg shadow-hb-green-600/30 transition transform hover:-translate-y-0.5 flex items-center justify-center gap-2"
                >
                  <UtensilsCrossed className="w-5 h-5 text-hb-orange" />
                  <span>Explore Daily Meals</span>
                </button>
                <button
                  onClick={() => openLoginModal()}
                  className="w-full sm:w-auto px-7 py-3.5 bg-white hover:bg-hb-cream-200 text-hb-green-800 border-2 border-hb-green-600 font-bold rounded-xl transition flex items-center justify-center gap-2"
                >
                  <span>Become a Home Chef</span>
                  <ChevronRight className="w-4 h-4 text-hb-green-600" />
                </button>
              </div>

              {/* Key Trust Stats */}
              <div className="grid grid-cols-3 gap-4 pt-4 border-t border-hb-green-100 text-left">
                <div>
                  <p className="text-2xl font-black text-hb-green-700 font-display">₹79<span className="text-xs font-semibold text-gray-500">/meal</span></p>
                  <p className="text-xs text-gray-500">Starting price for students</p>
                </div>
                <div>
                  <p className="text-2xl font-black text-hb-green-700 font-display">100%</p>
                  <p className="text-xs text-gray-500">FSSAI verified home kitchens</p>
                </div>
                <div>
                  <p className="text-2xl font-black text-hb-green-700 font-display">4.9 ★</p>
                  <p className="text-xs text-gray-500">Hygiene & taste average</p>
                </div>
              </div>

            </div>

            {/* Right Hero Image Card Collage */}
            <div className="lg:col-span-5 relative">
              <div className="relative mx-auto max-w-md lg:max-w-none">
                {/* Main Hero Card */}
                <div className="relative rounded-3xl overflow-hidden shadow-2xl border-4 border-white bg-white group">
                  <img
                    src="https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=1000&q=80"
                    alt="Authentic Homestyle Indian Thali"
                    className="w-full h-80 sm:h-96 object-cover object-center group-hover:scale-105 transition-transform duration-700"
                  />
                  <div className="absolute inset-0 bg-gradient-to-t from-black/80 via-black/20 to-transparent flex flex-col justify-end p-6 text-white">
                    <div className="flex items-center gap-2 mb-2">
                      <span className="px-2.5 py-1 rounded-full bg-hb-green-600 text-white text-[11px] font-bold">
                        Special Lunch Box
                      </span>
                      <span className="px-2.5 py-1 rounded-full bg-white/20 backdrop-blur text-white text-[11px] font-semibold flex items-center gap-1">
                        <Flame className="w-3.5 h-3.5 text-hb-orange" /> Cooked 25 mins ago
                      </span>
                    </div>
                    <h3 className="text-xl font-bold leading-snug">Anita Aunty's Ghar Ka Rajma Chawal</h3>
                    <p className="text-xs text-gray-200 mt-1 flex items-center justify-between">
                      <span>With Phulkas, Salad & Pure Cow Ghee</span>
                      <span className="text-base font-black text-hb-orange">₹99 only</span>
                    </p>
                  </div>
                </div>

                {/* Floating Testimonial Capsule */}
                <div className="absolute -bottom-6 -left-6 bg-white p-3.5 rounded-2xl shadow-float border border-hb-green-100 flex items-center gap-3 max-w-xs animate-subtle-pulse">
                  <div className="w-10 h-10 rounded-full bg-hb-green-100 flex items-center justify-center text-hb-green-700 font-bold flex-shrink-0">
                    🍲
                  </div>
                  <div>
                    <p className="text-xs font-bold text-gray-900">"Tastes just like mom's cooking!"</p>
                    <p className="text-[10px] text-gray-500">Rohit M. • DTU 3rd Year CSE</p>
                  </div>
                </div>

                {/* Floating Verified Badge */}
                <div className="absolute -top-4 -right-4 bg-white px-3.5 py-2 rounded-2xl shadow-lg border border-hb-green-100 flex items-center gap-2">
                  <ShieldCheck className="w-5 h-5 text-hb-green-600" />
                  <div className="text-left">
                    <p className="text-[11px] font-extrabold text-hb-green-800 leading-none">Hygiene 4.9/5</p>
                    <p className="text-[9px] text-gray-500">FSSAI Certified</p>
                  </div>
                </div>

              </div>
            </div>

          </div>
        </div>
      </section>

      {/* 2. PROBLEM & SOLUTION SECTION */}
      <section className="py-16 sm:py-20 bg-white border-b border-hb-green-100">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          
          <div className="text-center max-w-3xl mx-auto mb-14">
            <span className="text-xs font-extrabold text-hb-orange uppercase tracking-wider bg-hb-orange-50 px-3 py-1 rounded-full border border-hb-orange-200">
              The Daily Struggle vs. The HomeBite Way
            </span>
            <h2 className="text-3xl sm:text-4xl font-extrabold text-gray-900 mt-3 font-display">
              Why Campus Food Sucks & How We Fix It
            </h2>
            <p className="text-base text-gray-600 mt-3">
              College students and young working professionals face a frustrating food dilemma every single day.
            </p>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-2 gap-8 items-stretch">
            
            {/* The Problem Card */}
            <div className="bg-rose-50/70 border-2 border-rose-200 rounded-3xl p-6 sm:p-8 flex flex-col justify-between">
              <div>
                <div className="flex items-center gap-3 mb-6">
                  <div className="w-10 h-10 rounded-2xl bg-rose-500 text-white flex items-center justify-center font-bold text-lg">
                    ✕
                  </div>
                  <div>
                    <h3 className="text-xl font-bold text-rose-950">The Current Daily Struggle</h3>
                    <p className="text-xs text-rose-700">Food delivery apps & repetitive college canteens</p>
                  </div>
                </div>

                <div className="space-y-4">
                  <div className="flex items-start gap-3">
                    <XCircle className="w-5 h-5 text-rose-500 flex-shrink-0 mt-0.5" />
                    <div>
                      <p className="text-sm font-bold text-gray-900">Expensive Restaurant Deliveries</p>
                      <p className="text-xs text-gray-600">A single basic meal costs ₹250 to ₹400 with hidden surge fees, platform charges, and tips.</p>
                    </div>
                  </div>

                  <div className="flex items-start gap-3">
                    <XCircle className="w-5 h-5 text-rose-500 flex-shrink-0 mt-0.5" />
                    <div>
                      <p className="text-sm font-bold text-gray-900">Unhealthy, Oily, Heavy Meals</p>
                      <p className="text-xs text-gray-600">Reused palm oils, excessive sodium, and food color lead to lethargy, brain fog, and weight gain.</p>
                    </div>
                  </div>

                  <div className="flex items-start gap-3">
                    <XCircle className="w-5 h-5 text-rose-500 flex-shrink-0 mt-0.5" />
                    <div>
                      <p className="text-sm font-bold text-gray-900">Monotonous Mess & Hostel Food</p>
                      <p className="text-xs text-gray-600">Watery dal, undercooked rotis, and repetitive weekly menus that students end up skipping.</p>
                    </div>
                  </div>

                  <div className="flex items-start gap-3">
                    <XCircle className="w-5 h-5 text-rose-500 flex-shrink-0 mt-0.5" />
                    <div>
                      <p className="text-sm font-bold text-gray-900">Zero Time to Cook Daily</p>
                      <p className="text-xs text-gray-600">Hostel rooms lack kitchens, and young professionals working 10h shifts cannot prep groceries.</p>
                    </div>
                  </div>
                </div>
              </div>

              <div className="mt-8 pt-4 border-t border-rose-200/60 text-xs font-semibold text-rose-800">
                Result: Spending ₹8,000-₹12,000/month on unhealthy outside food.
              </div>
            </div>

            {/* The HomeBite Solution Card */}
            <div className="bg-hb-green-50/70 border-2 border-hb-green-300 rounded-3xl p-6 sm:p-8 flex flex-col justify-between shadow-soft">
              <div>
                <div className="flex items-center gap-3 mb-6">
                  <div className="w-10 h-10 rounded-2xl bg-hb-green-600 text-white flex items-center justify-center font-bold text-lg">
                    ✓
                  </div>
                  <div>
                    <h3 className="text-xl font-bold text-hb-green-950">The HomeBite Experience</h3>
                    <p className="text-xs text-hb-green-800">Hyperlocal, mom-cooked, affordable & nutritious</p>
                  </div>
                </div>

                <div className="space-y-4">
                  <div className="flex items-start gap-3">
                    <CheckCircle className="w-5 h-5 text-hb-green-600 flex-shrink-0 mt-0.5" />
                    <div>
                      <p className="text-sm font-bold text-gray-900">Pocket-Friendly: Starting ₹79/meal</p>
                      <p className="text-xs text-gray-600">Save up to 60% compared to food delivery apps. Weekly student dabba plans reduce cost to ₹69/meal.</p>
                    </div>
                  </div>

                  <div className="flex items-start gap-3">
                    <CheckCircle className="w-5 h-5 text-hb-green-600 flex-shrink-0 mt-0.5" />
                    <div>
                      <p className="text-sm font-bold text-gray-900">100% Homestyle Hygiene & Low Oil</p>
                      <p className="text-xs text-gray-600">Prepared fresh with pure desi ghee/mustard oil, whole grains, and macro-balanced protein.</p>
                    </div>
                  </div>

                  <div className="flex items-start gap-3">
                    <CheckCircle className="w-5 h-5 text-hb-green-600 flex-shrink-0 mt-0.5" />
                    <div>
                      <p className="text-sm font-bold text-gray-900">Loving Neighborhood Home Chefs</p>
                      <p className="text-xs text-gray-600">Prepared by verified home cooks living within 2km of your campus, maintaining family kitchen standards.</p>
                    </div>
                  </div>

                  <div className="flex items-start gap-3">
                    <CheckCircle className="w-5 h-5 text-hb-green-600 flex-shrink-0 mt-0.5" />
                    <div>
                      <p className="text-sm font-bold text-gray-900">Scheduled Daily Campus Delivery</p>
                      <p className="text-xs text-gray-600">Hot meals delivered right outside your hostel gate at exact lunch (12:30 PM) and dinner (8:00 PM) slots.</p>
                    </div>
                  </div>
                </div>
              </div>

              <div className="mt-8 pt-4 border-t border-hb-green-200 text-xs font-bold text-hb-green-800 flex items-center justify-between">
                <span>Result: Save ₹4,000+ monthly & eat nutritious daily.</span>
                <span className="text-hb-orange font-black">100% Home Taste</span>
              </div>
            </div>

          </div>

        </div>
      </section>

      {/* 3. HOW IT WORKS */}
      <section className="py-16 sm:py-20 bg-hb-cream border-b border-hb-green-100">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          
          <div className="text-center max-w-2xl mx-auto mb-14">
            <span className="text-xs font-extrabold text-hb-green-700 uppercase tracking-wider bg-hb-green-100 px-3 py-1 rounded-full border border-hb-green-200">
              Simple 4-Step Process
            </span>
            <h2 className="text-3xl sm:text-4xl font-extrabold text-gray-900 mt-3 font-display">
              How HomeBite Works
            </h2>
            <p className="text-sm sm:text-base text-gray-600 mt-2">
              From local home kitchen to your hostel plate in under 30 minutes.
            </p>
          </div>

          <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6">
            
            {/* Step 1 */}
            <div className="bg-white rounded-2xl p-6 border border-hb-green-100 shadow-sm relative group hover:border-hb-green-400 hover:shadow-md transition">
              <div className="w-12 h-12 rounded-2xl bg-hb-green-100 text-hb-green-700 flex items-center justify-center font-bold text-xl mb-4 group-hover:bg-hb-green-600 group-hover:text-white transition">
                1
              </div>
              <h3 className="text-lg font-bold text-gray-900 mb-1">Enter Your Campus</h3>
              <p className="text-xs text-gray-600 leading-relaxed">
                Choose your college campus, tech park, or hostel location to see verified home kitchens in your immediate 2km radius.
              </p>
            </div>

            {/* Step 2 */}
            <div className="bg-white rounded-2xl p-6 border border-hb-green-100 shadow-sm relative group hover:border-hb-green-400 hover:shadow-md transition">
              <div className="w-12 h-12 rounded-2xl bg-hb-green-100 text-hb-green-700 flex items-center justify-center font-bold text-xl mb-4 group-hover:bg-hb-green-600 group-hover:text-white transition">
                2
              </div>
              <h3 className="text-lg font-bold text-gray-900 mb-1">Explore Nearby Chefs</h3>
              <p className="text-xs text-gray-600 leading-relaxed">
                Browse aunties and local home cooks, inspect their FSSAI certification, kitchen cleanliness photos, and community ratings.
              </p>
            </div>

            {/* Step 3 */}
            <div className="bg-white rounded-2xl p-6 border border-hb-green-100 shadow-sm relative group hover:border-hb-green-400 hover:shadow-md transition">
              <div className="w-12 h-12 rounded-2xl bg-hb-green-100 text-hb-green-700 flex items-center justify-center font-bold text-xl mb-4 group-hover:bg-hb-green-600 group-hover:text-white transition">
                3
              </div>
              <h3 className="text-lg font-bold text-gray-900 mb-1">Select Meal or Dabba</h3>
              <p className="text-xs text-gray-600 leading-relaxed">
                Order a single lunch combo or subscribe to a 7-day or 30-day student dabba plan to unlock automated daily deliveries.
              </p>
            </div>

            {/* Step 4 */}
            <div className="bg-white rounded-2xl p-6 border border-hb-green-100 shadow-sm relative group hover:border-hb-green-400 hover:shadow-md transition">
              <div className="w-12 h-12 rounded-2xl bg-hb-green-100 text-hb-green-700 flex items-center justify-center font-bold text-xl mb-4 group-hover:bg-hb-green-600 group-hover:text-white transition">
                4
              </div>
              <h3 className="text-lg font-bold text-gray-900 mb-1">Piping Hot Delivery</h3>
              <p className="text-xs text-gray-600 leading-relaxed">
                Track your meal in real-time as the chef packs it fresh and our delivery partner brings it straight to your hostel entrance.
              </p>
            </div>

          </div>

        </div>
      </section>

      {/* 4. FEATURED MEALS SECTION */}
      <section className="py-16 sm:py-20 bg-white border-b border-hb-green-100">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          
          <div className="flex flex-col sm:flex-row sm:items-end justify-between mb-10 gap-4">
            <div>
              <span className="text-xs font-extrabold text-hb-orange uppercase tracking-wider bg-hb-orange-50 px-3 py-1 rounded-full border border-hb-orange-200">
                Fresh From The Kitchen Today
              </span>
              <h2 className="text-3xl font-extrabold text-gray-900 mt-2 font-display">
                Featured Campus Meals
              </h2>
              <p className="text-sm text-gray-600 mt-1">
                Cooked in small batches with zero preservatives. Freshly prepared today.
              </p>
            </div>

            <button
              onClick={() => setActiveView('customer')}
              className="inline-flex items-center gap-1.5 text-sm font-bold text-hb-green-700 hover:text-hb-green-800 self-start sm:self-auto"
            >
              <span>View All 16+ Meals</span>
              <ArrowRight className="w-4 h-4" />
            </button>
          </div>

          <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6">
            {featuredMeals.map((meal) => (
              <div
                key={meal.id}
                className="bg-hb-cream/40 rounded-2xl border border-hb-green-100 overflow-hidden shadow-sm hover:shadow-card transition flex flex-col justify-between group"
              >
                <div>
                  {/* Meal Image with Badges */}
                  <div 
                    onClick={() => setSelectedMealForDetails(meal)}
                    className="relative h-44 overflow-hidden cursor-pointer"
                  >
                    <img
                      src={meal.imageUrl}
                      alt={meal.name}
                      className="w-full h-full object-cover group-hover:scale-105 transition-transform duration-500"
                    />
                    <div className="absolute top-2.5 left-2.5 flex items-center gap-1.5">
                      <span className={`w-3.5 h-3.5 rounded-full border-2 flex items-center justify-center bg-white ${
                        meal.dietary === 'veg' ? 'border-emerald-600' : 'border-rose-600'
                      }`}>
                        <span className={`w-1.5 h-1.5 rounded-full ${
                          meal.dietary === 'veg' ? 'bg-emerald-600' : 'bg-rose-600'
                        }`}></span>
                      </span>
                      <span className="px-2 py-0.5 rounded-md bg-black/60 backdrop-blur text-white text-[10px] font-bold">
                        {meal.nutrition.calories} kcal
                      </span>
                    </div>

                    <div className="absolute top-2.5 right-2.5 bg-white/90 backdrop-blur px-2 py-0.5 rounded-md text-[11px] font-extrabold text-gray-800 flex items-center gap-1 shadow-sm">
                      <Star className="w-3 h-3 text-amber-500 fill-amber-500" />
                      <span>{meal.rating}</span>
                    </div>

                    <div className="absolute bottom-2 left-2 bg-black/70 backdrop-blur-md text-white text-[9px] font-semibold px-2 py-0.5 rounded-md flex items-center gap-1">
                      <span>📍 {meal.campusDistanceKm} km {currentCampus ? `from ${currentCampus.split(',')[0].trim()}` : ''}</span>
                    </div>
                  </div>

                  {/* Body Content */}
                  <div className="p-4">
                    {/* Chef Info */}
                    <div className="flex items-center gap-2 mb-2">
                      <div className="w-6 h-6 rounded-full bg-orange-100 text-hb-orange flex items-center justify-center flex-shrink-0 border border-orange-200">
                        <ChefHat className="w-3.5 h-3.5" />
                      </div>
                      <span className="text-xs text-gray-600 font-medium truncate">
                        {meal.kitchenName}
                      </span>
                    </div>

                    <h4 
                      onClick={() => setSelectedMealForDetails(meal)}
                      className="text-sm font-bold text-gray-900 leading-snug hover:text-hb-green-700 cursor-pointer line-clamp-2 mb-2"
                    >
                      {meal.name}
                    </h4>

                    {/* Macros Bar */}
                    <div className="flex items-center justify-between text-[11px] text-gray-500 bg-white p-2 rounded-xl border border-gray-100 mb-3">
                      <div>
                        <span className="text-gray-400 block text-[9px] uppercase">Protein</span>
                        <span className="font-bold text-hb-green-700">{meal.nutrition.protein}g</span>
                      </div>
                      <div className="w-px h-6 bg-gray-100"></div>
                      <div>
                        <span className="text-gray-400 block text-[9px] uppercase">Carbs</span>
                        <span className="font-bold text-gray-700">{meal.nutrition.carbs}g</span>
                      </div>
                      <div className="w-px h-6 bg-gray-100"></div>
                      <div>
                        <span className="text-gray-400 block text-[9px] uppercase">Prep</span>
                        <span className="font-bold text-gray-700">{meal.prepTimeMinutes}m</span>
                      </div>
                    </div>
                  </div>
                </div>

                {/* Footer Action */}
                <div className="p-4 pt-0 flex items-center justify-between">
                  <div>
                    <span className="text-base font-extrabold text-gray-900">₹{meal.price}</span>
                    {meal.originalPrice && (
                      <span className="text-xs text-gray-400 line-through ml-1.5">₹{meal.originalPrice}</span>
                    )}
                  </div>
                  <button
                    onClick={() => addToCart(meal)}
                    className="px-3.5 py-1.5 rounded-xl bg-hb-green-600 hover:bg-hb-green-700 text-white text-xs font-bold shadow-sm transition transform active:scale-95"
                  >
                    + Add to Cart
                  </button>
                </div>
              </div>
            ))}
          </div>

        </div>
      </section>

      {/* 5. WHY HOMEBITE */}
      <section className="py-16 sm:py-20 bg-hb-cream border-b border-hb-green-100">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          
          <div className="text-center max-w-2xl mx-auto mb-14">
            <span className="text-xs font-extrabold text-hb-green-800 uppercase tracking-wider bg-hb-green-100 px-3 py-1 rounded-full border border-hb-green-200">
              Our Core Promise
            </span>
            <h2 className="text-3xl sm:text-4xl font-extrabold text-gray-900 mt-3 font-display">
              Why Students & Professionals Choose HomeBite
            </h2>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
            <div className="bg-white p-6 rounded-3xl border border-hb-green-100 shadow-soft">
              <div className="w-12 h-12 rounded-2xl bg-hb-green-100 text-hb-green-700 flex items-center justify-center mb-5">
                <Heart className="w-6 h-6 text-hb-green-600" />
              </div>
              <h3 className="text-lg font-bold text-gray-900 mb-2">Real Ghar Ka Khana (0% Preservatives)</h3>
              <p className="text-xs text-gray-600 leading-relaxed">
                Cooked exactly like in an Indian home: no artificial thickeners, zero food color, no reused trans fats, and light spices that keep your stomach happy.
              </p>
            </div>

            <div className="bg-white p-6 rounded-3xl border border-hb-green-100 shadow-soft">
              <div className="w-12 h-12 rounded-2xl bg-amber-100 text-amber-700 flex items-center justify-center mb-5">
                <ShieldCheck className="w-6 h-6 text-amber-600" />
              </div>
              <h3 className="text-lg font-bold text-gray-900 mb-2">FSSAI Certified & Inspected Kitchens</h3>
              <p className="text-xs text-gray-600 leading-relaxed">
                Every home chef on HomeBite undergoes strict personal kitchen audits, hair-net & hygiene checks, and must hold a verified FSSAI registration.
              </p>
            </div>

            <div className="bg-white p-6 rounded-3xl border border-hb-green-100 shadow-soft">
              <div className="w-12 h-12 rounded-2xl bg-orange-100 text-orange-700 flex items-center justify-center mb-5">
                <Clock className="w-6 h-6 text-orange-600" />
              </div>
              <h3 className="text-lg font-bold text-gray-900 mb-2">Flexible Weekly & Monthly Dabbas</h3>
              <p className="text-xs text-gray-600 leading-relaxed">
                Pause anytime with 3 hours notice when you travel home for the weekend. No locked-in waste, with guaranteed hot meals delivered on schedule.
              </p>
            </div>
          </div>

        </div>
      </section>

      {/* 6. CTA BANNER */}
      <section className="py-12 bg-gradient-to-r from-hb-green-700 via-hb-green-600 to-hb-green-800 text-white">
        <div className="max-w-6xl mx-auto px-4 sm:px-6 lg:px-8 text-center space-y-4">
          <h2 className="text-3xl sm:text-4xl font-black font-display">
            Ready to Eat Better & Save Money?
          </h2>
          <p className="text-base text-hb-cream-200 max-w-xl mx-auto">
            Join 3,500+ college students enjoying warm homemade meals every day.
          </p>
          <div className="pt-2 flex flex-col sm:flex-row items-center justify-center gap-3">
            <button
              onClick={() => setActiveView('customer')}
              className="px-8 py-3.5 bg-hb-orange hover:bg-orange-500 text-white rounded-xl font-bold shadow-lg transition transform hover:scale-105"
            >
              Order Your First Meal Now (₹25 OFF)
            </button>
            <button
              onClick={() => setActiveView('subscriptions')}
              className="px-6 py-3.5 bg-white/10 hover:bg-white/20 border border-white/30 text-white rounded-xl font-bold transition"
            >
              View Student Dabba Plans
            </button>
          </div>
        </div>
      </section>

      {/* FOOTER */}
      <footer className="bg-hb-green-950 text-white py-12 border-t border-hb-green-900 text-xs">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="grid grid-cols-1 md:grid-cols-4 gap-8 mb-8">
            <div className="space-y-3">
              <div className="flex items-center gap-2">
                <span className="text-2xl">🍲</span>
                <span className="text-xl font-black text-white font-display">HomeBite</span>
              </div>
              <p className="text-gray-400 text-xs leading-relaxed">
                Hyperlocal homemade meal marketplace built for students and young professionals. Wholesome, hygienic, and affordable.
              </p>
              <div className="flex items-center gap-2 text-[11px] text-hb-green-400 font-semibold">
                <ShieldCheck className="w-4 h-4" />
                <span>FSSAI Partner Kitchen Compliant</span>
              </div>
            </div>

            <div>
              <p className="font-bold text-white uppercase tracking-wider mb-3">Popular Campus Hubs</p>
              <ul className="space-y-1.5 text-gray-400">
                <li>Delhi Technological University (DTU)</li>
                <li>IIT Bombay, Powai</li>
                <li>North Campus, Delhi University</li>
                <li>Koramangala Tech Park Hub</li>
                <li>St. Xavier's College, Mumbai</li>
              </ul>
            </div>

            <div>
              <p className="font-bold text-white uppercase tracking-wider mb-3">Community & Chefs</p>
              <ul className="space-y-1.5 text-gray-400">
                <li><button onClick={() => openRegisterModal()} className="hover:text-hb-orange">Register Your Home Kitchen</button></li>
                <li>Hygiene Guidelines & Audits</li>
                <li>Eco-friendly Steel Dabba Initiative</li>
                <li>Student Campus Ambassador Program</li>
              </ul>
            </div>

            <div>
              <p className="font-bold text-white uppercase tracking-wider mb-3">Sandbox Demo Accounts</p>
              <div className="flex flex-col gap-2">
                <button
                  onClick={() => loginAsSandbox('customer')}
                  className="px-3 py-1.5 rounded bg-hb-green-900 text-gray-200 hover:text-white text-left font-medium"
                >
                  🎓 Login as Student (Aarav)
                </button>
                <button
                  onClick={() => loginAsSandbox('chef')}
                  className="px-3 py-1.5 rounded bg-hb-green-900 text-gray-200 hover:text-white text-left font-medium"
                >
                  👩‍🍳 Login as Chef (Anita)
                </button>
                <button
                  onClick={() => loginAsSandbox('delivery')}
                  className="px-3 py-1.5 rounded bg-hb-green-900 text-gray-200 hover:text-white text-left font-medium"
                >
                  🛵 Login as Rider (Ramesh)
                </button>
              </div>
            </div>
          </div>

          <div className="pt-8 border-t border-hb-green-900 flex flex-col sm:flex-row items-center justify-between text-gray-500 text-[11px]">
            <p>© 2026 HomeBite Technologies Pvt. Ltd. Made with ❤️ for hungry hostelites.</p>
            <p>Empowering local home chefs across 45+ campuses.</p>
          </div>
        </div>
      </footer>
    </div>
  );
};


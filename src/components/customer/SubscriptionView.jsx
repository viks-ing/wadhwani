import React, { useState } from 'react';
import { useApp } from '../../context/AppContext';
import { SUBSCRIPTION_PLANS, DABBA_COMBO_MENUS, WEEKLY_DABBA_ROTATION } from '../../data/mockData';
import {
    Check,
    Sparkles,
    ShieldCheck,
    ArrowRight,
    PauseCircle,
    Utensils,
    Flame,
    Star,
    Clock,
    ShoppingBag,
    Calendar,
    Sun,
    Moon,
    Layers
} from 'lucide-react';

const COMBO_CATEGORIES = ['All Combos', 'Homestyle Veg', 'High-Protein', 'South Indian', 'Non-Veg Specials'];

export const SubscriptionView = () => {
    const { userSubscriptions, subscribeToPlan, currentCampus, addToCart, setIsCartOpen } = useApp();
    const [selectedCategory, setSelectedCategory] = useState('All Combos');
    const [selectedDay, setSelectedDay] = useState('Mon');

    const filteredCombos = selectedCategory === 'All Combos'
        ? DABBA_COMBO_MENUS
        : DABBA_COMBO_MENUS.filter((combo) => combo.category === selectedCategory);

    const activeDaySchedule = WEEKLY_DABBA_ROTATION.find((d) => d.day === selectedDay) || WEEKLY_DABBA_ROTATION[0];

    const handleOrderTrialCombo = (combo) => {
        const trialMeal = {
            id: `trial-${combo.id}`,
            chefId: combo.chefId,
            chefName: combo.chefName,
            chefAvatar: '',
            kitchenName: combo.kitchenName,
            isChefVerified: true,
            name: `${combo.name} (1-Day Trial Dabba)`,
            description: combo.description,
            category: 'lunch',
            dietary: combo.dietary,
            price: combo.trialPrice,
            originalPrice: combo.originalPrice,
            rating: combo.rating,
            reviewsCount: 120,
            prepTimeMinutes: 25,
            imageUrl: combo.imageUrl,
            ingredients: combo.tiers,
            nutrition: {
                calories: combo.calories,
                protein: combo.protein,
                carbs: 65,
                fats: 12
            },
            isAvailable: true,
            tags: combo.tags,
            spiceLevel: 'Mild',
            servingSize: 'Full 3-Tier Dabba Combo',
            campusDistanceKm: 1.1
        };
        addToCart(trialMeal, 1);
        setIsCartOpen(true);
    };

    const campusLabel = currentCampus ? currentCampus.split(',')[0] : 'SNIST Campus';

    return (
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8 sm:py-12 space-y-14 animate-fadeIn">

            {/* Header Banner */}
            <div className="text-center max-w-3xl mx-auto space-y-3">
                <div className="inline-flex items-center gap-2 px-3.5 py-1 rounded-full bg-hb-orange-50 border border-hb-orange-200 text-hb-orange text-xs font-bold uppercase tracking-wider">
                    <Sparkles className="w-3.5 h-3.5" />
                    <span>Save up to ₹3,100 Every Month</span>
                </div>
                <h1 className="text-3xl sm:text-4xl font-black text-gray-900 font-display">
                    Hostel & Campus Dabba Subscriptions
                </h1>
                <p className="text-sm sm:text-base text-gray-600">
                    Scheduled warm lunch & dinner combos delivered straight to your hostel gate at <strong>{campusLabel}</strong>. Pause anytime when you go home for the weekend!
                </p>
            </div>

            {/* 1. Plan Cards Grid */}
            <div className="grid grid-cols-1 md:grid-cols-3 gap-8 items-stretch">
                {SUBSCRIPTION_PLANS.map((plan) => {
                    const isEnrolled = userSubscriptions.includes(plan.id);
                    return (
                        <div
                            key={plan.id}
                            className={`rounded-3xl p-6 sm:p-8 flex flex-col justify-between transition-all duration-300 relative ${
                                plan.popular
                                    ? 'bg-white border-2 border-hb-green-600 shadow-xl ring-4 ring-hb-green-100'
                                    : 'bg-white border border-hb-green-100 shadow-soft hover:shadow-card'
                            }`}
                        >
                            {plan.popular && (
                                <div className="absolute -top-3.5 left-1/2 -translate-x-1/2 px-4 py-1 rounded-full bg-hb-orange text-white text-[11px] font-black tracking-wide uppercase shadow-sm whitespace-nowrap">
                                    ★ Most Popular on Campus
                                </div>
                            )}

                            <div>
                                {/* Title & Tagline */}
                                <div className="border-b border-gray-100 pb-5">
                                    <h3 className="text-xl font-black text-gray-900">{plan.title}</h3>
                                    <p className="text-xs text-gray-500 mt-1">{plan.tagline}</p>

                                    <div className="mt-4 flex items-baseline gap-2">
                                        <span className="text-3xl font-black text-gray-900">₹{plan.totalPrice}</span>
                                        <span className="text-xs text-gray-400 line-through">₹{plan.originalPrice}</span>
                                        <span className="px-2 py-0.5 rounded bg-emerald-100 text-emerald-800 text-xs font-bold">
                                            Save ₹{plan.savings}
                                        </span>
                                    </div>
                                    <p className="text-[11px] text-hb-green-700 font-bold mt-1">
                                        Just ₹{plan.pricePerMeal} per wholesome thali!
                                    </p>
                                </div>

                                {/* Features List */}
                                <div className="py-6 space-y-3">
                                    <p className="text-xs font-bold text-gray-700 uppercase tracking-wider">What's Included:</p>
                                    {plan.features.map((feat, idx) => (
                                        <div key={idx} className="flex items-start gap-2.5 text-xs text-gray-600">
                                            <div className="w-4 h-4 rounded-full bg-hb-green-100 text-hb-green-700 flex items-center justify-center flex-shrink-0 mt-0.5">
                                                <Check className="w-2.5 h-2.5" />
                                            </div>
                                            <span>{feat}</span>
                                        </div>
                                    ))}
                                </div>
                            </div>

                            {/* Action Button */}
                            <div className="pt-4 border-t border-gray-100">
                                {isEnrolled ? (
                                    <div className="w-full py-3 rounded-2xl bg-emerald-50 text-emerald-800 border border-emerald-300 text-center font-bold text-xs flex items-center justify-center gap-2">
                                        <Check className="w-4 h-4 text-emerald-600" />
                                        <span>Active Subscription</span>
                                    </div>
                                ) : (
                                    <button
                                        onClick={() => subscribeToPlan(plan)}
                                        className={`w-full py-3.5 px-6 rounded-2xl font-bold text-xs shadow-md transition flex items-center justify-center gap-2 ${
                                            plan.popular
                                                ? 'bg-hb-green-600 hover:bg-hb-green-700 text-white shadow-hb-green-600/30'
                                                : 'bg-gray-900 hover:bg-gray-800 text-white'
                                        }`}
                                    >
                                        <span>Subscribe to Plan</span>
                                        <ArrowRight className="w-4 h-4" />
                                    </button>
                                )}
                            </div>
                        </div>
                    );
                })}
            </div>

            {/* 2. SIGNATURE DABBA COMBO MENUS SHOWCASE */}
            <div className="space-y-6">
                <div className="flex flex-col md:flex-row md:items-end justify-between gap-4">
                    <div>
                        <div className="inline-flex items-center gap-1.5 px-3 py-1 rounded-full bg-hb-green-50 border border-hb-green-200 text-hb-green-700 text-[11px] font-bold uppercase tracking-wider mb-2">
                            <Layers className="w-3.5 h-3.5" />
                            <span>3-Tier Steel Tiffin Showcase</span>
                        </div>
                        <h2 className="text-2xl sm:text-3xl font-black text-gray-900 font-display">
                            Signature Dabba Combo Menus
                        </h2>
                        <p className="text-xs sm:text-sm text-gray-600 mt-1">
                            Explore the curated homestyle combos included in your subscription — or order a 1-day trial dabba right now!
                        </p>
                    </div>

                    {/* Category Filter Pills */}
                    <div className="flex flex-wrap gap-2">
                        {COMBO_CATEGORIES.map((category) => (
                            <button
                                key={category}
                                onClick={() => setSelectedCategory(category)}
                                className={`px-3.5 py-2 rounded-full text-xs font-bold transition ${
                                    selectedCategory === category
                                        ? 'bg-hb-green-700 text-white shadow-sm'
                                        : 'bg-white border border-hb-green-200 text-gray-700 hover:bg-hb-green-50'
                                }`}
                            >
                                {category}
                            </button>
                        ))}
                    </div>
                </div>

                {/* Combo Cards Grid */}
                <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                    {filteredCombos.map((combo) => (
                        <div
                            key={combo.id}
                            className="bg-white rounded-3xl border border-hb-green-100 shadow-soft hover:shadow-card transition-all duration-300 overflow-hidden flex flex-col justify-between group"
                        >
                            <div>
                                {/* Dish Photo Header */}
                                <div className="relative h-48 overflow-hidden bg-gray-100">
                                    <img
                                        src={combo.imageUrl}
                                        alt={combo.name}
                                        className="w-full h-full object-cover group-hover:scale-105 transition-transform duration-500"
                                    />
                                    <div className="absolute inset-0 bg-gradient-to-t from-black/65 via-black/15 to-transparent" />

                                    {/* Top Badges */}
                                    <div className="absolute top-3 left-3 flex items-center gap-1.5">
                                        <span
                                            className={`px-2 py-0.5 rounded-md text-[10px] font-black uppercase tracking-wider flex items-center gap-1 bg-white/95 shadow-xs ${
                                                combo.dietary === 'veg' ? 'text-emerald-700' : 'text-rose-700'
                                            }`}
                                        >
                                            <span
                                                className={`w-2 h-2 rounded-full ${
                                                    combo.dietary === 'veg' ? 'bg-emerald-600' : 'bg-rose-600'
                                                }`}
                                            />
                                            {combo.dietary === 'veg' ? 'Pure Veg' : 'Non-Veg'}
                                        </span>
                                        <span className="px-2.5 py-0.5 rounded-md bg-hb-orange text-white text-[10px] font-extrabold shadow-xs">
                                            {combo.badge}
                                        </span>
                                    </div>

                                    {/* Rating Pill */}
                                    <div className="absolute top-3 right-3 px-2 py-0.5 rounded-lg bg-black/70 backdrop-blur-xs text-white text-[11px] font-bold flex items-center gap-1">
                                        <Star className="w-3 h-3 fill-amber-400 text-amber-400" />
                                        <span>{combo.rating}</span>
                                    </div>

                                    {/* Bottom Photo Info */}
                                    <div className="absolute bottom-3 left-3 right-3 text-white">
                                        <p className="text-[11px] font-semibold text-hb-cream-200 flex items-center gap-1">
                                            <Clock className="w-3 h-3" />
                                            <span>{combo.timing} • {combo.kitchenName}</span>
                                        </p>
                                        <h3 className="text-base font-black leading-snug mt-0.5">
                                            {combo.name}
                                        </h3>
                                    </div>
                                </div>

                                {/* Combo Body */}
                                <div className="p-5 space-y-4">
                                    <p className="text-xs text-gray-600 leading-relaxed">
                                        {combo.description}
                                    </p>

                                    {/* 3-Tier Dabba Breakdown */}
                                    <div className="bg-hb-cream/70 rounded-2xl p-3.5 border border-hb-green-100 space-y-2">
                                        <p className="text-[10px] font-black uppercase tracking-wider text-hb-green-800 flex items-center gap-1.5">
                                            <Utensils className="w-3 h-3 text-hb-orange" />
                                            <span>Inside This Dabba Combo:</span>
                                        </p>
                                        <ul className="space-y-1.5">
                                            {combo.tiers.map((tier, idx) => (
                                                <li key={idx} className="text-[11px] text-gray-700 flex items-start gap-2 leading-snug">
                                                    <span className="w-1.5 h-1.5 rounded-full bg-hb-green-600 flex-shrink-0 mt-1.5" />
                                                    <span>{tier}</span>
                                                </li>
                                            ))}
                                        </ul>
                                    </div>

                                    {/* Macros & Tags */}
                                    <div className="flex flex-wrap items-center justify-between gap-2 pt-1">
                                        <div className="flex items-center gap-2 text-[11px] font-bold">
                                            <span className="px-2.5 py-1 rounded-lg bg-emerald-50 text-emerald-700 border border-emerald-100">
                                                ⚡ {combo.protein}g Protein
                                            </span>
                                            <span className="px-2.5 py-1 rounded-lg bg-amber-50 text-amber-700 border border-amber-100 flex items-center gap-1">
                                                <Flame className="w-3 h-3" />
                                                {combo.calories} kcal
                                            </span>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            {/* Pricing & Trial CTA Footer */}
                            <div className="px-5 pb-5 pt-3 border-t border-gray-100 flex items-center justify-between gap-3">
                                <div>
                                    <span className="text-[10px] font-bold uppercase text-hb-green-700 block">
                                        On Plan: ₹{combo.subscriptionPrice}/meal
                                    </span>
                                    <div className="flex items-baseline gap-1.5">
                                        <span className="text-lg font-black text-gray-900">₹{combo.trialPrice}</span>
                                        <span className="text-[11px] text-gray-400 line-through">₹{combo.originalPrice}</span>
                                        <span className="text-[10px] text-gray-500">trial</span>
                                    </div>
                                </div>

                                <button
                                    onClick={() => handleOrderTrialCombo(combo)}
                                    className="px-4 py-2.5 rounded-xl bg-hb-green-600 hover:bg-hb-green-700 text-white font-bold text-xs shadow-sm transition flex items-center gap-1.5 active:scale-95"
                                >
                                    <ShoppingBag className="w-3.5 h-3.5" />
                                    <span>Order Trial</span>
                                </button>
                            </div>
                        </div>
                    ))}
                </div>
            </div>

            {/* 3. INTERACTIVE 7-DAY ROTATING MENU PREVIEW */}
            <div className="bg-white rounded-3xl p-6 sm:p-8 border border-hb-green-100 shadow-soft space-y-6">
                <div className="flex flex-col md:flex-row md:items-center justify-between gap-4">
                    <div>
                        <span className="inline-flex items-center gap-1.5 text-[11px] font-black uppercase tracking-wider text-hb-orange">
                            <Calendar className="w-3.5 h-3.5" />
                            <span>Zero-Repetition Weekly Schedule</span>
                        </span>
                        <h3 className="text-xl sm:text-2xl font-black text-gray-900 font-display mt-0.5">
                            Sample 7-Day Rotating Dabba Menu
                        </h3>
                    </div>

                    {/* Day Selector Pills */}
                    <div className="flex flex-wrap gap-1.5 bg-hb-cream p-1.5 rounded-2xl border border-hb-green-100">
                        {WEEKLY_DABBA_ROTATION.map((d) => (
                            <button
                                key={d.day}
                                onClick={() => setSelectedDay(d.day)}
                                className={`px-3.5 py-2 rounded-xl text-xs font-extrabold transition ${
                                    selectedDay === d.day
                                        ? 'bg-hb-green-700 text-white shadow-sm'
                                        : 'text-gray-600 hover:text-hb-green-800 hover:bg-white'
                                }`}
                            >
                                {d.day}
                            </button>
                        ))}
                    </div>
                </div>

                {/* Selected Day Highlight Banner */}
                <div className="flex items-center justify-between flex-wrap gap-2 px-4 py-2.5 rounded-2xl bg-hb-green-50 border border-hb-green-200 text-xs">
                    <span className="font-black text-hb-green-900">
                        {activeDaySchedule.fullDay}'s Featured Theme:
                    </span>
                    <span className="px-3 py-0.5 rounded-full bg-white text-hb-orange font-bold border border-hb-orange-200">
                        ✨ {activeDaySchedule.highlight}
                    </span>
                </div>

                {/* Lunch & Dinner Side-by-Side */}
                <div className="grid grid-cols-1 md:grid-cols-2 gap-5">
                    {/* Lunch Card */}
                    <div className="p-5 rounded-2xl bg-amber-50/50 border border-amber-200/80 space-y-2.5">
                        <div className="flex items-center justify-between">
                            <span className="inline-flex items-center gap-1.5 px-2.5 py-1 rounded-lg bg-amber-100 text-amber-800 text-[11px] font-extrabold">
                                <Sun className="w-3.5 h-3.5" />
                                <span>LUNCH DABBA (12:30 PM)</span>
                            </span>
                            <span className="text-[11px] font-bold text-gray-500">{activeDaySchedule.lunch.calories}</span>
                        </div>
                        <h4 className="text-sm sm:text-base font-black text-gray-900">
                            {activeDaySchedule.lunch.title}
                        </h4>
                        <p className="text-xs text-gray-600">
                            <strong>Accompaniments:</strong> {activeDaySchedule.lunch.sides}
                        </p>
                    </div>

                    {/* Dinner Card */}
                    <div className="p-5 rounded-2xl bg-indigo-50/40 border border-indigo-200/80 space-y-2.5">
                        <div className="flex items-center justify-between">
                            <span className="inline-flex items-center gap-1.5 px-2.5 py-1 rounded-lg bg-indigo-100 text-indigo-800 text-[11px] font-extrabold">
                                <Moon className="w-3.5 h-3.5" />
                                <span>DINNER DABBA (8:00 PM)</span>
                            </span>
                            <span className="text-[11px] font-bold text-gray-500">{activeDaySchedule.dinner.calories}</span>
                        </div>
                        <h4 className="text-sm sm:text-base font-black text-gray-900">
                            {activeDaySchedule.dinner.title}
                        </h4>
                        <p className="text-xs text-gray-600">
                            <strong>Accompaniments:</strong> {activeDaySchedule.dinner.sides}
                        </p>
                    </div>
                </div>
            </div>

            {/* 4. Subscription FAQ / Highlights */}
            <div className="bg-hb-cream rounded-3xl p-6 sm:p-8 border border-hb-green-200">
                <h3 className="text-lg font-bold text-gray-900 mb-4 font-display">
                    How NutriBite Subscriptions Work For Students
                </h3>
                <div className="grid grid-cols-1 md:grid-cols-3 gap-6 text-xs text-gray-600">
                    <div className="flex items-start gap-3">
                        <PauseCircle className="w-5 h-5 text-hb-green-600 flex-shrink-0 mt-0.5" />
                        <div>
                            <p className="font-bold text-gray-900">Pause Anytime</p>
                            <p className="mt-0.5 leading-relaxed">
                                Going home for Diwali or semester break? Pause meals anytime with 3 hours notice in the app. Unused meals rollover.
                            </p>
                        </div>
                    </div>

                    <div className="flex items-start gap-3">
                        <Utensils className="w-5 h-5 text-hb-orange flex-shrink-0 mt-0.5" />
                        <div>
                            <p className="font-bold text-gray-900">Zero Repetition Menu</p>
                            <p className="mt-0.5 leading-relaxed">
                                Our chefs rotate daily sabzis, dal varieties (Panchmel, Toor, Tadka, Chana), and thali desserts so you never get bored.
                            </p>
                        </div>
                    </div>

                    <div className="flex items-start gap-3">
                        <ShieldCheck className="w-5 h-5 text-emerald-600 flex-shrink-0 mt-0.5" />
                        <div>
                            <p className="font-bold text-gray-900">Returnable Steel Dabba</p>
                            <p className="mt-0.5 leading-relaxed">
                                Opt for traditional 3-tier stainless steel tiffins. Zero plastic waste. The delivery rider swaps the empty dabba daily!
                            </p>
                        </div>
                    </div>
                </div>
            </div>

        </div>
    );
};

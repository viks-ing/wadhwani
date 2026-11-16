import React from 'react';
import { useApp } from '../../context/AppContext';
import { SUBSCRIPTION_PLANS } from '../../data/mockData';
import { SubscriptionPlan } from '../../types';
import { 
  Check, 
  CalendarCheck, 
  Sparkles, 
  Clock, 
  ShieldCheck, 
  TrendingDown, 
  ArrowRight,
  PauseCircle,
  Utensils
} from 'lucide-react';

export const SubscriptionView: React.FC = () => {
  const { userSubscriptions, subscribeToPlan, currentCampus } = useApp();

  return (
    <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8 sm:py-12 space-y-10 animate-fadeIn">
      
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
          Scheduled warm lunch & dinner delivered straight to your hostel gate at {currentCampus.split(',')[0]}. Pause anytime when you go home for the weekend!
        </p>
      </div>

      {/* Plan Cards Grid */}
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
                <div className="absolute -top-3.5 left-1/2 -translate-x-1/2 px-4 py-1 rounded-full bg-hb-orange text-white text-[11px] font-black tracking-wide uppercase shadow-sm">
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

      {/* Subscription FAQ / Highlights */}
      <div className="bg-hb-cream rounded-3xl p-6 sm:p-8 border border-hb-green-200">
        <h3 className="text-lg font-bold text-gray-900 mb-4 font-display">
          How HomeBite Subscriptions Work For Students
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


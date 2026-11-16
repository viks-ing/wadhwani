import React, { useState } from 'react';
import { useApp } from '../../context/AppContext';
import { 
  X, 
  Star, 
  ShieldCheck, 
  Flame, 
  Check, 
  Plus, 
  Minus, 
  ShoppingBag,
  Award,
  Sparkles,
  Info,
  Clock,
  ChefHat
} from 'lucide-react';

export const MealDetailsModal: React.FC = () => {
  const { selectedMealForDetails, setSelectedMealForDetails, addToCart, currentCampus } = useApp();
  const [quantity, setQuantity] = useState(1);

  if (!selectedMealForDetails) return null;

  const meal = selectedMealForDetails;

  const handleAddToCart = () => {
    addToCart(meal, quantity);
    setSelectedMealForDetails(null);
  };

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/60 backdrop-blur-sm overflow-y-auto animate-fadeIn">
      <div className="bg-white rounded-3xl shadow-2xl max-w-2xl w-full overflow-hidden border border-hb-green-100 my-8">
        
        {/* Header Image */}
        <div className="relative h-64 sm:h-72 w-full overflow-hidden">
          <img
            src={meal.imageUrl}
            alt={meal.name}
            className="w-full h-full object-cover"
          />
          <button
            onClick={() => setSelectedMealForDetails(null)}
            className="absolute top-4 right-4 p-2 rounded-full bg-black/50 text-white hover:bg-black/75 transition"
          >
            <X className="w-5 h-5" />
          </button>

          <div className="absolute bottom-4 left-4 flex items-center gap-2">
            <span className={`px-2.5 py-1 rounded-full text-xs font-bold text-white flex items-center gap-1.5 ${
              meal.dietary === 'veg' ? 'bg-emerald-600' : 'bg-rose-600'
            }`}>
              <span className="w-2 h-2 rounded-full bg-white"></span>
              {meal.dietary === 'veg' ? 'Pure Vegetarian' : 'Non-Vegetarian'}
            </span>
            <span className="px-2.5 py-1 rounded-full bg-black/60 backdrop-blur text-white text-xs font-semibold flex items-center gap-1">
              <Clock className="w-3.5 h-3.5 text-hb-orange" />
              {meal.prepTimeMinutes} mins prep
            </span>
          </div>
        </div>

        {/* Modal Body */}
        <div className="p-6 sm:p-8 space-y-6 max-h-[calc(85vh-280px)] overflow-y-auto">
          
          {/* Title & Price */}
          <div className="flex flex-col sm:flex-row sm:items-start justify-between gap-2 border-b border-gray-100 pb-4">
            <div>
              <h2 className="text-xl sm:text-2xl font-black text-gray-900 leading-snug">
                {meal.name}
              </h2>
              <p className="text-xs text-gray-500 mt-1 flex items-center gap-2">
                <span>Serving size: <strong>{meal.servingSize}</strong></span>
                <span>•</span>
                <span>Spice: <strong>{meal.spiceLevel}</strong></span>
              </p>
            </div>
            <div className="text-right sm:text-right">
              <div className="text-2xl font-black text-hb-green-700">₹{meal.price}</div>
              {meal.originalPrice && (
                <div className="text-xs text-gray-400 line-through">₹{meal.originalPrice}</div>
              )}
            </div>
          </div>

          {/* Description */}
          <div>
            <p className="text-xs sm:text-sm text-gray-600 leading-relaxed">
              {meal.description}
            </p>
          </div>

          {/* Home Chef Verification Card */}
          <div className="p-4 rounded-2xl bg-hb-green-50/70 border border-hb-green-200 flex items-center justify-between gap-4">
            <div className="flex items-center gap-3">
              <div className="w-12 h-12 rounded-2xl bg-orange-100 text-hb-orange flex items-center justify-center border-2 border-hb-green-500 shadow-sm flex-shrink-0">
                <ChefHat className="w-6 h-6 text-hb-orange" />
              </div>
              <div>
                <div className="flex items-center gap-1.5">
                  <span className="text-sm font-bold text-gray-900">{meal.kitchenName}</span>
                  <ShieldCheck className="w-4 h-4 text-hb-green-600" />
                </div>
                <p className="text-xs text-gray-600">Cooked by {meal.chefName} • {meal.campusDistanceKm} km from {currentCampus ? currentCampus.split(',')[0] : 'campus'}</p>
                <div className="flex items-center gap-2 mt-0.5">
                  <span className="text-[10px] bg-hb-green-200/80 text-hb-green-900 font-bold px-1.5 py-0.2 rounded">
                    FSSAI Verified
                  </span>
                  <span className="text-[10px] text-gray-500">
                    Hygiene Score: <strong>4.9 / 5.0</strong>
                  </span>
                </div>
              </div>
            </div>

            <div className="text-right hidden sm:block">
              <div className="flex items-center justify-end gap-1 text-xs font-black text-amber-600">
                <Star className="w-3.5 h-3.5 fill-amber-500 text-amber-500" />
                <span>{meal.rating}</span>
              </div>
              <span className="text-[10px] text-gray-500">({meal.reviewsCount} reviews)</span>
            </div>
          </div>

          {/* Macro Nutrition Breakdown */}
          <div>
            <h4 className="text-xs font-bold text-gray-900 uppercase tracking-wider mb-2.5 flex items-center gap-1.5">
              <Sparkles className="w-3.5 h-3.5 text-hb-orange" />
              Nutritional Breakdown (Estimated per portion)
            </h4>
            <div className="grid grid-cols-4 gap-2 text-center">
              <div className="bg-hb-cream p-2.5 rounded-xl border border-hb-green-100">
                <span className="text-[10px] font-bold text-gray-500 uppercase block">Calories</span>
                <span className="text-base font-black text-gray-900">{meal.nutrition.calories}</span>
                <span className="text-[10px] text-gray-500 block">kcal</span>
              </div>
              <div className="bg-emerald-50 p-2.5 rounded-xl border border-emerald-100">
                <span className="text-[10px] font-bold text-emerald-700 uppercase block">Protein</span>
                <span className="text-base font-black text-emerald-800">{meal.nutrition.protein}g</span>
                <span className="text-[10px] text-emerald-600 block">High Protein</span>
              </div>
              <div className="bg-amber-50 p-2.5 rounded-xl border border-amber-100">
                <span className="text-[10px] font-bold text-amber-700 uppercase block">Carbs</span>
                <span className="text-base font-black text-amber-800">{meal.nutrition.carbs}g</span>
                <span className="text-[10px] text-amber-600 block">Complex</span>
              </div>
              <div className="bg-rose-50 p-2.5 rounded-xl border border-rose-100">
                <span className="text-[10px] font-bold text-rose-700 uppercase block">Fats</span>
                <span className="text-base font-black text-rose-800">{meal.nutrition.fats}g</span>
                <span className="text-[10px] text-rose-600 block">Low Oil / Ghee</span>
              </div>
            </div>
          </div>

          {/* Fresh Ingredients */}
          <div>
            <h4 className="text-xs font-bold text-gray-900 uppercase tracking-wider mb-2">
              Fresh Ingredients Used
            </h4>
            <div className="flex flex-wrap gap-1.5">
              {meal.ingredients.map((ing, idx) => (
                <span
                  key={idx}
                  className="px-2.5 py-1 rounded-lg bg-gray-100 text-gray-700 text-xs font-medium flex items-center gap-1"
                >
                  <Check className="w-3 h-3 text-hb-green-600" />
                  {ing}
                </span>
              ))}
            </div>
          </div>

        </div>

        {/* Modal Footer Controls */}
        <div className="p-4 sm:p-6 bg-gray-50 border-t border-gray-100 flex items-center justify-between gap-4">
          <div className="flex items-center gap-3 bg-white border border-gray-200 rounded-xl p-1 shadow-sm">
            <button
              onClick={() => setQuantity(Math.max(1, quantity - 1))}
              className="p-1.5 text-gray-600 hover:text-gray-900 hover:bg-gray-100 rounded-lg transition"
            >
              <Minus className="w-4 h-4" />
            </button>
            <span className="w-6 text-center font-bold text-sm text-gray-900">{quantity}</span>
            <button
              onClick={() => setQuantity(quantity + 1)}
              className="p-1.5 text-gray-600 hover:text-gray-900 hover:bg-gray-100 rounded-lg transition"
            >
              <Plus className="w-4 h-4" />
            </button>
          </div>

          <button
            onClick={handleAddToCart}
            className="flex-grow py-3 px-6 rounded-xl bg-hb-green-600 hover:bg-hb-green-700 text-white font-bold text-sm shadow-md transition flex items-center justify-center gap-2"
          >
            <ShoppingBag className="w-4 h-4" />
            <span>Add to Cart • ₹{meal.price * quantity}</span>
          </button>
        </div>

      </div>
    </div>
  );
};


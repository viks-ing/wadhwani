import React, { useState } from 'react';
import { useApp } from '../../context/AppContext';
import { X, ShoppingBag, Plus, Minus, Trash2, ArrowRight, Tag, ShieldCheck, Bike } from 'lucide-react';
export const CartDrawer = () => {
    const { isCartOpen, setIsCartOpen, cart, updateCartQuantity, removeFromCart, cartTotal, cartItemCount, setIsCheckoutOpen, currentCampus } = useApp();
    const [promoCode, setPromoCode] = useState('STUDENT25');
    const [isPromoApplied, setIsPromoApplied] = useState(true);
    if (!isCartOpen)
        return null;
    const deliveryFee = cartTotal > 150 ? 0 : 15;
    const packagingFee = 10;
    const discount = isPromoApplied ? (cartTotal > 100 ? 25 : 0) : 0;
    const finalTotal = Math.max(0, cartTotal + deliveryFee + packagingFee - discount);
    return (<div className="fixed inset-0 z-50 overflow-hidden animate-fadeIn">
      {/* Backdrop */}
      <div onClick={() => setIsCartOpen(false)} className="absolute inset-0 bg-black/50 backdrop-blur-sm transition-opacity"></div>

      <div className="fixed inset-y-0 right-0 max-w-full flex pl-10">
        <div className="w-screen max-w-md bg-white shadow-2xl flex flex-col justify-between">
          
          {/* Header */}
          <div className="p-6 border-b border-gray-100 flex items-center justify-between bg-hb-cream">
            <div className="flex items-center gap-2.5">
              <div className="w-9 h-9 rounded-xl bg-hb-green-600 text-white flex items-center justify-center">
                <ShoppingBag className="w-5 h-5"/>
              </div>
              <div>
                <h3 className="text-base font-black text-gray-900 leading-tight">Your Food Dabba</h3>
                <p className="text-xs text-gray-500 font-medium">
                  {cartItemCount} {cartItemCount === 1 ? 'item' : 'items'} from local home chefs
                </p>
              </div>
            </div>
            <button onClick={() => setIsCartOpen(false)} className="p-2 text-gray-400 hover:text-gray-700 rounded-full hover:bg-white transition">
              <X className="w-5 h-5"/>
            </button>
          </div>

          {/* Cart Items List */}
          <div className="flex-1 overflow-y-auto p-6 space-y-4">
            {cart.length === 0 ? (<div className="text-center py-16 space-y-4">
                <div className="w-16 h-16 mx-auto rounded-full bg-hb-cream-200 flex items-center justify-center text-3xl">
                  🍲
                </div>
                <div>
                  <h4 className="text-base font-bold text-gray-800">Your cart is empty</h4>
                  <p className="text-xs text-gray-500 mt-1 max-w-xs mx-auto">
                    Explore delicious homemade dabbas, thalis, and snacks prepared by campus home chefs!
                  </p>
                </div>
                <button onClick={() => setIsCartOpen(false)} className="px-5 py-2.5 rounded-xl bg-hb-green-600 text-white font-bold text-xs hover:bg-hb-green-700 transition">
                  Browse Campus Menu
                </button>
              </div>) : (<>
                {/* Kitchen Notice */}
                <div className="p-3 bg-hb-green-50 border border-hb-green-200 rounded-xl flex items-center gap-2.5 text-xs text-hb-green-800">
                  <ShieldCheck className="w-4 h-4 text-hb-green-600 flex-shrink-0"/>
                  <span>
                    Delivering to <strong>{currentCampus.split(',')[0]}</strong> in ~25 mins.
                  </span>
                </div>

                {/* Items */}
                <div className="space-y-3">
                  {cart.map((item) => (<div key={item.meal.id} className="p-3 rounded-2xl border border-gray-100 bg-gray-50/50 flex items-center justify-between gap-3 hover:border-hb-green-200 transition">
                      <img src={item.meal.imageUrl} alt={item.meal.name} className="w-16 h-16 rounded-xl object-cover flex-shrink-0 border border-gray-200"/>

                      <div className="flex-1 min-w-0">
                        <div className="flex items-center gap-1.5 mb-0.5">
                          <span className={`w-2.5 h-2.5 rounded-full ${item.meal.dietary === 'veg' ? 'bg-emerald-600' : 'bg-rose-600'}`}></span>
                          <h5 className="text-xs font-bold text-gray-900 truncate">
                            {item.meal.name}
                          </h5>
                        </div>
                        <p className="text-[11px] text-gray-500 truncate">
                          {item.meal.kitchenName}
                        </p>
                        <p className="text-xs font-extrabold text-hb-green-800 mt-1">
                          ₹{item.meal.price * item.quantity}
                        </p>
                      </div>

                      {/* Quantity Controller */}
                      <div className="flex items-center gap-1.5 bg-white border border-gray-200 rounded-xl p-1 shadow-xs">
                        <button onClick={() => updateCartQuantity(item.meal.id, item.quantity - 1)} className="p-1 text-gray-500 hover:text-gray-800 hover:bg-gray-100 rounded transition">
                          <Minus className="w-3 h-3"/>
                        </button>
                        <span className="w-5 text-center text-xs font-bold text-gray-800">
                          {item.quantity}
                        </span>
                        <button onClick={() => updateCartQuantity(item.meal.id, item.quantity + 1)} className="p-1 text-gray-500 hover:text-gray-800 hover:bg-gray-100 rounded transition">
                          <Plus className="w-3 h-3"/>
                        </button>
                      </div>

                      <button onClick={() => removeFromCart(item.meal.id)} className="p-1.5 text-gray-400 hover:text-rose-500 transition">
                        <Trash2 className="w-4 h-4"/>
                      </button>
                    </div>))}
                </div>

                {/* Promo Code Box */}
                <div className="p-3 bg-hb-cream rounded-xl border border-hb-orange/30 flex items-center justify-between gap-2">
                  <div className="flex items-center gap-2">
                    <Tag className="w-4 h-4 text-hb-orange"/>
                    <div>
                      <p className="text-xs font-bold text-gray-800">STUDENT25 Applied</p>
                      <p className="text-[10px] text-hb-green-700">₹25 off on student orders</p>
                    </div>
                  </div>
                  <span className="text-xs font-bold text-hb-orange bg-white px-2 py-0.5 rounded border border-hb-orange/40">
                    -₹{discount}
                  </span>
                </div>

                {/* Bill Breakdown */}
                <div className="space-y-2 pt-2 border-t border-gray-100 text-xs">
                  <div className="flex justify-between text-gray-600">
                    <span>Items Subtotal</span>
                    <span className="font-semibold text-gray-800">₹{cartTotal}</span>
                  </div>
                  <div className="flex justify-between text-gray-600">
                    <span className="flex items-center gap-1">
                      <Bike className="w-3.5 h-3.5 text-gray-400"/> Campus Delivery Fee
                    </span>
                    <span className="font-semibold text-gray-800">
                      {deliveryFee === 0 ? <span className="text-emerald-600 font-bold">FREE</span> : `₹${deliveryFee}`}
                    </span>
                  </div>
                  <div className="flex justify-between text-gray-600">
                    <span>Eco Hygienic Packaging</span>
                    <span className="font-semibold text-gray-800">₹{packagingFee}</span>
                  </div>
                  {discount > 0 && (<div className="flex justify-between text-emerald-700 font-semibold">
                      <span>Student Discount Promo</span>
                      <span>-₹{discount}</span>
                    </div>)}
                  <div className="flex justify-between text-sm font-black text-gray-900 pt-2 border-t border-gray-200">
                    <span>Total Amount</span>
                    <span className="text-base text-hb-green-700">₹{finalTotal}</span>
                  </div>
                </div>
              </>)}
          </div>

          {/* Footer Checkout Trigger */}
          {cart.length > 0 && (<div className="p-6 bg-white border-t border-gray-100 space-y-3">
              <button onClick={() => {
                setIsCartOpen(false);
                setIsCheckoutOpen(true);
            }} className="w-full py-3.5 px-6 rounded-2xl bg-hb-green-600 hover:bg-hb-green-700 text-white font-bold text-sm shadow-md shadow-hb-green-600/30 transition flex items-center justify-between">
                <div className="text-left">
                  <span className="text-[11px] block font-medium opacity-90">Total to pay</span>
                  <span className="text-base font-extrabold leading-none">₹{finalTotal}</span>
                </div>
                <div className="flex items-center gap-1.5 font-bold">
                  <span>Proceed to Checkout</span>
                  <ArrowRight className="w-4 h-4"/>
                </div>
              </button>
            </div>)}

        </div>
      </div>
    </div>);
};

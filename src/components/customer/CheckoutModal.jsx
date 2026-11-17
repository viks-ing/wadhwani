import React, { useState } from 'react';
import { useApp } from '../../context/AppContext';
import { X, MapPin, CreditCard, Banknote, ShieldCheck, ArrowRight, Loader2, Lock } from 'lucide-react';
export const CheckoutModal = () => {
    const { isCheckoutOpen, setIsCheckoutOpen, cartTotal, placeOrder, currentUser, currentCampus } = useApp();
    const [deliveryAddress, setDeliveryAddress] = useState(currentUser.address || 'Hostel Block C, Room 204, DTU Campus, Bawana Road, Delhi');
    const [orderNotes, setOrderNotes] = useState('Please call upon reaching hostel main gate.');
    const [paymentMethod, setPaymentMethod] = useState('UPI (GPay / PhonePe)');
    const [isProcessing, setIsProcessing] = useState(false);
    if (!isCheckoutOpen)
        return null;
    const deliveryFee = cartTotal > 150 ? 0 : 15;
    const packagingFee = 10;
    const discount = cartTotal > 100 ? 25 : 0;
    const totalAmount = Math.max(0, cartTotal + deliveryFee + packagingFee - discount);
    const handlePlaceOrder = async (e) => {
        e.preventDefault();
        setIsProcessing(true);
        // Simulate realistic 1.2s payment gateway handshake
        setTimeout(async () => {
            await placeOrder({
                deliveryAddress,
                paymentMethod,
                orderNotes,
            });
            setIsProcessing(false);
        }, 1200);
    };
    return (<div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/60 backdrop-blur-sm overflow-y-auto animate-fadeIn">
      <div className="bg-white rounded-3xl shadow-2xl max-w-lg w-full overflow-hidden border border-hb-green-100 my-8">
        
        {/* Header */}
        <div className="p-6 border-b border-gray-100 flex items-center justify-between bg-hb-cream">
          <div>
            <div className="flex items-center gap-1.5 text-xs font-bold text-hb-green-700 uppercase tracking-wider">
              <Lock className="w-3.5 h-3.5"/>
              <span>Safe & Secure Checkout</span>
            </div>
            <h3 className="text-xl font-black text-gray-900 mt-0.5">Confirm Your Dabba Order</h3>
          </div>
          <button onClick={() => setIsCheckoutOpen(false)} disabled={isProcessing} className="p-2 text-gray-400 hover:text-gray-700 rounded-full hover:bg-white transition">
            <X className="w-5 h-5"/>
          </button>
        </div>

        <form onSubmit={handlePlaceOrder} className="p-6 space-y-5">
          
          {/* 1. Delivery Address */}
          <div className="space-y-2">
            <label className="text-xs font-bold text-gray-800 flex items-center justify-between">
              <span className="flex items-center gap-1.5">
                <MapPin className="w-4 h-4 text-hb-green-600"/>
                <span>Delivery Address / Hostel Details</span>
              </span>
              <span className="text-[11px] text-hb-green-700 font-semibold">{currentCampus.split(',')[0]}</span>
            </label>
            <textarea rows={2} required value={deliveryAddress} onChange={(e) => setDeliveryAddress(e.target.value)} className="w-full text-xs p-3 rounded-xl border border-gray-200 focus:border-hb-green-500 focus:ring-1 focus:ring-hb-green-500 outline-none text-gray-800 bg-gray-50/50" placeholder="Hostel name, room number, or floor..."/>
          </div>

          {/* 2. Order Notes */}
          <div className="space-y-1">
            <label className="text-xs font-bold text-gray-700">Delivery Instructions (Optional)</label>
            <input type="text" value={orderNotes} onChange={(e) => setOrderNotes(e.target.value)} placeholder="e.g. Leave with security guard, call when outside..." className="w-full text-xs p-2.5 rounded-xl border border-gray-200 focus:border-hb-green-500 outline-none bg-gray-50/50 text-gray-800"/>
          </div>

          {/* 3. Payment Method */}
          <div className="space-y-2 pt-2 border-t border-gray-100">
            <label className="text-xs font-bold text-gray-800 block">
              Select Payment Method <span className="text-gray-400 font-normal">(Instant Mock Payment)</span>
            </label>

            <div className="space-y-2">
              <label className={`flex items-center justify-between p-3 rounded-xl border cursor-pointer transition ${paymentMethod === 'UPI (GPay / PhonePe)'
            ? 'border-hb-green-600 bg-hb-green-50/70 font-bold'
            : 'border-gray-200 hover:border-gray-300'}`}>
                <div className="flex items-center gap-3">
                  <div className="w-8 h-8 rounded-lg bg-white border border-gray-200 flex items-center justify-center text-hb-green-700 font-black text-xs">
                    UPI
                  </div>
                  <div>
                    <p className="text-xs font-bold text-gray-900">UPI (GPay, PhonePe, Paytm)</p>
                    <p className="text-[10px] text-gray-500">Zero transaction charges • Preferred by students</p>
                  </div>
                </div>
                <input type="radio" name="paymentMethod" checked={paymentMethod === 'UPI (GPay / PhonePe)'} onChange={() => setPaymentMethod('UPI (GPay / PhonePe)')} className="accent-hb-green-600"/>
              </label>

              <label className={`flex items-center justify-between p-3 rounded-xl border cursor-pointer transition ${paymentMethod === 'Credit / Debit Card'
            ? 'border-hb-green-600 bg-hb-green-50/70 font-bold'
            : 'border-gray-200 hover:border-gray-300'}`}>
                <div className="flex items-center gap-3">
                  <div className="w-8 h-8 rounded-lg bg-white border border-gray-200 flex items-center justify-center text-gray-700">
                    <CreditCard className="w-4 h-4 text-hb-orange"/>
                  </div>
                  <div>
                    <p className="text-xs font-bold text-gray-900">Credit / Debit Card</p>
                    <p className="text-[10px] text-gray-500">Visa, Mastercard, RuPay cards accepted</p>
                  </div>
                </div>
                <input type="radio" name="paymentMethod" checked={paymentMethod === 'Credit / Debit Card'} onChange={() => setPaymentMethod('Credit / Debit Card')} className="accent-hb-green-600"/>
              </label>

              <label className={`flex items-center justify-between p-3 rounded-xl border cursor-pointer transition ${paymentMethod === 'Cash on Delivery'
            ? 'border-hb-green-600 bg-hb-green-50/70 font-bold'
            : 'border-gray-200 hover:border-gray-300'}`}>
                <div className="flex items-center gap-3">
                  <div className="w-8 h-8 rounded-lg bg-white border border-gray-200 flex items-center justify-center text-gray-700">
                    <Banknote className="w-4 h-4 text-emerald-600"/>
                  </div>
                  <div>
                    <p className="text-xs font-bold text-gray-900">Cash on Delivery (COD)</p>
                    <p className="text-[10px] text-gray-500">Pay cash upon meal handover at gate</p>
                  </div>
                </div>
                <input type="radio" name="paymentMethod" checked={paymentMethod === 'Cash on Delivery'} onChange={() => setPaymentMethod('Cash on Delivery')} className="accent-hb-green-600"/>
              </label>
            </div>
          </div>

          {/* Amount Summary */}
          <div className="p-3.5 bg-gray-50 rounded-2xl border border-gray-200 flex items-center justify-between text-xs">
            <div>
              <span className="text-gray-500 block">Total Payable:</span>
              <span className="text-lg font-black text-hb-green-700">₹{totalAmount}</span>
            </div>
            <div className="flex items-center gap-1.5 text-[11px] text-emerald-700 font-semibold bg-emerald-50 px-2.5 py-1 rounded-lg border border-emerald-200">
              <ShieldCheck className="w-4 h-4"/>
              <span>Simulated Payment Active</span>
            </div>
          </div>

          {/* Submit Button */}
          <button type="submit" disabled={isProcessing} className="w-full py-3.5 px-6 rounded-2xl bg-hb-green-600 hover:bg-hb-green-700 text-white font-bold text-sm shadow-md transition flex items-center justify-center gap-2 disabled:opacity-75">
            {isProcessing ? (<>
                <Loader2 className="w-5 h-5 animate-spin"/>
                <span>Simulating Payment Gateway...</span>
              </>) : (<>
                <span>Pay ₹{totalAmount} & Confirm Order</span>
                <ArrowRight className="w-4 h-4"/>
              </>)}
          </button>
        </form>

      </div>
    </div>);
};

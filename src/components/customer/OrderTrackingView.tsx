import React from 'react';
import { useApp } from '../../context/AppContext';
import { OrderStatus } from '../../types';
import { 
  CheckCircle2, 
  Clock, 
  ChefHat, 
  ShoppingBag, 
  Bike, 
  CheckCircle, 
  Phone, 
  MapPin, 
  Calendar,
  AlertCircle,
  ArrowRight,
  Sparkles,
  RefreshCw
} from 'lucide-react';
import { LiveDeliveryMap } from './LiveDeliveryMap';

const STATUS_STEPS: { key: OrderStatus; label: string; desc: string; icon: any }[] = [
  { key: 'order_placed', label: 'Order Placed', desc: 'Received & sent to home kitchen', icon: ShoppingBag },
  { key: 'chef_preparing', label: 'Chef Preparing', desc: 'Fresh ingredients being cooked', icon: ChefHat },
  { key: 'ready_for_pickup', label: 'Ready for Pickup', desc: 'Packed warm in hygienic dabba', icon: CheckCircle2 },
  { key: 'out_for_delivery', label: 'Out for Delivery', desc: 'Rider heading to campus gate', icon: Bike },
  { key: 'delivered', label: 'Delivered', desc: 'Enjoy your warm home-cooked meal!', icon: CheckCircle },
];

export const OrderTrackingView: React.FC = () => {
  const { 
    orders, 
    activeOrder, 
    setActiveOrder, 
    updateOrderStatus, 
    setActiveView,
    currentCampus,
    userCoords 
  } = useApp();

  const currentOrder = activeOrder || orders[0];

  if (!currentOrder) {
    return (
      <div className="min-h-[70vh] flex flex-col items-center justify-center p-6 text-center">
        <div className="w-16 h-16 rounded-full bg-hb-cream-200 flex items-center justify-center text-3xl mb-4">
          📦
        </div>
        <h2 className="text-xl font-bold text-gray-900">No Active Orders Yet</h2>
        <p className="text-xs text-gray-500 mt-1 max-w-sm">
          Browse our student-favorite home kitchens to order a fresh homemade dabba!
        </p>
        <button
          onClick={() => setActiveView('customer')}
          className="mt-4 px-6 py-2.5 rounded-xl bg-hb-green-600 text-white font-bold text-xs hover:bg-hb-green-700 transition"
        >
          Explore Campus Meals
        </button>
      </div>
    );
  }

  const currentStepIndex = STATUS_STEPS.findIndex(s => s.key === currentOrder.status);

  return (
    <div className="max-w-4xl mx-auto px-4 py-8 sm:py-12 space-y-8 animate-fadeIn">
      
      {/* Top Header Card */}
      <div className="bg-white rounded-3xl p-6 sm:p-8 border border-hb-green-100 shadow-soft">
        <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4 border-b border-gray-100 pb-6">
          <div>
            <div className="flex items-center gap-2">
              <span className="px-2.5 py-1 rounded-md bg-hb-green-100 text-hb-green-800 text-xs font-black">
                {currentOrder.id}
              </span>
              <span className="text-xs text-gray-400 font-medium">
                Placed at {new Date(currentOrder.createdAt).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })}
              </span>
            </div>
            <h1 className="text-2xl font-black text-gray-900 mt-1">
              Live Order Tracking
            </h1>
            <p className="text-xs text-gray-600 flex items-center gap-1.5 mt-0.5">
              <span>Kitchen: <strong>{currentOrder.kitchenName}</strong></span>
              <span>•</span>
              <span className="text-hb-green-700 font-semibold">ETA: ~{currentOrder.estimatedDeliveryTime}</span>
            </p>
          </div>

          {/* Realtime Live Sync Badge */}
          <div className="bg-emerald-50 border border-emerald-200 p-3 rounded-2xl text-xs max-w-xs">
            <div className="flex items-center gap-1.5 font-bold text-emerald-800 mb-1">
              <Sparkles className="w-3.5 h-3.5 text-hb-orange" />
              <span>Supabase Realtime Sync:</span>
            </div>
            <p className="text-[11px] text-gray-700 leading-snug">
              Status changes made by the chef or rider update your screen automatically over live WebSocket.
            </p>
          </div>
        </div>

        {/* 5-Stage Visual Progress Tracker */}
        <div className="py-8">
          <div className="relative">
            {/* Background Bar */}
            <div className="hidden sm:block absolute top-1/2 left-0 right-0 h-1.5 bg-gray-100 -translate-y-1/2 z-0"></div>
            {/* Active Colored Bar */}
            <div 
              className="hidden sm:block absolute top-1/2 left-0 h-1.5 bg-hb-green-600 -translate-y-1/2 z-0 transition-all duration-700"
              style={{ width: `${(Math.max(0, currentStepIndex) / (STATUS_STEPS.length - 1)) * 100}%` }}
            ></div>

            {/* Steps Container */}
            <div className="grid grid-cols-1 sm:grid-cols-5 gap-4 relative z-10">
              {STATUS_STEPS.map((step, idx) => {
                const Icon = step.icon;
                const isPassed = idx <= currentStepIndex;
                const isCurrent = idx === currentStepIndex;

                return (
                  <div key={step.key} className="flex sm:flex-col items-center gap-3 sm:gap-2 text-left sm:text-center">
                    <div 
                      className={`w-12 h-12 rounded-2xl flex items-center justify-center text-sm font-bold transition-all duration-500 shadow-sm ${
                        isCurrent
                          ? 'bg-hb-green-600 text-white ring-4 ring-hb-green-100 scale-110'
                          : isPassed
                          ? 'bg-hb-green-700 text-white'
                          : 'bg-white border-2 border-gray-200 text-gray-400'
                      }`}
                    >
                      <Icon className="w-5 h-5" />
                    </div>

                    <div>
                      <p className={`text-xs font-bold leading-tight ${isPassed ? 'text-gray-900' : 'text-gray-400'}`}>
                        {step.label}
                      </p>
                      <p className="text-[10px] text-gray-500 leading-tight mt-0.5 max-w-[120px]">
                        {step.desc}
                      </p>
                    </div>
                  </div>
                );
              })}
            </div>
          </div>
        </div>

        {/* Interactive Fast-Forward Simulation Bar */}
        <div className="pt-4 border-t border-gray-100 flex flex-wrap items-center justify-between gap-3 text-xs">
          <span className="font-semibold text-gray-500 flex items-center gap-1.5">
            <RefreshCw className="w-3.5 h-3.5 text-hb-orange" />
            Fast-Forward Simulation:
          </span>
          <div className="flex flex-wrap gap-1.5">
            {STATUS_STEPS.map((step) => (
              <button
                key={step.key}
                onClick={() => updateOrderStatus(currentOrder.id, step.key)}
                className={`px-2.5 py-1 rounded-lg text-[11px] font-bold transition ${
                  currentOrder.status === step.key
                    ? 'bg-hb-green-600 text-white shadow-sm'
                    : 'bg-gray-100 text-gray-700 hover:bg-gray-200'
                }`}
              >
                {step.label}
              </button>
            ))}
          </div>
        </div>

      </div>

      {/* Live GPS Partner Route Tracker & Interactive Leaflet Map */}
      <LiveDeliveryMap order={currentOrder} currentCampus={currentCampus} userCoords={userCoords} />

      {/* Two Column Section: Driver & Delivery Details + Ordered Items */}
      <div className="grid grid-cols-1 md:grid-cols-12 gap-6">
        
        {/* Left: Delivery Partner & Destination */}
        <div className="md:col-span-6 space-y-6">
          {/* Driver Card */}
          {currentOrder.deliveryPartner && (
            <div className="bg-white rounded-3xl p-6 border border-hb-green-100 shadow-soft">
              <h3 className="text-xs font-bold text-gray-500 uppercase tracking-wider mb-4 flex items-center gap-1.5">
                <Bike className="w-4 h-4 text-hb-green-600" />
                <span>HomeBite Delivery Partner</span>
              </h3>

              <div className="flex items-center justify-between gap-3">
                <div className="flex items-center gap-3">
                  <div className="w-12 h-12 rounded-2xl bg-indigo-100 text-indigo-700 flex items-center justify-center border-2 border-indigo-400 shadow-sm flex-shrink-0">
                    <Bike className="w-6 h-6 text-indigo-700" />
                  </div>
                  <div>
                    <h4 className="text-sm font-bold text-gray-900">{currentOrder.deliveryPartner.name}</h4>
                    <p className="text-xs text-gray-500">{currentOrder.deliveryPartner.vehicleNumber}</p>
                    <span className="text-[10px] text-amber-600 font-extrabold flex items-center gap-0.5 mt-0.5">
                      ★ {currentOrder.deliveryPartner.rating} Delivery Rating
                    </span>
                  </div>
                </div>

                <a
                  href={`tel:${currentOrder.deliveryPartner.phone}`}
                  className="p-3 rounded-2xl bg-hb-green-50 hover:bg-hb-green-100 text-hb-green-700 border border-hb-green-200 transition"
                  title="Call Rider"
                >
                  <Phone className="w-5 h-5" />
                </a>
              </div>
            </div>
          )}

          {/* Delivery Location & Notes */}
          <div className="bg-white rounded-3xl p-6 border border-hb-green-100 shadow-soft space-y-4">
            <h3 className="text-xs font-bold text-gray-500 uppercase tracking-wider flex items-center gap-1.5">
              <MapPin className="w-4 h-4 text-hb-green-600" />
              <span>Campus Delivery Destination</span>
            </h3>

            <div>
              <p className="text-xs font-bold text-gray-900">{currentCampus || currentOrder.collegeOrWorkplace || 'Campus Delivery Hub'}</p>
              <p className="text-xs text-gray-600 mt-0.5">{currentOrder.deliveryAddress}</p>
            </div>

            {currentOrder.orderNotes && (
              <div className="p-3 bg-hb-cream rounded-xl border border-hb-green-200 text-xs text-gray-700">
                <span className="font-bold text-gray-900 block text-[11px] mb-0.5">Hostel Gate Note:</span>
                "{currentOrder.orderNotes}"
              </div>
            )}
          </div>
        </div>

        {/* Right: Items Ordered & Bill */}
        <div className="md:col-span-6">
          <div className="bg-white rounded-3xl p-6 border border-hb-green-100 shadow-soft space-y-4">
            <h3 className="text-xs font-bold text-gray-500 uppercase tracking-wider flex items-center gap-1.5">
              <ShoppingBag className="w-4 h-4 text-hb-green-600" />
              <span>Items in this Dabba</span>
            </h3>

            <div className="space-y-3">
              {currentOrder.items.map((item, idx) => (
                <div key={idx} className="flex items-center justify-between text-xs py-2 border-b border-gray-100 last:border-0">
                  <div className="flex items-center gap-2.5">
                    <span className={`w-2.5 h-2.5 rounded-full ${
                      item.dietary === 'veg' ? 'bg-emerald-600' : 'bg-rose-600'
                    }`}></span>
                    <div>
                      <p className="font-bold text-gray-900">{item.name}</p>
                      <p className="text-[11px] text-gray-500">Qty: {item.quantity}</p>
                    </div>
                  </div>
                  <span className="font-bold text-gray-900">₹{item.price * item.quantity}</span>
                </div>
              ))}
            </div>

            {/* Bill Summary */}
            <div className="pt-3 border-t border-gray-100 space-y-1.5 text-xs text-gray-600">
              <div className="flex justify-between">
                <span>Subtotal</span>
                <span>₹{currentOrder.subtotal}</span>
              </div>
              <div className="flex justify-between">
                <span>Delivery Fee</span>
                <span>₹{currentOrder.deliveryFee}</span>
              </div>
              <div className="flex justify-between">
                <span>Hygienic Packaging</span>
                <span>₹{currentOrder.packagingFee}</span>
              </div>
              {currentOrder.discount > 0 && (
                <div className="flex justify-between text-emerald-700 font-bold">
                  <span>Student Promo Discount</span>
                  <span>-₹{currentOrder.discount}</span>
                </div>
              )}
              <div className="flex justify-between text-sm font-black text-gray-900 pt-2 border-t border-gray-200">
                <span>Total Paid ({currentOrder.paymentMethod})</span>
                <span className="text-hb-green-700">₹{currentOrder.totalAmount}</span>
              </div>
            </div>

          </div>
        </div>

      </div>

    </div>
  );
};


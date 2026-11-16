import React, { useState } from 'react';
import { useApp } from '../../context/AppContext';
import { Order, OrderStatus } from '../../types';
import { 
  Bike, 
  MapPin, 
  Phone, 
  CheckCircle2, 
  Clock, 
  Navigation, 
  DollarSign, 
  Star, 
  ShieldCheck, 
  Power,
  PackageCheck,
  AlertCircle,
  ArrowRight,
  TrendingUp,
  UserCheck
} from 'lucide-react';

export const DeliveryDashboard: React.FC = () => {
  const { 
    currentUser, 
    orders, 
    updateOrderStatus, 
    setActiveView,
    addToast 
  } = useApp();

  const [isOnline, setIsOnline] = useState(currentUser.isOnline ?? true);
  const [activeTab, setActiveTab] = useState<'active' | 'available' | 'earnings'>('active');

  const toggleOnlineStatus = () => {
    const next = !isOnline;
    setIsOnline(next);
    addToast(next ? 'You are now ONLINE. Ready for delivery assignments!' : 'You are now OFFLINE.', next ? 'success' : 'info');
  };

  // Orders assigned to this delivery partner or currently in delivery
  const myAssignedOrders = orders.filter(
    o => o.deliveryPartnerId === currentUser.id || o.deliveryPartner?.id === currentUser.id || o.status === 'out_for_delivery' || o.status === 'chef_preparing'
  );

  // Available orders that are ready for pickup but unassigned or open
  const availableOrders = orders.filter(
    o => o.status === 'ready_for_pickup' || (o.status === 'chef_preparing' && !o.deliveryPartnerId)
  );

  // Active delivery (first ongoing order)
  const activeOrder = orders.find(
    o => o.status === 'ready_for_pickup' || o.status === 'out_for_delivery'
  );

  const completedOrders = orders.filter(o => o.status === 'delivered');
  const todayEarnings = completedOrders.length * 45 + (activeOrder ? 45 : 0);

  const handleAcceptOrder = (orderId: string) => {
    updateOrderStatus(orderId, 'ready_for_pickup');
    addToast('Delivery accepted! Navigate to the home chef kitchen for pickup.', 'success');
  };

  const handleConfirmPickup = (orderId: string) => {
    updateOrderStatus(orderId, 'out_for_delivery');
    addToast('Picked up hot dabba from kitchen! Now en route to campus gate.', 'success');
  };

  const handleArrivedAtGate = (orderId: string) => {
    addToast('Notification sent to student: Rider arrived at hostel gate! 📲', 'info');
  };

  const handleMarkDelivered = (orderId: string) => {
    updateOrderStatus(orderId, 'delivered');
    addToast('Order marked DELIVERED! +₹45 added to your daily payout. 🎉', 'success');
  };

  return (
    <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8 space-y-8 animate-fadeIn">
      
      {/* Rider Header & Online Toggle */}
      <div className="bg-white rounded-3xl p-6 sm:p-8 border border-hb-green-100 shadow-soft">
        <div className="flex flex-col lg:flex-row lg:items-center justify-between gap-6">
          
          <div className="flex items-center gap-4">
            <div className="relative">
              <div className="w-16 h-16 sm:w-20 sm:h-20 rounded-2xl bg-indigo-100 text-indigo-700 border-4 border-indigo-400 shadow-md flex items-center justify-center font-bold">
                <Bike className="w-8 h-8 sm:w-10 sm:h-10 text-indigo-700" />
              </div>
              <span className={`absolute -bottom-1 -right-1 w-5 h-5 rounded-full border-2 border-white flex items-center justify-center ${
                isOnline ? 'bg-emerald-500' : 'bg-gray-400'
              }`}>
                <span className="w-2 h-2 rounded-full bg-white"></span>
              </span>
            </div>

            <div>
              <div className="flex items-center gap-2 flex-wrap">
                <h1 className="text-xl sm:text-2xl font-black text-gray-900 font-display">
                  {currentUser.name}
                </h1>
                <span className="px-2.5 py-0.5 rounded-full bg-indigo-100 text-indigo-800 text-[11px] font-bold border border-indigo-200 flex items-center gap-1">
                  <Bike className="w-3.5 h-3.5" /> Campus Delivery Partner
                </span>
              </div>
              <p className="text-xs text-gray-600 mt-1">
                Vehicle: <strong>{currentUser.vehicleNumber || 'DL 08 EF 4321 (Hero Splendor)'}</strong> • Zone: <strong>DTU & Rohini Sector Hub</strong>
              </p>
              <div className="flex items-center gap-3 mt-1.5 text-xs text-gray-500">
                <span className="text-amber-600 font-bold flex items-center gap-1">
                  <Star className="w-3.5 h-3.5 fill-amber-500 text-amber-500" />
                  {currentUser.deliveryRating || 4.92} Rider Rating
                </span>
                <span>•</span>
                <span className="text-emerald-700 font-bold">184 Trips Completed</span>
              </div>
            </div>
          </div>

          {/* Online / Offline Switch */}
          <div className="flex items-center gap-3">
            <button
              onClick={toggleOnlineStatus}
              className={`px-5 py-3 rounded-2xl font-bold text-xs shadow-md transition flex items-center gap-2.5 ${
                isOnline
                  ? 'bg-emerald-600 hover:bg-emerald-700 text-white shadow-emerald-600/30'
                  : 'bg-gray-200 hover:bg-gray-300 text-gray-700'
              }`}
            >
              <Power className="w-4 h-4" />
              <span>{isOnline ? 'Active (ONLINE)' : 'Inactive (OFFLINE)'}</span>
            </button>
          </div>

        </div>

        {/* Metrics Row */}
        <div className="grid grid-cols-2 sm:grid-cols-4 gap-4 mt-6 pt-6 border-t border-gray-100">
          <div className="bg-hb-cream/60 p-4 rounded-2xl border border-hb-green-100">
            <span className="text-[11px] font-bold text-gray-500 uppercase block">Active Deliveries</span>
            <span className="text-2xl font-black text-hb-green-700 mt-0.5 block">{activeOrder ? 1 : 0}</span>
            <span className="text-[10px] text-gray-500">In transit</span>
          </div>

          <div className="bg-hb-cream/60 p-4 rounded-2xl border border-hb-green-100">
            <span className="text-[11px] font-bold text-gray-500 uppercase block">Today's Earnings</span>
            <span className="text-2xl font-black text-hb-orange mt-0.5 block">₹{todayEarnings}</span>
            <span className="text-[10px] text-emerald-600 font-bold">+₹45 / delivery + tips</span>
          </div>

          <div className="bg-hb-cream/60 p-4 rounded-2xl border border-hb-green-100">
            <span className="text-[11px] font-bold text-gray-500 uppercase block">Total Disbursed</span>
            <span className="text-2xl font-black text-gray-900 mt-0.5 block">₹{currentUser.deliveryEarnings?.toLocaleString() || '14,250'}</span>
            <span className="text-[10px] text-gray-500">Weekly direct UPI transfer</span>
          </div>

          <div className="bg-hb-cream/60 p-4 rounded-2xl border border-hb-green-100">
            <span className="text-[11px] font-bold text-gray-500 uppercase block">On-Time Rate</span>
            <span className="text-2xl font-black text-emerald-600 mt-0.5 block">99.2%</span>
            <span className="text-[10px] text-gray-500">Campus gate punctuality</span>
          </div>
        </div>

      </div>

      {/* Navigation Tabs */}
      <div className="flex items-center gap-2 border-b border-gray-200">
        <button
          onClick={() => setActiveTab('active')}
          className={`pb-3 px-4 text-xs font-bold transition border-b-2 flex items-center gap-2 ${
            activeTab === 'active'
              ? 'border-hb-green-600 text-hb-green-700'
              : 'border-transparent text-gray-500 hover:text-gray-800'
          }`}
        >
          <Bike className="w-4 h-4" />
          <span>Current Active Trip ({activeOrder ? 1 : 0})</span>
        </button>

        <button
          onClick={() => setActiveTab('available')}
          className={`pb-3 px-4 text-xs font-bold transition border-b-2 flex items-center gap-2 ${
            activeTab === 'available'
              ? 'border-hb-green-600 text-hb-green-700'
              : 'border-transparent text-gray-500 hover:text-gray-800'
          }`}
        >
          <PackageCheck className="w-4 h-4" />
          <span>Available Campus Deliveries ({availableOrders.length})</span>
        </button>
      </div>

      {/* TAB 1: ACTIVE DELIVERY */}
      {activeTab === 'active' && (
        <div className="space-y-6">
          {!activeOrder ? (
            <div className="bg-white rounded-3xl p-12 text-center border border-hb-green-100 shadow-soft">
              <div className="w-16 h-16 mx-auto rounded-full bg-hb-cream-200 flex items-center justify-center text-3xl mb-3">
                🛵
              </div>
              <h3 className="text-base font-bold text-gray-900">No active delivery in progress</h3>
              <p className="text-xs text-gray-500 mt-1 max-w-sm mx-auto">
                Check the "Available Campus Deliveries" tab to accept an incoming food dabba from neighborhood kitchens.
              </p>
              <button
                onClick={() => setActiveTab('available')}
                className="mt-4 px-5 py-2.5 rounded-xl bg-hb-green-600 text-white font-bold text-xs hover:bg-hb-green-700 transition"
              >
                Browse Available Deliveries
              </button>
            </div>
          ) : (
            <div className="bg-white rounded-3xl p-6 sm:p-8 border-2 border-hb-green-600 shadow-xl space-y-6">
              
              {/* Trip Header */}
              <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4 pb-5 border-b border-gray-100">
                <div>
                  <div className="flex items-center gap-2">
                    <span className="px-2.5 py-1 rounded-md bg-hb-green-100 text-hb-green-800 font-black text-xs">
                      {activeOrder.id}
                    </span>
                    <span className="px-2.5 py-0.5 rounded-full bg-indigo-100 text-indigo-800 text-[11px] font-bold capitalize">
                      {activeOrder.status.replace(/_/g, ' ')}
                    </span>
                    <span className="text-xs text-gray-400">
                      ETA: ~{activeOrder.estimatedDeliveryTime}
                    </span>
                  </div>
                  <h3 className="text-xl font-black text-gray-900 mt-1">
                    Hostel Gate Dabba Dispatch
                  </h3>
                </div>

                <div className="text-right">
                  <span className="text-xs text-gray-500 block">Rider Payout</span>
                  <span className="text-2xl font-black text-hb-green-700">₹{activeOrder.deliveryPayout || 45}</span>
                </div>
              </div>

              {/* Waypoints: Pickup and Dropoff */}
              <div className="grid grid-cols-1 md:grid-cols-2 gap-6 bg-hb-cream/40 p-5 rounded-2xl border border-hb-green-100">
                
                {/* 1. Pickup Kitchen */}
                <div className="space-y-3">
                  <div className="flex items-center justify-between">
                    <span className="text-[10px] font-black uppercase tracking-wider text-amber-700 bg-amber-100 px-2 py-0.5 rounded">
                      Step 1: Pickup From Kitchen
                    </span>
                    <a
                      href="tel:+919811234567"
                      className="text-xs font-bold text-hb-green-800 flex items-center gap-1 hover:underline"
                    >
                      <Phone className="w-3 h-3" /> Call Chef
                    </a>
                  </div>

                  <div>
                    <h4 className="text-sm font-bold text-gray-900">{activeOrder.kitchenName}</h4>
                    <p className="text-xs text-gray-600 mt-0.5">
                      📍 Sector 16, Rohini (1.2 km from DTU)
                    </p>
                    <p className="text-[11px] text-gray-500 mt-1">
                      Chef: <strong>{activeOrder.chefName}</strong>
                    </p>
                  </div>

                  <div className="pt-2 border-t border-gray-100 text-xs text-gray-700">
                    <span className="font-semibold text-gray-900">Items: </span>
                    {activeOrder.items.map(i => `${i.quantity}x ${i.name}`).join(', ')}
                  </div>
                </div>

                {/* 2. Campus Dropoff */}
                <div className="space-y-3 md:border-l md:border-gray-200 md:pl-6">
                  <div className="flex items-center justify-between">
                    <span className="text-[10px] font-black uppercase tracking-wider text-emerald-700 bg-emerald-100 px-2 py-0.5 rounded">
                      Step 2: Campus Gate Delivery
                    </span>
                    <a
                      href={`tel:${activeOrder.customerPhone}`}
                      className="text-xs font-bold text-hb-green-800 flex items-center gap-1 hover:underline"
                    >
                      <Phone className="w-3 h-3" /> Call Student
                    </a>
                  </div>

                  <div>
                    <h4 className="text-sm font-bold text-gray-900">{activeOrder.customerName}</h4>
                    <p className="text-xs text-gray-600 mt-0.5">
                      📍 {activeOrder.deliveryAddress}
                    </p>
                    <p className="text-[11px] text-gray-500 mt-1">
                      Campus: <strong>{activeOrder.collegeOrWorkplace}</strong>
                    </p>
                  </div>

                  {activeOrder.orderNotes && (
                    <div className="p-2 bg-white rounded-lg border border-gray-200 text-xs text-gray-700">
                      <strong>Hostel Note:</strong> "{activeOrder.orderNotes}"
                    </div>
                  )}
                </div>

              </div>

              {/* Action Buttons for Rider */}
              <div className="flex flex-wrap items-center justify-between gap-3 pt-4 border-t border-gray-100">
                <span className="text-xs font-bold text-gray-500">
                  Update Live Status for Student & Kitchen:
                </span>

                <div className="flex flex-wrap gap-2">
                  {activeOrder.status === 'ready_for_pickup' && (
                    <button
                      onClick={() => handleConfirmPickup(activeOrder.id)}
                      className="px-5 py-2.5 rounded-xl bg-indigo-600 hover:bg-indigo-700 text-white font-bold text-xs shadow-md transition flex items-center gap-1.5"
                    >
                      <PackageCheck className="w-4 h-4" />
                      <span>Confirm Food Pickup (Start Ride)</span>
                    </button>
                  )}

                  {activeOrder.status === 'out_for_delivery' && (
                    <>
                      <button
                        onClick={() => handleArrivedAtGate(activeOrder.id)}
                        className="px-4 py-2.5 rounded-xl bg-amber-500 hover:bg-amber-600 text-white font-bold text-xs transition flex items-center gap-1.5"
                      >
                        <Navigation className="w-4 h-4" />
                        <span>Notify: Arrived at Campus Gate</span>
                      </button>

                      <button
                        onClick={() => handleMarkDelivered(activeOrder.id)}
                        className="px-5 py-2.5 rounded-xl bg-emerald-600 hover:bg-emerald-700 text-white font-bold text-xs shadow-md transition flex items-center gap-1.5"
                      >
                        <CheckCircle2 className="w-4 h-4" />
                        <span>Handover & Complete Delivery</span>
                      </button>
                    </>
                  )}
                </div>
              </div>

            </div>
          )}
        </div>
      )}

      {/* TAB 2: AVAILABLE DELIVERIES */}
      {activeTab === 'available' && (
        <div className="space-y-4">
          <div className="flex items-center justify-between">
            <h3 className="text-base font-bold text-gray-900">
              Campus Delivery Board (Accept & Earn)
            </h3>
            <span className="text-xs text-gray-500">
              Pick up from nearby verified kitchens and deliver to hostel gates
            </span>
          </div>

          {availableOrders.length === 0 ? (
            <div className="bg-white rounded-3xl p-12 text-center border border-hb-green-100 shadow-soft">
              <p className="text-sm font-bold text-gray-700">No new orders waiting for pickup right now.</p>
              <p className="text-xs text-gray-500 mt-1">Keep yourself ONLINE to receive live notifications.</p>
            </div>
          ) : (
            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
              {availableOrders.map((order) => (
                <div
                  key={order.id}
                  className="bg-white rounded-3xl p-6 border border-hb-green-100 shadow-soft flex flex-col justify-between space-y-4"
                >
                  <div className="space-y-3">
                    <div className="flex items-center justify-between">
                      <span className="px-2.5 py-1 rounded-md bg-hb-green-100 text-hb-green-800 font-black text-xs">
                        {order.id}
                      </span>
                      <span className="text-base font-black text-hb-green-700">
                        +₹{order.deliveryPayout || 45} Payout
                      </span>
                    </div>

                    <div className="text-xs space-y-1">
                      <p className="text-gray-900 font-bold flex items-center gap-1.5">
                        <span className="w-2 h-2 rounded-full bg-amber-500"></span>
                        Pickup: {order.kitchenName}
                      </p>
                      <p className="text-gray-700 font-bold flex items-center gap-1.5">
                        <span className="w-2 h-2 rounded-full bg-emerald-500"></span>
                        Drop: {order.collegeOrWorkplace.split(',')[0]} ({order.deliveryAddress})
                      </p>
                    </div>

                    <div className="p-2.5 bg-gray-50 rounded-xl text-xs text-gray-600">
                      <strong>Meal: </strong> {order.items.map(i => `${i.quantity}x ${i.name}`).join(', ')}
                    </div>
                  </div>

                  <button
                    onClick={() => handleAcceptOrder(order.id)}
                    className="w-full py-3 rounded-xl bg-hb-green-600 hover:bg-hb-green-700 text-white font-bold text-xs shadow-md transition flex items-center justify-center gap-2"
                  >
                    <Bike className="w-4 h-4" />
                    <span>Accept Delivery Assignment</span>
                  </button>
                </div>
              ))}
            </div>
          )}
        </div>
      )}

    </div>
  );
};


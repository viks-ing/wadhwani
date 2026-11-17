import React, { useState } from 'react';
import { useApp } from '../../context/AppContext';
import { ChefHat, ShieldCheck, Plus, Trash2, Edit3, Star, ShoppingBag, CheckCircle2, Eye, EyeOff, Flame } from 'lucide-react';
export const ChefDashboard = () => {
    const { currentUser, meals, orders, updateOrderStatus, addMeal, updateMeal, deleteMeal, toggleMealAvailability, setActiveView } = useApp();
    const [activeTab, setActiveTab] = useState('orders');
    const [isAddMealModalOpen, setIsAddMealModalOpen] = useState(false);
    const [editingMeal, setEditingMeal] = useState(null);
    // Filter chef's meals and orders
    const chefMeals = meals.filter(m => m.chefId === currentUser.id || m.chefId === 'user-chef-1');
    const incomingOrders = orders; // Show all orders for demo kitchen
    // Metrics
    const activeOrdersCount = incomingOrders.filter(o => o.status !== 'delivered' && o.status !== 'cancelled').length;
    const completedOrdersCount = incomingOrders.filter(o => o.status === 'delivered').length;
    const totalChefEarnings = currentUser.earnings || 28450;
    // New Meal Form State
    const [formData, setFormData] = useState({
        name: '',
        description: '',
        category: 'lunch',
        dietary: 'veg',
        price: 99,
        originalPrice: 129,
        prepTimeMinutes: 20,
        imageUrl: 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=800&q=80',
        ingredients: 'Basmati Rice, Desi Ghee, Pure Spices, Fresh Vegetables',
        calories: 510,
        protein: 18,
        carbs: 70,
        fats: 12,
        spiceLevel: 'Medium',
        servingSize: '1 Full Dabba Box (500g)'
    });
    const handleOpenAdd = () => {
        setEditingMeal(null);
        setFormData({
            name: '',
            description: '',
            category: 'lunch',
            dietary: 'veg',
            price: 99,
            originalPrice: 129,
            prepTimeMinutes: 20,
            imageUrl: 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=800&q=80',
            ingredients: 'Basmati Rice, Desi Ghee, Pure Spices, Fresh Vegetables',
            calories: 510,
            protein: 18,
            carbs: 70,
            fats: 12,
            spiceLevel: 'Medium',
            servingSize: '1 Full Dabba Box (500g)'
        });
        setIsAddMealModalOpen(true);
    };
    const handleOpenEdit = (meal) => {
        setEditingMeal(meal);
        setFormData({
            name: meal.name,
            description: meal.description,
            category: meal.category,
            dietary: meal.dietary,
            price: meal.price,
            originalPrice: meal.originalPrice || meal.price + 30,
            prepTimeMinutes: meal.prepTimeMinutes,
            imageUrl: meal.imageUrl,
            ingredients: meal.ingredients.join(', '),
            calories: meal.nutrition.calories,
            protein: meal.nutrition.protein,
            carbs: meal.nutrition.carbs,
            fats: meal.nutrition.fats,
            spiceLevel: meal.spiceLevel,
            servingSize: meal.servingSize
        });
        setIsAddMealModalOpen(true);
    };
    const handleSaveMeal = (e) => {
        e.preventDefault();
        const mealPayload = {
            chefId: currentUser.id,
            chefName: currentUser.name,
            kitchenName: currentUser.kitchenName || "Anita Aunty's Ghar Ki Rasoi",
            isChefVerified: true,
            chefAvatar: currentUser.avatarUrl,
            name: formData.name,
            description: formData.description,
            category: formData.category,
            dietary: formData.dietary,
            price: Number(formData.price),
            originalPrice: Number(formData.originalPrice),
            rating: editingMeal ? editingMeal.rating : 4.9,
            reviewsCount: editingMeal ? editingMeal.reviewsCount : 1,
            prepTimeMinutes: Number(formData.prepTimeMinutes),
            imageUrl: formData.imageUrl,
            ingredients: formData.ingredients.split(',').map(s => s.trim()).filter(Boolean),
            nutrition: {
                calories: Number(formData.calories),
                protein: Number(formData.protein),
                carbs: Number(formData.carbs),
                fats: Number(formData.fats),
                fiber: 8
            },
            isAvailable: true,
            tags: ['Home Chef Special', 'Freshly Cooked'],
            spiceLevel: formData.spiceLevel,
            servingSize: formData.servingSize,
            campusDistanceKm: 1.2
        };
        if (editingMeal) {
            updateMeal({ ...mealPayload, id: editingMeal.id });
        }
        else {
            addMeal(mealPayload);
        }
        setIsAddMealModalOpen(false);
    };
    return (<div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8 space-y-8 animate-fadeIn">
      
      {/* Top Chef Profile & Hygiene Header */}
      <div className="bg-white rounded-3xl p-6 sm:p-8 border border-hb-green-100 shadow-soft">
        <div className="flex flex-col lg:flex-row lg:items-center justify-between gap-6">
          
          <div className="flex items-center gap-4">
            <div className="relative">
              <div className="w-16 h-16 sm:w-20 sm:h-20 rounded-2xl bg-orange-100 text-hb-orange border-4 border-hb-green-500 shadow-md flex items-center justify-center font-bold">
                <ChefHat className="w-8 h-8 sm:w-10 sm:h-10 text-hb-orange"/>
              </div>
              <span className="absolute -bottom-2 -right-2 p-1.5 rounded-full bg-hb-green-600 text-white shadow-sm" title="FSSAI Verified">
                <ShieldCheck className="w-4 h-4"/>
              </span>
            </div>

            <div>
              <div className="flex items-center gap-2 flex-wrap">
                <h1 className="text-xl sm:text-2xl font-black text-gray-900 font-display">
                  {currentUser.kitchenName || "Anita Aunty's Ghar Ki Rasoi"}
                </h1>
                <span className="px-2.5 py-0.5 rounded-full bg-hb-green-100 text-hb-green-800 text-[11px] font-bold border border-hb-green-300 flex items-center gap-1">
                  <ShieldCheck className="w-3.5 h-3.5"/> FSSAI Verified
                </span>
              </div>
              <p className="text-xs text-gray-600 mt-1">
                Head Chef: <strong>{currentUser.name}</strong> • Rohini Sector 16 (1.2 km from DTU Campus)
              </p>
              <div className="flex items-center gap-3 mt-1.5 text-xs text-gray-500">
                <span>License: <strong className="text-gray-700">{currentUser.fssaiNumber || 'FSSAI-11523034000892'}</strong></span>
                <span>•</span>
                <span className="text-amber-600 font-bold flex items-center gap-1">
                  <Star className="w-3.5 h-3.5 fill-amber-500 text-amber-500"/>
                  4.9 / 5.0 Hygiene Score
                </span>
              </div>
            </div>
          </div>

          {/* Action to add meal */}
          <div className="flex items-center gap-3">
            <button onClick={handleOpenAdd} className="px-5 py-3 rounded-2xl bg-hb-green-600 hover:bg-hb-green-700 text-white font-bold text-xs shadow-md transition flex items-center gap-2">
              <Plus className="w-4 h-4"/>
              <span>+ Add New Dish</span>
            </button>
          </div>

        </div>

        {/* 4 Stats Cards */}
        <div className="grid grid-cols-2 sm:grid-cols-4 gap-4 mt-6 pt-6 border-t border-gray-100">
          <div className="bg-hb-cream/60 p-4 rounded-2xl border border-hb-green-100">
            <span className="text-[11px] font-bold text-gray-500 uppercase block">Active Kitchen Orders</span>
            <span className="text-2xl font-black text-hb-green-700 mt-0.5 block">{activeOrdersCount}</span>
            <span className="text-[10px] text-gray-500">Currently preparing</span>
          </div>

          <div className="bg-hb-cream/60 p-4 rounded-2xl border border-hb-green-100">
            <span className="text-[11px] font-bold text-gray-500 uppercase block">Total Meals Cooked</span>
            <span className="text-2xl font-black text-gray-900 mt-0.5 block">246</span>
            <span className="text-[10px] text-emerald-600 font-bold">↑ 18% this week</span>
          </div>

          <div className="bg-hb-cream/60 p-4 rounded-2xl border border-hb-green-100">
            <span className="text-[11px] font-bold text-gray-500 uppercase block">Chef Earnings</span>
            <span className="text-2xl font-black text-hb-orange mt-0.5 block">₹{totalChefEarnings.toLocaleString()}</span>
            <span className="text-[10px] text-gray-500">Disbursed weekly to UPI</span>
          </div>

          <div className="bg-hb-cream/60 p-4 rounded-2xl border border-hb-green-100">
            <span className="text-[11px] font-bold text-gray-500 uppercase block">Student Rating</span>
            <span className="text-2xl font-black text-amber-500 mt-0.5 block">4.9 ★</span>
            <span className="text-[10px] text-gray-500">Based on 142 reviews</span>
          </div>
        </div>

      </div>

      {/* Navigation Tabs */}
      <div className="flex items-center gap-2 border-b border-gray-200">
        <button onClick={() => setActiveTab('orders')} className={`pb-3 px-4 text-xs font-bold transition border-b-2 flex items-center gap-2 ${activeTab === 'orders'
            ? 'border-hb-green-600 text-hb-green-700'
            : 'border-transparent text-gray-500 hover:text-gray-800'}`}>
          <ShoppingBag className="w-4 h-4"/>
          <span>Live Kitchen Orders Queue</span>
          {activeOrdersCount > 0 && (<span className="px-2 py-0.2 rounded-full bg-hb-orange text-white text-[10px] font-black">
              {activeOrdersCount}
            </span>)}
        </button>

        <button onClick={() => setActiveTab('menu')} className={`pb-3 px-4 text-xs font-bold transition border-b-2 flex items-center gap-2 ${activeTab === 'menu'
            ? 'border-hb-green-600 text-hb-green-700'
            : 'border-transparent text-gray-500 hover:text-gray-800'}`}>
          <ChefHat className="w-4 h-4"/>
          <span>My Menu Listings ({chefMeals.length})</span>
        </button>
      </div>

      {/* TAB 1: LIVE ORDERS QUEUE */}
      {activeTab === 'orders' && (<div className="space-y-4">
          <div className="flex items-center justify-between">
            <h3 className="text-base font-bold text-gray-900">
              Orders Requiring Action (Live Kitchen Dispatch)
            </h3>
            <span className="text-xs text-gray-500">
              Advance the status to update student tracking in real-time
            </span>
          </div>

          {incomingOrders.length === 0 ? (<div className="bg-white rounded-3xl p-12 text-center border border-hb-green-100 shadow-soft">
              <p className="text-sm font-bold text-gray-700">No incoming orders right now.</p>
            </div>) : (<div className="space-y-4">
              {incomingOrders.map((order) => {
                    const isFinished = order.status === 'delivered' || order.status === 'cancelled';
                    return (<div key={order.id} className={`bg-white rounded-3xl p-6 border transition-all duration-300 shadow-soft ${order.status === 'order_placed'
                            ? 'border-hb-orange ring-2 ring-hb-orange/20'
                            : 'border-hb-green-100'}`}>
                    <div className="flex flex-col md:flex-row md:items-center justify-between gap-4 pb-4 border-b border-gray-100">
                      <div>
                        <div className="flex items-center gap-2">
                          <span className="px-2.5 py-1 rounded-md bg-hb-green-100 text-hb-green-800 font-black text-xs">
                            {order.id}
                          </span>
                          <span className="text-xs text-gray-400">
                            {new Date(order.createdAt).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })}
                          </span>
                          <span className={`px-2.5 py-0.5 rounded-full text-[11px] font-bold capitalize ${order.status === 'order_placed'
                            ? 'bg-amber-100 text-amber-800'
                            : order.status === 'chef_preparing'
                                ? 'bg-blue-100 text-blue-800'
                                : order.status === 'ready_for_pickup'
                                    ? 'bg-purple-100 text-purple-800'
                                    : order.status === 'out_for_delivery'
                                        ? 'bg-indigo-100 text-indigo-800'
                                        : 'bg-emerald-100 text-emerald-800'}`}>
                            {order.status.replace(/_/g, ' ')}
                          </span>
                        </div>

                        <h4 className="text-sm font-bold text-gray-900 mt-1">
                          Student: {order.customerName} ({order.customerPhone})
                        </h4>
                        <p className="text-xs text-gray-600 mt-0.5">
                          📍 Delivery to: {order.deliveryAddress} ({order.collegeOrWorkplace.split(',')[0]})
                        </p>
                      </div>

                      <div className="text-right">
                        <span className="text-lg font-black text-hb-green-700">₹{order.totalAmount}</span>
                        <p className="text-[10px] text-gray-500">{order.paymentMethod} • Paid</p>
                      </div>
                    </div>

                    {/* Items List */}
                    <div className="py-3 space-y-1.5">
                      {order.items.map((item, idx) => (<div key={idx} className="flex items-center justify-between text-xs text-gray-700">
                          <div className="flex items-center gap-2">
                            <span className="w-5 h-5 rounded-md bg-hb-cream flex items-center justify-center font-bold text-[10px]">
                              {item.quantity}x
                            </span>
                            <span className="font-semibold text-gray-900">{item.name}</span>
                          </div>
                          <span>₹{item.price * item.quantity}</span>
                        </div>))}
                    </div>

                    {/* Order Notes */}
                    {order.orderNotes && (<div className="p-2.5 bg-hb-cream-100 rounded-xl border border-hb-green-100 text-xs text-gray-700 mb-3">
                        <strong className="text-gray-900">Student Note:</strong> {order.orderNotes}
                      </div>)}

                    {/* Kitchen Stage Progression Action Buttons */}
                    <div className="pt-3 border-t border-gray-100 flex flex-wrap items-center justify-between gap-3">
                      <span className="text-xs font-bold text-gray-500">
                        Kitchen Status Controls:
                      </span>

                      <div className="flex flex-wrap items-center gap-2">
                        {order.status === 'order_placed' && (<button onClick={() => updateOrderStatus(order.id, 'chef_preparing')} className="px-4 py-2 rounded-xl bg-hb-orange hover:bg-orange-500 text-white font-bold text-xs shadow-sm transition flex items-center gap-1.5">
                            <Flame className="w-3.5 h-3.5"/>
                            <span>Accept & Start Cooking</span>
                          </button>)}

                        {order.status === 'chef_preparing' && (<button onClick={() => updateOrderStatus(order.id, 'ready_for_pickup')} className="px-4 py-2 rounded-xl bg-purple-600 hover:bg-purple-700 text-white font-bold text-xs shadow-sm transition flex items-center gap-1.5">
                            <CheckCircle2 className="w-3.5 h-3.5"/>
                            <span>Mark Ready for Pickup (Packed)</span>
                          </button>)}

                        {order.status === 'ready_for_pickup' && (<button onClick={() => updateOrderStatus(order.id, 'out_for_delivery')} className="px-4 py-2 rounded-xl bg-indigo-600 hover:bg-indigo-700 text-white font-bold text-xs shadow-sm transition flex items-center gap-1.5">
                            <span>Handover to Rider (Out for Delivery)</span>
                          </button>)}

                        {order.status === 'out_for_delivery' && (<button onClick={() => updateOrderStatus(order.id, 'delivered')} className="px-4 py-2 rounded-xl bg-emerald-600 hover:bg-emerald-700 text-white font-bold text-xs shadow-sm transition flex items-center gap-1.5">
                            <span>Mark as Delivered ✓</span>
                          </button>)}

                        {isFinished && (<span className="text-xs font-bold text-emerald-700 bg-emerald-50 px-3 py-1 rounded-xl border border-emerald-200">
                            Completed & Paid
                          </span>)}
                      </div>
                    </div>

                  </div>);
                })}
            </div>)}
        </div>)}

      {/* TAB 2: MY MENU LISTINGS */}
      {activeTab === 'menu' && (<div className="space-y-4">
          <div className="flex items-center justify-between">
            <h3 className="text-base font-bold text-gray-900">
              Kitchen Dishes & Daily Availability
            </h3>
            <button onClick={handleOpenAdd} className="px-4 py-2 bg-hb-green-600 text-white font-bold rounded-xl text-xs flex items-center gap-1.5">
              <Plus className="w-4 h-4"/>
              <span>Add Dish</span>
            </button>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
            {chefMeals.map((meal) => (<div key={meal.id} className="bg-white rounded-3xl border border-hb-green-100 overflow-hidden shadow-soft flex flex-col justify-between">
                <div>
                  <div className="relative h-40">
                    <img src={meal.imageUrl} alt={meal.name} className="w-full h-full object-cover"/>
                    <div className="absolute top-2.5 left-2.5 flex items-center gap-1.5">
                      <span className={`w-3.5 h-3.5 rounded-full border-2 flex items-center justify-center bg-white ${meal.dietary === 'veg' ? 'border-emerald-600' : 'border-rose-600'}`}>
                        <span className={`w-1.5 h-1.5 rounded-full ${meal.dietary === 'veg' ? 'bg-emerald-600' : 'bg-rose-600'}`}></span>
                      </span>
                      <span className="px-2 py-0.5 rounded bg-black/60 backdrop-blur text-white text-[10px] font-bold">
                        {meal.category}
                      </span>
                    </div>

                    <button onClick={() => toggleMealAvailability(meal.id)} className={`absolute top-2.5 right-2.5 px-2.5 py-1 rounded-full text-xs font-bold shadow-sm transition flex items-center gap-1 ${meal.isAvailable
                    ? 'bg-emerald-500 text-white'
                    : 'bg-rose-600 text-white'}`}>
                      {meal.isAvailable ? <Eye className="w-3 h-3"/> : <EyeOff className="w-3 h-3"/>}
                      <span>{meal.isAvailable ? 'Available' : 'Sold Out'}</span>
                    </button>
                  </div>

                  <div className="p-4 space-y-2">
                    <h4 className="text-sm font-bold text-gray-900 leading-snug line-clamp-1">{meal.name}</h4>
                    <p className="text-xs text-gray-500 line-clamp-2">{meal.description}</p>
                    
                    <div className="flex items-center justify-between text-xs text-gray-600 pt-1">
                      <span>Protein: <strong>{meal.nutrition.protein}g</strong></span>
                      <span>Calories: <strong>{meal.nutrition.calories} kcal</strong></span>
                      <span>Prep: <strong>{meal.prepTimeMinutes}m</strong></span>
                    </div>
                  </div>
                </div>

                <div className="p-4 pt-0 flex items-center justify-between border-t border-gray-100 pt-3">
                  <span className="text-base font-black text-gray-900">₹{meal.price}</span>
                  <div className="flex items-center gap-2">
                    <button onClick={() => handleOpenEdit(meal)} className="p-1.5 text-gray-500 hover:text-hb-green-700 rounded-lg hover:bg-gray-100" title="Edit Dish">
                      <Edit3 className="w-4 h-4"/>
                    </button>
                    <button onClick={() => deleteMeal(meal.id)} className="p-1.5 text-gray-400 hover:text-rose-600 rounded-lg hover:bg-gray-100" title="Delete Dish">
                      <Trash2 className="w-4 h-4"/>
                    </button>
                  </div>
                </div>

              </div>))}
          </div>
        </div>)}

      {/* ADD / EDIT MEAL MODAL */}
      {isAddMealModalOpen && (<div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/60 backdrop-blur-sm overflow-y-auto animate-fadeIn">
          <div className="bg-white rounded-3xl shadow-2xl max-w-xl w-full overflow-hidden border border-hb-green-100 my-8">
            <div className="p-6 border-b border-gray-100 flex items-center justify-between bg-hb-cream">
              <h3 className="text-base font-black text-gray-900">
                {editingMeal ? 'Edit Dish Listing' : 'Add New Homemade Dish'}
              </h3>
              <button onClick={() => setIsAddMealModalOpen(false)} className="text-gray-400 hover:text-gray-700">
                ✕
              </button>
            </div>

            <form onSubmit={handleSaveMeal} className="p-6 space-y-4 max-h-[80vh] overflow-y-auto text-xs">
              <div className="space-y-1">
                <label className="font-bold text-gray-700">Dish Name</label>
                <input type="text" required value={formData.name} onChange={(e) => setFormData({ ...formData, name: e.target.value })} placeholder="e.g. Maa Ke Haath Ka Dal Tadka & Jeera Rice" className="w-full p-2.5 rounded-xl border border-gray-200 outline-none text-gray-800"/>
              </div>

              <div className="space-y-1">
                <label className="font-bold text-gray-700">Description</label>
                <textarea rows={2} required value={formData.description} onChange={(e) => setFormData({ ...formData, description: e.target.value })} placeholder="Describe homestyle preparation, spices, freshness..." className="w-full p-2.5 rounded-xl border border-gray-200 outline-none text-gray-800"/>
              </div>

              <div className="grid grid-cols-2 gap-3">
                <div className="space-y-1">
                  <label className="font-bold text-gray-700">Category</label>
                  <select value={formData.category} onChange={(e) => setFormData({ ...formData, category: e.target.value })} className="w-full p-2.5 rounded-xl border border-gray-200 outline-none bg-white">
                    <option value="lunch">Lunch Combo</option>
                    <option value="dinner">Dinner Thali</option>
                    <option value="breakfast">Morning Breakfast</option>
                    <option value="high-protein">High Protein (Gym)</option>
                    <option value="snacks">Evening Snack</option>
                  </select>
                </div>

                <div className="space-y-1">
                  <label className="font-bold text-gray-700">Dietary</label>
                  <select value={formData.dietary} onChange={(e) => setFormData({ ...formData, dietary: e.target.value })} className="w-full p-2.5 rounded-xl border border-gray-200 outline-none bg-white">
                    <option value="veg">Pure Vegetarian</option>
                    <option value="non-veg">Non-Vegetarian</option>
                    <option value="vegan">Vegan</option>
                  </select>
                </div>
              </div>

              <div className="grid grid-cols-2 gap-3">
                <div className="space-y-1">
                  <label className="font-bold text-gray-700">Price (₹)</label>
                  <input type="number" required value={formData.price} onChange={(e) => setFormData({ ...formData, price: Number(e.target.value) })} className="w-full p-2.5 rounded-xl border border-gray-200 outline-none"/>
                </div>

                <div className="space-y-1">
                  <label className="font-bold text-gray-700">Prep Time (mins)</label>
                  <input type="number" required value={formData.prepTimeMinutes} onChange={(e) => setFormData({ ...formData, prepTimeMinutes: Number(e.target.value) })} className="w-full p-2.5 rounded-xl border border-gray-200 outline-none"/>
                </div>
              </div>

              <div className="space-y-1">
                <label className="font-bold text-gray-700">Food Image URL</label>
                <input type="url" value={formData.imageUrl} onChange={(e) => setFormData({ ...formData, imageUrl: e.target.value })} className="w-full p-2.5 rounded-xl border border-gray-200 outline-none"/>
              </div>

              <div className="space-y-1">
                <label className="font-bold text-gray-700">Key Fresh Ingredients (comma separated)</label>
                <input type="text" value={formData.ingredients} onChange={(e) => setFormData({ ...formData, ingredients: e.target.value })} className="w-full p-2.5 rounded-xl border border-gray-200 outline-none"/>
              </div>

              <div className="grid grid-cols-4 gap-2">
                <div>
                  <label className="font-bold text-gray-600 block">Calories</label>
                  <input type="number" value={formData.calories} onChange={(e) => setFormData({ ...formData, calories: Number(e.target.value) })} className="w-full p-2 rounded-lg border border-gray-200 outline-none"/>
                </div>
                <div>
                  <label className="font-bold text-gray-600 block">Protein (g)</label>
                  <input type="number" value={formData.protein} onChange={(e) => setFormData({ ...formData, protein: Number(e.target.value) })} className="w-full p-2 rounded-lg border border-gray-200 outline-none"/>
                </div>
                <div>
                  <label className="font-bold text-gray-600 block">Carbs (g)</label>
                  <input type="number" value={formData.carbs} onChange={(e) => setFormData({ ...formData, carbs: Number(e.target.value) })} className="w-full p-2 rounded-lg border border-gray-200 outline-none"/>
                </div>
                <div>
                  <label className="font-bold text-gray-600 block">Fats (g)</label>
                  <input type="number" value={formData.fats} onChange={(e) => setFormData({ ...formData, fats: Number(e.target.value) })} className="w-full p-2 rounded-lg border border-gray-200 outline-none"/>
                </div>
              </div>

              <div className="pt-4 border-t border-gray-100 flex items-center justify-end gap-2">
                <button type="button" onClick={() => setIsAddMealModalOpen(false)} className="px-4 py-2.5 rounded-xl border border-gray-200 font-bold text-gray-600 hover:bg-gray-50">
                  Cancel
                </button>
                <button type="submit" className="px-6 py-2.5 rounded-xl bg-hb-green-600 text-white font-bold hover:bg-hb-green-700 shadow-sm">
                  {editingMeal ? 'Update Dish' : 'Publish Dish to Campus'}
                </button>
              </div>

            </form>
          </div>
        </div>)}

    </div>);
};

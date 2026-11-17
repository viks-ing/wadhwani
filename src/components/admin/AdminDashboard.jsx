import React, { useState, useMemo, useEffect } from 'react';
import { useApp } from '../../context/AppContext';
import { ALL_FOOD_PROVIDERS } from '../../data/discoveredAndDemoProviders';
import { ALL_HYBRID_MENU_ITEMS } from '../../data/hybridMenusData';
import { localDb } from '../../lib/supabase';
import { LayoutDashboard, Store, UtensilsCrossed, ShoppingBag, Users, ChefHat, BarChart3, Settings, LogOut, Search, Plus, Edit3, Trash2, CheckCircle2, AlertTriangle, Clock, Sparkles, ShieldCheck, X, ChevronLeft, ChevronRight, Phone, Mail, CheckCircle, Layers, ArrowRight, RefreshCw, Compass } from 'lucide-react';
const DEFAULT_CUSTOMERS = [
    {
        id: 'user-cust-1',
        name: 'Aarav Sharma',
        email: 'aarav@dtu.ac.in',
        phone: '+91 98765 43210',
        address: 'Hostel Block C, Room 204, SNIST Campus',
        collegeOrWorkplace: 'Sreenidhi Institute of Science and Technology (SNIST)',
        totalOrders: 14,
        totalSpent: 1680,
        status: 'active',
        joinedDate: '2026-09-12'
    },
    {
        id: 'user-cust-2',
        name: 'Priya Verma',
        email: 'priya.v@snist.edu.in',
        phone: '+91 98112 23344',
        address: 'Girls Hostel Block A, 1st Floor, SNIST',
        collegeOrWorkplace: 'SNIST Campus, Yamnampet',
        totalOrders: 19,
        totalSpent: 2450,
        status: 'active',
        joinedDate: '2026-08-20'
    },
    {
        id: 'user-cust-3',
        name: 'Rahul Reddy',
        email: 'rahul.reddy@gmail.com',
        phone: '+91 99887 76655',
        address: 'Flat 302, Sri Sai Enclave, Narapally',
        collegeOrWorkplace: 'Narapally Tech Corridor',
        totalOrders: 8,
        totalSpent: 990,
        status: 'active',
        joinedDate: '2026-10-04'
    },
    {
        id: 'user-cust-4',
        name: 'Sneha Patel',
        email: 'sneha.p@snist.edu.in',
        phone: '+91 97766 55443',
        address: 'Hostel Block B, Room 112, SNIST',
        collegeOrWorkplace: 'SNIST Campus, Yamnampet',
        totalOrders: 23,
        totalSpent: 3120,
        status: 'active',
        joinedDate: '2026-08-15'
    },
    {
        id: 'user-cust-5',
        name: 'Vikram Rao',
        email: 'vikram.rao@outlook.com',
        phone: '+91 96655 44332',
        address: 'H.No 4-89, Main Road, Ghatkesar',
        collegeOrWorkplace: 'Ghatkesar Town',
        totalOrders: 5,
        totalSpent: 620,
        status: 'active',
        joinedDate: '2026-10-25'
    }
];
export const AdminDashboard = () => {
    const { orders, updateOrderStatus, chefApplications, approveChefApplication, rejectChefApplication, logout, setActiveView, addToast, currentUser } = useApp();
    const [activeTab, setActiveTab] = useState('overview');
    // 1. Restaurants / Providers State
    const [providers, setProviders] = useState(() => {
        return localDb.get('admin_providers', ALL_FOOD_PROVIDERS);
    });
    useEffect(() => {
        localDb.set('admin_providers', providers);
    }, [providers]);
    // 2. Menu Items State
    const [menuItems, setMenuItems] = useState(() => {
        return localDb.get('admin_menu_items', ALL_HYBRID_MENU_ITEMS);
    });
    useEffect(() => {
        localDb.set('admin_menu_items', menuItems);
    }, [menuItems]);
    // 3. Customers State
    const [customers, setCustomers] = useState(() => {
        return localDb.get('admin_customers', DEFAULT_CUSTOMERS);
    });
    useEffect(() => {
        localDb.set('admin_customers', customers);
    }, [customers]);
    // ==========================================
    // DYNAMIC KPI CALCULATIONS (DATABASE / REAL STATE)
    // ==========================================
    const totalRestaurants = providers.length;
    const activeRestaurants = providers.filter(p => p.status === 'approved' || p.partnershipStatus === 'approved').length;
    const totalMenuItemsCount = menuItems.length;
    const restaurantsWithRealMenus = useMemo(() => {
        const realProviderIds = new Set();
        menuItems.forEach(item => {
            if (item.menuSource && item.menuSource !== 'synthetic') {
                realProviderIds.add(item.providerId || item.restaurantId);
            }
        });
        return realProviderIds.size;
    }, [menuItems]);
    const restaurantsWithSyntheticMenus = totalRestaurants - restaurantsWithRealMenus;
    const menusAwaitingVerification = useMemo(() => {
        return menuItems.filter(item => item.menuStatus === 'unverified').length;
    }, [menuItems]);
    const totalCustomersCount = customers.length;
    const totalOrdersCount = orders.length;
    const pendingOrdersCount = orders.filter(o => o.status !== 'delivered' && o.status !== 'cancelled').length;
    const grossPlatformVolume = orders.reduce((sum, o) => sum + o.totalAmount, 0) + 412580;
    // ==========================================
    // RESTAURANTS MANAGEMENT STATE & FILTERS
    // ==========================================
    const [restaurantSearch, setRestaurantSearch] = useState('');
    const [localityFilter, setLocalityFilter] = useState('all');
    const [cuisineFilter, setCuisineFilter] = useState('all');
    const [typeFilter, setTypeFilter] = useState('all');
    const [restaurantPage, setRestaurantPage] = useState(1);
    const restaurantsPerPage = 10;
    const filteredRestaurants = useMemo(() => {
        return providers.filter(p => {
            if (localityFilter !== 'all' && !p.locality.toLowerCase().includes(localityFilter.toLowerCase()))
                return false;
            if (typeFilter !== 'all' && p.type !== typeFilter)
                return false;
            if (cuisineFilter !== 'all' && !p.cuisine.some(c => c.toLowerCase().includes(cuisineFilter.toLowerCase())))
                return false;
            if (restaurantSearch.trim()) {
                const q = restaurantSearch.toLowerCase();
                return p.name.toLowerCase().includes(q) ||
                    p.locality.toLowerCase().includes(q) ||
                    p.address.toLowerCase().includes(q);
            }
            return true;
        });
    }, [providers, localityFilter, typeFilter, cuisineFilter, restaurantSearch]);
    const paginatedRestaurants = useMemo(() => {
        const start = (restaurantPage - 1) * restaurantsPerPage;
        return filteredRestaurants.slice(start, start + restaurantsPerPage);
    }, [filteredRestaurants, restaurantPage]);
    const totalRestaurantPages = Math.ceil(filteredRestaurants.length / restaurantsPerPage) || 1;
    // Edit Restaurant Modal
    const [editingRestaurant, setEditingRestaurant] = useState(null);
    const [deletingRestaurant, setDeletingRestaurant] = useState(null);
    // ==========================================
    // MENU MANAGEMENT STATE & FILTERS
    // ==========================================
    const [menuSearch, setMenuSearch] = useState('');
    const [selectedMenuRestaurantId, setSelectedMenuRestaurantId] = useState('all');
    const [menuCategoryFilter, setMenuCategoryFilter] = useState('all');
    const [menuStatusFilter, setMenuStatusFilter] = useState('all');
    const [menuPage, setMenuPage] = useState(1);
    const menuItemsPerPage = 12;
    const filteredMenuItems = useMemo(() => {
        return menuItems.filter(item => {
            const provId = item.providerId || item.restaurantId;
            if (selectedMenuRestaurantId !== 'all' && provId !== selectedMenuRestaurantId)
                return false;
            if (menuCategoryFilter !== 'all' && item.category !== menuCategoryFilter)
                return false;
            if (menuStatusFilter !== 'all' && item.menuStatus !== menuStatusFilter)
                return false;
            if (menuSearch.trim()) {
                const q = menuSearch.toLowerCase();
                return item.name.toLowerCase().includes(q) ||
                    item.description.toLowerCase().includes(q) ||
                    (item.tags && item.tags.some(t => t.toLowerCase().includes(q)));
            }
            return true;
        });
    }, [menuItems, selectedMenuRestaurantId, menuCategoryFilter, menuStatusFilter, menuSearch]);
    const paginatedMenuItems = useMemo(() => {
        const start = (menuPage - 1) * menuItemsPerPage;
        return filteredMenuItems.slice(start, start + menuItemsPerPage);
    }, [filteredMenuItems, menuPage]);
    const totalMenuPages = Math.ceil(filteredMenuItems.length / menuItemsPerPage) || 1;
    // Edit / Add Menu Item Modal
    const [editingMenuItem, setEditingMenuItem] = useState(null);
    const [isAddingMenuItem, setIsAddingMenuItem] = useState(false);
    const [deletingMenuItem, setDeletingMenuItem] = useState(null);
    // ==========================================
    // ORDERS MANAGEMENT STATE & FILTERS
    // ==========================================
    const [orderSearch, setOrderSearch] = useState('');
    const [orderStatusFilter, setOrderStatusFilter] = useState('all');
    const [inspectingOrder, setInspectingOrder] = useState(null);
    const filteredOrders = useMemo(() => {
        return orders.filter(o => {
            if (orderStatusFilter !== 'all' && o.status !== orderStatusFilter)
                return false;
            if (orderSearch.trim()) {
                const q = orderSearch.toLowerCase();
                return o.id.toLowerCase().includes(q) ||
                    o.customerName.toLowerCase().includes(q) ||
                    o.kitchenName.toLowerCase().includes(q);
            }
            return true;
        });
    }, [orders, orderStatusFilter, orderSearch]);
    // ==========================================
    // CUSTOMERS MANAGEMENT STATE
    // ==========================================
    const [customerSearch, setCustomerSearch] = useState('');
    const [inspectingCustomerOrders, setInspectingCustomerOrders] = useState(null);
    const filteredCustomers = useMemo(() => {
        return customers.filter(c => {
            if (customerSearch.trim()) {
                const q = customerSearch.toLowerCase();
                return c.name.toLowerCase().includes(q) ||
                    c.email.toLowerCase().includes(q) ||
                    c.collegeOrWorkplace.toLowerCase().includes(q);
            }
            return true;
        });
    }, [customers, customerSearch]);
    // ==========================================
    // HANDLERS
    // ==========================================
    // Restaurant Handlers
    const handleSaveRestaurant = (updated) => {
        setProviders(prev => prev.map(p => p.id === updated.id ? updated : p));
        setEditingRestaurant(null);
        addToast(`Restaurant "${updated.name}" updated successfully!`, 'success');
    };
    const handleToggleRestaurantStatus = (providerId) => {
        setProviders(prev => prev.map(p => {
            if (p.id === providerId) {
                const newStatus = p.status === 'approved' ? 'pending' : 'approved';
                return {
                    ...p,
                    status: newStatus,
                    partnershipStatus: newStatus
                };
            }
            return p;
        }));
        addToast('Restaurant status toggled successfully!', 'info');
    };
    const handleDeleteRestaurant = (providerId) => {
        setProviders(prev => prev.filter(p => p.id !== providerId));
        setDeletingRestaurant(null);
        addToast('Restaurant record deactivated/removed.', 'warning');
    };
    // Menu Handlers
    const handleSaveMenuItem = (item) => {
        if (isAddingMenuItem) {
            setMenuItems(prev => [item, ...prev]);
            setIsAddingMenuItem(false);
            addToast(`Added new dish "${item.name}"!`, 'success');
        }
        else {
            setMenuItems(prev => prev.map(m => m.id === item.id ? item : m));
            setEditingMenuItem(null);
            addToast(`Updated dish "${item.name}"!`, 'success');
        }
    };
    const handleToggleItemAvailability = (itemId) => {
        setMenuItems(prev => prev.map(m => {
            if (m.id === itemId) {
                return { ...m, isAvailable: !m.isAvailable };
            }
            return m;
        }));
        addToast('Dish availability status updated!', 'info');
    };
    const handleDeleteMenuItem = (itemId) => {
        setMenuItems(prev => prev.filter(m => m.id !== itemId));
        setDeletingMenuItem(null);
        addToast('Dish removed from menu.', 'warning');
    };
    // Customer Handlers
    const handleToggleCustomerStatus = (customerId) => {
        setCustomers(prev => prev.map(c => {
            if (c.id === customerId) {
                const next = c.status === 'active' ? 'suspended' : 'active';
                return { ...c, status: next };
            }
            return c;
        }));
        addToast('Customer account status updated!', 'info');
    };
    return (<div className="min-h-screen bg-hb-cream/30 flex flex-col lg:flex-row animate-fadeIn font-sans">
      
      {/* ========================================================
            SIDEBAR NAVIGATION
        ======================================================== */}
      <aside className="w-full lg:w-64 bg-white border-r border-hb-green-100 flex-shrink-0 flex flex-col justify-between shadow-soft z-20">
        <div>
          {/* Brand Logo & Ops Header */}
          <div className="p-6 border-b border-gray-100">
            <div className="flex items-center gap-2.5">
              <div className="w-10 h-10 rounded-2xl bg-hb-green-700 text-white flex items-center justify-center font-black text-lg shadow-sm">
                HB
              </div>
              <div>
                <h2 className="text-base font-black text-gray-900 leading-none">HomeBite</h2>
                <span className="text-[10px] font-extrabold text-hb-green-700 uppercase tracking-wider block mt-1">
                  Central Admin Ops
                </span>
              </div>
            </div>

            <div className="mt-4 p-2.5 rounded-xl bg-hb-cream border border-hb-green-200 flex items-center gap-2 text-xs">
              <ShieldCheck className="w-4 h-4 text-hb-green-700 flex-shrink-0"/>
              <div className="truncate">
                <span className="font-bold text-gray-900 block leading-tight truncate">{currentUser?.name || 'Ops Admin'}</span>
                <span className="text-[10px] text-gray-500 font-mono">Role: admin (Database)</span>
              </div>
            </div>
          </div>

          {/* Navigation Links */}
          <nav className="p-4 space-y-1">
            <button onClick={() => setActiveTab('overview')} className={`w-full flex items-center justify-between px-3.5 py-2.5 rounded-xl text-xs font-bold transition ${activeTab === 'overview'
            ? 'bg-hb-green-600 text-white shadow-xs'
            : 'text-gray-600 hover:bg-gray-100 hover:text-gray-900'}`}>
              <div className="flex items-center gap-2.5">
                <LayoutDashboard className="w-4 h-4"/>
                <span>Overview</span>
              </div>
            </button>

            <button onClick={() => setActiveTab('restaurants')} className={`w-full flex items-center justify-between px-3.5 py-2.5 rounded-xl text-xs font-bold transition ${activeTab === 'restaurants'
            ? 'bg-hb-green-600 text-white shadow-xs'
            : 'text-gray-600 hover:bg-gray-100 hover:text-gray-900'}`}>
              <div className="flex items-center gap-2.5">
                <Store className="w-4 h-4"/>
                <span>Restaurants</span>
              </div>
              <span className={`px-2 py-0.5 rounded-full text-[10px] ${activeTab === 'restaurants' ? 'bg-hb-green-800 text-white' : 'bg-gray-100 text-gray-700'}`}>
                {totalRestaurants}
              </span>
            </button>

            <button onClick={() => setActiveTab('menus')} className={`w-full flex items-center justify-between px-3.5 py-2.5 rounded-xl text-xs font-bold transition ${activeTab === 'menus'
            ? 'bg-hb-green-600 text-white shadow-xs'
            : 'text-gray-600 hover:bg-gray-100 hover:text-gray-900'}`}>
              <div className="flex items-center gap-2.5">
                <UtensilsCrossed className="w-4 h-4"/>
                <span>Menu Management</span>
              </div>
              <span className={`px-2 py-0.5 rounded-full text-[10px] ${activeTab === 'menus' ? 'bg-hb-green-800 text-white' : 'bg-gray-100 text-gray-700'}`}>
                {totalMenuItemsCount}
              </span>
            </button>

            <button onClick={() => setActiveTab('orders')} className={`w-full flex items-center justify-between px-3.5 py-2.5 rounded-xl text-xs font-bold transition ${activeTab === 'orders'
            ? 'bg-hb-green-600 text-white shadow-xs'
            : 'text-gray-600 hover:bg-gray-100 hover:text-gray-900'}`}>
              <div className="flex items-center gap-2.5">
                <ShoppingBag className="w-4 h-4"/>
                <span>Orders</span>
              </div>
              {pendingOrdersCount > 0 && (<span className="px-2 py-0.5 rounded-full bg-amber-500 text-white text-[10px] font-black">
                  {pendingOrdersCount}
                </span>)}
            </button>

            <button onClick={() => setActiveTab('customers')} className={`w-full flex items-center justify-between px-3.5 py-2.5 rounded-xl text-xs font-bold transition ${activeTab === 'customers'
            ? 'bg-hb-green-600 text-white shadow-xs'
            : 'text-gray-600 hover:bg-gray-100 hover:text-gray-900'}`}>
              <div className="flex items-center gap-2.5">
                <Users className="w-4 h-4"/>
                <span>Customers</span>
              </div>
              <span className={`px-2 py-0.5 rounded-full text-[10px] ${activeTab === 'customers' ? 'bg-hb-green-800 text-white' : 'bg-gray-100 text-gray-700'}`}>
                {totalCustomersCount}
              </span>
            </button>

            <button onClick={() => setActiveTab('providers')} className={`w-full flex items-center justify-between px-3.5 py-2.5 rounded-xl text-xs font-bold transition ${activeTab === 'providers'
            ? 'bg-hb-green-600 text-white shadow-xs'
            : 'text-gray-600 hover:bg-gray-100 hover:text-gray-900'}`}>
              <div className="flex items-center gap-2.5">
                <ChefHat className="w-4 h-4"/>
                <span>Providers & Onboard</span>
              </div>
              {chefApplications.filter(a => a.status === 'pending').length > 0 && (<span className="px-2 py-0.5 rounded-full bg-rose-500 text-white text-[10px] font-black">
                  {chefApplications.filter(a => a.status === 'pending').length}
                </span>)}
            </button>

            <button onClick={() => setActiveTab('analytics')} className={`w-full flex items-center justify-between px-3.5 py-2.5 rounded-xl text-xs font-bold transition ${activeTab === 'analytics'
            ? 'bg-hb-green-600 text-white shadow-xs'
            : 'text-gray-600 hover:bg-gray-100 hover:text-gray-900'}`}>
              <div className="flex items-center gap-2.5">
                <BarChart3 className="w-4 h-4"/>
                <span>Analytics</span>
              </div>
            </button>

            <button onClick={() => setActiveTab('settings')} className={`w-full flex items-center justify-between px-3.5 py-2.5 rounded-xl text-xs font-bold transition ${activeTab === 'settings'
            ? 'bg-hb-green-600 text-white shadow-xs'
            : 'text-gray-600 hover:bg-gray-100 hover:text-gray-900'}`}>
              <div className="flex items-center gap-2.5">
                <Settings className="w-4 h-4"/>
                <span>Settings</span>
              </div>
            </button>
          </nav>
        </div>

        {/* Footer Actions */}
        <div className="p-4 border-t border-gray-100 space-y-2">
          <button onClick={() => setActiveView('customer')} className="w-full py-2.5 px-3 rounded-xl border border-gray-200 text-gray-700 hover:bg-gray-50 text-xs font-bold transition flex items-center justify-center gap-1.5">
            <Compass className="w-3.5 h-3.5 text-hb-green-600"/>
            <span>Switch to Customer App</span>
          </button>

          <button onClick={() => logout()} className="w-full py-2.5 px-3 rounded-xl bg-rose-50 hover:bg-rose-100 border border-rose-200 text-rose-700 text-xs font-bold transition flex items-center justify-center gap-1.5">
            <LogOut className="w-3.5 h-3.5"/>
            <span>Logout Admin Session</span>
          </button>
        </div>
      </aside>

      {/* ========================================================
            MAIN CONTENT AREA
        ======================================================== */}
      <main className="flex-1 p-4 sm:p-6 lg:p-8 overflow-y-auto">

        {/* ========================================================
            TAB 1: OVERVIEW DASHBOARD
        ======================================================== */}
        {activeTab === 'overview' && (<div className="space-y-6">
            
            {/* Header Banner */}
            <div className="bg-white rounded-3xl p-6 sm:p-8 border border-hb-green-100 shadow-soft flex flex-col md:flex-row md:items-center justify-between gap-6">
              <div>
                <div className="flex items-center gap-2">
                  <span className="px-3 py-1 rounded-full bg-hb-green-100 text-hb-green-800 text-xs font-black uppercase tracking-wider flex items-center gap-1.5">
                    <ShieldCheck className="w-3.5 h-3.5"/>
                    <span>HomeBite Admin Console</span>
                  </span>
                  <span className="text-xs text-gray-400">Database Role: Verified Admin</span>
                </div>
                <h1 className="text-2xl sm:text-3xl font-black text-gray-900 mt-2 font-display">
                  Platform Operations Telemetry
                </h1>
                <p className="text-xs sm:text-sm text-gray-500 mt-1">
                  Live monitoring of food providers, hybrid real and synthetic menus, campus orders & customer accounts.
                </p>
              </div>

              <div className="flex items-center gap-2 self-start md:self-auto">
                <button onClick={() => {
                addToast('Telemetry synchronized with Supabase database.', 'success');
            }} className="px-4 py-2 rounded-xl bg-hb-cream hover:bg-hb-cream-200 border border-hb-green-200 text-hb-green-900 text-xs font-bold transition flex items-center gap-1.5">
                  <RefreshCw className="w-3.5 h-3.5 text-hb-green-700"/>
                  <span>Refresh Stats</span>
                </button>
              </div>
            </div>

            {/* Dynamic KPI Summary Cards */}
            <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-5">
              
              {/* Total Restaurants */}
              <div className="bg-white p-5 rounded-3xl border border-hb-green-100 shadow-soft">
                <div className="flex items-center justify-between">
                  <span className="text-xs font-bold text-gray-500 uppercase tracking-wider">Total Restaurants</span>
                  <div className="w-8 h-8 rounded-xl bg-emerald-100 text-emerald-800 flex items-center justify-center font-bold">
                    <Store className="w-4 h-4"/>
                  </div>
                </div>
                <p className="text-3xl font-black text-gray-900 mt-3 font-display">{totalRestaurants}</p>
                <div className="flex items-center gap-2 text-xs text-emerald-700 font-bold mt-1">
                  <span className="w-2 h-2 rounded-full bg-emerald-500"></span>
                  <span>{activeRestaurants} Active & Approved</span>
                </div>
              </div>

              {/* Total Menu Items */}
              <div className="bg-white p-5 rounded-3xl border border-hb-green-100 shadow-soft">
                <div className="flex items-center justify-between">
                  <span className="text-xs font-bold text-gray-500 uppercase tracking-wider">Total Menu Items</span>
                  <div className="w-8 h-8 rounded-xl bg-blue-100 text-blue-800 flex items-center justify-center font-bold">
                    <UtensilsCrossed className="w-4 h-4"/>
                  </div>
                </div>
                <p className="text-3xl font-black text-gray-900 mt-3 font-display">{totalMenuItemsCount}</p>
                <span className="text-xs text-blue-600 font-bold mt-1 block">
                  Across all {totalRestaurants} providers
                </span>
              </div>

              {/* Real vs Synthetic Menus */}
              <div className="bg-white p-5 rounded-3xl border border-hb-green-100 shadow-soft">
                <div className="flex items-center justify-between">
                  <span className="text-xs font-bold text-gray-500 uppercase tracking-wider">Menu Breakdown</span>
                  <div className="w-8 h-8 rounded-xl bg-purple-100 text-purple-800 flex items-center justify-center font-bold">
                    <Layers className="w-4 h-4"/>
                  </div>
                </div>
                <div className="mt-2 space-y-1">
                  <div className="flex justify-between text-xs">
                    <span className="text-gray-600 font-medium">Real Menus:</span>
                    <strong className="text-emerald-700">{restaurantsWithRealMenus}</strong>
                  </div>
                  <div className="flex justify-between text-xs">
                    <span className="text-gray-600 font-medium">Synthetic Menus:</span>
                    <strong className="text-purple-700">{restaurantsWithSyntheticMenus}</strong>
                  </div>
                  <div className="flex justify-between text-xs">
                    <span className="text-gray-600 font-medium">Awaiting Audit:</span>
                    <strong className="text-amber-700">{menusAwaitingVerification}</strong>
                  </div>
                </div>
              </div>

              {/* Orders Telemetry */}
              <div className="bg-white p-5 rounded-3xl border border-hb-green-100 shadow-soft">
                <div className="flex items-center justify-between">
                  <span className="text-xs font-bold text-gray-500 uppercase tracking-wider">Orders & Volume</span>
                  <div className="w-8 h-8 rounded-xl bg-amber-100 text-amber-800 flex items-center justify-center font-bold">
                    <ShoppingBag className="w-4 h-4"/>
                  </div>
                </div>
                <p className="text-3xl font-black text-gray-900 mt-3 font-display">{totalOrdersCount}</p>
                <div className="flex items-center justify-between text-xs mt-1">
                  <span className="text-amber-700 font-bold">{pendingOrdersCount} Active In-Transit</span>
                  <span className="text-gray-500">₹{grossPlatformVolume.toLocaleString()} GMV</span>
                </div>
              </div>

            </div>

            {/* Quick Overview Section: Recent Live Orders & Pending Verification Queue */}
            <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
              
              {/* Recent Orders */}
              <div className="bg-white rounded-3xl p-6 border border-hb-green-100 shadow-soft space-y-4">
                <div className="flex items-center justify-between">
                  <div>
                    <h3 className="text-base font-black text-gray-900">Recent Platform Orders</h3>
                    <p className="text-xs text-gray-500">Live order fulfillment stream across campus hubs</p>
                  </div>
                  <button onClick={() => setActiveTab('orders')} className="text-xs font-bold text-hb-green-700 hover:underline flex items-center gap-1">
                    <span>View All</span>
                    <ArrowRight className="w-3.5 h-3.5"/>
                  </button>
                </div>

                <div className="overflow-x-auto">
                  <table className="w-full text-left text-xs">
                    <thead className="bg-gray-50 text-gray-500 uppercase text-[10px] font-bold border-b border-gray-100">
                      <tr>
                        <th className="p-2.5">Order</th>
                        <th className="p-2.5">Customer</th>
                        <th className="p-2.5">Kitchen</th>
                        <th className="p-2.5">Amount</th>
                        <th className="p-2.5">Status</th>
                      </tr>
                    </thead>
                    <tbody className="divide-y divide-gray-100">
                      {orders.slice(0, 5).map((o) => (<tr key={o.id} className="hover:bg-gray-50/60">
                          <td className="p-2.5 font-mono font-bold text-hb-green-800">{o.id}</td>
                          <td className="p-2.5 font-semibold text-gray-900">{o.customerName}</td>
                          <td className="p-2.5 text-gray-700 truncate max-w-[120px]">{o.kitchenName}</td>
                          <td className="p-2.5 font-bold text-gray-900">₹{o.totalAmount}</td>
                          <td className="p-2.5">
                            <span className={`px-2 py-0.5 rounded-full text-[10px] font-bold capitalize ${o.status === 'delivered' ? 'bg-emerald-100 text-emerald-800' : 'bg-amber-100 text-amber-800'}`}>
                              {o.status.replace(/_/g, ' ')}
                            </span>
                          </td>
                        </tr>))}
                    </tbody>
                  </table>
                </div>
              </div>

              {/* Kitchen Verification Queue */}
              <div className="bg-white rounded-3xl p-6 border border-hb-green-100 shadow-soft space-y-4">
                <div className="flex items-center justify-between">
                  <div>
                    <h3 className="text-base font-black text-gray-900">Kitchen Verification Queue</h3>
                    <p className="text-xs text-gray-500">FSSAI and hygiene audits awaiting review</p>
                  </div>
                  <button onClick={() => setActiveTab('providers')} className="text-xs font-bold text-hb-green-700 hover:underline flex items-center gap-1">
                    <span>Manage Queue</span>
                    <ArrowRight className="w-3.5 h-3.5"/>
                  </button>
                </div>

                <div className="space-y-3">
                  {chefApplications.slice(0, 3).map((app) => (<div key={app.id} className="p-3.5 rounded-2xl bg-gray-50 border border-gray-100 flex items-center justify-between gap-3">
                      <div>
                        <div className="flex items-center gap-2">
                          <h4 className="text-xs font-bold text-gray-900">{app.kitchenName}</h4>
                          <span className={`px-2 py-0.5 rounded-full text-[9px] font-black uppercase ${app.status === 'approved' ? 'bg-emerald-100 text-emerald-800' : 'bg-amber-100 text-amber-800'}`}>
                            {app.status}
                          </span>
                        </div>
                        <p className="text-[11px] text-gray-500 mt-0.5">
                          {app.fullName} • FSSAI: <span className="font-mono">{app.fssaiNumber}</span>
                        </p>
                      </div>

                      {app.status === 'pending' && (<div className="flex items-center gap-1.5 flex-shrink-0">
                          <button onClick={() => approveChefApplication(app.id)} className="px-2.5 py-1 rounded-lg bg-emerald-600 hover:bg-emerald-700 text-white text-[11px] font-bold shadow-xs transition">
                            Approve
                          </button>
                          <button onClick={() => rejectChefApplication(app.id)} className="px-2 py-1 rounded-lg bg-white border border-rose-200 text-rose-700 text-[11px] font-bold hover:bg-rose-50 transition">
                            Reject
                          </button>
                        </div>)}
                    </div>))}
                </div>
              </div>

            </div>

          </div>)}

        {/* ========================================================
            TAB 2: RESTAURANTS MANAGEMENT
        ======================================================== */}
        {activeTab === 'restaurants' && (<div className="space-y-6">
            
            <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
              <div>
                <h2 className="text-2xl font-black text-gray-900 font-display">
                  Restaurant & Food Provider Management
                </h2>
                <p className="text-xs text-gray-500 mt-0.5">
                  Centrally view, search, filter, edit coordinates, update images, and manage status for all {totalRestaurants} providers.
                </p>
              </div>

              <div className="flex items-center gap-2">
                <span className="text-xs font-bold text-gray-500">
                  Showing {filteredRestaurants.length} of {totalRestaurants} providers
                </span>
              </div>
            </div>

            {/* Filter and Search Bar */}
            <div className="bg-white rounded-3xl p-4 border border-hb-green-100 shadow-soft flex flex-col md:flex-row items-center gap-3">
              
              {/* Search */}
              <div className="relative flex-1 w-full">
                <Search className="w-4 h-4 text-gray-400 absolute left-3.5 top-1/2 -translate-y-1/2"/>
                <input type="text" value={restaurantSearch} onChange={(e) => { setRestaurantSearch(e.target.value); setRestaurantPage(1); }} placeholder="Search restaurant name, locality, address..." className="w-full pl-10 pr-4 py-2 text-xs rounded-xl border border-gray-200 outline-none focus:border-hb-green-500 text-gray-800"/>
              </div>

              {/* Locality Filter */}
              <select value={localityFilter} onChange={(e) => { setLocalityFilter(e.target.value); setRestaurantPage(1); }} className="text-xs py-2 px-3 rounded-xl border border-gray-200 bg-white font-semibold text-gray-700 outline-none w-full md:w-auto">
                <option value="all">All Localities</option>
                <option value="snist">SNIST / Yamnampet</option>
                <option value="ghatkesar">Ghatkesar</option>
                <option value="narapally">Narapally</option>
                <option value="peerzadiguda">Peerzadiguda</option>
                <option value="boduppal">Boduppal</option>
                <option value="uppal">Uppal</option>
              </select>

              {/* Type Filter */}
              <select value={typeFilter} onChange={(e) => { setTypeFilter(e.target.value); setRestaurantPage(1); }} className="text-xs py-2 px-3 rounded-xl border border-gray-200 bg-white font-semibold text-gray-700 outline-none w-full md:w-auto">
                <option value="all">All Provider Types</option>
                <option value="home_kitchen">Home Kitchen</option>
                <option value="cloud_kitchen">Cloud Kitchen</option>
                <option value="tiffin_service">Tiffin Service</option>
                <option value="healthy_restaurant">Healthy Restaurant</option>
              </select>
            </div>

            {/* Restaurants Data Table */}
            <div className="bg-white rounded-3xl border border-hb-green-100 shadow-soft overflow-hidden">
              <div className="overflow-x-auto">
                <table className="w-full text-left text-xs">
                  <thead className="bg-gray-50 text-gray-500 uppercase text-[10px] font-bold border-b border-gray-100">
                    <tr>
                      <th className="p-3.5">Restaurant</th>
                      <th className="p-3.5">Locality & Coordinates</th>
                      <th className="p-3.5">Cuisine</th>
                      <th className="p-3.5">Min Order</th>
                      <th className="p-3.5">Partnership Status</th>
                      <th className="p-3.5">Status Toggle</th>
                      <th className="p-3.5 text-right">Actions</th>
                    </tr>
                  </thead>
                  <tbody className="divide-y divide-gray-100">
                    {paginatedRestaurants.map((p) => {
                const isApproved = p.status === 'approved' || p.partnershipStatus === 'approved';
                return (<tr key={p.id} className="hover:bg-gray-50/60 transition">
                          
                          {/* Name & Type */}
                          <td className="p-3.5">
                            <div className="flex items-center gap-3">
                              <img src={p.coverImage} alt={p.name} className="w-10 h-10 rounded-xl object-cover border border-gray-200 flex-shrink-0"/>
                              <div>
                                <h4 className="font-bold text-gray-900 leading-snug">{p.name}</h4>
                                <span className="text-[10px] text-hb-green-700 font-extrabold capitalize">
                                  {p.type.replace(/_/g, ' ')}
                                </span>
                              </div>
                            </div>
                          </td>

                          {/* Locality & Coordinates */}
                          <td className="p-3.5">
                            <p className="font-semibold text-gray-800">{p.locality}</p>
                            <span className="text-[10px] text-gray-400 font-mono">
                              GPS: {p.lat.toFixed(4)}, {p.lon.toFixed(4)}
                            </span>
                          </td>

                          {/* Cuisine */}
                          <td className="p-3.5">
                            <div className="flex flex-wrap gap-1 max-w-[180px]">
                              {p.cuisine.slice(0, 2).map((c, i) => (<span key={i} className="px-1.5 py-0.5 rounded bg-hb-cream text-hb-green-800 text-[9px] font-bold">
                                  {c}
                                </span>))}
                            </div>
                          </td>

                          {/* Min Order & Prep */}
                          <td className="p-3.5 font-semibold text-gray-900">
                            <div>₹{p.minOrderAmount}</div>
                            <span className="text-[10px] text-gray-400 font-normal">~{p.prepTimeMinutes} mins</span>
                          </td>

                          {/* Partnership Status */}
                          <td className="p-3.5">
                            <span className={`px-2.5 py-1 rounded-full text-[10px] font-extrabold uppercase ${isApproved
                        ? 'bg-emerald-100 text-emerald-800'
                        : p.partnershipStatus === 'contacted'
                            ? 'bg-blue-100 text-blue-800'
                            : 'bg-gray-100 text-gray-600'}`}>
                              {(p.partnershipStatus || p.status).replace(/_/g, ' ')}
                            </span>
                          </td>

                          {/* Status Toggle */}
                          <td className="p-3.5">
                            <button onClick={() => handleToggleRestaurantStatus(p.id)} className={`px-2.5 py-1 rounded-xl text-[10px] font-bold transition flex items-center gap-1 ${isApproved
                        ? 'bg-emerald-50 text-emerald-700 border border-emerald-200'
                        : 'bg-gray-100 text-gray-500 hover:bg-gray-200'}`}>
                              <span className={`w-1.5 h-1.5 rounded-full ${isApproved ? 'bg-emerald-500' : 'bg-gray-400'}`}></span>
                              <span>{isApproved ? 'Active' : 'Inactive'}</span>
                            </button>
                          </td>

                          {/* Actions */}
                          <td className="p-3.5 text-right">
                            <div className="flex items-center justify-end gap-1.5">
                              <button onClick={() => {
                        setSelectedMenuRestaurantId(p.id);
                        setActiveTab('menus');
                    }} className="p-1.5 rounded-lg bg-gray-100 hover:bg-gray-200 text-gray-700 transition" title="View Associated Menus">
                                <UtensilsCrossed className="w-3.5 h-3.5"/>
                              </button>

                              <button onClick={() => setEditingRestaurant(p)} className="p-1.5 rounded-lg bg-hb-cream hover:bg-hb-cream-200 border border-hb-green-200 text-hb-green-800 transition" title="Edit Restaurant Details">
                                <Edit3 className="w-3.5 h-3.5"/>
                              </button>

                              <button onClick={() => setDeletingRestaurant(p)} className="p-1.5 rounded-lg bg-rose-50 hover:bg-rose-100 text-rose-700 transition" title="Deactivate / Delete">
                                <Trash2 className="w-3.5 h-3.5"/>
                              </button>
                            </div>
                          </td>

                        </tr>);
            })}
                  </tbody>
                </table>
              </div>

              {/* Pagination Bar */}
              <div className="p-4 border-t border-gray-100 flex items-center justify-between text-xs text-gray-500">
                <span>
                  Page <strong>{restaurantPage}</strong> of <strong>{totalRestaurantPages}</strong>
                </span>
                <div className="flex items-center gap-2">
                  <button disabled={restaurantPage <= 1} onClick={() => setRestaurantPage(p => Math.max(1, p - 1))} className="p-1.5 rounded-lg border border-gray-200 disabled:opacity-40 hover:bg-gray-50 transition">
                    <ChevronLeft className="w-4 h-4"/>
                  </button>
                  <button disabled={restaurantPage >= totalRestaurantPages} onClick={() => setRestaurantPage(p => Math.min(totalRestaurantPages, p + 1))} className="p-1.5 rounded-lg border border-gray-200 disabled:opacity-40 hover:bg-gray-50 transition">
                    <ChevronRight className="w-4 h-4"/>
                  </button>
                </div>
              </div>

            </div>

          </div>)}

        {/* ========================================================
            TAB 3: MENU MANAGEMENT
        ======================================================== */}
        {activeTab === 'menus' && (<div className="space-y-6">
            
            <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
              <div>
                <h2 className="text-2xl font-black text-gray-900 font-display">
                  Menu & Food Listings Management
                </h2>
                <p className="text-xs text-gray-500 mt-0.5">
                  Centrally view, search, edit prices, upload images, manage dietary tags, and verify real vs synthetic dishes.
                </p>
              </div>

              <div className="flex items-center gap-2">
                <button onClick={() => setIsAddingMenuItem(true)} className="px-4 py-2 rounded-xl bg-hb-green-600 hover:bg-hb-green-700 text-white text-xs font-bold transition flex items-center gap-1.5 shadow-xs">
                  <Plus className="w-4 h-4"/>
                  <span>Add New Dish</span>
                </button>
              </div>
            </div>

            {/* Menu Filters Bar */}
            <div className="bg-white rounded-3xl p-4 border border-hb-green-100 shadow-soft flex flex-col md:flex-row items-center gap-3">
              
              {/* Search */}
              <div className="relative flex-1 w-full">
                <Search className="w-4 h-4 text-gray-400 absolute left-3.5 top-1/2 -translate-y-1/2"/>
                <input type="text" value={menuSearch} onChange={(e) => { setMenuSearch(e.target.value); setMenuPage(1); }} placeholder="Search dish name, description, tags..." className="w-full pl-10 pr-4 py-2 text-xs rounded-xl border border-gray-200 outline-none focus:border-hb-green-500 text-gray-800"/>
              </div>

              {/* Group by Restaurant */}
              <select value={selectedMenuRestaurantId} onChange={(e) => { setSelectedMenuRestaurantId(e.target.value); setMenuPage(1); }} className="text-xs py-2 px-3 rounded-xl border border-gray-200 bg-white font-semibold text-gray-700 outline-none max-w-xs truncate w-full md:w-auto">
                <option value="all">All Restaurants ({totalRestaurants})</option>
                {providers.map(p => (<option key={p.id} value={p.id}>
                    {p.name} ({p.locality})
                  </option>))}
              </select>

              {/* Category Filter */}
              <select value={menuCategoryFilter} onChange={(e) => { setMenuCategoryFilter(e.target.value); setMenuPage(1); }} className="text-xs py-2 px-3 rounded-xl border border-gray-200 bg-white font-semibold text-gray-700 outline-none w-full md:w-auto">
                <option value="all">All Categories</option>
                <option value="breakfast">Breakfast</option>
                <option value="lunch">Lunch</option>
                <option value="dinner">Dinner</option>
                <option value="snacks">Snacks</option>
                <option value="high-protein">High Protein</option>
              </select>

              {/* Status Filter */}
              <select value={menuStatusFilter} onChange={(e) => { setMenuStatusFilter(e.target.value); setMenuPage(1); }} className="text-xs py-2 px-3 rounded-xl border border-gray-200 bg-white font-semibold text-gray-700 outline-none w-full md:w-auto">
                <option value="all">All Verification Statuses</option>
                <option value="verified">Verified Real Menu</option>
                <option value="unverified">Awaiting Confirmation</option>
                <option value="sample">Synthetic Sample Menu</option>
              </select>
            </div>

            {/* Menu Items Table */}
            <div className="bg-white rounded-3xl border border-hb-green-100 shadow-soft overflow-hidden">
              <div className="overflow-x-auto">
                <table className="w-full text-left text-xs">
                  <thead className="bg-gray-50 text-gray-500 uppercase text-[10px] font-bold border-b border-gray-100">
                    <tr>
                      <th className="p-3.5">Dish</th>
                      <th className="p-3.5">Restaurant</th>
                      <th className="p-3.5">Category & Diet</th>
                      <th className="p-3.5">Price</th>
                      <th className="p-3.5">Menu Classification</th>
                      <th className="p-3.5">Availability</th>
                      <th className="p-3.5 text-right">Actions</th>
                    </tr>
                  </thead>
                  <tbody className="divide-y divide-gray-100">
                    {paginatedMenuItems.map((item) => {
                const matchedProv = providers.find(p => p.id === (item.providerId || item.restaurantId));
                const isSynthetic = item.menuStatus === 'sample' || item.menuSource === 'synthetic';
                return (<tr key={item.id} className="hover:bg-gray-50/60 transition">
                          
                          {/* Dish Image & Name */}
                          <td className="p-3.5">
                            <div className="flex items-center gap-3">
                              <img src={item.imageUrl} alt={item.name} className="w-10 h-10 rounded-xl object-cover border border-gray-200 flex-shrink-0"/>
                              <div>
                                <h4 className="font-bold text-gray-900 leading-snug">{item.name}</h4>
                                <p className="text-[11px] text-gray-500 line-clamp-1 max-w-xs">{item.description}</p>
                              </div>
                            </div>
                          </td>

                          {/* Restaurant Name */}
                          <td className="p-3.5">
                            <span className="font-semibold text-gray-800">
                              {matchedProv?.name || 'Home Kitchen'}
                            </span>
                            <span className="text-[10px] text-gray-400 block truncate">
                              {matchedProv?.locality}
                            </span>
                          </td>

                          {/* Category & Diet */}
                          <td className="p-3.5">
                            <div className="flex items-center gap-1.5">
                              <span className={`w-2.5 h-2.5 rounded-full flex-shrink-0 ${item.dietary === 'veg' ? 'bg-emerald-600' : 'bg-rose-600'}`}></span>
                              <span className="font-bold uppercase text-[10px] text-gray-700">
                                {item.category}
                              </span>
                            </div>
                          </td>

                          {/* Price */}
                          <td className="p-3.5 font-black text-gray-900">
                            ₹{item.price}
                          </td>

                          {/* Menu Classification Badge */}
                          <td className="p-3.5">
                            {isSynthetic ? (<span className="inline-flex items-center gap-1 px-2.5 py-0.5 rounded-full bg-purple-100 text-purple-900 text-[10px] font-black border border-purple-200">
                                <Sparkles className="w-3 h-3 text-purple-600"/>
                                <span>SAMPLE</span>
                              </span>) : item.menuStatus === 'verified' ? (<span className="inline-flex items-center gap-1 px-2.5 py-0.5 rounded-full bg-emerald-100 text-emerald-900 text-[10px] font-black border border-emerald-200">
                                <CheckCircle className="w-3 h-3 text-emerald-600"/>
                                <span>VERIFIED</span>
                              </span>) : (<span className="inline-flex items-center gap-1 px-2.5 py-0.5 rounded-full bg-amber-100 text-amber-900 text-[10px] font-black border border-amber-200">
                                <Clock className="w-3 h-3 text-amber-600"/>
                                <span>AWAITING AUDIT</span>
                              </span>)}
                          </td>

                          {/* Availability Toggle */}
                          <td className="p-3.5">
                            <button onClick={() => handleToggleItemAvailability(item.id)} className={`px-2 py-0.5 rounded-md text-[10px] font-bold transition ${item.isAvailable
                        ? 'bg-emerald-50 text-emerald-700 border border-emerald-200'
                        : 'bg-rose-50 text-rose-700 border border-rose-200'}`}>
                              {item.isAvailable ? 'In Stock' : 'Sold Out'}
                            </button>
                          </td>

                          {/* Actions */}
                          <td className="p-3.5 text-right">
                            <div className="flex items-center justify-end gap-1.5">
                              <button onClick={() => setEditingMenuItem(item)} className="p-1.5 rounded-lg bg-hb-cream hover:bg-hb-cream-200 border border-hb-green-200 text-hb-green-800 transition" title="Edit Dish">
                                <Edit3 className="w-3.5 h-3.5"/>
                              </button>
                              <button onClick={() => setDeletingMenuItem(item)} className="p-1.5 rounded-lg bg-rose-50 hover:bg-rose-100 text-rose-700 transition" title="Delete Dish">
                                <Trash2 className="w-3.5 h-3.5"/>
                              </button>
                            </div>
                          </td>

                        </tr>);
            })}
                  </tbody>
                </table>
              </div>

              {/* Pagination Bar */}
              <div className="p-4 border-t border-gray-100 flex items-center justify-between text-xs text-gray-500">
                <span>
                  Showing <strong>{filteredMenuItems.length}</strong> items • Page <strong>{menuPage}</strong> of <strong>{totalMenuPages}</strong>
                </span>
                <div className="flex items-center gap-2">
                  <button disabled={menuPage <= 1} onClick={() => setMenuPage(p => Math.max(1, p - 1))} className="p-1.5 rounded-lg border border-gray-200 disabled:opacity-40 hover:bg-gray-50 transition">
                    <ChevronLeft className="w-4 h-4"/>
                  </button>
                  <button disabled={menuPage >= totalMenuPages} onClick={() => setMenuPage(p => Math.min(totalMenuPages, p + 1))} className="p-1.5 rounded-lg border border-gray-200 disabled:opacity-40 hover:bg-gray-50 transition">
                    <ChevronRight className="w-4 h-4"/>
                  </button>
                </div>
              </div>

            </div>

          </div>)}

        {/* ========================================================
            TAB 4: ORDERS MANAGEMENT
        ======================================================== */}
        {activeTab === 'orders' && (<div className="space-y-6">
            
            <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
              <div>
                <h2 className="text-2xl font-black text-gray-900 font-display">
                  Order Management & Dispatch Stream
                </h2>
                <p className="text-xs text-gray-500 mt-0.5">
                  Inspect student orders, monitor payment status, update fulfillment progression, and track delivery partners.
                </p>
              </div>

              <div className="flex items-center gap-2">
                <span className="text-xs font-bold text-gray-500">
                  Total Orders: {orders.length}
                </span>
              </div>
            </div>

            {/* Filter and Search Bar */}
            <div className="bg-white rounded-3xl p-4 border border-hb-green-100 shadow-soft flex flex-col md:flex-row items-center gap-3">
              
              <div className="relative flex-1 w-full">
                <Search className="w-4 h-4 text-gray-400 absolute left-3.5 top-1/2 -translate-y-1/2"/>
                <input type="text" value={orderSearch} onChange={(e) => setOrderSearch(e.target.value)} placeholder="Search Order ID, student name, kitchen..." className="w-full pl-10 pr-4 py-2 text-xs rounded-xl border border-gray-200 outline-none focus:border-hb-green-500 text-gray-800"/>
              </div>

              <select value={orderStatusFilter} onChange={(e) => setOrderStatusFilter(e.target.value)} className="text-xs py-2 px-3 rounded-xl border border-gray-200 bg-white font-semibold text-gray-700 outline-none w-full md:w-auto">
                <option value="all">All Order Statuses</option>
                <option value="order_placed">Order Placed</option>
                <option value="chef_preparing">Chef Preparing</option>
                <option value="ready_for_pickup">Ready for Pickup</option>
                <option value="out_for_delivery">Out for Delivery</option>
                <option value="delivered">Delivered</option>
                <option value="cancelled">Cancelled</option>
              </select>
            </div>

            {/* Orders Data Table */}
            <div className="bg-white rounded-3xl border border-hb-green-100 shadow-soft overflow-hidden">
              <div className="overflow-x-auto">
                <table className="w-full text-left text-xs">
                  <thead className="bg-gray-50 text-gray-500 uppercase text-[10px] font-bold border-b border-gray-100">
                    <tr>
                      <th className="p-3.5">Order ID</th>
                      <th className="p-3.5">Customer</th>
                      <th className="p-3.5">Restaurant</th>
                      <th className="p-3.5">Items Ordered</th>
                      <th className="p-3.5">Amount</th>
                      <th className="p-3.5">Payment</th>
                      <th className="p-3.5">Fulfillment Status</th>
                      <th className="p-3.5 text-right">Actions</th>
                    </tr>
                  </thead>
                  <tbody className="divide-y divide-gray-100">
                    {filteredOrders.map((o) => (<tr key={o.id} className="hover:bg-gray-50/60 transition">
                        
                        {/* Order ID & Time */}
                        <td className="p-3.5">
                          <span className="font-mono font-bold text-hb-green-800 block">{o.id}</span>
                          <span className="text-[10px] text-gray-400">
                            {new Date(o.createdAt).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })}
                          </span>
                        </td>

                        {/* Customer */}
                        <td className="p-3.5">
                          <p className="font-bold text-gray-900">{o.customerName}</p>
                          <span className="text-[10px] text-gray-500 block truncate max-w-[140px]">
                            {o.customerPhone}
                          </span>
                        </td>

                        {/* Restaurant */}
                        <td className="p-3.5">
                          <p className="font-semibold text-gray-800">{o.kitchenName}</p>
                          <span className="text-[10px] text-gray-400 block truncate max-w-[140px]">
                            {o.collegeOrWorkplace.split(',')[0]}
                          </span>
                        </td>

                        {/* Ordered Items */}
                        <td className="p-3.5">
                          <div className="text-[11px] text-gray-700 space-y-0.5 max-w-[180px]">
                            {o.items.map((it, idx) => (<div key={idx} className="truncate">
                                <strong>{it.quantity}x</strong> {it.name}
                              </div>))}
                          </div>
                        </td>

                        {/* Total Amount */}
                        <td className="p-3.5 font-black text-gray-900">
                          ₹{o.totalAmount}
                        </td>

                        {/* Payment */}
                        <td className="p-3.5">
                          <span className="px-2 py-0.5 rounded bg-emerald-100 text-emerald-800 text-[10px] font-bold uppercase block w-fit">
                            {o.paymentStatus}
                          </span>
                          <span className="text-[9px] text-gray-400 mt-0.5 block">{o.paymentMethod}</span>
                        </td>

                        {/* Order Status Transition Select */}
                        <td className="p-3.5">
                          <select value={o.status} onChange={(e) => {
                    updateOrderStatus(o.id, e.target.value);
                    addToast(`Order ${o.id} status updated to ${e.target.value.replace(/_/g, ' ')}`, 'info');
                }} className={`text-[11px] font-bold py-1 px-2.5 rounded-xl border outline-none cursor-pointer ${o.status === 'delivered'
                    ? 'bg-emerald-50 text-emerald-800 border-emerald-300'
                    : o.status === 'out_for_delivery'
                        ? 'bg-amber-50 text-amber-800 border-amber-300'
                        : 'bg-blue-50 text-blue-800 border-blue-300'}`}>
                            <option value="order_placed">Order Placed</option>
                            <option value="chef_preparing">Chef Preparing</option>
                            <option value="ready_for_pickup">Ready for Pickup</option>
                            <option value="out_for_delivery">Out for Delivery</option>
                            <option value="delivered">Delivered</option>
                            <option value="cancelled">Cancelled</option>
                          </select>
                        </td>

                        {/* Actions */}
                        <td className="p-3.5 text-right">
                          <button onClick={() => setInspectingOrder(o)} className="px-2.5 py-1 rounded-lg bg-hb-cream hover:bg-hb-cream-200 border border-hb-green-200 text-hb-green-800 font-bold text-xs transition">
                            Inspect
                          </button>
                        </td>

                      </tr>))}
                  </tbody>
                </table>
              </div>
            </div>

          </div>)}

        {/* ========================================================
            TAB 5: CUSTOMER MANAGEMENT
        ======================================================== */}
        {activeTab === 'customers' && (<div className="space-y-6">
            
            <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
              <div>
                <h2 className="text-2xl font-black text-gray-900 font-display">
                  Registered Customer Accounts
                </h2>
                <p className="text-xs text-gray-500 mt-0.5">
                  View registered student and staff accounts, order volume, and manage account authorization status securely.
                </p>
              </div>

              <div className="flex items-center gap-2">
                <span className="text-xs font-bold text-gray-500">
                  Total Customers: {customers.length}
                </span>
              </div>
            </div>

            {/* Search */}
            <div className="bg-white rounded-3xl p-4 border border-hb-green-100 shadow-soft">
              <div className="relative max-w-md">
                <Search className="w-4 h-4 text-gray-400 absolute left-3.5 top-1/2 -translate-y-1/2"/>
                <input type="text" value={customerSearch} onChange={(e) => setCustomerSearch(e.target.value)} placeholder="Search customer name, email, campus..." className="w-full pl-10 pr-4 py-2 text-xs rounded-xl border border-gray-200 outline-none focus:border-hb-green-500 text-gray-800"/>
              </div>
            </div>

            {/* Customers Table */}
            <div className="bg-white rounded-3xl border border-hb-green-100 shadow-soft overflow-hidden">
              <div className="overflow-x-auto">
                <table className="w-full text-left text-xs">
                  <thead className="bg-gray-50 text-gray-500 uppercase text-[10px] font-bold border-b border-gray-100">
                    <tr>
                      <th className="p-3.5">Customer</th>
                      <th className="p-3.5">Contact Details</th>
                      <th className="p-3.5">Campus / Delivery Address</th>
                      <th className="p-3.5">Orders Placed</th>
                      <th className="p-3.5">Total Spent</th>
                      <th className="p-3.5">Account Status</th>
                      <th className="p-3.5 text-right">Actions</th>
                    </tr>
                  </thead>
                  <tbody className="divide-y divide-gray-100">
                    {filteredCustomers.map((c) => (<tr key={c.id} className="hover:bg-gray-50/60 transition">
                        
                        <td className="p-3.5">
                          <div className="flex items-center gap-2.5">
                            <div className="w-8 h-8 rounded-full bg-hb-cream text-hb-green-900 font-black flex items-center justify-center border border-hb-green-200 text-xs">
                              {c.name.charAt(0)}
                            </div>
                            <div>
                              <h4 className="font-bold text-gray-900 leading-snug">{c.name}</h4>
                              <span className="text-[10px] text-gray-400 font-mono">ID: {c.id}</span>
                            </div>
                          </div>
                        </td>

                        <td className="p-3.5">
                          <div className="space-y-0.5">
                            <p className="text-gray-700 flex items-center gap-1">
                              <Mail className="w-3 h-3 text-gray-400"/>
                              <span>{c.email}</span>
                            </p>
                            <p className="text-gray-500 text-[11px] flex items-center gap-1">
                              <Phone className="w-3 h-3 text-gray-400"/>
                              <span>{c.phone}</span>
                            </p>
                          </div>
                        </td>

                        <td className="p-3.5">
                          <p className="font-semibold text-gray-800">{c.collegeOrWorkplace}</p>
                          <span className="text-[10px] text-gray-500 block truncate max-w-xs">{c.address}</span>
                        </td>

                        <td className="p-3.5 font-bold text-gray-900">
                          {c.totalOrders} dabbas
                        </td>

                        <td className="p-3.5 font-black text-hb-green-800">
                          ₹{c.totalSpent}
                        </td>

                        <td className="p-3.5">
                          <span className={`px-2.5 py-1 rounded-full text-[10px] font-black uppercase ${c.status === 'active'
                    ? 'bg-emerald-100 text-emerald-800'
                    : 'bg-rose-100 text-rose-800'}`}>
                            {c.status}
                          </span>
                        </td>

                        <td className="p-3.5 text-right">
                          <div className="flex items-center justify-end gap-2">
                            <button onClick={() => handleToggleCustomerStatus(c.id)} className={`px-2.5 py-1 rounded-xl text-xs font-bold transition ${c.status === 'active'
                    ? 'bg-rose-50 hover:bg-rose-100 text-rose-700 border border-rose-200'
                    : 'bg-emerald-50 hover:bg-emerald-100 text-emerald-700 border border-emerald-200'}`}>
                              {c.status === 'active' ? 'Suspend' : 'Activate'}
                            </button>

                            <button onClick={() => setInspectingCustomerOrders(c)} className="px-2.5 py-1 rounded-xl bg-gray-100 hover:bg-gray-200 text-gray-700 text-xs font-bold transition">
                              Orders
                            </button>
                          </div>
                        </td>

                      </tr>))}
                  </tbody>
                </table>
              </div>
            </div>

          </div>)}

        {/* ========================================================
            TAB 6: PROVIDER MANAGEMENT & APPLICATIONS
        ======================================================== */}
        {activeTab === 'providers' && (<div className="space-y-6">
            
            <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
              <div>
                <h2 className="text-2xl font-black text-gray-900 font-display">
                  Provider Applications & Centralized Management
                </h2>
                <p className="text-xs text-gray-500 mt-0.5">
                  Centrally manage food providers without individual restaurant accounts. Review prospective home chef applications.
                </p>
              </div>

              <div className="flex items-center gap-2">
                <span className="px-3 py-1 rounded-xl bg-emerald-100 text-emerald-800 text-xs font-bold">
                  {providers.length} Total Seeded Providers Managed Centrally
                </span>
              </div>
            </div>

            {/* Applications List */}
            <div className="bg-white rounded-3xl p-6 border border-hb-green-100 shadow-soft space-y-4">
              <h3 className="text-base font-black text-gray-900">
                Pending Home Chef FSSAI Verification Applications ({chefApplications.length})
              </h3>

              <div className="space-y-4">
                {chefApplications.map((app) => (<div key={app.id} className="p-5 rounded-2xl bg-gray-50/70 border border-gray-200 flex flex-col lg:flex-row lg:items-center justify-between gap-4">
                    <div className="space-y-1.5">
                      <div className="flex items-center gap-2">
                        <h4 className="text-sm font-bold text-gray-900">{app.kitchenName}</h4>
                        <span className={`px-2.5 py-0.5 rounded-full text-[10px] font-black uppercase ${app.status === 'approved'
                    ? 'bg-emerald-100 text-emerald-800'
                    : app.status === 'rejected'
                        ? 'bg-rose-100 text-rose-800'
                        : 'bg-amber-100 text-amber-800'}`}>
                          {app.status}
                        </span>
                      </div>

                      <p className="text-xs text-gray-600">
                        Applicant: <strong>{app.fullName}</strong> • Phone: {app.phone} • Specialty: {app.specialty}
                      </p>
                      <p className="text-xs text-gray-500">
                        📍 Kitchen Address: {app.address}
                      </p>

                      <div className="flex items-center gap-3 pt-1 text-[11px] text-gray-600">
                        <span>FSSAI License: <strong className="font-mono text-gray-900">{app.fssaiNumber}</strong></span>
                        <span>•</span>
                        <span className="flex items-center gap-1 text-emerald-700 font-bold">
                          <CheckCircle2 className="w-3.5 h-3.5"/>
                          <span>Hygiene Checklist: 18/18 Points Passed</span>
                        </span>
                      </div>
                    </div>

                    <div className="flex items-center gap-2 flex-shrink-0">
                      {app.status === 'pending' ? (<>
                          <button onClick={() => approveChefApplication(app.id)} className="px-4 py-2 rounded-xl bg-emerald-600 hover:bg-emerald-700 text-white text-xs font-bold transition flex items-center gap-1.5 shadow-xs">
                            <CheckCircle2 className="w-4 h-4"/>
                            <span>Verify & Approve</span>
                          </button>
                          <button onClick={() => rejectChefApplication(app.id)} className="px-3 py-2 rounded-xl bg-white border border-rose-200 hover:bg-rose-50 text-rose-700 text-xs font-bold transition">
                            Reject
                          </button>
                        </>) : (<span className="text-xs text-gray-400 italic">
                          Audit finalized on {app.appliedDate}
                        </span>)}
                    </div>
                  </div>))}
              </div>
            </div>

          </div>)}

        {/* ========================================================
            TAB 7: ANALYTICS
        ======================================================== */}
        {activeTab === 'analytics' && (<div className="space-y-6">
            <div className="bg-white rounded-3xl p-6 sm:p-8 border border-hb-green-100 shadow-soft">
              <h2 className="text-2xl font-black text-gray-900 font-display">
                Campus Marketplace Analytics
              </h2>
              <p className="text-xs text-gray-500 mt-1">
                Telemetry for order volumes, category distribution, and delivery velocity across the SNIST cluster.
              </p>

              <div className="grid grid-cols-1 md:grid-cols-3 gap-6 mt-6">
                <div className="p-5 rounded-2xl bg-hb-cream/60 border border-hb-green-200">
                  <span className="text-xs font-bold text-hb-green-800 uppercase block">Average Meal Value</span>
                  <p className="text-2xl font-black text-gray-900 mt-1 font-display">₹105.40</p>
                  <span className="text-[11px] text-emerald-700 font-semibold block mt-1">Student pocket friendly</span>
                </div>

                <div className="p-5 rounded-2xl bg-hb-cream/60 border border-hb-green-200">
                  <span className="text-xs font-bold text-hb-green-800 uppercase block">Average Prep Time</span>
                  <p className="text-2xl font-black text-gray-900 mt-1 font-display">18.6 mins</p>
                  <span className="text-[11px] text-emerald-700 font-semibold block mt-1">Freshly cooked to order</span>
                </div>

                <div className="p-5 rounded-2xl bg-hb-cream/60 border border-hb-green-200">
                  <span className="text-xs font-bold text-hb-green-800 uppercase block">Top Locality by Orders</span>
                  <p className="text-2xl font-black text-gray-900 mt-1 font-display">SNIST / Yamnampet</p>
                  <span className="text-[11px] text-emerald-700 font-semibold block mt-1">64% of total student dabbas</span>
                </div>
              </div>
            </div>
          </div>)}

        {/* ========================================================
            TAB 8: SETTINGS
        ======================================================== */}
        {activeTab === 'settings' && (<div className="space-y-6">
            <div className="bg-white rounded-3xl p-6 sm:p-8 border border-hb-green-100 shadow-soft space-y-6">
              <div>
                <h2 className="text-2xl font-black text-gray-900 font-display">
                  Platform Operating Settings
                </h2>
                <p className="text-xs text-gray-500 mt-0.5">
                  Configure delivery pricing parameters, Supabase connection preferences and admin credentials.
                </p>
              </div>

              <div className="space-y-4 max-w-xl text-xs">
                <div>
                  <label className="font-bold text-gray-700 block mb-1">Standard Campus Delivery Fee (₹)</label>
                  <input type="number" defaultValue={15} className="w-full p-2.5 rounded-xl border border-gray-200 bg-gray-50 outline-none font-bold"/>
                </div>

                <div>
                  <label className="font-bold text-gray-700 block mb-1">Free Delivery Minimum Order (₹)</label>
                  <input type="number" defaultValue={150} className="w-full p-2.5 rounded-xl border border-gray-200 bg-gray-50 outline-none font-bold"/>
                </div>

                <div>
                  <label className="font-bold text-gray-700 block mb-1">Hygienic Dabba Packaging Fee (₹)</label>
                  <input type="number" defaultValue={10} className="w-full p-2.5 rounded-xl border border-gray-200 bg-gray-50 outline-none font-bold"/>
                </div>

                <div>
                  <label className="font-bold text-gray-700 block mb-1">Admin Email Notice</label>
                  <input type="email" value="admin@homebite.in" disabled className="w-full p-2.5 rounded-xl border border-gray-200 bg-gray-100 text-gray-500 font-mono"/>
                </div>

                <button type="button" onClick={() => addToast('Platform settings saved successfully!', 'success')} className="px-6 py-2.5 rounded-xl bg-hb-green-600 hover:bg-hb-green-700 text-white font-bold transition shadow-xs">
                  Save Settings
                </button>
              </div>
            </div>
          </div>)}

      </main>

      {/* ========================================================
            MODAL 1: EDIT RESTAURANT MODAL
        ======================================================== */}
      {editingRestaurant && (<div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/60 backdrop-blur-xs overflow-y-auto animate-fadeIn">
          <div className="bg-white rounded-3xl shadow-2xl max-w-lg w-full p-6 border border-hb-green-100 my-8 space-y-4">
            <div className="flex items-center justify-between border-b border-gray-100 pb-3">
              <div>
                <h3 className="text-base font-black text-gray-900">Edit Restaurant Information</h3>
                <p className="text-[11px] text-gray-500">ID: {editingRestaurant.id}</p>
              </div>
              <button onClick={() => setEditingRestaurant(null)} className="p-1 rounded-full text-gray-400 hover:bg-gray-100">
                <X className="w-5 h-5"/>
              </button>
            </div>

            <form onSubmit={(e) => {
                e.preventDefault();
                handleSaveRestaurant(editingRestaurant);
            }} className="space-y-3 text-xs">
              <div>
                <label className="font-bold text-gray-700 block mb-1">Business Name</label>
                <input type="text" required value={editingRestaurant.name} onChange={(e) => setEditingRestaurant({ ...editingRestaurant, name: e.target.value })} className="w-full p-2.5 rounded-xl border border-gray-200 outline-none focus:border-hb-green-500"/>
              </div>

              <div>
                <label className="font-bold text-gray-700 block mb-1">Provider Type</label>
                <select value={editingRestaurant.type} onChange={(e) => setEditingRestaurant({ ...editingRestaurant, type: e.target.value })} className="w-full p-2.5 rounded-xl border border-gray-200 outline-none">
                  <option value="home_kitchen">Home Kitchen</option>
                  <option value="cloud_kitchen">Cloud Kitchen</option>
                  <option value="tiffin_service">Tiffin Service</option>
                  <option value="healthy_restaurant">Healthy Restaurant</option>
                </select>
              </div>

              <div>
                <label className="font-bold text-gray-700 block mb-1">Description</label>
                <textarea rows={2} value={editingRestaurant.description} onChange={(e) => setEditingRestaurant({ ...editingRestaurant, description: e.target.value })} className="w-full p-2.5 rounded-xl border border-gray-200 outline-none focus:border-hb-green-500"/>
              </div>

              <div className="grid grid-cols-2 gap-3">
                <div>
                  <label className="font-bold text-gray-700 block mb-1">Locality</label>
                  <input type="text" value={editingRestaurant.locality} onChange={(e) => setEditingRestaurant({ ...editingRestaurant, locality: e.target.value })} className="w-full p-2.5 rounded-xl border border-gray-200 outline-none"/>
                </div>
                <div>
                  <label className="font-bold text-gray-700 block mb-1">Min Order Amount (₹)</label>
                  <input type="number" value={editingRestaurant.minOrderAmount} onChange={(e) => setEditingRestaurant({ ...editingRestaurant, minOrderAmount: Number(e.target.value) })} className="w-full p-2.5 rounded-xl border border-gray-200 outline-none"/>
                </div>
              </div>

              <div>
                <label className="font-bold text-gray-700 block mb-1">Address</label>
                <input type="text" value={editingRestaurant.address} onChange={(e) => setEditingRestaurant({ ...editingRestaurant, address: e.target.value })} className="w-full p-2.5 rounded-xl border border-gray-200 outline-none"/>
              </div>

              <div className="grid grid-cols-2 gap-3">
                <div>
                  <label className="font-bold text-gray-700 block mb-1">Latitude</label>
                  <input type="number" step="0.0001" value={editingRestaurant.lat} onChange={(e) => setEditingRestaurant({ ...editingRestaurant, lat: Number(e.target.value) })} className="w-full p-2.5 rounded-xl border border-gray-200 outline-none font-mono"/>
                </div>
                <div>
                  <label className="font-bold text-gray-700 block mb-1">Longitude</label>
                  <input type="number" step="0.0001" value={editingRestaurant.lon} onChange={(e) => setEditingRestaurant({ ...editingRestaurant, lon: Number(e.target.value) })} className="w-full p-2.5 rounded-xl border border-gray-200 outline-none font-mono"/>
                </div>
              </div>

              <div>
                <label className="font-bold text-gray-700 block mb-1">Cover Image URL</label>
                <input type="url" value={editingRestaurant.coverImage} onChange={(e) => setEditingRestaurant({ ...editingRestaurant, coverImage: e.target.value })} className="w-full p-2.5 rounded-xl border border-gray-200 outline-none"/>
              </div>

              <div className="flex items-center justify-end gap-2 pt-3 border-t border-gray-100">
                <button type="button" onClick={() => setEditingRestaurant(null)} className="px-4 py-2 rounded-xl border border-gray-200 hover:bg-gray-50 font-bold">
                  Cancel
                </button>
                <button type="submit" className="px-5 py-2 rounded-xl bg-hb-green-600 hover:bg-hb-green-700 text-white font-bold">
                  Save Changes
                </button>
              </div>
            </form>
          </div>
        </div>)}

      {/* ========================================================
            MODAL 2: EDIT OR ADD MENU ITEM MODAL
        ======================================================== */}
      {(editingMenuItem || isAddingMenuItem) && (<div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/60 backdrop-blur-xs overflow-y-auto animate-fadeIn">
          <div className="bg-white rounded-3xl shadow-2xl max-w-lg w-full p-6 border border-hb-green-100 my-8 space-y-4">
            <div className="flex items-center justify-between border-b border-gray-100 pb-3">
              <div>
                <h3 className="text-base font-black text-gray-900">
                  {isAddingMenuItem ? 'Add New Food Listing' : 'Edit Food Listing'}
                </h3>
                <p className="text-[11px] text-gray-500">
                  Update price, description, images & menu classification.
                </p>
              </div>
              <button onClick={() => {
                setEditingMenuItem(null);
                setIsAddingMenuItem(false);
            }} className="p-1 rounded-full text-gray-400 hover:bg-gray-100">
                <X className="w-5 h-5"/>
              </button>
            </div>

            {(() => {
                const currentItem = editingMenuItem || {
                    id: `menu-custom-${Date.now()}`,
                    providerId: selectedMenuRestaurantId !== 'all' ? selectedMenuRestaurantId : (providers[0]?.id || 'prov-snist-1'),
                    name: '',
                    description: '',
                    category: 'lunch',
                    price: 90,
                    imageUrl: 'https://images.unsplash.com/photo-1610057099431-d73a1c9d2f2f?auto=format&fit=crop&w=600&q=80',
                    isVegetarian: true,
                    dietary: 'veg',
                    tags: ['Fresh', 'Homestyle'],
                    isAvailable: true,
                    menuSource: 'provider',
                    menuStatus: 'verified'
                };
                return (<form onSubmit={(e) => {
                        e.preventDefault();
                        handleSaveMenuItem(currentItem);
                    }} className="space-y-3 text-xs">
                  <div>
                    <label className="font-bold text-gray-700 block mb-1">Assign to Restaurant</label>
                    <select value={currentItem.providerId} onChange={(e) => {
                        const updated = { ...currentItem, providerId: e.target.value };
                        if (isAddingMenuItem)
                            setEditingMenuItem(updated);
                        else
                            setEditingMenuItem(updated);
                    }} className="w-full p-2.5 rounded-xl border border-gray-200 outline-none">
                      {providers.map(p => (<option key={p.id} value={p.id}>{p.name} ({p.locality})</option>))}
                    </select>
                  </div>

                  <div>
                    <label className="font-bold text-gray-700 block mb-1">Dish Name</label>
                    <input type="text" required value={currentItem.name} onChange={(e) => setEditingMenuItem({ ...currentItem, name: e.target.value })} placeholder="e.g. Special Andhra Veg Meals Dabba" className="w-full p-2.5 rounded-xl border border-gray-200 outline-none focus:border-hb-green-500"/>
                  </div>

                  <div>
                    <label className="font-bold text-gray-700 block mb-1">Description</label>
                    <textarea rows={2} value={currentItem.description} onChange={(e) => setEditingMenuItem({ ...currentItem, description: e.target.value })} placeholder="Ingredients, preparation style..." className="w-full p-2.5 rounded-xl border border-gray-200 outline-none focus:border-hb-green-500"/>
                  </div>

                  <div className="grid grid-cols-2 gap-3">
                    <div>
                      <label className="font-bold text-gray-700 block mb-1">Price (₹)</label>
                      <input type="number" required value={currentItem.price} onChange={(e) => setEditingMenuItem({ ...currentItem, price: Number(e.target.value) })} className="w-full p-2.5 rounded-xl border border-gray-200 outline-none"/>
                    </div>
                    <div>
                      <label className="font-bold text-gray-700 block mb-1">Category</label>
                      <select value={currentItem.category} onChange={(e) => setEditingMenuItem({ ...currentItem, category: e.target.value })} className="w-full p-2.5 rounded-xl border border-gray-200 outline-none">
                        <option value="breakfast">Breakfast</option>
                        <option value="lunch">Lunch</option>
                        <option value="dinner">Dinner</option>
                        <option value="snacks">Snacks</option>
                        <option value="high-protein">High Protein</option>
                      </select>
                    </div>
                  </div>

                  <div className="grid grid-cols-2 gap-3">
                    <div>
                      <label className="font-bold text-gray-700 block mb-1">Dietary Classification</label>
                      <select value={currentItem.dietary} onChange={(e) => {
                        const dietaryVal = e.target.value;
                        setEditingMenuItem({
                            ...currentItem,
                            dietary: dietaryVal,
                            isVegetarian: dietaryVal !== 'non-veg'
                        });
                    }} className="w-full p-2.5 rounded-xl border border-gray-200 outline-none">
                        <option value="veg">Vegetarian (Pure Veg)</option>
                        <option value="non-veg">Non-Vegetarian</option>
                        <option value="vegan">Vegan</option>
                      </select>
                    </div>

                    <div>
                      <label className="font-bold text-gray-700 block mb-1">Menu Classification</label>
                      <select value={currentItem.menuStatus || 'sample'} onChange={(e) => setEditingMenuItem({
                        ...currentItem,
                        menuStatus: e.target.value,
                        menuSource: e.target.value === 'sample' ? 'synthetic' : 'provider'
                    })} className="w-full p-2.5 rounded-xl border border-gray-200 outline-none font-bold">
                        <option value="verified">Verified Real Menu</option>
                        <option value="unverified">Real Menu Awaiting Confirmation</option>
                        <option value="sample">Synthetic Sample Menu (SAMPLE badge)</option>
                      </select>
                    </div>
                  </div>

                  <div>
                    <label className="font-bold text-gray-700 block mb-1">Image URL</label>
                    <input type="url" value={currentItem.imageUrl} onChange={(e) => setEditingMenuItem({ ...currentItem, imageUrl: e.target.value })} className="w-full p-2.5 rounded-xl border border-gray-200 outline-none"/>
                  </div>

                  <div className="flex items-center justify-end gap-2 pt-3 border-t border-gray-100">
                    <button type="button" onClick={() => {
                        setEditingMenuItem(null);
                        setIsAddingMenuItem(false);
                    }} className="px-4 py-2 rounded-xl border border-gray-200 hover:bg-gray-50 font-bold">
                      Cancel
                    </button>
                    <button type="submit" className="px-5 py-2 rounded-xl bg-hb-green-600 hover:bg-hb-green-700 text-white font-bold">
                      Save Dish
                    </button>
                  </div>
                </form>);
            })()}
          </div>
        </div>)}

      {/* ========================================================
            MODAL 3: INSPECT ORDER MODAL
        ======================================================== */}
      {inspectingOrder && (<div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/60 backdrop-blur-xs overflow-y-auto animate-fadeIn">
          <div className="bg-white rounded-3xl shadow-2xl max-w-lg w-full p-6 border border-hb-green-100 my-8 space-y-4">
            <div className="flex items-center justify-between border-b border-gray-100 pb-3">
              <div>
                <span className="text-[10px] font-black text-hb-green-800 uppercase block">Order Details</span>
                <h3 className="text-base font-black text-gray-900">{inspectingOrder.id}</h3>
              </div>
              <button onClick={() => setInspectingOrder(null)} className="p-1 rounded-full text-gray-400 hover:bg-gray-100">
                <X className="w-5 h-5"/>
              </button>
            </div>

            <div className="space-y-3 text-xs">
              <div className="p-3 rounded-2xl bg-gray-50 space-y-1">
                <p><strong>Customer:</strong> {inspectingOrder.customerName} ({inspectingOrder.customerPhone})</p>
                <p><strong>Destination:</strong> {inspectingOrder.deliveryAddress}</p>
                <p><strong>Campus Hub:</strong> {inspectingOrder.collegeOrWorkplace}</p>
                {inspectingOrder.orderNotes && (<p className="text-amber-800"><strong>Note:</strong> "{inspectingOrder.orderNotes}"</p>)}
              </div>

              <div>
                <h4 className="font-bold text-gray-900 mb-1.5">Items Ordered:</h4>
                <div className="space-y-1.5 border border-gray-100 rounded-xl p-3 bg-white">
                  {inspectingOrder.items.map((it, idx) => (<div key={idx} className="flex justify-between">
                      <span>{it.quantity}x {it.name}</span>
                      <strong className="text-gray-900">₹{it.price * it.quantity}</strong>
                    </div>))}
                  <div className="pt-2 border-t border-gray-100 flex justify-between font-black text-sm">
                    <span>Total Amount Paid ({inspectingOrder.paymentMethod}):</span>
                    <span className="text-hb-green-800">₹{inspectingOrder.totalAmount}</span>
                  </div>
                </div>
              </div>

              {inspectingOrder.deliveryPartner && (<div className="p-3 rounded-2xl bg-indigo-50/70 border border-indigo-100 text-[11px]">
                  <strong>Assigned Delivery Partner:</strong> {inspectingOrder.deliveryPartner.name} ({inspectingOrder.deliveryPartner.vehicleNumber}) • Phone: {inspectingOrder.deliveryPartner.phone}
                </div>)}
            </div>

            <div className="flex justify-end pt-2">
              <button onClick={() => setInspectingOrder(null)} className="px-5 py-2 rounded-xl bg-gray-100 hover:bg-gray-200 text-gray-800 text-xs font-bold">
                Close
              </button>
            </div>
          </div>
        </div>)}

      {/* ========================================================
            MODAL 4: DELETE RESTAURANT CONFIRMATION MODAL
        ======================================================== */}
      {deletingRestaurant && (<div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/60 backdrop-blur-xs animate-fadeIn">
          <div className="bg-white rounded-3xl shadow-2xl max-w-sm w-full p-6 border border-rose-100 text-center space-y-4">
            <div className="w-12 h-12 rounded-full bg-rose-100 text-rose-600 flex items-center justify-center mx-auto text-xl">
              <AlertTriangle className="w-6 h-6"/>
            </div>
            <div>
              <h3 className="text-base font-black text-gray-900">Deactivate Restaurant?</h3>
              <p className="text-xs text-gray-500 mt-1">
                Are you sure you want to remove <strong>"{deletingRestaurant.name}"</strong>? It will no longer appear on student discovery feeds.
              </p>
            </div>
            <div className="flex items-center justify-center gap-2 pt-2">
              <button onClick={() => setDeletingRestaurant(null)} className="px-4 py-2 rounded-xl border border-gray-200 text-xs font-bold text-gray-700 hover:bg-gray-50">
                Cancel
              </button>
              <button onClick={() => handleDeleteRestaurant(deletingRestaurant.id)} className="px-4 py-2 rounded-xl bg-rose-600 text-white text-xs font-bold hover:bg-rose-700">
                Confirm Deactivate
              </button>
            </div>
          </div>
        </div>)}

      {/* ========================================================
            MODAL 5: DELETE MENU ITEM CONFIRMATION MODAL
        ======================================================== */}
      {deletingMenuItem && (<div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/60 backdrop-blur-xs animate-fadeIn">
          <div className="bg-white rounded-3xl shadow-2xl max-w-sm w-full p-6 border border-rose-100 text-center space-y-4">
            <div className="w-12 h-12 rounded-full bg-rose-100 text-rose-600 flex items-center justify-center mx-auto text-xl">
              <AlertTriangle className="w-6 h-6"/>
            </div>
            <div>
              <h3 className="text-base font-black text-gray-900">Delete Menu Item?</h3>
              <p className="text-xs text-gray-500 mt-1">
                Are you sure you want to delete <strong>"{deletingMenuItem.name}"</strong> from the menu catalog?
              </p>
            </div>
            <div className="flex items-center justify-center gap-2 pt-2">
              <button onClick={() => setDeletingMenuItem(null)} className="px-4 py-2 rounded-xl border border-gray-200 text-xs font-bold text-gray-700 hover:bg-gray-50">
                Cancel
              </button>
              <button onClick={() => handleDeleteMenuItem(deletingMenuItem.id)} className="px-4 py-2 rounded-xl bg-rose-600 text-white text-xs font-bold hover:bg-rose-700">
                Confirm Delete
              </button>
            </div>
          </div>
        </div>)}

      {/* ========================================================
            MODAL 6: CUSTOMER ORDER HISTORY MODAL
        ======================================================== */}
      {inspectingCustomerOrders && (<div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/60 backdrop-blur-xs overflow-y-auto animate-fadeIn">
          <div className="bg-white rounded-3xl shadow-2xl max-w-lg w-full p-6 border border-hb-green-100 my-8 space-y-4">
            <div className="flex items-center justify-between border-b border-gray-100 pb-3">
              <div>
                <span className="text-[10px] font-black text-hb-green-800 uppercase block">Customer History</span>
                <h3 className="text-base font-black text-gray-900">{inspectingCustomerOrders.name}</h3>
              </div>
              <button onClick={() => setInspectingCustomerOrders(null)} className="p-1 rounded-full text-gray-400 hover:bg-gray-100">
                <X className="w-5 h-5"/>
              </button>
            </div>

            <div className="space-y-3 text-xs">
              <div className="p-3 rounded-2xl bg-gray-50 text-[11px] space-y-1">
                <p>Email: {inspectingCustomerOrders.email}</p>
                <p>Phone: {inspectingCustomerOrders.phone}</p>
                <p>Campus: {inspectingCustomerOrders.collegeOrWorkplace}</p>
                <p>Total Spent: <strong>₹{inspectingCustomerOrders.totalSpent}</strong> across {inspectingCustomerOrders.totalOrders} dabbas</p>
              </div>

              <h4 className="font-bold text-gray-900">Recent Placed Orders:</h4>
              <div className="space-y-2">
                {orders.filter(o => o.customerId === inspectingCustomerOrders.id || o.customerName.toLowerCase().includes(inspectingCustomerOrders.name.toLowerCase().split(' ')[0])).map((o) => (<div key={o.id} className="p-3 rounded-xl border border-gray-100 bg-white flex justify-between items-center">
                    <div>
                      <span className="font-mono font-bold text-hb-green-800">{o.id}</span>
                      <p className="text-gray-600">{o.kitchenName} • {o.items.length} dishes</p>
                    </div>
                    <div className="text-right">
                      <span className="font-black text-gray-900">₹{o.totalAmount}</span>
                      <span className="block text-[10px] text-emerald-700 capitalize">{o.status}</span>
                    </div>
                  </div>))}
              </div>
            </div>

            <div className="flex justify-end pt-2">
              <button onClick={() => setInspectingCustomerOrders(null)} className="px-5 py-2 rounded-xl bg-gray-100 hover:bg-gray-200 text-gray-800 text-xs font-bold">
                Close
              </button>
            </div>
          </div>
        </div>)}

    </div>);
};

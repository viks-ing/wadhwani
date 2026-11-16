import React, { createContext, useContext, useState, useEffect, useCallback } from 'react';
import { 
  Meal, 
  UserProfile, 
  UserRole, 
  CartItem, 
  Order, 
  OrderStatus, 
  SubscriptionPlan,
  ChefApplication 
} from '../types';
import { 
  DEMO_USERS, 
  DEMO_CREDENTIALS,
  INITIAL_MEALS, 
  INITIAL_ORDERS, 
  INITIAL_CHEF_APPLICATIONS,
  CAMPUS_LOCATIONS,
  CHEF_LOCATIONS
} from '../data/mockData';
import { 
  localDb, 
  supabase, 
  isSupabaseConfigured, 
  broadcastRealtimeEvent 
} from '../lib/supabase';
import {
  LatLon,
  haversineKm,
  reverseGeocode,
  reverseGeocodeDetails,
  fetchNutritionFromOFF,
  getCurrentPosition,
  calculateChefDistance,
} from '../lib/geoService';
import { generateRealtimeLocationMeals } from '../lib/realtimeFeedService';
import confetti from 'canvas-confetti';

interface ToastNotification {
  id: string;
  message: string;
  type: 'success' | 'info' | 'warning' | 'error';
}

export type ActiveViewType = 'landing' | 'customer' | 'chef' | 'delivery' | 'admin' | 'tracking' | 'subscriptions';

interface AppContextType {
  // Authentication & Session
  isAuthenticated: boolean;
  currentUser: UserProfile;
  currentRole: UserRole;
  isAuthModalOpen: boolean;
  setIsAuthModalOpen: (open: boolean) => void;
  authMode: 'login' | 'register';
  setAuthMode: (mode: 'login' | 'register') => void;
  openLoginModal: () => void;
  openRegisterModal: () => void;
  login: (email: string, password?: string) => Promise<void>;
  loginAsSandbox: (role: UserRole) => Promise<void>;
  register: (details: {
    email: string;
    password: string;
    fullName: string;
    phone: string;
    role: 'customer' | 'chef' | 'delivery';
    collegeOrWorkplace?: string;
    kitchenName?: string;
    specialty?: string;
    vehicleNumber?: string;
  }) => Promise<void>;
  logout: () => void;
  requestPasswordReset: (email: string) => Promise<void>;
  updateUserProfile: (profile: Partial<UserProfile>) => void;
  
  // Realtime Supabase
  isSupabaseConfigOpen: boolean;
  setIsSupabaseConfigOpen: (open: boolean) => void;
  isRealtimeConnected: boolean;
  realtimeMessagesCount: number;

  // Navigation & View
  activeView: ActiveViewType;
  setActiveView: (view: ActiveViewType) => void;
  navigateToView: (view: ActiveViewType) => void;
  currentCampus: string;
  setCurrentCampus: (campus: string) => void;
  userCoords: LatLon | null;
  detectAndSetLocation: () => Promise<void>;
  isLocating: boolean;
  
  // Meals & Browse
  meals: Meal[];
  addMeal: (mealData: Omit<Meal, 'id'>) => void;
  updateMeal: (meal: Meal) => void;
  deleteMeal: (mealId: string) => void;
  toggleMealAvailability: (mealId: string) => void;
  selectedMealForDetails: Meal | null;
  setSelectedMealForDetails: (meal: Meal | null) => void;
  
  // Cart
  cart: CartItem[];
  addToCart: (meal: Meal, quantity?: number) => void;
  updateCartQuantity: (mealId: string, quantity: number) => void;
  removeFromCart: (mealId: string) => void;
  clearCart: () => void;
  cartTotal: number;
  cartItemCount: number;
  isCartOpen: boolean;
  setIsCartOpen: (open: boolean) => void;
  isCheckoutOpen: boolean;
  setIsCheckoutOpen: (open: boolean) => void;
  
  // Orders
  orders: Order[];
  activeOrder: Order | null;
  setActiveOrder: (order: Order | null) => void;
  placeOrder: (details: {
    deliveryAddress: string;
    paymentMethod: any;
    orderNotes?: string;
  }) => Promise<Order>;
  updateOrderStatus: (orderId: string, status: OrderStatus) => void;
  
  // Subscriptions
  userSubscriptions: string[];
  subscribeToPlan: (plan: SubscriptionPlan) => void;
  
  // Admin & Chef Approvals
  chefApplications: ChefApplication[];
  approveChefApplication: (id: string) => void;
  rejectChefApplication: (id: string) => void;
  
  // Toasts
  toasts: ToastNotification[];
  addToast: (message: string, type?: 'success' | 'info' | 'warning' | 'error') => void;
  removeToast: (id: string) => void;
}

const AppContext = createContext<AppContextType | undefined>(undefined);

export const AppProvider: React.FC<{ children: React.ReactNode }> = ({ children }) => {
  // Session State - Persistent
  const [isAuthenticated, setIsAuthenticated] = useState<boolean>(() => localDb.get('is_authenticated', false));
  const [currentRole, setCurrentRole] = useState<UserRole>(() => localDb.get('current_role', 'customer'));
  const [currentUser, setCurrentUser] = useState<UserProfile>(() => localDb.get('current_user', DEMO_USERS.customer));
  
  // Auth Modal State
  const [isAuthModalOpen, setIsAuthModalOpen] = useState(false);
  const [authMode, setAuthMode] = useState<'login' | 'register'>('login');

  // Supabase Realtime State
  const [isSupabaseConfigOpen, setIsSupabaseConfigOpen] = useState(false);
  const [isRealtimeConnected, setIsRealtimeConnected] = useState(true);
  const [realtimeMessagesCount, setRealtimeMessagesCount] = useState(0);

  // Navigation State
  const [activeView, setActiveView] = useState<ActiveViewType>('landing');
  const [currentCampus, setCurrentCampus] = useState<string>(() => localDb.get('current_campus', ''));
  const [userCoords, setUserCoords] = useState<LatLon | null>(() => localDb.get('user_coords', null));
  const [isLocating, setIsLocating] = useState<boolean>(false);

  // Data Store
  const [meals, setMeals] = useState<Meal[]>(() => localDb.get('meals_list', INITIAL_MEALS));
  const [cart, setCart] = useState<CartItem[]>(() => localDb.get('cart_items', []));
  const [orders, setOrders] = useState<Order[]>(() => localDb.get('orders_list', INITIAL_ORDERS));
  const [chefApplications, setChefApplications] = useState<ChefApplication[]>(() => localDb.get('chef_apps', INITIAL_CHEF_APPLICATIONS));
  const [userSubscriptions, setUserSubscriptions] = useState<string[]>(() => localDb.get('user_subscriptions', ['sub-daily-student']));
  
  const [selectedMealForDetails, setSelectedMealForDetails] = useState<Meal | null>(null);
  const [activeOrder, setActiveOrder] = useState<Order | null>(() => {
    const list = localDb.get<Order[]>('orders_list', INITIAL_ORDERS);
    return list.length > 0 ? list[0] : null;
  });
  
  const [isCartOpen, setIsCartOpen] = useState(false);
  const [isCheckoutOpen, setIsCheckoutOpen] = useState(false);
  const [toasts, setToasts] = useState<ToastNotification[]>([]);

  // Sync state to local storage
  useEffect(() => { localDb.set('is_authenticated', isAuthenticated); }, [isAuthenticated]);
  useEffect(() => { localDb.set('current_role', currentRole); }, [currentRole]);
  useEffect(() => { localDb.set('current_user', currentUser); }, [currentUser]);
  useEffect(() => { localDb.set('meals_list', meals); }, [meals]);
  useEffect(() => { localDb.set('cart_items', cart); }, [cart]);
  useEffect(() => { localDb.set('orders_list', orders); }, [orders]);
  useEffect(() => { localDb.set('chef_apps', chefApplications); }, [chefApplications]);
  useEffect(() => { localDb.set('user_subscriptions', userSubscriptions); }, [userSubscriptions]);
  useEffect(() => { localDb.set('current_campus', currentCampus); }, [currentCampus]);
  useEffect(() => { localDb.set('user_coords', userCoords); }, [userCoords]);

  // Recalculate dynamic meal distances when userCoords changes
  useEffect(() => {
    if (userCoords) {
      setMeals((prevMeals) =>
        prevMeals.map((meal, index) => {
          const chefCoord = CHEF_LOCATIONS[meal.chefId];
          const dist = calculateChefDistance(userCoords, chefCoord, index);
          return { ...meal, campusDistanceKm: dist };
        })
      );
    }
  }, [userCoords]);

  const addToast = (message: string, type: 'success' | 'info' | 'warning' | 'error' = 'info') => {
    const id = Math.random().toString(36).substring(2, 9);
    setToasts((prev) => [...prev, { id, message, type }]);
    setTimeout(() => {
      removeToast(id);
    }, 4000);
  };

  const removeToast = (id: string) => {
    setToasts((prev) => prev.filter((t) => t.id !== id));
  };

  // =========================================================================
  // SUPABASE GLOBAL REALTIME SUBSCRIPTION
  // =========================================================================
  useEffect(() => {
    try {
      const channel = supabase
        .channel('homebite-global-sync', {
          config: { broadcast: { ack: true } }
        })
        .on('broadcast', { event: 'order_created' }, ({ payload }) => {
          if (payload && payload.order) {
            setOrders((prev) => {
              if (prev.some(o => o.id === payload.order.id)) return prev;
              return [payload.order, ...prev];
            });
            setRealtimeMessagesCount(c => c + 1);
            addToast(`⚡ Realtime: New order ${payload.order.id} received!`, 'success');
          }
        })
        .on('broadcast', { event: 'order_status_updated' }, ({ payload }) => {
          if (payload && payload.orderId && payload.status) {
            setOrders((prev) =>
              prev.map((o) =>
                o.id === payload.orderId ? { ...o, status: payload.status, updatedAt: new Date().toISOString() } : o
              )
            );
            setActiveOrder((prev) =>
              prev && prev.id === payload.orderId ? { ...prev, status: payload.status, updatedAt: new Date().toISOString() } : prev
            );
            setRealtimeMessagesCount(c => c + 1);
            addToast(`⚡ Realtime: Order ${payload.orderId} moved to ${payload.status.replace(/_/g, ' ')}!`, 'info');
          }
        })
        .on('broadcast', { event: 'meal_added' }, ({ payload }) => {
          if (payload && payload.meal) {
            setMeals((prev) => {
              if (prev.some(m => m.id === payload.meal.id)) return prev;
              return [payload.meal, ...prev];
            });
            setRealtimeMessagesCount(c => c + 1);
            addToast(`⚡ Realtime: Chef listed new dish "${payload.meal.name}"!`, 'info');
          }
        })
        .subscribe((status) => {
          if (status === 'SUBSCRIBED') {
            setIsRealtimeConnected(true);
          }
        });

      return () => {
        channel.unsubscribe();
      };
    } catch (e) {
      console.warn('Supabase Realtime subscription notice:', e);
    }
  }, []);

  const openLoginModal = () => {
    setAuthMode('login');
    setIsAuthModalOpen(true);
  };

  const openRegisterModal = () => {
    setAuthMode('register');
    setIsAuthModalOpen(true);
  };

  // Live Geolocation Detection and Hyperlocal Distance Refresh
  const detectAndSetLocation = useCallback(async () => {
    if (!navigator.geolocation) {
      addToast('Geolocation is not supported by your browser.', 'error');
      return;
    }
    setIsLocating(true);
    try {
      const pos = await getCurrentPosition();
      const coords: LatLon = {
        lat: pos.coords.latitude,
        lon: pos.coords.longitude,
      };
      setUserCoords(coords);

      // 1. Reverse geocode to exact area, neighborhood and city
      const geoDetails = await reverseGeocodeDetails(coords.lat, coords.lon);
      setCurrentCampus(geoDetails.displayName);

      // 2. Fetch realtime location-accurate meals & local kitchens
      const liveMeals = await generateRealtimeLocationMeals(coords, {
        areaName: geoDetails.displayName,
        suburb: geoDetails.suburb,
        neighbourhood: geoDetails.neighbourhood,
        city: geoDetails.city,
        road: geoDetails.road,
      });

      setMeals(liveMeals);
      localDb.set('meals_list', liveMeals);

      addToast(`📍 Location & Live Menu synced for ${geoDetails.displayName}!`, 'success');
    } catch (err: any) {
      if (err?.code === 1) {
        addToast('Location access denied. Please allow location permissions in your browser.', 'warning');
      } else {
        addToast('Unable to detect live location. Please try again.', 'warning');
      }
    } finally {
      setIsLocating(false);
    }
  }, [setCurrentCampus, addToast]);

  // Auto-detect live location on initial load if not already detected
  useEffect(() => {
    if (navigator.geolocation && !currentCampus) {
      detectAndSetLocation();
    }
  }, [detectAndSetLocation, currentCampus]);

  // Role Redirection Map
  const getRoleDashboard = (role: UserRole): ActiveViewType => {
    switch (role) {
      case 'chef': return 'chef';
      case 'delivery': return 'delivery';
      case 'admin': return 'admin';
      case 'customer':
      default: return 'customer';
    }
  };

  // Protected View Navigation
  const navigateToView = (view: ActiveViewType) => {
    // If attempting to open protected dashboard when not authenticated
    if (['customer', 'chef', 'delivery', 'admin', 'tracking'].includes(view) && !isAuthenticated) {
      if (view === 'customer' || view === 'landing' || view === 'subscriptions') {
        setActiveView(view);
        return;
      }
      openLoginModal();
      addToast('Please sign in to access your portal.', 'info');
      return;
    }

    // Role-based Access Control Guard
    if (isAuthenticated) {
      if (view === 'chef' && currentRole !== 'chef' && currentRole !== 'admin') {
        addToast('Access Denied: You are logged in as a Student. Log out first to access the Chef Kitchen.', 'error');
        return;
      }
      if (view === 'delivery' && currentRole !== 'delivery' && currentRole !== 'admin') {
        addToast('Access Denied: You are not logged in as a Delivery Partner. Log out to access the Rider Portal.', 'error');
        return;
      }
      if (view === 'admin' && currentRole !== 'admin') {
        addToast('Access Denied: Administrator clearance required.', 'error');
        return;
      }
    }

    setActiveView(view);
  };

  // 1-Click Sandbox Demo Account Login
  const loginAsSandbox = async (role: UserRole) => {
    const targetUser = DEMO_USERS[role] || DEMO_USERS.customer;
    setCurrentRole(role);
    setCurrentUser(targetUser);
    setIsAuthenticated(true);
    setIsAuthModalOpen(false);

    const targetDashboard = getRoleDashboard(role);
    setActiveView(targetDashboard);

    const roleTitles: Record<UserRole, string> = {
      customer: 'Student / Customer',
      chef: 'Home Chef (Anita Devi)',
      delivery: 'Delivery Partner (Ramesh Kumar)',
      admin: 'Operations Admin'
    };

    try {
      confetti({ particleCount: 50, spread: 50, origin: { y: 0.6 } });
    } catch (e) {}

    addToast(`Logged in as ${roleTitles[role]}! Welcome back, ${targetUser.name} 🍲`, 'success');
  };

  // Standard Login with credentials
  const login = async (email: string, password?: string) => {
    if (isSupabaseConfigured && password) {
      try {
        const { data, error } = await supabase.auth.signInWithPassword({ email, password });
        if (error) throw error;
      } catch (err: any) {
        console.warn('Supabase auth notice, using registered profiles:', err.message);
      }
    }

    const matchedCred = DEMO_CREDENTIALS.find(c => c.email.toLowerCase() === email.toLowerCase());
    let targetRole: UserRole = 'customer';
    let targetUser: UserProfile = DEMO_USERS.customer;

    if (matchedCred) {
      targetRole = matchedCred.role as UserRole;
      targetUser = DEMO_USERS[targetRole] || DEMO_USERS.customer;
    } else {
      const customUsers = localDb.get<UserProfile[]>('registered_users', []);
      const found = customUsers.find(u => u.email.toLowerCase() === email.toLowerCase());
      if (found) {
        targetRole = found.role;
        targetUser = found;
      } else {
        targetUser = {
          ...DEMO_USERS.customer,
          email,
          name: email.split('@')[0].toUpperCase(),
        };
      }
    }

    setCurrentRole(targetRole);
    setCurrentUser(targetUser);
    setIsAuthenticated(true);
    setIsAuthModalOpen(false);

    const targetDashboard = getRoleDashboard(targetRole);
    setActiveView(targetDashboard);

    addToast(`Welcome back, ${targetUser.name}! (${targetRole.toUpperCase()}) 🍲`, 'success');
  };

  // Registration
  const register = async ({
    email,
    password,
    fullName,
    phone,
    role,
    collegeOrWorkplace,
    kitchenName,
    specialty,
    vehicleNumber,
  }: {
    email: string;
    password: string;
    fullName: string;
    phone: string;
    role: 'customer' | 'chef' | 'delivery';
    collegeOrWorkplace?: string;
    kitchenName?: string;
    specialty?: string;
    vehicleNumber?: string;
  }) => {
    if (isSupabaseConfigured) {
      try {
        await supabase.auth.signUp({
          email,
          password,
          options: {
            data: { full_name: fullName, role, phone }
          }
        });
      } catch (e) {
        console.warn('Supabase signup fallback notice');
      }
    }

    const newUser: UserProfile = {
      id: `user-${role}-${Date.now()}`,
      name: fullName,
      email,
      role,
      phone,
      avatarUrl: '',
      address: collegeOrWorkplace || 'Rohini Sector Hub, Delhi',
      collegeOrWorkplace: collegeOrWorkplace || currentCampus,
      kitchenName: role === 'chef' ? (kitchenName || `${fullName}'s Kitchen`) : undefined,
      specialty: specialty || undefined,
      isVerified: role === 'chef' ? false : true,
      vehicleNumber: role === 'delivery' ? vehicleNumber : undefined,
      deliveryRating: role === 'delivery' ? 5.0 : undefined,
      completedDeliveriesCount: 0,
      deliveryEarnings: 0,
      isOnline: role === 'delivery' ? true : undefined,
      earnings: role === 'chef' ? 0 : undefined,
    };

    const existingUsers = localDb.get<UserProfile[]>('registered_users', []);
    localDb.set('registered_users', [newUser, ...existingUsers]);

    setCurrentRole(role);
    setCurrentUser(newUser);
    setIsAuthenticated(true);
    setIsAuthModalOpen(false);

    const targetDashboard = getRoleDashboard(role);
    setActiveView(targetDashboard);

    try {
      confetti({ particleCount: 60, spread: 55, origin: { y: 0.6 } });
    } catch (e) {}

    addToast(`Account created successfully! Welcome to HomeBite, ${fullName} 🎉`, 'success');
  };

  // LOGOUT: strictly terminates session so user can access another role
  const logout = () => {
    setIsAuthenticated(false);
    setCurrentRole('customer');
    setCurrentUser(DEMO_USERS.customer);
    setActiveView('landing');
    addToast('Logged out successfully. You can now login to another role.', 'info');
  };

  const requestPasswordReset = async (email: string) => {
    if (isSupabaseConfigured) {
      await supabase.auth.resetPasswordForEmail(email);
    }
    await new Promise(r => setTimeout(r, 800));
  };

  const updateUserProfile = (profileUpdate: Partial<UserProfile>) => {
    if (profileUpdate.role && profileUpdate.role !== currentRole) {
      addToast('Security Alert: You cannot alter your registered role.', 'error');
      return;
    }
    setCurrentUser((prev) => ({ ...prev, ...profileUpdate }));
    addToast('Profile updated successfully!', 'success');
  };

  // Cart operations
  const addToCart = (meal: Meal, quantity = 1) => {
    setCart((prev) => {
      const existing = prev.find((item) => item.meal.id === meal.id);
      if (existing) {
        return prev.map((item) =>
          item.meal.id === meal.id
            ? { ...item, quantity: item.quantity + quantity }
            : item
        );
      }
      return [...prev, { meal, quantity }];
    });
    addToast(`Added "${meal.name}" to cart! 🍲`, 'success');
  };

  const updateCartQuantity = (mealId: string, quantity: number) => {
    if (quantity <= 0) {
      removeFromCart(mealId);
      return;
    }
    setCart((prev) =>
      prev.map((item) =>
        item.meal.id === mealId ? { ...item, quantity } : item
      )
    );
  };

  const removeFromCart = (mealId: string) => {
    setCart((prev) => prev.filter((item) => item.meal.id !== mealId));
    addToast('Item removed from cart', 'info');
  };

  const clearCart = () => {
    setCart([]);
  };

  const cartTotal = cart.reduce((sum, item) => sum + item.meal.price * item.quantity, 0);
  const cartItemCount = cart.reduce((count, item) => count + item.quantity, 0);

  // Orders: with Supabase Global Realtime Broadcast
  const placeOrder = async ({
    deliveryAddress,
    paymentMethod,
    orderNotes,
  }: {
    deliveryAddress: string;
    paymentMethod: any;
    orderNotes?: string;
  }): Promise<Order> => {
    const subtotal = cartTotal;
    const deliveryFee = 15;
    const packagingFee = 10;
    const discount = subtotal > 150 ? 25 : 0;
    const totalAmount = subtotal + deliveryFee + packagingFee - discount;

    const primaryChefId = cart[0]?.meal.chefId || 'user-chef-1';
    const primaryChefName = cart[0]?.meal.chefName || 'Anita Devi';
    const primaryKitchen = cart[0]?.meal.kitchenName || "Anita Aunty's Ghar Ki Rasoi";

    const newOrder: Order = {
      id: `ORD-${Math.floor(1000 + Math.random() * 9000)}`,
      customerId: currentUser.id,
      customerName: currentUser.name,
      customerPhone: currentUser.phone || '+91 98765 43210',
      deliveryAddress,
      collegeOrWorkplace: currentCampus,
      chefId: primaryChefId,
      chefName: primaryChefName,
      kitchenName: primaryKitchen,
      items: cart.map((c) => ({
        mealId: c.meal.id,
        name: c.meal.name,
        price: c.meal.price,
        quantity: c.quantity,
        dietary: c.meal.dietary,
        imageUrl: c.meal.imageUrl,
      })),
      subtotal,
      deliveryFee,
      packagingFee,
      discount,
      totalAmount,
      status: 'order_placed',
      paymentMethod,
      paymentStatus: 'paid',
      orderNotes,
      createdAt: new Date().toISOString(),
      updatedAt: new Date().toISOString(),
      estimatedDeliveryTime: '20-25 mins',
      deliveryPartnerId: 'user-delivery-1',
      deliveryPayout: 45,
      deliveryStep: 'accepted',
      deliveryPartner: {
        id: 'user-delivery-1',
        name: 'Ramesh Kumar',
        phone: '+91 98711 00223',
        vehicleNumber: 'DL 08 EF 4321',
        rating: 4.92,
        avatarUrl: '',
      },
      statusTimestamps: {
        order_placed: new Date().toISOString(),
      },
    };

    setOrders((prev) => [newOrder, ...prev]);
    setActiveOrder(newOrder);
    clearCart();
    setIsCheckoutOpen(false);

    // Global Supabase Realtime Broadcast
    await broadcastRealtimeEvent('order_created', { order: newOrder });

    try {
      confetti({
        particleCount: 80,
        spread: 70,
        origin: { y: 0.6 },
        colors: ['#238B57', '#F59E42', '#FFF9EF'],
      });
    } catch (e) {}

    addToast('🎉 Order placed & broadcasted via Supabase Realtime!', 'success');
    setActiveView('tracking');
    return newOrder;
  };

  // Update order status with Supabase Global Realtime Broadcast
  const updateOrderStatus = async (orderId: string, status: OrderStatus) => {
    setOrders((prev) =>
      prev.map((order) => {
        if (order.id === orderId) {
          const updatedTimestamps = {
            ...order.statusTimestamps,
            [status]: new Date().toISOString(),
          };
          const updated = {
            ...order,
            status,
            updatedAt: new Date().toISOString(),
            statusTimestamps: updatedTimestamps,
          };
          if (activeOrder?.id === orderId) {
            setActiveOrder(updated);
          }
          return updated;
        }
        return order;
      })
    );

    // Global Supabase Realtime Broadcast
    await broadcastRealtimeEvent('order_status_updated', { orderId, status });

    const statusReadable: Record<OrderStatus, string> = {
      order_placed: 'Order Placed',
      chef_preparing: 'Chef is Preparing your meal',
      ready_for_pickup: 'Order Ready for Pickup',
      out_for_delivery: 'Rider is Out for Delivery',
      delivered: 'Delivered',
      cancelled: 'Cancelled',
    };

    addToast(`Order ${orderId} status: ${statusReadable[status]}`, 'info');
  };

  // Chef operations with Realtime Broadcast
  const addMeal = async (mealData: Omit<Meal, 'id'>) => {
    const newMeal: Meal = {
      ...mealData,
      id: `meal-${Date.now()}`,
    };
    setMeals((prev) => [newMeal, ...prev]);

    // Global Supabase Realtime Broadcast
    await broadcastRealtimeEvent('meal_added', { meal: newMeal });

    addToast(`Meal "${newMeal.name}" listed & broadcasted globally! 🥗`, 'success');
  };

  const updateMeal = (updatedMeal: Meal) => {
    setMeals((prev) => prev.map((m) => (m.id === updatedMeal.id ? updatedMeal : m)));
    addToast('Meal listing updated!', 'success');
  };

  const deleteMeal = (mealId: string) => {
    setMeals((prev) => prev.filter((m) => m.id !== mealId));
    addToast('Meal removed from menu', 'info');
  };

  const toggleMealAvailability = (mealId: string) => {
    setMeals((prev) =>
      prev.map((m) => (m.id === mealId ? { ...m, isAvailable: !m.isAvailable } : m))
    );
    addToast('Meal availability toggled', 'info');
  };

  // Subscriptions
  const subscribeToPlan = (plan: SubscriptionPlan) => {
    if (!userSubscriptions.includes(plan.id)) {
      setUserSubscriptions((prev) => [...prev, plan.id]);
    }
    try {
      confetti({
        particleCount: 70,
        spread: 60,
        origin: { y: 0.5 },
      });
    } catch (e) {}
    addToast(`Subscribed to ${plan.title}! Fresh meals scheduled.`, 'success');
  };

  // Admin Chef Approvals
  const approveChefApplication = (id: string) => {
    setChefApplications((prev) =>
      prev.map((app) => (app.id === id ? { ...app, status: 'approved' } : app))
    );
    addToast('Chef kitchen verified and approved! ✅', 'success');
  };

  const rejectChefApplication = (id: string) => {
    setChefApplications((prev) =>
      prev.map((app) => (app.id === id ? { ...app, status: 'rejected' } : app))
    );
    addToast('Chef application rejected', 'warning');
  };

  return (
    <AppContext.Provider
      value={{
        isAuthenticated,
        currentUser,
        currentRole,
        isAuthModalOpen,
        setIsAuthModalOpen,
        authMode,
        setAuthMode,
        openLoginModal,
        openRegisterModal,
        login,
        loginAsSandbox,
        register,
        logout,
        requestPasswordReset,
        updateUserProfile,
        isSupabaseConfigOpen,
        setIsSupabaseConfigOpen,
        isRealtimeConnected,
        realtimeMessagesCount,
        activeView,
        setActiveView,
        navigateToView,
        currentCampus,
        setCurrentCampus,
        userCoords,
        detectAndSetLocation,
        isLocating,
        meals,
        addMeal,
        updateMeal,
        deleteMeal,
        toggleMealAvailability,
        selectedMealForDetails,
        setSelectedMealForDetails,
        cart,
        addToCart,
        updateCartQuantity,
        removeFromCart,
        clearCart,
        cartTotal,
        cartItemCount,
        isCartOpen,
        setIsCartOpen,
        isCheckoutOpen,
        setIsCheckoutOpen,
        orders,
        activeOrder,
        setActiveOrder,
        placeOrder,
        updateOrderStatus,
        userSubscriptions,
        subscribeToPlan,
        chefApplications,
        approveChefApplication,
        rejectChefApplication,
        toasts,
        addToast,
        removeToast,
      }}
    >
      {children}
    </AppContext.Provider>
  );
};

export const useApp = () => {
  const context = useContext(AppContext);
  if (!context) {
    throw new Error('useApp must be used within an AppProvider');
  }
  return context;
};

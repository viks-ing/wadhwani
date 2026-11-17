import React, { createContext, useContext, useState, useEffect, useCallback } from 'react';
import { DEMO_USERS, DEMO_CREDENTIALS, INITIAL_MEALS, INITIAL_ORDERS, INITIAL_CHEF_APPLICATIONS, CHEF_LOCATIONS } from '../data/mockData';
import { localDb, supabase, isSupabaseConfigured, broadcastRealtimeEvent } from '../lib/supabase';
import { reverseGeocodeDetails, getCurrentPosition, calculateChefDistance, } from '../lib/geoService';
import { generateRealtimeLocationMeals } from '../lib/realtimeFeedService';
import confetti from 'canvas-confetti';
const AppContext = createContext(undefined);
export const AppProvider = ({ children }) => {
    // Session State - Persistent
    const [isAuthenticated, setIsAuthenticated] = useState(() => localDb.get('is_authenticated', false));
    const [currentRole, setCurrentRole] = useState(() => localDb.get('current_role', 'customer'));
    const [currentUser, setCurrentUser] = useState(() => localDb.get('current_user', DEMO_USERS.customer));
    // Auth Modal State
    const [isAuthModalOpen, setIsAuthModalOpen] = useState(false);
    const [authMode, setAuthMode] = useState('login');
    // Supabase Realtime State
    const [isSupabaseConfigOpen, setIsSupabaseConfigOpen] = useState(false);
    const [isRealtimeConnected, setIsRealtimeConnected] = useState(true);
    const [realtimeMessagesCount, setRealtimeMessagesCount] = useState(0);
    // Navigation State
    const [activeView, setActiveView] = useState('landing');
    const [currentCampus, setCurrentCampus] = useState(() => localDb.get('current_campus', ''));
    const [userCoords, setUserCoords] = useState(() => localDb.get('user_coords', null));
    const [isLocating, setIsLocating] = useState(false);
    const [selectedProvider, setSelectedProvider] = useState(null);
    const openProviderMenu = useCallback((provider) => {
        setSelectedProvider(provider);
        setActiveView('restaurant_menu');
        window.scrollTo({ top: 0, behavior: 'smooth' });
    }, []);
    // Data Store
    const [meals, setMeals] = useState(() => localDb.get('meals_list', INITIAL_MEALS));
    const [cart, setCart] = useState(() => localDb.get('cart_items', []));
    const [orders, setOrders] = useState(() => localDb.get('orders_list', INITIAL_ORDERS));
    const [chefApplications, setChefApplications] = useState(() => localDb.get('chef_apps', INITIAL_CHEF_APPLICATIONS));
    const [userSubscriptions, setUserSubscriptions] = useState(() => localDb.get('user_subscriptions', ['sub-daily-student']));
    const [selectedMealForDetails, setSelectedMealForDetails] = useState(null);
    const [activeOrder, setActiveOrder] = useState(() => {
        const list = localDb.get('orders_list', INITIAL_ORDERS);
        return list.length > 0 ? list[0] : null;
    });
    const [isCartOpen, setIsCartOpen] = useState(false);
    const [isCheckoutOpen, setIsCheckoutOpen] = useState(false);
    const [toasts, setToasts] = useState([]);
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
            setMeals((prevMeals) => prevMeals.map((meal, index) => {
                const chefCoord = CHEF_LOCATIONS[meal.chefId];
                const dist = calculateChefDistance(userCoords, chefCoord, index);
                return { ...meal, campusDistanceKm: dist };
            }));
        }
    }, [userCoords]);
    const addToast = (message, type = 'info') => {
        const id = Math.random().toString(36).substring(2, 9);
        setToasts((prev) => [...prev, { id, message, type }]);
        setTimeout(() => {
            removeToast(id);
        }, 4000);
    };
    const removeToast = (id) => {
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
                        if (prev.some(o => o.id === payload.order.id))
                            return prev;
                        return [payload.order, ...prev];
                    });
                    setRealtimeMessagesCount(c => c + 1);
                    addToast(`⚡ Realtime: New order ${payload.order.id} received!`, 'success');
                }
            })
                .on('broadcast', { event: 'order_status_updated' }, ({ payload }) => {
                if (payload && payload.orderId && payload.status) {
                    setOrders((prev) => prev.map((o) => o.id === payload.orderId ? { ...o, status: payload.status, updatedAt: new Date().toISOString() } : o));
                    setActiveOrder((prev) => prev && prev.id === payload.orderId ? { ...prev, status: payload.status, updatedAt: new Date().toISOString() } : prev);
                    setRealtimeMessagesCount(c => c + 1);
                    addToast(`⚡ Realtime: Order ${payload.orderId} moved to ${payload.status.replace(/_/g, ' ')}!`, 'info');
                }
            })
                .on('broadcast', { event: 'meal_added' }, ({ payload }) => {
                if (payload && payload.meal) {
                    setMeals((prev) => {
                        if (prev.some(m => m.id === payload.meal.id))
                            return prev;
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
        }
        catch (e) {
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
            const coords = {
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
        }
        catch (err) {
            if (err?.code === 1) {
                addToast('Location access denied. Please allow location permissions in your browser.', 'warning');
            }
            else {
                addToast('Unable to detect live location. Please try again.', 'warning');
            }
        }
        finally {
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
    const getRoleDashboard = (role) => {
        switch (role) {
            case 'chef':
            case 'restaurant_owner': return 'chef';
            case 'delivery': return 'delivery';
            case 'admin': return 'admin';
            case 'customer':
            default: return 'customer';
        }
    };
    // Protected View Navigation
    const navigateToView = (view) => {
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
    const loginAsSandbox = async (role) => {
        const targetUser = DEMO_USERS[role] || DEMO_USERS.customer;
        setCurrentRole(role);
        setCurrentUser(targetUser);
        setIsAuthenticated(true);
        setIsAuthModalOpen(false);
        const targetDashboard = getRoleDashboard(role);
        setActiveView(targetDashboard);
        const roleTitles = {
            customer: 'Student / Customer',
            chef: 'Home Chef (Anita Devi)',
            restaurant_owner: 'Food Provider / Restaurant Owner',
            delivery: 'Delivery Partner (Ramesh Kumar)',
            admin: 'Operations Admin'
        };
        try {
            confetti({ particleCount: 50, spread: 50, origin: { y: 0.6 } });
        }
        catch (e) { }
        addToast(`Logged in as ${roleTitles[role]}! Welcome back, ${targetUser.name} 🍲`, 'success');
    };
    // Standard Login with credentials
    const login = async (email, password) => {
        if (isSupabaseConfigured && password) {
            try {
                const { data, error } = await supabase.auth.signInWithPassword({ email, password });
                if (error)
                    throw error;
            }
            catch (err) {
                console.warn('Supabase auth notice, using registered profiles:', err.message);
            }
        }
        const matchedCred = DEMO_CREDENTIALS.find(c => c.email.toLowerCase() === email.toLowerCase());
        let targetRole = 'customer';
        let targetUser = DEMO_USERS.customer;
        if (matchedCred) {
            targetRole = matchedCred.role;
            targetUser = DEMO_USERS[targetRole] || DEMO_USERS.customer;
        }
        else {
            const customUsers = localDb.get('registered_users', []);
            const found = customUsers.find(u => u.email.toLowerCase() === email.toLowerCase());
            if (found) {
                targetRole = found.role;
                targetUser = found;
            }
            else {
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
    const register = async ({ email, password, fullName, phone, role, collegeOrWorkplace, kitchenName, specialty, vehicleNumber, }) => {
        if (isSupabaseConfigured) {
            try {
                await supabase.auth.signUp({
                    email,
                    password,
                    options: {
                        data: { full_name: fullName, role, phone }
                    }
                });
            }
            catch (e) {
                console.warn('Supabase signup fallback notice');
            }
        }
        const newUser = {
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
        const existingUsers = localDb.get('registered_users', []);
        localDb.set('registered_users', [newUser, ...existingUsers]);
        setCurrentRole(role);
        setCurrentUser(newUser);
        setIsAuthenticated(true);
        setIsAuthModalOpen(false);
        const targetDashboard = getRoleDashboard(role);
        setActiveView(targetDashboard);
        try {
            confetti({ particleCount: 60, spread: 55, origin: { y: 0.6 } });
        }
        catch (e) { }
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
    const requestPasswordReset = async (email) => {
        if (isSupabaseConfigured) {
            await supabase.auth.resetPasswordForEmail(email);
        }
        await new Promise(r => setTimeout(r, 800));
    };
    const updateUserProfile = (profileUpdate) => {
        if (profileUpdate.role && profileUpdate.role !== currentRole) {
            addToast('Security Alert: You cannot alter your registered role.', 'error');
            return;
        }
        setCurrentUser((prev) => ({ ...prev, ...profileUpdate }));
        addToast('Profile updated successfully!', 'success');
    };
    // Cart operations
    const addToCart = (meal, quantity = 1) => {
        setCart((prev) => {
            const existing = prev.find((item) => item.meal.id === meal.id);
            if (existing) {
                return prev.map((item) => item.meal.id === meal.id
                    ? { ...item, quantity: item.quantity + quantity }
                    : item);
            }
            return [...prev, { meal, quantity }];
        });
        addToast(`Added "${meal.name}" to cart! 🍲`, 'success');
    };
    const updateCartQuantity = (mealId, quantity) => {
        if (quantity <= 0) {
            removeFromCart(mealId);
            return;
        }
        setCart((prev) => prev.map((item) => item.meal.id === mealId ? { ...item, quantity } : item));
    };
    const removeFromCart = (mealId) => {
        setCart((prev) => prev.filter((item) => item.meal.id !== mealId));
        addToast('Item removed from cart', 'info');
    };
    const clearCart = () => {
        setCart([]);
    };
    const cartTotal = cart.reduce((sum, item) => sum + item.meal.price * item.quantity, 0);
    const cartItemCount = cart.reduce((count, item) => count + item.quantity, 0);
    // Orders: with Supabase Global Realtime Broadcast
    const placeOrder = async ({ deliveryAddress, paymentMethod, orderNotes, }) => {
        const subtotal = cartTotal;
        const deliveryFee = 15;
        const packagingFee = 10;
        const discount = subtotal > 150 ? 25 : 0;
        const totalAmount = subtotal + deliveryFee + packagingFee - discount;
        const primaryChefId = cart[0]?.meal.chefId || 'user-chef-1';
        const primaryChefName = cart[0]?.meal.chefName || 'Anita Devi';
        const primaryKitchen = cart[0]?.meal.kitchenName || "Anita Aunty's Ghar Ki Rasoi";
        const newOrder = {
            id: `ORD-${Math.floor(1000 + Math.random() * 9000)}`,
            customerId: currentUser.id,
            customerName: currentUser.name,
            customerPhone: currentUser.phone || '+91 98765 43210',
            deliveryAddress,
            collegeOrWorkplace: currentCampus || 'SNIST Campus, Yamnampet, Ghatkesar',
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
            deliveryPayout: 45,
            deliveryStep: 'awaiting_assignment',
            deliveryPartnerId: undefined,
            deliveryPartner: undefined,
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
        }
        catch (e) { }
        addToast('🎉 Order placed & broadcasted via Supabase Realtime!', 'success');
        setActiveView('tracking');
        return newOrder;
    };
    // Delivery assignment: Rider claims order
    const acceptDeliveryOrder = async (orderId, rider) => {
        const riderInfo = {
            id: rider.id,
            name: rider.name || 'Ramesh Kumar',
            phone: rider.phone || '+91 98711 00223',
            vehicleNumber: rider.vehicleNumber || 'TS 08 EF 4321 (Hero Splendor)',
            vehicleType: rider.vehicleType || 'Motorcycle',
            rating: rider.deliveryRating || 4.92,
            avatarUrl: rider.avatarUrl || '',
        };
        setOrders((prev) => prev.map((order) => {
            if (order.id === orderId) {
                const updatedTimestamps = {
                    ...order.statusTimestamps,
                    ready_for_pickup: order.statusTimestamps?.ready_for_pickup || new Date().toISOString(),
                };
                const updated = {
                    ...order,
                    deliveryPartnerId: rider.id,
                    deliveryPartner: riderInfo,
                    deliveryStep: 'accepted',
                    status: order.status === 'order_placed' ? 'ready_for_pickup' : order.status,
                    updatedAt: new Date().toISOString(),
                    statusTimestamps: updatedTimestamps,
                };
                if (activeOrder?.id === orderId) {
                    setActiveOrder(updated);
                }
                return updated;
            }
            return order;
        }));
        // Global Supabase Realtime Broadcast
        await broadcastRealtimeEvent('order_assigned', { orderId, rider: riderInfo });
        addToast(`Delivery assignment accepted for ${orderId}! Proceed to kitchen. 🛵`, 'success');
    };
    // Update order status with Supabase Global Realtime Broadcast
    const updateOrderStatus = async (orderId, status) => {
        setOrders((prev) => prev.map((order) => {
            if (order.id === orderId) {
                const updatedTimestamps = {
                    ...order.statusTimestamps,
                    [status]: new Date().toISOString(),
                };
                let step = order.deliveryStep;
                if (status === 'out_for_delivery')
                    step = 'picked_up';
                else if (status === 'delivered')
                    step = 'delivered';
                const updated = {
                    ...order,
                    status,
                    deliveryStep: step,
                    updatedAt: new Date().toISOString(),
                    statusTimestamps: updatedTimestamps,
                };
                if (activeOrder?.id === orderId) {
                    setActiveOrder(updated);
                }
                return updated;
            }
            return order;
        }));
        // Global Supabase Realtime Broadcast
        await broadcastRealtimeEvent('order_status_updated', { orderId, status });
        const statusReadable = {
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
    const addMeal = async (mealData) => {
        const newMeal = {
            ...mealData,
            id: `meal-${Date.now()}`,
        };
        setMeals((prev) => [newMeal, ...prev]);
        // Global Supabase Realtime Broadcast
        await broadcastRealtimeEvent('meal_added', { meal: newMeal });
        addToast(`Meal "${newMeal.name}" listed & broadcasted globally! 🥗`, 'success');
    };
    const updateMeal = (updatedMeal) => {
        setMeals((prev) => prev.map((m) => (m.id === updatedMeal.id ? updatedMeal : m)));
        addToast('Meal listing updated!', 'success');
    };
    const deleteMeal = (mealId) => {
        setMeals((prev) => prev.filter((m) => m.id !== mealId));
        addToast('Meal removed from menu', 'info');
    };
    const toggleMealAvailability = (mealId) => {
        setMeals((prev) => prev.map((m) => (m.id === mealId ? { ...m, isAvailable: !m.isAvailable } : m)));
        addToast('Meal availability toggled', 'info');
    };
    // Subscriptions
    const subscribeToPlan = (plan) => {
        if (!userSubscriptions.includes(plan.id)) {
            setUserSubscriptions((prev) => [...prev, plan.id]);
        }
        try {
            confetti({
                particleCount: 70,
                spread: 60,
                origin: { y: 0.5 },
            });
        }
        catch (e) { }
        addToast(`Subscribed to ${plan.title}! Fresh meals scheduled.`, 'success');
    };
    // Admin Chef Approvals
    const approveChefApplication = (id) => {
        setChefApplications((prev) => prev.map((app) => (app.id === id ? { ...app, status: 'approved' } : app)));
        addToast('Chef kitchen verified and approved! ✅', 'success');
    };
    const rejectChefApplication = (id) => {
        setChefApplications((prev) => prev.map((app) => (app.id === id ? { ...app, status: 'rejected' } : app)));
        addToast('Chef application rejected', 'warning');
    };
    return (<AppContext.Provider value={{
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
            selectedProvider,
            setSelectedProvider,
            openProviderMenu,
            currentCampus,
            setCurrentCampus,
            userCoords,
            setUserCoords,
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
            acceptDeliveryOrder,
            userSubscriptions,
            subscribeToPlan,
            chefApplications,
            approveChefApplication,
            rejectChefApplication,
            toasts,
            addToast,
            removeToast,
        }}>
      {children}
    </AppContext.Provider>);
};
export const useApp = () => {
    const context = useContext(AppContext);
    if (!context) {
        throw new Error('useApp must be used within an AppProvider');
    }
    return context;
};

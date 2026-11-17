import React from 'react';
import { useApp } from './context/AppContext';
import { Navbar } from './components/common/Navbar';
import { ToastContainer } from './components/common/ToastContainer';
import { LandingPage } from './components/landing/LandingPage';
import { CustomerDashboard } from './components/customer/CustomerDashboard';
import { MealDetailsModal } from './components/customer/MealDetailsModal';
import { CartDrawer } from './components/customer/CartDrawer';
import { CheckoutModal } from './components/customer/CheckoutModal';
import { OrderTrackingView } from './components/customer/OrderTrackingView';
import { SubscriptionView } from './components/customer/SubscriptionView';
import { RestaurantMenuView } from './components/customer/RestaurantMenuView';
import { ChefDashboard } from './components/chef/ChefDashboard';
import { DeliveryDashboard } from './components/delivery/DeliveryDashboard';
import { AdminDashboard } from './components/admin/AdminDashboard';
import { AuthModal } from './components/auth/AuthModal';
import { SupabaseConfigModal } from './components/common/SupabaseConfigModal';

export const AppContent: React.FC = () => {
  const { 
    activeView, 
    isAuthModalOpen, 
    setIsAuthModalOpen,
    isSupabaseConfigOpen,
    setIsSupabaseConfigOpen 
  } = useApp();

  return (
    <div className="min-h-screen bg-hb-cream flex flex-col selection:bg-hb-green-600 selection:text-white">
      {/* 1. Primary Navigation & Authentication Bar */}
      <Navbar />

      {/* 2. Role-Based Dynamic Page View */}
      <main className="flex-1">
        {activeView === 'landing' && <LandingPage />}
        {activeView === 'customer' && <CustomerDashboard />}
        {activeView === 'subscriptions' && <SubscriptionView />}
        {activeView === 'restaurant_menu' && <RestaurantMenuView />}
        {activeView === 'tracking' && <OrderTrackingView />}
        {activeView === 'chef' && <ChefDashboard />}
        {activeView === 'delivery' && <DeliveryDashboard />}
        {activeView === 'admin' && <AdminDashboard />}
      </main>

      {/* 3. Global Modals & Overlays */}
      <AuthModal isOpen={isAuthModalOpen} onClose={() => setIsAuthModalOpen(false)} />
      <SupabaseConfigModal isOpen={isSupabaseConfigOpen} onClose={() => setIsSupabaseConfigOpen(false)} />
      <MealDetailsModal />
      <CartDrawer />
      <CheckoutModal />
      <ToastContainer />
    </div>
  );
};

export default function App() {
  return <AppContent />;
}

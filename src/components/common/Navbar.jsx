import React, { useState } from 'react';
import { useApp } from '../../context/AppContext';
import { ShoppingBag, MapPin, ChefHat, User, Bike, ShieldCheck, Clock, Menu, X, CalendarCheck, LogOut, LogIn, UserPlus, Zap, LocateFixed, Loader2 } from 'lucide-react';
export const Navbar = () => {
    const { activeView, setActiveView, cartItemCount, cartTotal, setIsCartOpen, currentCampus, setCurrentCampus, userCoords, detectAndSetLocation, isLocating, currentUser, currentRole, isAuthenticated, openLoginModal, openRegisterModal, setIsSupabaseConfigOpen, logout, orders, addToast } = useApp();
    const [isUserMenuOpen, setIsUserMenuOpen] = useState(false);
    const [isMobileMenuOpen, setIsMobileMenuOpen] = useState(false);
    const hasActiveOrder = orders.some(o => o.status !== 'delivered' && o.status !== 'cancelled');
    const getRoleBadge = () => {
        switch (currentRole) {
            case 'chef':
                return { label: 'Home Chef', color: 'bg-orange-100 text-orange-800 border-orange-200', icon: ChefHat };
            case 'delivery':
                return { label: 'Delivery Rider', color: 'bg-indigo-100 text-indigo-800 border-indigo-200', icon: Bike };
            case 'admin':
                return { label: 'Platform Admin', color: 'bg-purple-100 text-purple-800 border-purple-200', icon: ShieldCheck };
            case 'customer':
            default:
                return { label: 'Student', color: 'bg-emerald-100 text-emerald-800 border-emerald-200', icon: User };
        }
    };
    const RoleBadge = getRoleBadge();
    const RoleIcon = RoleBadge.icon;
    return (<header className="sticky top-0 z-30 bg-hb-cream/95 backdrop-blur-md border-b border-hb-green-100 shadow-soft transition-all">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="flex items-center justify-between h-20">
          
          {/* Logo & Brand */}
          <div className="flex items-center gap-5">
            <button onClick={() => setActiveView('landing')} className="flex items-center gap-2.5 text-left group">
              <div className="w-11 h-11 rounded-2xl bg-gradient-to-tr from-hb-green-600 to-hb-green-500 flex items-center justify-center text-white shadow-md shadow-hb-green-600/20 group-hover:scale-105 transition-transform">
                <span className="text-2xl">🍲</span>
              </div>
              <div>
                <span className="text-2xl font-black text-hb-green-800 tracking-tight flex items-center gap-1 font-display">
                  HomeBite
                  <span className="w-2 h-2 rounded-full bg-hb-orange inline-block"></span>
                </span>
                <span className="block text-[11px] font-semibold text-hb-green-600 tracking-wider uppercase">
                  Homemade • Daily • Fresh
                </span>
              </div>
            </button>

            {/* Live Geolocation Pill */}
            {(!isAuthenticated || currentRole === 'customer') && (<div className="relative hidden md:block">
                <button onClick={detectAndSetLocation} disabled={isLocating} title={currentCampus ? `Detected: ${currentCampus} — click to refresh live GPS` : 'Click to detect your location'} className="flex items-center gap-2 px-3.5 py-1.5 rounded-full bg-white border border-hb-green-200 text-gray-700 hover:border-hb-green-500 hover:shadow-sm transition text-xs font-medium disabled:opacity-70 disabled:cursor-wait">
                  {isLocating ? (<Loader2 className="w-3.5 h-3.5 text-hb-green-600 animate-spin flex-shrink-0"/>) : currentCampus ? (<MapPin className="w-3.5 h-3.5 text-hb-green-600 flex-shrink-0"/>) : (<LocateFixed className="w-3.5 h-3.5 text-hb-green-600 flex-shrink-0"/>)}
                  <span className="max-w-[190px] truncate font-semibold text-gray-800">
                    {isLocating
                ? 'Detecting…'
                : currentCampus || 'Detect My Location'}
                  </span>
                  <LocateFixed className={`w-3 h-3 flex-shrink-0 ${isLocating ? 'text-gray-300' : 'text-hb-green-500'}`}/>
                </button>
              </div>)}
          </div>

          {/* Center Navigation Links - Strictly filtered by role */}
          <nav className="hidden lg:flex items-center gap-1 bg-white/70 p-1.5 rounded-full border border-hb-green-100 shadow-sm">
            
            {/* PUBLIC OR CUSTOMER VIEW */}
            {(!isAuthenticated || currentRole === 'customer') && (<>
                <button onClick={() => setActiveView('landing')} className={`px-4 py-2 rounded-full text-xs font-semibold transition ${activeView === 'landing'
                ? 'bg-hb-green-600 text-white shadow-sm'
                : 'text-gray-600 hover:text-hb-green-700 hover:bg-hb-green-50/50'}`}>
                  Home
                </button>
                <button onClick={() => setActiveView('customer')} className={`px-4 py-2 rounded-full text-xs font-semibold transition ${activeView === 'customer'
                ? 'bg-hb-green-600 text-white shadow-sm'
                : 'text-gray-600 hover:text-hb-green-700 hover:bg-hb-green-50/50'}`}>
                  Explore Meals
                </button>
                <button onClick={() => setActiveView('subscriptions')} className={`px-4 py-2 rounded-full text-xs font-semibold transition flex items-center gap-1.5 ${activeView === 'subscriptions'
                ? 'bg-hb-green-600 text-white shadow-sm'
                : 'text-gray-600 hover:text-hb-green-700 hover:bg-hb-green-50/50'}`}>
                  <CalendarCheck className="w-3.5 h-3.5"/>
                  <span>Dabba Plans</span>
                </button>
                {isAuthenticated && (<button onClick={() => setActiveView('tracking')} className={`px-4 py-2 rounded-full text-xs font-semibold transition flex items-center gap-1.5 relative ${activeView === 'tracking'
                    ? 'bg-hb-green-600 text-white shadow-sm'
                    : 'text-gray-600 hover:text-hb-green-700 hover:bg-hb-green-50/50'}`}>
                    <Clock className="w-3.5 h-3.5"/>
                    <span>My Orders</span>
                    {hasActiveOrder && (<span className="w-2 h-2 rounded-full bg-hb-orange animate-ping absolute top-1 right-2"></span>)}
                  </button>)}
              </>)}

            {/* CHEF VIEW */}
            {isAuthenticated && currentRole === 'chef' && (<>
                <button onClick={() => setActiveView('chef')} className={`px-4 py-2 rounded-full text-xs font-bold transition flex items-center gap-1.5 ${activeView === 'chef'
                ? 'bg-hb-orange text-white shadow-sm'
                : 'text-gray-700 hover:text-hb-orange hover:bg-orange-50'}`}>
                  <ChefHat className="w-3.5 h-3.5"/>
                  <span>Kitchen Orders & Menu</span>
                </button>
              </>)}

            {/* DELIVERY RIDER VIEW */}
            {isAuthenticated && currentRole === 'delivery' && (<>
                <button onClick={() => setActiveView('delivery')} className={`px-4 py-2 rounded-full text-xs font-bold transition flex items-center gap-1.5 ${activeView === 'delivery'
                ? 'bg-indigo-600 text-white shadow-sm'
                : 'text-gray-700 hover:text-indigo-600 hover:bg-indigo-50'}`}>
                  <Bike className="w-3.5 h-3.5"/>
                  <span>Rider Trips & Earnings</span>
                </button>
              </>)}

            {/* ADMIN VIEW */}
            {isAuthenticated && currentRole === 'admin' && (<>
                <button onClick={() => setActiveView('admin')} className={`px-4 py-2 rounded-full text-xs font-bold transition flex items-center gap-1.5 ${activeView === 'admin'
                ? 'bg-purple-600 text-white shadow-sm'
                : 'text-gray-700 hover:text-purple-600 hover:bg-purple-50'}`}>
                  <ShieldCheck className="w-3.5 h-3.5"/>
                  <span>Operations Console</span>
                </button>
              </>)}

            {/* Supabase Realtime Indicator Button */}
            <button onClick={() => setIsSupabaseConfigOpen(true)} className="px-3 py-1.5 rounded-full text-[11px] font-semibold text-emerald-700 hover:bg-emerald-50 transition flex items-center gap-1" title="Supabase Global Realtime Status">
              <Zap className="w-3.5 h-3.5 text-amber-500 fill-amber-500"/>
              <span>Realtime</span>
            </button>
          </nav>

          {/* Right Action Elements */}
          <div className="flex items-center gap-3">
            
            {/* Student Cart Trigger Button (Only visible if not chef/delivery/admin) */}
            {(!isAuthenticated || currentRole === 'customer') && (<button onClick={() => setIsCartOpen(true)} className="relative flex items-center gap-2.5 px-4 py-2 rounded-xl bg-hb-green-600 text-white hover:bg-hb-green-700 shadow-md shadow-hb-green-600/25 transition transform active:scale-95">
                <ShoppingBag className="w-4 h-4"/>
                <div className="text-left hidden sm:block">
                  <span className="text-[11px] block leading-none font-medium opacity-90">Cart</span>
                  <span className="text-xs font-extrabold">₹{cartTotal}</span>
                </div>
                {cartItemCount > 0 && (<span className="w-5 h-5 rounded-full bg-hb-orange text-white text-[11px] font-black flex items-center justify-center shadow-sm">
                    {cartItemCount}
                  </span>)}
              </button>)}

            {/* AUTHENTICATION STATE */}
            {isAuthenticated ? (<div className="flex items-center gap-2">
                
                {/* User Capsule */}
                <div className="flex items-center gap-2 bg-white px-3 py-1.5 rounded-2xl border border-hb-green-200 shadow-xs">
                  <div className={`w-8 h-8 rounded-full flex items-center justify-center font-bold text-xs border ${RoleBadge.color}`}>
                    <RoleIcon className="w-4 h-4"/>
                  </div>
                  <div className="text-left hidden md:block">
                    <p className="text-xs font-bold text-gray-900 leading-tight">{currentUser.name}</p>
                    <span className={`inline-block px-1.5 py-0.2 rounded-full text-[9px] font-bold border ${RoleBadge.color}`}>
                      {RoleBadge.label}
                    </span>
                  </div>
                </div>

                {/* Prominent Logout Button */}
                <button onClick={logout} className="px-3.5 py-2 rounded-xl border border-rose-200 bg-rose-50 hover:bg-rose-100 text-rose-700 font-bold text-xs transition flex items-center gap-1.5 shadow-xs" title="Logout of current role to access another">
                  <LogOut className="w-3.5 h-3.5"/>
                  <span className="hidden sm:inline">Logout</span>
                </button>

              </div>) : (<div className="flex items-center gap-2">
                <button onClick={openLoginModal} className="px-4 py-2 rounded-xl text-xs font-bold text-hb-green-800 bg-white border border-hb-green-300 hover:bg-hb-green-50 shadow-xs transition flex items-center gap-1.5">
                  <LogIn className="w-3.5 h-3.5 text-hb-green-600"/>
                  <span>Login</span>
                </button>
                <button onClick={openRegisterModal} className="px-4 py-2 rounded-xl bg-hb-green-600 hover:bg-hb-green-700 text-white text-xs font-bold shadow-md shadow-hb-green-600/25 transition flex items-center gap-1.5">
                  <UserPlus className="w-3.5 h-3.5"/>
                  <span className="hidden sm:inline">Register</span>
                </button>
              </div>)}

            {/* Mobile Hamburger */}
            <button onClick={() => setIsMobileMenuOpen(!isMobileMenuOpen)} className="lg:hidden p-2 rounded-xl text-gray-700 hover:bg-hb-green-100">
              {isMobileMenuOpen ? <X className="w-6 h-6"/> : <Menu className="w-6 h-6"/>}
            </button>
          </div>
        </div>
      </div>

      {/* Mobile Menu */}
      {isMobileMenuOpen && (<div className="lg:hidden bg-white border-b border-hb-green-100 p-4 space-y-3 animate-fadeIn">
          {(!isAuthenticated || currentRole === 'customer') && (<div className="p-3 bg-hb-cream rounded-xl flex items-center gap-2">
              {isLocating ? (<Loader2 className="w-3.5 h-3.5 text-hb-green-600 animate-spin flex-shrink-0"/>) : (<MapPin className="w-3.5 h-3.5 text-hb-green-600 flex-shrink-0"/>)}
              <div className="flex-1 min-w-0">
                <p className="text-[10px] font-bold text-gray-500 uppercase tracking-wider">Your Location</p>
                <p className="text-xs font-bold text-gray-900 truncate">
                  {isLocating ? 'Detecting…' : currentCampus || 'Not detected'}
                </p>
              </div>
              <button onClick={() => { detectAndSetLocation(); setIsMobileMenuOpen(false); }} disabled={isLocating} className="text-[10px] font-bold text-hb-green-700 bg-hb-green-50 border border-hb-green-200 px-2 py-1 rounded-lg flex-shrink-0">
                {currentCampus ? 'Refresh' : 'Detect'}
              </button>
            </div>)}

          <div className="flex flex-col gap-1 text-sm font-semibold">
            {(!isAuthenticated || currentRole === 'customer') && (<>
                <button onClick={() => { setActiveView('landing'); setIsMobileMenuOpen(false); }} className="text-left py-2 px-3 rounded-lg hover:bg-hb-green-50 text-gray-800">
                  Home Page
                </button>
                <button onClick={() => { setActiveView('customer'); setIsMobileMenuOpen(false); }} className="text-left py-2 px-3 rounded-lg hover:bg-hb-green-50 text-gray-800">
                  Explore Meals
                </button>
                <button onClick={() => { setActiveView('subscriptions'); setIsMobileMenuOpen(false); }} className="text-left py-2 px-3 rounded-lg hover:bg-hb-green-50 text-gray-800">
                  Dabba Plans & Subscriptions
                </button>
              </>)}

            {isAuthenticated && currentRole === 'chef' && (<button onClick={() => { setActiveView('chef'); setIsMobileMenuOpen(false); }} className="text-left py-2 px-3 rounded-lg hover:bg-orange-50 text-orange-800 font-bold">
                Chef Kitchen Orders & Menu
              </button>)}

            {isAuthenticated && currentRole === 'delivery' && (<button onClick={() => { setActiveView('delivery'); setIsMobileMenuOpen(false); }} className="text-left py-2 px-3 rounded-lg hover:bg-indigo-50 text-indigo-800 font-bold">
                Rider Trips & Earnings
              </button>)}

            {isAuthenticated && currentRole === 'admin' && (<button onClick={() => { setActiveView('admin'); setIsMobileMenuOpen(false); }} className="text-left py-2 px-3 rounded-lg hover:bg-purple-50 text-purple-800 font-bold">
                Admin Operations Console
              </button>)}

            {!isAuthenticated ? (<div className="pt-3 border-t border-gray-100 flex gap-2">
                <button onClick={() => { openLoginModal(); setIsMobileMenuOpen(false); }} className="flex-1 py-2.5 text-xs font-bold rounded-xl border border-hb-green-600 text-hb-green-800">
                  Sign In
                </button>
                <button onClick={() => { openRegisterModal(); setIsMobileMenuOpen(false); }} className="flex-1 py-2.5 text-xs font-bold rounded-xl bg-hb-green-600 text-white">
                  Register
                </button>
              </div>) : (<button onClick={() => { logout(); setIsMobileMenuOpen(false); }} className="text-left py-2.5 px-3 rounded-xl bg-rose-50 text-rose-600 font-bold text-xs mt-2 flex items-center gap-2">
                <LogOut className="w-4 h-4"/>
                <span>Logout ({currentUser.name} - {RoleBadge.label})</span>
              </button>)}
          </div>
        </div>)}
    </header>);
};

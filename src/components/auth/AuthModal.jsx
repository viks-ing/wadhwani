import React, { useState } from 'react';
import { useApp } from '../../context/AppContext';
import { X, Lock, Mail, Eye, EyeOff, User, ChefHat, Bike, ShieldCheck, Sparkles, ArrowRight, CheckCircle2, AlertCircle, Loader2 } from 'lucide-react';
export const AuthModal = () => {
    const { isAuthModalOpen, setIsAuthModalOpen, authMode, setAuthMode, login, loginAsSandbox, register, requestPasswordReset, addToast } = useApp();
    const [email, setEmail] = useState('');
    const [password, setPassword] = useState('');
    const [showPassword, setShowPassword] = useState(false);
    const [fullName, setFullName] = useState('');
    const [phone, setPhone] = useState('');
    const [selectedRole, setSelectedRole] = useState('customer');
    // Role specific fields
    const [collegeOrWorkplace, setCollegeOrWorkplace] = useState('Sreenidhi Institute of Science and Technology (SNIST)');
    const [kitchenName, setKitchenName] = useState('');
    const [specialty, setSpecialty] = useState('');
    const [vehicleNumber, setVehicleNumber] = useState('');
    const [isLoading, setIsLoading] = useState(false);
    const [errorMessage, setErrorMessage] = useState('');
    const [successMessage, setSuccessMessage] = useState('');
    const [isForgotPassword, setIsForgotPassword] = useState(false);
    const [showManualLogin, setShowManualLogin] = useState(false);
    if (!isAuthModalOpen)
        return null;
    const handleSandboxLogin = async (role) => {
        setIsLoading(true);
        setErrorMessage('');
        try {
            await loginAsSandbox(role);
            setIsLoading(false);
        }
        catch (err) {
            setIsLoading(false);
            setErrorMessage('Failed to login to sandbox account.');
        }
    };
    const handleLoginSubmit = async (e) => {
        e.preventDefault();
        setErrorMessage('');
        setSuccessMessage('');
        setIsLoading(true);
        try {
            await login(email, password);
            setIsLoading(false);
        }
        catch (err) {
            setIsLoading(false);
            setErrorMessage(err.message || 'Invalid email or password. Please try again.');
        }
    };
    const handleRegisterSubmit = async (e) => {
        e.preventDefault();
        setErrorMessage('');
        setSuccessMessage('');
        if (password.length < 6) {
            setErrorMessage('Password must be at least 6 characters long.');
            return;
        }
        setIsLoading(true);
        try {
            await register({
                email,
                password,
                fullName,
                phone,
                role: selectedRole,
                collegeOrWorkplace: selectedRole === 'customer' ? collegeOrWorkplace : undefined,
                kitchenName: selectedRole === 'chef' ? kitchenName : undefined,
                specialty: selectedRole === 'chef' ? specialty : undefined,
                vehicleNumber: selectedRole === 'delivery' ? vehicleNumber : undefined,
            });
            setIsLoading(false);
        }
        catch (err) {
            setIsLoading(false);
            setErrorMessage(err.message || 'Registration failed. Please check your details.');
        }
    };
    const handleForgotPasswordSubmit = async (e) => {
        e.preventDefault();
        if (!email.trim()) {
            setErrorMessage('Please enter your registered email address.');
            return;
        }
        setIsLoading(true);
        setErrorMessage('');
        try {
            await requestPasswordReset(email);
            setIsLoading(false);
            setSuccessMessage('Password recovery link sent! Please check your email inbox.');
        }
        catch (err) {
            setIsLoading(false);
            setErrorMessage('Failed to send reset link. Verify your email.');
        }
    };
    return (<div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/60 backdrop-blur-sm overflow-y-auto animate-fadeIn">
      <div className="bg-white rounded-3xl shadow-2xl max-w-xl w-full overflow-hidden border border-hb-green-100 my-8">
        
        {/* Brand Header */}
        <div className="bg-gradient-to-r from-hb-green-800 via-hb-green-700 to-hb-green-800 p-6 sm:p-7 text-white relative">
          <button onClick={() => setIsAuthModalOpen(false)} className="absolute top-4 right-4 p-2 rounded-full bg-white/10 hover:bg-white/20 text-white transition">
            <X className="w-5 h-5"/>
          </button>

          <div className="flex items-center gap-3 mb-2">
            <div className="w-10 h-10 rounded-2xl bg-white/20 backdrop-blur flex items-center justify-center text-2xl shadow-sm">
              🍲
            </div>
            <div>
              <span className="text-xl font-black tracking-tight font-display">HomeBite</span>
              <span className="block text-[10px] text-hb-cream-300 font-semibold uppercase tracking-wider">
                Homemade • Daily • Fresh
              </span>
            </div>
          </div>

          <h2 className="text-2xl font-black font-display mt-2">
            {isForgotPassword
            ? 'Reset Your Password'
            : authMode === 'login'
                ? 'Choose an Account to Login'
                : 'Create Your HomeBite Account'}
          </h2>
          <p className="text-xs text-hb-cream-200 mt-1">
            {isForgotPassword
            ? 'Enter your registered email to receive a secure recovery code.'
            : authMode === 'login'
                ? 'Select a role demo sandbox account or sign in with custom credentials.'
                : 'Register as a student, neighborhood home chef, or campus delivery partner.'}
          </p>
        </div>

        {/* Form Body */}
        <div className="p-6 sm:p-8 space-y-6 max-h-[75vh] overflow-y-auto text-xs">
          
          {/* Error & Success Alerts */}
          {errorMessage && (<div className="p-3 bg-rose-50 border border-rose-200 rounded-xl text-rose-700 flex items-start gap-2">
              <AlertCircle className="w-4 h-4 flex-shrink-0 mt-0.5"/>
              <span>{errorMessage}</span>
            </div>)}

          {successMessage && (<div className="p-3 bg-emerald-50 border border-emerald-200 rounded-xl text-emerald-800 flex items-start gap-2">
              <CheckCircle2 className="w-4 h-4 flex-shrink-0 mt-0.5"/>
              <span>{successMessage}</span>
            </div>)}

          {/* FORGOT PASSWORD FORM */}
          {isForgotPassword ? (<form onSubmit={handleForgotPasswordSubmit} className="space-y-4">
              <div className="space-y-1">
                <label className="font-bold text-gray-700">Registered Email Address</label>
                <div className="relative">
                  <Mail className="w-4 h-4 text-gray-400 absolute left-3 top-1/2 -translate-y-1/2"/>
                  <input type="email" required value={email} onChange={(e) => setEmail(e.target.value)} placeholder="e.g. aarav@dtu.ac.in" className="w-full pl-9 pr-3 py-2.5 rounded-xl border border-gray-200 outline-none focus:border-hb-green-500 text-gray-800"/>
                </div>
              </div>

              <div className="flex items-center justify-between pt-2">
                <button type="button" onClick={() => { setIsForgotPassword(false); setErrorMessage(''); }} className="font-bold text-gray-600 hover:text-gray-900">
                  ← Back to Login
                </button>

                <button type="submit" disabled={isLoading} className="px-6 py-2.5 rounded-xl bg-hb-green-600 hover:bg-hb-green-700 text-white font-bold transition flex items-center gap-1.5 shadow-sm disabled:opacity-70">
                  {isLoading ? <Loader2 className="w-4 h-4 animate-spin"/> : 'Send Reset Link'}
                </button>
              </div>
            </form>) : authMode === 'login' ? (
        /* LOGIN VIEW: 3 SANDBOX DEMO ACCOUNTS + MANUAL LOGIN */
        <div className="space-y-5">
              
              <div>
                <div className="flex items-center justify-between mb-2.5">
                  <span className="font-extrabold text-gray-900 text-xs uppercase tracking-wider flex items-center gap-1.5">
                    <Sparkles className="w-4 h-4 text-hb-orange"/>
                    <span>Select a Sandbox Demo Account:</span>
                  </span>
                  <span className="text-[10px] text-hb-green-700 font-bold bg-hb-green-50 px-2 py-0.5 rounded-full border border-hb-green-200">
                    1-Click Instant Login
                  </span>
                </div>

                <div className="grid grid-cols-1 gap-3">
                  
                  {/* Option 1: Student Sandbox */}
                  <div className="p-4 rounded-2xl border-2 border-emerald-200 bg-emerald-50/40 hover:border-emerald-500 hover:bg-emerald-50 transition-all flex items-center justify-between gap-3 group">
                    <div className="flex items-center gap-3">
                      <div className="w-11 h-11 rounded-2xl bg-emerald-600 text-white flex items-center justify-center font-bold text-lg shadow-sm">
                        <User className="w-5 h-5"/>
                      </div>
                      <div>
                        <div className="flex items-center gap-2">
                          <h4 className="font-bold text-gray-900 text-sm">Customer / Student</h4>
                          <span className="px-2 py-0.2 rounded-full bg-emerald-100 text-emerald-800 text-[10px] font-bold">
                            Aarav Sharma
                          </span>
                        </div>
                        <p className="text-[11px] text-gray-600 mt-0.5">
                          SNIST Campus • Explore homemade meals, cart & dabba plans
                        </p>
                      </div>
                    </div>

                    <button type="button" disabled={isLoading} onClick={() => handleSandboxLogin('customer')} className="px-4 py-2.5 rounded-xl bg-emerald-600 hover:bg-emerald-700 text-white font-bold text-xs shadow-sm transition flex items-center gap-1 flex-shrink-0">
                      <span>Login</span>
                      <ArrowRight className="w-3.5 h-3.5"/>
                    </button>
                  </div>

                  {/* Option 2: Home Chef Sandbox */}
                  <div className="p-4 rounded-2xl border-2 border-orange-200 bg-orange-50/40 hover:border-orange-500 hover:bg-orange-50 transition-all flex items-center justify-between gap-3 group">
                    <div className="flex items-center gap-3">
                      <div className="w-11 h-11 rounded-2xl bg-hb-orange text-white flex items-center justify-center font-bold text-lg shadow-sm">
                        <ChefHat className="w-5 h-5"/>
                      </div>
                      <div>
                        <div className="flex items-center gap-2">
                          <h4 className="font-bold text-gray-900 text-sm">Home Chef / Provider</h4>
                          <span className="px-2 py-0.2 rounded-full bg-orange-100 text-orange-800 text-[10px] font-bold">
                            Anita Devi
                          </span>
                        </div>
                        <p className="text-[11px] text-gray-600 mt-0.5">
                          Anita Aunty's Kitchen • Accept kitchen orders & edit dishes
                        </p>
                      </div>
                    </div>

                    <button type="button" disabled={isLoading} onClick={() => handleSandboxLogin('chef')} className="px-4 py-2.5 rounded-xl bg-hb-orange hover:bg-orange-600 text-white font-bold text-xs shadow-sm transition flex items-center gap-1 flex-shrink-0">
                      <span>Login</span>
                      <ArrowRight className="w-3.5 h-3.5"/>
                    </button>
                  </div>

                  {/* Option 3: Delivery Partner Sandbox */}
                  <div className="p-4 rounded-2xl border-2 border-indigo-200 bg-indigo-50/40 hover:border-indigo-500 hover:bg-indigo-50 transition-all flex items-center justify-between gap-3 group">
                    <div className="flex items-center gap-3">
                      <div className="w-11 h-11 rounded-2xl bg-indigo-600 text-white flex items-center justify-center font-bold text-lg shadow-sm">
                        <Bike className="w-5 h-5"/>
                      </div>
                      <div>
                        <div className="flex items-center gap-2">
                          <h4 className="font-bold text-gray-900 text-sm">Delivery Partner / Rider</h4>
                          <span className="px-2 py-0.2 rounded-full bg-indigo-100 text-indigo-800 text-[10px] font-bold">
                            Ramesh Kumar
                          </span>
                        </div>
                        <p className="text-[11px] text-gray-600 mt-0.5">
                          TS 08 EF 4321 • Accept delivery assignments & track payouts
                        </p>
                      </div>
                    </div>

                    <button type="button" disabled={isLoading} onClick={() => handleSandboxLogin('delivery')} className="px-4 py-2.5 rounded-xl bg-indigo-600 hover:bg-indigo-700 text-white font-bold text-xs shadow-sm transition flex items-center gap-1 flex-shrink-0">
                      <span>Login</span>
                      <ArrowRight className="w-3.5 h-3.5"/>
                    </button>
                  </div>

                </div>

                {/* Optional Admin Sandbox Toggle */}
                <div className="mt-2.5 pt-2 flex items-center justify-between text-[11px] text-gray-500">
                  <span>Need platform administration access?</span>
                  <button type="button" onClick={() => handleSandboxLogin('admin')} className="font-bold text-purple-700 hover:text-purple-900 flex items-center gap-1">
                    <ShieldCheck className="w-3.5 h-3.5"/>
                    <span>Login as Admin</span>
                  </button>
                </div>
              </div>

              {/* Collapsible Manual Login */}
              <div className="pt-3 border-t border-gray-100">
                <button type="button" onClick={() => setShowManualLogin(!showManualLogin)} className="w-full text-center text-xs font-semibold text-gray-500 hover:text-gray-800 transition flex items-center justify-center gap-1.5 py-1">
                  <Lock className="w-3.5 h-3.5 text-gray-400"/>
                  <span>{showManualLogin ? 'Hide Custom Credentials Login' : 'Or Sign In with Email & Password'}</span>
                </button>

                {showManualLogin && (<form onSubmit={handleLoginSubmit} className="space-y-3 mt-3 animate-fadeIn">
                    <div className="space-y-1">
                      <label className="font-bold text-gray-700">Email Address</label>
                      <div className="relative">
                        <Mail className="w-4 h-4 text-gray-400 absolute left-3 top-1/2 -translate-y-1/2"/>
                        <input type="email" required value={email} onChange={(e) => setEmail(e.target.value)} placeholder="name@campus.ac.in" className="w-full pl-9 pr-3 py-2 rounded-xl border border-gray-200 outline-none focus:border-hb-green-500 text-gray-800"/>
                      </div>
                    </div>

                    <div className="space-y-1">
                      <div className="flex items-center justify-between">
                        <label className="font-bold text-gray-700">Password</label>
                        <button type="button" onClick={() => { setIsForgotPassword(true); setErrorMessage(''); }} className="text-[10px] font-bold text-hb-green-700 hover:underline">
                          Forgot Password?
                        </button>
                      </div>
                      <div className="relative">
                        <Lock className="w-4 h-4 text-gray-400 absolute left-3 top-1/2 -translate-y-1/2"/>
                        <input type={showPassword ? 'text' : 'password'} required value={password} onChange={(e) => setPassword(e.target.value)} placeholder="Enter password" className="w-full pl-9 pr-10 py-2 rounded-xl border border-gray-200 outline-none focus:border-hb-green-500 text-gray-800"/>
                        <button type="button" onClick={() => setShowPassword(!showPassword)} className="absolute right-3 top-1/2 -translate-y-1/2 text-gray-400 hover:text-gray-700">
                          {showPassword ? <EyeOff className="w-4 h-4"/> : <Eye className="w-4 h-4"/>}
                        </button>
                      </div>
                    </div>

                    <button type="submit" disabled={isLoading} className="w-full py-2.5 px-4 rounded-xl bg-gray-900 hover:bg-gray-800 text-white font-bold text-xs transition flex items-center justify-center gap-2">
                      {isLoading ? <Loader2 className="w-4 h-4 animate-spin"/> : <span>Sign In</span>}
                    </button>
                  </form>)}
              </div>

              <div className="text-center pt-3 border-t border-gray-100">
                <p className="text-gray-600">
                  New to HomeBite?{' '}
                  <button type="button" onClick={() => { setAuthMode('register'); setErrorMessage(''); }} className="font-bold text-hb-green-700 hover:underline">
                    Create a New Account
                  </button>
                </p>
              </div>

            </div>) : (
        /* REGISTRATION FORM WITH ROLE SELECTION */
        <form onSubmit={handleRegisterSubmit} className="space-y-5">
              
              {/* Role Selection Cards */}
              <div className="space-y-2">
                <label className="font-bold text-gray-800 block text-xs">
                  Select Your Account Type <span className="text-rose-500">*</span>
                </label>

                <div className="grid grid-cols-1 sm:grid-cols-3 gap-2.5">
                  {/* Option 1: Customer */}
                  <div onClick={() => setSelectedRole('customer')} className={`p-3 rounded-2xl border-2 cursor-pointer transition flex flex-col justify-between ${selectedRole === 'customer'
                ? 'border-hb-green-600 bg-hb-green-50/70 shadow-sm'
                : 'border-gray-200 hover:border-gray-300'}`}>
                    <div>
                      <div className="w-8 h-8 rounded-xl bg-hb-green-100 text-hb-green-700 flex items-center justify-center mb-2">
                        <User className="w-4 h-4"/>
                      </div>
                      <h4 className="font-bold text-gray-900 text-xs">Student / Customer</h4>
                      <p className="text-[10px] text-gray-500 mt-0.5 leading-snug">
                        Affordable daily meals & dabba plans
                      </p>
                    </div>
                  </div>

                  {/* Option 2: Chef */}
                  <div onClick={() => setSelectedRole('chef')} className={`p-3 rounded-2xl border-2 cursor-pointer transition flex flex-col justify-between ${selectedRole === 'chef'
                ? 'border-hb-green-600 bg-hb-green-50/70 shadow-sm'
                : 'border-gray-200 hover:border-gray-300'}`}>
                    <div>
                      <div className="w-8 h-8 rounded-xl bg-hb-orange-100 text-hb-orange-700 flex items-center justify-center mb-2">
                        <ChefHat className="w-4 h-4"/>
                      </div>
                      <h4 className="font-bold text-gray-900 text-xs">Home Chef / Cook</h4>
                      <p className="text-[10px] text-gray-500 mt-0.5 leading-snug">
                        Sell fresh homestyle food from home
                      </p>
                    </div>
                  </div>

                  {/* Option 3: Delivery */}
                  <div onClick={() => setSelectedRole('delivery')} className={`p-3 rounded-2xl border-2 cursor-pointer transition flex flex-col justify-between ${selectedRole === 'delivery'
                ? 'border-hb-green-600 bg-hb-green-50/70 shadow-sm'
                : 'border-gray-200 hover:border-gray-300'}`}>
                    <div>
                      <div className="w-8 h-8 rounded-xl bg-indigo-100 text-indigo-700 flex items-center justify-center mb-2">
                        <Bike className="w-4 h-4"/>
                      </div>
                      <h4 className="font-bold text-gray-900 text-xs">Delivery Partner</h4>
                      <p className="text-[10px] text-gray-500 mt-0.5 leading-snug">
                        Deliver meals & earn ₹45/trip + tips
                      </p>
                    </div>
                  </div>
                </div>

                {/* Explicit Admin Security Notice */}
                <div className="p-2.5 bg-gray-50 rounded-xl border border-gray-200 text-[10px] text-gray-500 flex items-center gap-1.5">
                  <ShieldCheck className="w-3.5 h-3.5 text-gray-400 flex-shrink-0"/>
                  <span>
                    <strong>Security Rule:</strong> Platform Administrator accounts are strictly managed by operations and cannot be self-registered.
                  </span>
                </div>
              </div>

              {/* General User Inputs */}
              <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
                <div className="space-y-1">
                  <label className="font-bold text-gray-700">Full Name</label>
                  <input type="text" required value={fullName} onChange={(e) => setFullName(e.target.value)} placeholder="e.g. Priya Sharma" className="w-full p-2.5 rounded-xl border border-gray-200 outline-none text-gray-800"/>
                </div>

                <div className="space-y-1">
                  <label className="font-bold text-gray-700">Phone Number</label>
                  <input type="tel" required value={phone} onChange={(e) => setPhone(e.target.value)} placeholder="+91 98765 00000" className="w-full p-2.5 rounded-xl border border-gray-200 outline-none text-gray-800"/>
                </div>
              </div>

              <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
                <div className="space-y-1">
                  <label className="font-bold text-gray-700">Email Address</label>
                  <input type="email" required value={email} onChange={(e) => setEmail(e.target.value)} placeholder="name@example.com" className="w-full p-2.5 rounded-xl border border-gray-200 outline-none text-gray-800"/>
                </div>

                <div className="space-y-1">
                  <label className="font-bold text-gray-700">Password (min 6 chars)</label>
                  <input type="password" required value={password} onChange={(e) => setPassword(e.target.value)} placeholder="Create a strong password" className="w-full p-2.5 rounded-xl border border-gray-200 outline-none text-gray-800"/>
                </div>
              </div>

              {/* Role-Specific Fields */}
              {selectedRole === 'customer' && (<div className="space-y-1 bg-hb-green-50/50 p-3 rounded-xl border border-hb-green-200">
                  <label className="font-bold text-gray-800">Campus / College / Workplace</label>
                  <input type="text" value={collegeOrWorkplace} onChange={(e) => setCollegeOrWorkplace(e.target.value)} placeholder="e.g. Delhi Technological University (DTU)" className="w-full p-2 rounded-lg border border-gray-200 outline-none bg-white text-gray-800"/>
                </div>)}

              {selectedRole === 'chef' && (<div className="grid grid-cols-1 sm:grid-cols-2 gap-3 bg-hb-orange-50/50 p-3 rounded-xl border border-hb-orange-200">
                  <div className="space-y-1">
                    <label className="font-bold text-gray-800">Kitchen Name</label>
                    <input type="text" required value={kitchenName} onChange={(e) => setKitchenName(e.target.value)} placeholder="e.g. Sunita Devi's Kitchen" className="w-full p-2 rounded-lg border border-gray-200 outline-none bg-white text-gray-800"/>
                  </div>
                  <div className="space-y-1">
                    <label className="font-bold text-gray-800">Specialty</label>
                    <input type="text" required value={specialty} onChange={(e) => setSpecialty(e.target.value)} placeholder="e.g. North Indian Thalis" className="w-full p-2 rounded-lg border border-gray-200 outline-none bg-white text-gray-800"/>
                  </div>
                </div>)}

              {selectedRole === 'delivery' && (<div className="space-y-1 bg-indigo-50/50 p-3 rounded-xl border border-indigo-200">
                  <label className="font-bold text-gray-800">Vehicle Model & Number</label>
                  <input type="text" required value={vehicleNumber} onChange={(e) => setVehicleNumber(e.target.value)} placeholder="e.g. DL 08 EF 4321 (Hero Splendor)" className="w-full p-2 rounded-lg border border-gray-200 outline-none bg-white text-gray-800"/>
                </div>)}

              <button type="submit" disabled={isLoading} className="w-full py-3 px-6 rounded-xl bg-hb-green-600 hover:bg-hb-green-700 text-white font-bold text-sm shadow-md transition flex items-center justify-center gap-2 disabled:opacity-75">
                {isLoading ? (<>
                    <Loader2 className="w-4 h-4 animate-spin"/>
                    <span>Creating Account & Setting Permissions...</span>
                  </>) : (<>
                    <span>Complete Registration ({selectedRole})</span>
                    <ArrowRight className="w-4 h-4"/>
                  </>)}
              </button>

              <div className="text-center pt-2 border-t border-gray-100">
                <p className="text-gray-600">
                  Already have an account?{' '}
                  <button type="button" onClick={() => { setAuthMode('login'); setErrorMessage(''); }} className="font-bold text-hb-green-700 hover:underline">
                    Sign In
                  </button>
                </p>
              </div>

            </form>)}

        </div>

      </div>
    </div>);
};

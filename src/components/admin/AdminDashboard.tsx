import React, { useState } from 'react';
import { useApp } from '../../context/AppContext';
import { 
  ShieldCheck, 
  Users, 
  ChefHat, 
  ShoppingBag, 
  DollarSign, 
  CheckCircle2, 
  XCircle, 
  MapPin, 
  AlertTriangle,
  FileText,
  Activity,
  ArrowRight,
  Compass,
  Phone,
  Check,
  Search
} from 'lucide-react';
import { CAMPUS_LOCATIONS } from '../../data/mockData';
import { DISCOVERED_REAL_BUSINESSES, LocalityInfo } from '../../data/discoveredAndDemoProviders';
import { FoodProvider } from '../../types';

export const AdminDashboard: React.FC = () => {
  const { 
    chefApplications, 
    approveChefApplication, 
    rejectChefApplication, 
    orders, 
    meals,
    setActiveView,
    logout,
    addToast
  } = useApp();

  const [activeTab, setActiveTab] = useState<'approvals' | 'discovered' | 'orders' | 'campuses'>('approvals');
  const [discoveredList, setDiscoveredList] = useState<FoodProvider[]>(DISCOVERED_REAL_BUSINESSES);
  const [zoneFilter, setZoneFilter] = useState<string>('all');
  const [statusFilter, setStatusFilter] = useState<string>('all');
  const [searchQuery, setSearchQuery] = useState<string>('');

  // Metrics
  const totalRevenue = 412580; // Gross marketplace volume
  const totalStudents = 3480;
  const totalChefs = 64;
  const pendingApprovals = chefApplications.filter(a => a.status === 'pending');

  const handleUpdateStatus = (id: string, newPartnership: 'contacted' | 'approved' | 'rejected') => {
    setDiscoveredList(prev => prev.map(p => {
      if (p.id === id) {
        return {
          ...p,
          partnershipStatus: newPartnership,
          status: newPartnership === 'approved' ? 'approved' : 'pending',
          isVerified: newPartnership === 'approved' ? true : p.isVerified
        };
      }
      return p;
    }));
    addToast(`Business listing status updated to "${newPartnership}"`, 'success');
  };

  const filteredDiscovered = discoveredList.filter(p => {
    if (zoneFilter !== 'all' && p.zone !== zoneFilter) return false;
    if (statusFilter !== 'all' && p.partnershipStatus !== statusFilter) return false;
    if (searchQuery.trim()) {
      const q = searchQuery.toLowerCase();
      if (!p.name.toLowerCase().includes(q) && !p.locality.toLowerCase().includes(q) && !p.address.toLowerCase().includes(q)) {
        return false;
      }
    }
    return true;
  });

  return (
    <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8 space-y-8 animate-fadeIn">
      
      {/* Admin Operations Header */}
      <div className="bg-white rounded-3xl p-6 sm:p-8 border border-hb-green-100 shadow-soft flex flex-col md:flex-row md:items-center justify-between gap-6">
        <div>
          <div className="flex items-center gap-2">
            <span className="px-3 py-1 rounded-full bg-hb-green-100 text-hb-green-800 text-xs font-black uppercase tracking-wider flex items-center gap-1.5">
              <ShieldCheck className="w-3.5 h-3.5" />
              <span>Platform Ops Console</span>
            </span>
          </div>
          <h1 className="text-2xl sm:text-3xl font-black text-gray-900 mt-2 font-display">
            HomeBite Central Command
          </h1>
          <p className="text-xs sm:text-sm text-gray-500 mt-1">
            Real-time campus order fulfillment, home chef FSSAI verifications & platform revenue telemetry.
          </p>
        </div>

        <div className="flex items-center gap-3">
          <button
            onClick={() => logout()}
            className="px-4 py-2.5 rounded-xl border border-rose-200 bg-rose-50 text-rose-700 hover:bg-rose-100 text-xs font-bold transition flex items-center gap-1.5"
          >
            <span>Exit Admin & Logout</span>
          </button>
        </div>
      </div>

      {/* KPI Overviews */}
      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6">
        <div className="bg-white p-6 rounded-3xl border border-hb-green-100 shadow-soft">
          <div className="flex items-center justify-between">
            <span className="text-xs font-bold text-gray-500 uppercase">Gross Platform Volume</span>
            <div className="w-9 h-9 rounded-xl bg-emerald-100 text-emerald-700 flex items-center justify-center font-bold text-sm">
              ₹
            </div>
          </div>
          <p className="text-3xl font-black text-gray-900 mt-3 font-display">₹{totalRevenue.toLocaleString()}</p>
          <span className="text-xs text-emerald-600 font-bold mt-1 block">↑ 24% vs last month</span>
        </div>

        <div className="bg-white p-6 rounded-3xl border border-hb-green-100 shadow-soft">
          <div className="flex items-center justify-between">
            <span className="text-xs font-bold text-gray-500 uppercase">Active Campus Students</span>
            <div className="w-9 h-9 rounded-xl bg-blue-100 text-blue-700 flex items-center justify-center">
              <Users className="w-4 h-4" />
            </div>
          </div>
          <p className="text-3xl font-black text-gray-900 mt-3 font-display">{totalStudents.toLocaleString()}</p>
          <span className="text-xs text-blue-600 font-bold mt-1 block">Across 7 university hubs</span>
        </div>

        <div className="bg-white p-6 rounded-3xl border border-hb-green-100 shadow-soft">
          <div className="flex items-center justify-between">
            <span className="text-xs font-bold text-gray-500 uppercase">Verified Home Kitchens</span>
            <div className="w-9 h-9 rounded-xl bg-amber-100 text-amber-700 flex items-center justify-center">
              <ChefHat className="w-4 h-4" />
            </div>
          </div>
          <p className="text-3xl font-black text-gray-900 mt-3 font-display">{totalChefs}</p>
          <span className="text-xs text-amber-700 font-bold mt-1 block">{pendingApprovals.length} pending audit</span>
        </div>

        <div className="bg-white p-6 rounded-3xl border border-hb-green-100 shadow-soft">
          <div className="flex items-center justify-between">
            <span className="text-xs font-bold text-gray-500 uppercase">Fulfilled Dabbas</span>
            <div className="w-9 h-9 rounded-xl bg-purple-100 text-purple-700 flex items-center justify-center">
              <ShoppingBag className="w-4 h-4" />
            </div>
          </div>
          <p className="text-3xl font-black text-gray-900 mt-3 font-display">12,490</p>
          <span className="text-xs text-purple-600 font-bold mt-1 block">99.4% on-time delivery</span>
        </div>
      </div>

      {/* Tabs */}
      <div className="flex items-center gap-2 border-b border-gray-200">
        <button
          onClick={() => setActiveTab('approvals')}
          className={`pb-3 px-4 text-xs font-bold transition border-b-2 flex items-center gap-2 ${
            activeTab === 'approvals'
              ? 'border-hb-green-600 text-hb-green-700'
              : 'border-transparent text-gray-500 hover:text-gray-800'
          }`}
        >
          <ShieldCheck className="w-4 h-4" />
          <span>Kitchen Verification Queue ({pendingApprovals.length})</span>
        </button>

        <button
          onClick={() => setActiveTab('discovered')}
          className={`pb-3 px-4 text-xs font-bold transition border-b-2 flex items-center gap-2 ${
            activeTab === 'discovered'
              ? 'border-hb-green-600 text-hb-green-700'
              : 'border-transparent text-gray-500 hover:text-gray-800'
          }`}
        >
          <Compass className="w-4 h-4" />
          <span>Discovered Food Businesses (55 Candidates)</span>
        </button>

        <button
          onClick={() => setActiveTab('orders')}
          className={`pb-3 px-4 text-xs font-bold transition border-b-2 flex items-center gap-2 ${
            activeTab === 'orders'
              ? 'border-hb-green-600 text-hb-green-700'
              : 'border-transparent text-gray-500 hover:text-gray-800'
          }`}
        >
          <Activity className="w-4 h-4" />
          <span>Live Platform Orders Stream</span>
        </button>

        <button
          onClick={() => setActiveTab('campuses')}
          className={`pb-3 px-4 text-xs font-bold transition border-b-2 flex items-center gap-2 ${
            activeTab === 'campuses'
              ? 'border-hb-green-600 text-hb-green-700'
              : 'border-transparent text-gray-500 hover:text-gray-800'
          }`}
        >
          <MapPin className="w-4 h-4" />
          <span>Campus Hub Status</span>
        </button>
      </div>

      {/* TAB 1: CHEF APPROVALS */}
      {activeTab === 'approvals' && (
        <div className="space-y-4">
          <div className="flex items-center justify-between">
            <h3 className="text-base font-bold text-gray-900">
              Pending Home Chef & Kitchen Verification Applications
            </h3>
            <span className="text-xs text-gray-500">
              Mandatory FSSAI, personal kitchen audit & water sample check
            </span>
          </div>

          <div className="space-y-4">
            {chefApplications.map((app) => (
              <div
                key={app.id}
                className="bg-white rounded-3xl p-6 border border-hb-green-100 shadow-soft flex flex-col md:flex-row md:items-center justify-between gap-4"
              >
                <div className="space-y-1.5">
                  <div className="flex items-center gap-2">
                    <h4 className="text-sm font-bold text-gray-900">{app.kitchenName}</h4>
                    <span className={`px-2.5 py-0.5 rounded-full text-[10px] font-bold uppercase ${
                      app.status === 'approved'
                        ? 'bg-emerald-100 text-emerald-800'
                        : app.status === 'rejected'
                        ? 'bg-rose-100 text-rose-800'
                        : 'bg-amber-100 text-amber-800'
                    }`}>
                      {app.status}
                    </span>
                  </div>

                  <p className="text-xs text-gray-600">
                    Applicant: <strong>{app.fullName}</strong> ({app.phone}) • Specialty: {app.specialty}
                  </p>
                  <p className="text-xs text-gray-500">
                    📍 Kitchen Address: {app.address}
                  </p>

                  <div className="flex items-center gap-3 pt-1 text-[11px] text-gray-600">
                    <span>FSSAI License: <strong className="font-mono text-gray-800">{app.fssaiNumber}</strong></span>
                    <span>•</span>
                    <span className="flex items-center gap-1">
                      <FileText className="w-3.5 h-3.5 text-hb-green-600" />
                      Hygiene Checklist: {app.hygieneChecklistCompleted ? 'Passed (18/18 checks)' : 'Pending audit'}
                    </span>
                  </div>
                </div>

                {/* Actions */}
                <div className="flex items-center gap-2 flex-shrink-0">
                  {app.status === 'pending' ? (
                    <>
                      <button
                        onClick={() => approveChefApplication(app.id)}
                        className="px-4 py-2 rounded-xl bg-emerald-600 hover:bg-emerald-700 text-white text-xs font-bold shadow-sm transition flex items-center gap-1.5"
                      >
                        <CheckCircle2 className="w-4 h-4" />
                        <span>Verify & Approve</span>
                      </button>
                      <button
                        onClick={() => rejectChefApplication(app.id)}
                        className="px-3 py-2 rounded-xl bg-rose-50 hover:bg-rose-100 text-rose-700 border border-rose-200 text-xs font-bold transition"
                      >
                        Reject
                      </button>
                    </>
                  ) : (
                    <span className="text-xs font-bold text-gray-500 italic">
                      Processed on {app.appliedDate}
                    </span>
                  )}
                </div>

              </div>
            ))}
          </div>
        </div>
      )}

      {/* TAB 1.5: DISCOVERED REAL BUSINESSES DIRECTORY */}
      {activeTab === 'discovered' && (
        <div className="space-y-5">
          <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-3">
            <div>
              <h3 className="text-base font-bold text-gray-900">
                Discovered Food Businesses & Research Directory (55 Candidates)
              </h3>
              <p className="text-xs text-gray-500 mt-0.5">
                Research listings across Telangana Zones. Only approved partners can receive customer orders.
              </p>
            </div>

            <div className="flex items-center gap-2">
              <span className="text-xs text-gray-500">Showing {filteredDiscovered.length} of {discoveredList.length}</span>
            </div>
          </div>

          {/* Directory Filter Bar */}
          <div className="bg-white rounded-2xl p-4 border border-hb-green-100 shadow-soft flex flex-col md:flex-row items-center gap-3">
            <div className="relative flex-1 w-full">
              <Search className="w-4 h-4 text-gray-400 absolute left-3 top-1/2 -translate-y-1/2" />
              <input
                type="text"
                value={searchQuery}
                onChange={(e) => setSearchQuery(e.target.value)}
                placeholder="Search business name, locality, street..."
                className="w-full pl-9 pr-3 py-2 text-xs rounded-xl border border-gray-200 outline-none focus:border-hb-green-500 text-gray-800"
              />
            </div>

            <div className="flex items-center gap-2 w-full md:w-auto">
              <select
                value={zoneFilter}
                onChange={(e) => setZoneFilter(e.target.value)}
                className="text-xs py-2 px-3 rounded-xl border border-gray-200 bg-white font-semibold text-gray-700 outline-none"
              >
                <option value="all">All Zones</option>
                <option value="zone_1_core">Zone 1 (Core SNIST 0-5km)</option>
                <option value="zone_2_nearby">Zone 2 (Nearby 5-12km)</option>
                <option value="zone_3_extended">Zone 3 (Extended 12-25km)</option>
                <option value="zone_4_hyderabad_wide">Zone 4 (Hyderabad Wide 25km+)</option>
              </select>

              <select
                value={statusFilter}
                onChange={(e) => setStatusFilter(e.target.value)}
                className="text-xs py-2 px-3 rounded-xl border border-gray-200 bg-white font-semibold text-gray-700 outline-none"
              >
                <option value="all">All Partnership Statuses</option>
                <option value="not_contacted">Not Contacted</option>
                <option value="contacted">Contacted / In Discussion</option>
                <option value="approved">Approved HomeBite Partner</option>
              </select>
            </div>
          </div>

          {/* Businesses List */}
          <div className="space-y-3">
            {filteredDiscovered.map((b) => (
              <div
                key={b.id}
                className="bg-white rounded-2xl p-4 border border-gray-200 shadow-2xs hover:border-hb-green-300 transition flex flex-col lg:flex-row lg:items-center justify-between gap-4"
              >
                <div className="space-y-1">
                  <div className="flex items-center gap-2 flex-wrap">
                    <h4 className="text-sm font-black text-gray-900">{b.name}</h4>
                    <span className="px-2 py-0.5 rounded-md bg-gray-100 text-gray-700 text-[10px] font-bold">
                      {b.locality}
                    </span>
                    <span className="px-2 py-0.5 rounded-md bg-hb-cream text-hb-green-800 text-[10px] font-bold capitalize">
                      {b.type.replace(/_/g, ' ')}
                    </span>
                    <span className={`px-2 py-0.5 rounded-md text-[10px] font-bold uppercase ${
                      b.partnershipStatus === 'approved'
                        ? 'bg-emerald-100 text-emerald-800'
                        : b.partnershipStatus === 'contacted'
                        ? 'bg-blue-100 text-blue-800'
                        : 'bg-gray-100 text-gray-600'
                    }`}>
                      {(b.partnershipStatus || 'not_contacted').replace(/_/g, ' ')}
                    </span>
                  </div>

                  <p className="text-xs text-gray-600">{b.description}</p>
                  <p className="text-[11px] text-gray-500">📍 {b.address} • Coordinates: {b.lat.toFixed(4)}, {b.lon.toFixed(4)}</p>
                </div>

                {/* Partner Management Actions */}
                <div className="flex items-center gap-2 flex-shrink-0">
                  {b.partnershipStatus !== 'contacted' && b.partnershipStatus !== 'approved' && (
                    <button
                      onClick={() => handleUpdateStatus(b.id, 'contacted')}
                      className="px-3 py-1.5 rounded-xl border border-blue-200 bg-blue-50 hover:bg-blue-100 text-blue-700 text-xs font-bold transition"
                    >
                      Mark Contacted
                    </button>
                  )}

                  {b.partnershipStatus !== 'approved' ? (
                    <button
                      onClick={() => handleUpdateStatus(b.id, 'approved')}
                      className="px-3 py-1.5 rounded-xl bg-hb-green-600 hover:bg-hb-green-700 text-white text-xs font-bold transition flex items-center gap-1 shadow-2xs"
                    >
                      <Check className="w-3.5 h-3.5" />
                      <span>Approve as Partner</span>
                    </button>
                  ) : (
                    <span className="px-3 py-1.5 rounded-xl bg-emerald-50 text-emerald-800 text-xs font-bold border border-emerald-200 flex items-center gap-1">
                      <CheckCircle2 className="w-3.5 h-3.5 text-emerald-600" />
                      <span>Verified Partner (Ordering Enabled)</span>
                    </span>
                  )}
                </div>
              </div>
            ))}
          </div>

        </div>
      )}

      {/* TAB 2: LIVE ORDERS MONITOR */}
      {activeTab === 'orders' && (
        <div className="bg-white rounded-3xl p-6 border border-hb-green-100 shadow-soft space-y-4">
          <h3 className="text-base font-bold text-gray-900">
            Platform Orders Log & Live Pipeline
          </h3>

          <div className="overflow-x-auto">
            <table className="w-full text-left text-xs">
              <thead className="bg-gray-50 text-gray-500 uppercase text-[10px] font-bold border-b border-gray-100">
                <tr>
                  <th className="p-3">Order ID</th>
                  <th className="p-3">Student</th>
                  <th className="p-3">Home Chef</th>
                  <th className="p-3">Campus</th>
                  <th className="p-3">Amount</th>
                  <th className="p-3">Status</th>
                  <th className="p-3">Time</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-gray-100">
                {orders.map((o) => (
                  <tr key={o.id} className="hover:bg-gray-50/60">
                    <td className="p-3 font-mono font-bold text-hb-green-800">{o.id}</td>
                    <td className="p-3 font-semibold text-gray-900">{o.customerName}</td>
                    <td className="p-3 text-gray-700">{o.kitchenName}</td>
                    <td className="p-3 text-gray-600">{o.collegeOrWorkplace.split(',')[0]}</td>
                    <td className="p-3 font-bold text-gray-900">₹{o.totalAmount}</td>
                    <td className="p-3">
                      <span className="px-2 py-0.5 rounded-full text-[10px] font-bold bg-hb-green-100 text-hb-green-800 capitalize">
                        {o.status.replace(/_/g, ' ')}
                      </span>
                    </td>
                    <td className="p-3 text-gray-400">
                      {new Date(o.createdAt).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })}
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </div>
      )}

      {/* TAB 3: CAMPUSES */}
      {activeTab === 'campuses' && (
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          {CAMPUS_LOCATIONS.map((c) => (
            <div key={c.name} className="bg-white p-6 rounded-3xl border border-hb-green-100 shadow-soft space-y-3">
              <div className="flex items-center justify-between">
                <span className="text-xs font-bold text-hb-green-700 bg-hb-green-50 px-2.5 py-0.5 rounded-full border border-hb-green-200">
                  📍 {c.city}
                </span>
                <span className="text-xs font-bold text-emerald-600">Active Zone</span>
              </div>
              <h4 className="text-base font-bold text-gray-900">{c.name}</h4>
              <div className="text-xs text-gray-600 space-y-1">
                <p>Verified Kitchens: <strong>{c.activeChefs} Home Chefs</strong></p>
                <p>Average Delivery Time: <strong>~{c.avgDeliveryMins} mins</strong></p>
                <p>Hostel Gates Covered: <strong>100% Doorstep Access</strong></p>
              </div>
            </div>
          ))}
        </div>
      )}

    </div>
  );
};


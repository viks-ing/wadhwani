import React from 'react';
import { useApp } from '../../context/AppContext';
import { Star, MapPin, Clock, ShieldCheck, ExternalLink, Info, ArrowRight, Sparkles, Utensils } from 'lucide-react';
export const FoodProviderCard = ({ provider }) => {
    const { currentCampus, openProviderMenu } = useApp();
    const isPartner = provider.partnershipStatus === 'approved';
    const menuItems = provider.menu || [];
    const getProviderTypeBadge = (type) => {
        switch (type) {
            case 'home_kitchen':
                return { label: '🏡 Home Kitchen', color: 'bg-emerald-700 text-white' };
            case 'cloud_kitchen':
                return { label: '☁️ Cloud Kitchen', color: 'bg-indigo-700 text-white' };
            case 'tiffin_service':
                return { label: '🍲 Tiffin Service', color: 'bg-amber-600 text-white' };
            case 'healthy_restaurant':
                return { label: '🥗 Healthy Restaurant', color: 'bg-teal-700 text-white' };
            default:
                return { label: '🍽️ Food Provider', color: 'bg-gray-700 text-white' };
        }
    };
    const typeBadge = getProviderTypeBadge(provider.type);
    // Determine menu status pill
    const firstItem = menuItems[0];
    const isSampleMenu = !isPartner || firstItem?.menuStatus === 'sample' || provider.isDemo;
    return (<div className={`bg-white rounded-3xl border transition-all duration-300 overflow-hidden flex flex-col justify-between group shadow-soft hover:shadow-card hover:-translate-y-1 ${isPartner ? 'border-hb-green-200' : 'border-gray-200/90 bg-gray-50/20'}`}>
      <div>
        
        {/* Cover Image & Badges */}
        <div onClick={() => openProviderMenu(provider)} className="relative h-48 overflow-hidden bg-gray-100 cursor-pointer">
          <img src={provider.coverImage} alt={provider.name} className="w-full h-full object-cover group-hover:scale-105 transition-transform duration-500"/>

          {/* Top Badges */}
          <div className="absolute top-3 left-3 flex flex-wrap items-center gap-1.5">
            <span className={`px-2.5 py-1 rounded-xl text-[10px] font-black shadow-sm ${typeBadge.color}`}>
              {typeBadge.label}
            </span>

            {isPartner ? (<span className="px-2.5 py-1 rounded-xl bg-hb-green-600 text-white text-[10px] font-extrabold flex items-center gap-1 shadow-sm">
                <ShieldCheck className="w-3 h-3 text-emerald-200"/>
                <span>HomeBite Partner</span>
              </span>) : (<span className="px-2.5 py-1 rounded-xl bg-gray-900/85 backdrop-blur-md text-amber-200 text-[10px] font-bold flex items-center gap-1 shadow-sm border border-amber-500/20">
                <Info className="w-3 h-3 text-amber-400"/>
                <span>Discovered Candidate</span>
              </span>)}
          </div>

          {/* Rating */}
          <div className="absolute top-3 right-3 bg-white/95 backdrop-blur px-2.5 py-1 rounded-xl text-xs font-black text-gray-900 flex items-center gap-1 shadow-sm">
            <Star className="w-3.5 h-3.5 text-amber-500 fill-amber-500"/>
            <span>{provider.rating.toFixed(1)}</span>
            <span className="text-[10px] text-gray-400 font-normal">({provider.reviewsCount})</span>
          </div>

          {/* Distance Pill */}
          <div className="absolute bottom-3 left-3 bg-black/75 backdrop-blur-md text-white text-[10px] font-semibold px-2.5 py-1 rounded-lg flex items-center gap-1.5 shadow-sm">
            <MapPin className="w-3 h-3 text-hb-orange"/>
            <span>
              <strong>{provider.distanceKm} km</strong> from {currentCampus ? currentCampus.split(',')[0].trim() : 'SNIST'}
            </span>
          </div>

          {/* Prep Time Pill */}
          <div className="absolute bottom-3 right-3 bg-black/75 backdrop-blur-md text-white text-[10px] font-semibold px-2.5 py-1 rounded-lg flex items-center gap-1 shadow-sm">
            <Clock className="w-3 h-3 text-emerald-400"/>
            <span>~{provider.prepTimeMinutes} mins</span>
          </div>
        </div>

        {/* Content Body */}
        <div className="p-5 space-y-3">
          
          <div>
            <div onClick={() => openProviderMenu(provider)} className="flex items-start justify-between gap-2 cursor-pointer">
              <h3 className="text-base font-extrabold text-gray-900 group-hover:text-hb-green-700 transition leading-snug">
                {provider.name}
              </h3>
            </div>
            <p className="text-xs text-gray-500 flex items-center gap-1 mt-0.5">
              <MapPin className="w-3 h-3 text-gray-400 flex-shrink-0"/>
              <span className="truncate">{provider.address}</span>
            </p>
          </div>

          <p className="text-xs text-gray-600 line-clamp-2 leading-relaxed">
            {provider.description}
          </p>

          {/* Cuisine Pills */}
          <div className="flex flex-wrap items-center gap-1">
            {provider.cuisine.map((c, i) => (<span key={i} className="px-2 py-0.5 rounded-lg bg-hb-cream text-hb-green-800 text-[10px] font-semibold border border-hb-green-100">
                {c}
              </span>))}
          </div>

          {/* Menu Type Tag */}
          <div className="pt-1">
            {isSampleMenu ? (<span className="inline-flex items-center gap-1 px-2.5 py-0.5 rounded-full bg-purple-50 text-purple-800 text-[10px] font-bold border border-purple-200">
                <Sparkles className="w-3 h-3 text-purple-600"/>
                <span>Sample Menu ({menuItems.length} items)</span>
              </span>) : (<span className="inline-flex items-center gap-1 px-2.5 py-0.5 rounded-full bg-emerald-50 text-emerald-800 text-[10px] font-bold border border-emerald-200">
                <Utensils className="w-3 h-3 text-emerald-600"/>
                <span>Restaurant Menu ({menuItems.length} items)</span>
              </span>)}
          </div>

        </div>
      </div>

      {/* Card Footer & Ordering Action */}
      <div className="p-5 pt-0 space-y-3">
        
        {/* Price & View Menu Row */}
        <div className="flex items-center justify-between pt-3 border-t border-gray-100">
          <div>
            <span className="text-[10px] text-gray-500 uppercase tracking-wider block font-bold">
              Starts From
            </span>
            <span className="text-base font-black text-gray-900">
              ₹{provider.minOrderAmount}
            </span>
          </div>

          {/* Direct Redirection to Restaurant Menu Page */}
          <button type="button" onClick={() => openProviderMenu(provider)} className="px-4 py-2 rounded-xl bg-hb-green-600 hover:bg-hb-green-700 text-white text-xs font-black transition flex items-center gap-1.5 shadow-xs group-hover:bg-hb-green-700">
            <span>View Menu</span>
            <ArrowRight className="w-3.5 h-3.5 group-hover:translate-x-0.5 transition-transform"/>
          </button>
        </div>

        {/* Discovery candidate external link */}
        {!isPartner && (<div className="pt-2 border-t border-gray-100 flex items-center justify-between gap-2">
            <span className="text-[10px] text-gray-400 flex items-center gap-1">
              <Info className="w-3 h-3 text-amber-500 flex-shrink-0"/>
              <span>Preview listing</span>
            </span>

            <a href={`https://www.google.com/maps/search/?api=1&query=${encodeURIComponent(`${provider.name} ${provider.address}`)}`} target="_blank" rel="noopener noreferrer" className="py-1 px-2 rounded-lg border border-gray-200 bg-white hover:bg-gray-50 text-gray-600 text-[10px] font-semibold transition flex items-center gap-1">
              <span>Maps</span>
              <ExternalLink className="w-2.5 h-2.5 text-gray-400"/>
            </a>
          </div>)}

      </div>
    </div>);
};

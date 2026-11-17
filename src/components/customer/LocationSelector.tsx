import React, { useState, useRef, useEffect } from 'react';
import { MapPin, Navigation, Compass, ChevronDown, Check, Sparkles, Loader2, X } from 'lucide-react';
import { useApp } from '../../context/AppContext';
import { HYDERABAD_LOCALITIES, LocalityInfo } from '../../data/discoveredAndDemoProviders';
import { LatLon } from '../../lib/geoService';

interface LocationSelectorProps {
  onLocationChanged?: (localityName: string, coords: LatLon) => void;
  compact?: boolean;
}

export const LocationSelector: React.FC<LocationSelectorProps> = ({
  onLocationChanged,
  compact = false
}) => {
  const { currentCampus, setCurrentCampus, userCoords, setUserCoords, detectAndSetLocation, isLocating, addToast } = useApp();
  
  const [isOpen, setIsOpen] = useState(false);
  const [searchQuery, setSearchQuery] = useState('');
  const dropdownRef = useRef<HTMLDivElement>(null);

  // Close dropdown on outside click
  useEffect(() => {
    const handleClickOutside = (e: MouseEvent) => {
      if (dropdownRef.current && !dropdownRef.current.contains(e.target as Node)) {
        setIsOpen(false);
      }
    };
    document.addEventListener('mousedown', handleClickOutside);
    return () => document.removeEventListener('mousedown', handleClickOutside);
  }, []);

  const handleSelectLocality = (loc: LocalityInfo) => {
    const coords: LatLon = { lat: loc.lat, lon: loc.lon };
    setCurrentCampus(loc.name);
    setUserCoords(coords);
    setIsOpen(false);
    setSearchQuery('');
    addToast(`📍 Location switched to ${loc.name}! Feed updated.`, 'success');
    if (onLocationChanged) onLocationChanged(loc.name, coords);
  };

  const handleUseGPS = async () => {
    setIsOpen(false);
    await detectAndSetLocation();
  };

  const filteredLocalities = HYDERABAD_LOCALITIES.filter(loc => 
    loc.name.toLowerCase().includes(searchQuery.toLowerCase()) ||
    loc.description.toLowerCase().includes(searchQuery.toLowerCase())
  );

  return (
    <div className="relative inline-block text-left w-full sm:w-auto" ref={dropdownRef}>
      
      {/* Trigger Button */}
      <button
        type="button"
        onClick={() => setIsOpen(!isOpen)}
        className={`flex items-center justify-between gap-2.5 px-4 py-2.5 rounded-2xl bg-white border border-hb-green-200 hover:border-hb-green-500 shadow-soft hover:shadow-md transition group w-full sm:w-auto ${
          compact ? 'text-xs' : 'text-xs sm:text-sm'
        }`}
      >
        <div className="flex items-center gap-2 truncate">
          <div className="w-6 h-6 rounded-lg bg-hb-green-50 text-hb-green-600 flex items-center justify-center flex-shrink-0 border border-hb-green-200">
            <MapPin className="w-3.5 h-3.5" />
          </div>
          <div className="text-left truncate">
            <span className="block text-[10px] text-gray-500 uppercase tracking-wider font-bold">
              Delivering Near
            </span>
            <span className="block font-black text-gray-900 truncate max-w-[200px] sm:max-w-[260px]">
              {currentCampus || "SNIST Campus, Yamnampet"}
            </span>
          </div>
        </div>
        <ChevronDown className={`w-4 h-4 text-gray-400 group-hover:text-hb-green-600 transition-transform ${isOpen ? 'rotate-180' : ''}`} />
      </button>

      {/* Dropdown Menu */}
      {isOpen && (
        <div className="absolute left-0 mt-2 w-80 sm:w-96 rounded-3xl bg-white shadow-2xl border border-hb-green-100 z-50 overflow-hidden animate-fadeIn">
          
          {/* Header & Search */}
          <div className="p-4 bg-hb-cream border-b border-hb-green-100 space-y-3">
            <div className="flex items-center justify-between">
              <span className="text-xs font-black text-gray-900 flex items-center gap-1.5">
                <Compass className="w-4 h-4 text-hb-green-700" />
                <span>Select Your Location</span>
              </span>
              <button
                type="button"
                onClick={() => setIsOpen(false)}
                className="p-1 rounded-full text-gray-400 hover:text-gray-700 hover:bg-gray-200/50"
              >
                <X className="w-4 h-4" />
              </button>
            </div>

            {/* GPS 1-Click Action */}
            <button
              type="button"
              onClick={handleUseGPS}
              disabled={isLocating}
              className="w-full py-2.5 px-3.5 rounded-xl bg-gradient-to-r from-hb-green-600 to-hb-green-700 text-white font-bold text-xs shadow-sm hover:from-hb-green-700 hover:to-hb-green-800 transition flex items-center justify-center gap-2 cursor-pointer disabled:opacity-70"
            >
              {isLocating ? (
                <>
                  <Loader2 className="w-3.5 h-3.5 animate-spin" />
                  <span>Detecting GPS Location...</span>
                </>
              ) : (
                <>
                  <Navigation className="w-3.5 h-3.5" />
                  <span>Use My Current Live Location (GPS)</span>
                </>
              )}
            </button>

            {/* Filter Input */}
            <input
              type="text"
              value={searchQuery}
              onChange={(e) => setSearchQuery(e.target.value)}
              placeholder="Search SNIST, Ghatkesar, Boduppal, Uppal..."
              className="w-full px-3 py-2 text-xs rounded-xl border border-gray-200 bg-white text-gray-800 outline-none focus:border-hb-green-500 shadow-xs"
            />
          </div>

          {/* Localities List */}
          <div className="max-h-72 overflow-y-auto p-2 space-y-1">
            <div className="px-3 py-1 text-[10px] font-bold text-gray-500 uppercase tracking-wider">
              Popular Telangana & Hyderabad Localities
            </div>

            {filteredLocalities.length === 0 ? (
              <div className="p-4 text-center text-xs text-gray-500">
                No matching locations found. Try "SNIST", "Ghatkesar" or "Uppal".
              </div>
            ) : (
              filteredLocalities.map((loc) => {
                const isSelected = currentCampus === loc.name;
                const isCore = loc.zone === 'zone_1_core';

                return (
                  <button
                    key={loc.name}
                    type="button"
                    onClick={() => handleSelectLocality(loc)}
                    className={`w-full text-left p-3 rounded-2xl transition flex items-start justify-between gap-2 ${
                      isSelected 
                        ? 'bg-hb-green-50 border border-hb-green-300' 
                        : 'hover:bg-gray-50'
                    }`}
                  >
                    <div className="flex items-start gap-2.5">
                      <div className={`w-7 h-7 rounded-xl flex items-center justify-center flex-shrink-0 mt-0.5 ${
                        isCore 
                          ? 'bg-emerald-100 text-emerald-800' 
                          : 'bg-gray-100 text-gray-600'
                      }`}>
                        <MapPin className="w-3.5 h-3.5" />
                      </div>
                      <div>
                        <div className="flex items-center gap-1.5">
                          <span className="font-extrabold text-xs text-gray-900">{loc.name}</span>
                          {isCore && (
                            <span className="px-1.5 py-0.2 rounded-md bg-emerald-600 text-white text-[9px] font-bold">
                              Core (SNIST)
                            </span>
                          )}
                        </div>
                        <p className="text-[11px] text-gray-500 leading-tight mt-0.5">
                          {loc.description}
                        </p>
                      </div>
                    </div>
                    {isSelected && (
                      <Check className="w-4 h-4 text-hb-green-700 flex-shrink-0 mt-1" />
                    )}
                  </button>
                );
              })
            )}
          </div>

        </div>
      )}

    </div>
  );
};

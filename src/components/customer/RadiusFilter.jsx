import React from 'react';
import { Compass } from 'lucide-react';
const RADIUS_OPTIONS = [
    { km: 1, label: '1 km', badge: 'Walking / Gate' },
    { km: 3, label: '3 km', badge: 'Local Hub' },
    { km: 5, label: '5 km', badge: 'Standard' },
    { km: 10, label: '10 km', badge: 'Extended' },
    { km: 15, label: '15 km', badge: 'Metro Suburbs' },
    { km: 25, label: '25 km', badge: 'Hyderabad Wide' },
];
export const RadiusFilter = ({ selectedRadiusKm, onRadiusChange, }) => {
    return (<div className="flex items-center gap-1.5 overflow-x-auto pb-1 scrollbar-none">
      <div className="flex items-center gap-1 text-[11px] font-bold text-gray-500 uppercase tracking-wider mr-1 flex-shrink-0">
        <Compass className="w-3.5 h-3.5 text-hb-green-600"/>
        <span>Radius:</span>
      </div>

      {RADIUS_OPTIONS.map((opt) => {
            const isActive = selectedRadiusKm === opt.km;
            return (<button key={opt.km} type="button" onClick={() => onRadiusChange(opt.km)} className={`px-3 py-1.5 rounded-xl text-xs font-bold transition flex items-center gap-1.5 flex-shrink-0 ${isActive
                    ? 'bg-hb-green-600 text-white shadow-sm ring-2 ring-hb-green-600/30'
                    : 'bg-white hover:bg-gray-50 text-gray-700 border border-gray-200'}`}>
            <span>{opt.label}</span>
            {opt.km === 5 && (<span className={`text-[9px] px-1 py-0.2 rounded font-extrabold ${isActive ? 'bg-white/25 text-white' : 'bg-hb-cream text-hb-green-800'}`}>
                Default
              </span>)}
          </button>);
        })}
    </div>);
};

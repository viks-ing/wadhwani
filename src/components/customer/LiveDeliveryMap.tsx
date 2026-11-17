import React, { useEffect, useRef, useState, useMemo } from 'react';
import L from 'leaflet';
import { Order } from '../../types';
import { LatLon, haversineKm } from '../../lib/geoService';
import { ALL_FOOD_PROVIDERS } from '../../data/discoveredAndDemoProviders';
import { SYNTHETIC_PROVIDERS } from '../../data/syntheticProvidersData';
import { 
  Bike, 
  MapPin, 
  ChefHat, 
  Navigation, 
  Route, 
  Zap, 
  Compass,
  CheckCircle2,
  Clock,
  Phone
} from 'lucide-react';

interface LiveDeliveryMapProps {
  order: Order;
  currentCampus: string;
  userCoords?: LatLon | null;
}

// Generate realistic street waypoints between start and end GPS coordinates
function generateStreetWaypoints(start: [number, number], end: [number, number], segments = 7): [number, number][] {
  const points: [number, number][] = [start];
  const dLat = end[0] - start[0];
  const dLon = end[1] - start[1];
  
  // Normal vector for gentle road curve
  const normLat = -dLon;
  const normLon = dLat;
  const length = Math.sqrt(normLat * normLat + normLon * normLon) || 1;
  const unitNormLat = normLat / length;
  const unitNormLon = normLon / length;
  
  for (let i = 1; i < segments; i++) {
    const fraction = i / segments;
    const baseLat = start[0] + dLat * fraction;
    const baseLon = start[1] + dLon * fraction;
    
    // Road sinusoidal curvature
    const curveAmount = Math.sin(fraction * Math.PI) * 0.0016 * (i % 2 === 0 ? 1 : -0.75);
    points.push([
      baseLat + unitNormLat * curveAmount,
      baseLon + unitNormLon * curveAmount
    ]);
  }
  points.push(end);
  return points;
}

export const LiveDeliveryMap: React.FC<LiveDeliveryMapProps> = ({ order, currentCampus, userCoords }) => {
  const mapContainerRef = useRef<HTMLDivElement>(null);
  const mapInstanceRef = useRef<L.Map | null>(null);
  const riderMarkerRef = useRef<L.Marker | null>(null);
  const completedPolylineRef = useRef<L.Polyline | null>(null);
  const remainingPolylineRef = useRef<L.Polyline | null>(null);

  // 1. Dynamically resolve food provider & kitchen GPS
  const provider = useMemo(() => {
    if (order.chefId) {
      const found = ALL_FOOD_PROVIDERS.find(p => p.id === order.chefId) ||
                    SYNTHETIC_PROVIDERS.find(p => p.id === order.chefId);
      if (found) return found;
    }
    if (order.kitchenName) {
      const norm = order.kitchenName.toLowerCase().trim();
      const found = ALL_FOOD_PROVIDERS.find(p => p.name.toLowerCase().trim() === norm || p.name.toLowerCase().includes(norm)) ||
                    SYNTHETIC_PROVIDERS.find(p => p.name.toLowerCase().trim() === norm || p.name.toLowerCase().includes(norm));
      if (found) return found;
    }
    return null;
  }, [order.chefId, order.kitchenName]);

  // 2. Dynamically resolve Customer Drop GPS coordinates
  const customerPos = useMemo<[number, number]>(() => {
    if (userCoords && userCoords.lat && userCoords.lon) {
      return [userCoords.lat, userCoords.lon];
    }
    const text = `${currentCampus} ${order.collegeOrWorkplace || ''} ${order.deliveryAddress || ''}`.toLowerCase();
    if (text.includes('snist') || text.includes('sreenidhi') || text.includes('yamnampet')) {
      return [17.4578, 78.6385]; // SNIST Campus Hub
    }
    if (text.includes('ghatkesar')) {
      return [17.4435, 78.6821];
    }
    if (text.includes('narapally')) {
      return [17.4285, 78.6255];
    }
    if (text.includes('peerzadiguda')) {
      return [17.4118, 78.5885];
    }
    if (text.includes('boduppal')) {
      return [17.4135, 78.5795];
    }
    if (text.includes('uppal')) {
      return [17.4010, 78.5588];
    }
    if (text.includes('gachibowli')) {
      return [17.4401, 78.3489];
    }
    if (text.includes('kukatpally')) {
      return [17.4948, 78.3996];
    }
    if (text.includes('meerpet')) {
      return [17.3297, 78.5332];
    }
    // Default to SNIST Campus Gate
    return [17.4578, 78.6385];
  }, [userCoords, currentCampus, order.collegeOrWorkplace, order.deliveryAddress]);

  // 3. Resolve Kitchen GPS coordinates
  const kitchenPos = useMemo<[number, number]>(() => {
    if (provider && provider.lat && provider.lon) {
      return [provider.lat, provider.lon];
    }
    // Realistic fallback offset: ~1.2 km north-west in local area
    return [customerPos[0] + 0.0088, customerPos[1] - 0.0076];
  }, [provider, customerPos]);

  // 4. Calculate actual Haversine distance
  const calculatedDistanceKm = useMemo(() => {
    const rawDist = haversineKm(
      { lat: kitchenPos[0], lon: kitchenPos[1] },
      { lat: customerPos[0], lon: customerPos[1] }
    );
    // Minimum delivery radius via streets is 0.8 km
    return Math.max(0.8, Number(rawDist.toFixed(1)));
  }, [kitchenPos, customerPos]);

  // Dynamic Waypoints between actual GPS points
  const waypoints = useMemo(() => {
    return generateStreetWaypoints(kitchenPos, customerPos, 8);
  }, [kitchenPos, customerPos]);

  // Route progress mapped to order status
  const [routeProgress, setRouteProgress] = useState<number>(() => {
    switch (order.status) {
      case 'order_placed': return 0.05;
      case 'chef_preparing': return 0.20;
      case 'ready_for_pickup': return 0.40;
      case 'out_for_delivery': return 0.65;
      case 'delivered': return 1.0;
      default: return 0.5;
    }
  });

  const [riderSpeed, setRiderSpeed] = useState<number>(() => {
    return order.status === 'out_for_delivery' ? 28 : 0;
  });

  // Sync route progress whenever order status changes
  useEffect(() => {
    switch (order.status) {
      case 'order_placed':
        setRouteProgress(0.05);
        setRiderSpeed(0);
        break;
      case 'chef_preparing':
        setRouteProgress(0.20);
        setRiderSpeed(0);
        break;
      case 'ready_for_pickup':
        setRouteProgress(0.40);
        setRiderSpeed(0);
        break;
      case 'out_for_delivery':
        setRouteProgress((prev) => (prev < 0.45 ? 0.60 : prev));
        setRiderSpeed(28);
        break;
      case 'delivered':
        setRouteProgress(1.0);
        setRiderSpeed(0);
        break;
    }
  }, [order.status]);

  // Live GPS movement simulation during "out_for_delivery"
  useEffect(() => {
    if (order.status !== 'out_for_delivery') return;

    const interval = setInterval(() => {
      setRouteProgress((prev) => {
        if (prev >= 0.96) return 0.60;
        return Number((prev + 0.015).toFixed(3));
      });
      setRiderSpeed(Math.floor(24 + Math.random() * 8));
    }, 1100);

    return () => clearInterval(interval);
  }, [order.status]);

  // Interpolate rider lat/lon along waypoints
  const getInterpolatedLatLng = (progress: number): [number, number] => {
    const clamped = Math.max(0, Math.min(1, progress));
    const totalSegments = waypoints.length - 1;
    const segmentIndex = Math.min(Math.floor(clamped * totalSegments), totalSegments - 1);
    const segmentProgress = (clamped * totalSegments) - segmentIndex;

    const p0 = waypoints[segmentIndex];
    const p1 = waypoints[segmentIndex + 1];

    const lat = p0[0] + (p1[0] - p0[0]) * segmentProgress;
    const lng = p0[1] + (p1[1] - p0[1]) * segmentProgress;
    return [lat, lng];
  };

  const riderLatLng = getInterpolatedLatLng(routeProgress);

  // Dynamic Labels
  const kitchenLabel = provider?.name || order.kitchenName || 'Home Kitchen';
  const kitchenAddress = provider?.address || 'SNIST / Yamnampet, Telangana';
  const destinationLabel = (currentCampus || order.collegeOrWorkplace || order.deliveryAddress || 'Campus Gate').split(',')[0].trim();
  const deliveryAddressSnippet = order.deliveryAddress || `${destinationLabel}, Campus Gate`;
  
  // Dynamic Delivery Partner
  const riderName = order.deliveryPartner?.name || 'Ramesh Kumar';
  const riderPhone = order.deliveryPartner?.phone || '+91 98711 00223';
  const riderVehicle = order.deliveryPartner?.vehicleNumber || 'TS 08 EF 4321 (Hero Splendor)';
  const riderRating = order.deliveryPartner?.rating || 4.9;

  // Dynamic Distances & Time
  const remainingDistanceKm = Math.max(0, Number((calculatedDistanceKm * (1 - routeProgress)).toFixed(1)));
  const prepTime = provider?.prepTimeMinutes || 20;
  const remainingMins = useMemo(() => {
    if (order.status === 'delivered') return 0;
    if (order.status === 'order_placed') return prepTime + Math.round(calculatedDistanceKm * 3);
    if (order.status === 'chef_preparing') return Math.max(10, Math.round(prepTime * 0.6) + Math.round(calculatedDistanceKm * 3));
    if (order.status === 'ready_for_pickup') return Math.max(5, Math.round(calculatedDistanceKm * 3.5));
    // out_for_delivery
    return Math.max(1, Math.round(remainingDistanceKm * 3.2));
  }, [order.status, prepTime, calculatedDistanceKm, remainingDistanceKm]);

  // Initialize and manage Leaflet Map with Real GPS Coordinates
  useEffect(() => {
    if (!mapContainerRef.current) return;

    if (mapInstanceRef.current) {
      mapInstanceRef.current.remove();
      mapInstanceRef.current = null;
    }

    const map = L.map(mapContainerRef.current, {
      center: customerPos,
      zoom: 15,
      zoomControl: true,
      scrollWheelZoom: false,
    });

    mapInstanceRef.current = map;

    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
      maxZoom: 19,
      attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors',
    }).addTo(map);

    // 1. Kitchen Custom DivIcon
    const kitchenIcon = L.divIcon({
      className: 'custom-leaflet-marker',
      html: `
        <div style="position: relative; display: flex; flex-direction: column; align-items: center; transform: translate(-50%, -100%);">
          <div style="background-color: #ffffff; border: 2.5px solid #238B57; border-radius: 12px; padding: 5px 9px; box-shadow: 0 4px 14px rgba(0,0,0,0.18); display: flex; align-items: center; gap: 5px; white-space: nowrap;">
            <span style="color: #238B57; font-size: 13px;">🍳</span>
            <span style="font-size: 11px; font-weight: 800; color: #1e3a29;">${kitchenLabel}</span>
          </div>
          <div style="width: 14px; height: 14px; background-color: #238B57; border: 2px solid #ffffff; border-radius: 50%; box-shadow: 0 2px 6px rgba(0,0,0,0.35); margin-top: -2px;"></div>
        </div>
      `,
      iconSize: [0, 0],
    });
    L.marker(kitchenPos, { icon: kitchenIcon }).addTo(map);

    // 2. Customer Destination Custom DivIcon
    const customerIcon = L.divIcon({
      className: 'custom-leaflet-marker',
      html: `
        <div style="position: relative; display: flex; flex-direction: column; align-items: center; transform: translate(-50%, -100%);">
          <div style="background-color: #ffffff; border: 2.5px solid #F59E42; border-radius: 12px; padding: 5px 9px; box-shadow: 0 4px 14px rgba(0,0,0,0.18); display: flex; align-items: center; gap: 5px; white-space: nowrap;">
            <span style="color: #F59E42; font-size: 13px;">📍</span>
            <span style="font-size: 11px; font-weight: 800; color: #1e293b;">${destinationLabel}</span>
          </div>
          <div style="width: 14px; height: 14px; background-color: #F59E42; border: 2px solid #ffffff; border-radius: 50%; box-shadow: 0 2px 6px rgba(0,0,0,0.35); margin-top: -2px;"></div>
        </div>
      `,
      iconSize: [0, 0],
    });
    L.marker(customerPos, { icon: customerIcon }).addTo(map);

    // 3. Moving Rider Marker
    const riderIcon = L.divIcon({
      className: 'custom-leaflet-marker',
      html: `
        <div style="position: relative; display: flex; flex-direction: column; align-items: center; transform: translate(-50%, -100%);">
          <div style="background-color: #1e3a29; color: #ffffff; border-radius: 14px; padding: 4px 10px; box-shadow: 0 4px 14px rgba(35,139,87,0.4); display: flex; align-items: center; gap: 6px; white-space: nowrap; border: 1.5px solid #ffffff;">
            <span style="font-size: 13px;">🛵</span>
            <div style="text-align: left;">
              <span style="font-size: 10px; font-weight: 800; display: block; line-height: 1;">${riderName}</span>
              <span style="font-size: 8px; opacity: 0.85; display: block; line-height: 1; margin-top: 2px;">
                ${order.status === 'out_for_delivery' ? `On Route • ${riderSpeed} km/h` : order.status === 'delivered' ? 'Delivered' : 'At Kitchen'}
              </span>
            </div>
          </div>
          <div style="position: relative; width: 18px; height: 18px; margin-top: -3px; display: flex; align-items: center; justify-content: center;">
            <div style="position: absolute; width: 18px; height: 18px; background-color: #238B57; border-radius: 50%; opacity: 0.4; animation: ping 1.5s cubic-bezier(0, 0, 0.2, 1) infinite;"></div>
            <div style="width: 12px; height: 12px; background-color: #238B57; border: 2.5px solid #ffffff; border-radius: 50%; position: relative; z-index: 2;"></div>
          </div>
        </div>
      `,
      iconSize: [0, 0],
    });

    const riderMarker = L.marker(riderLatLng, { icon: riderIcon, zIndexOffset: 1000 }).addTo(map);
    riderMarkerRef.current = riderMarker;

    // 4. Polylines:
    // Completed segment (Kitchen -> Rider)
    const completedPoly = L.polyline([kitchenPos, riderLatLng], {
      color: '#238B57',
      weight: 5,
      opacity: 0.95,
      lineCap: 'round',
    }).addTo(map);
    completedPolylineRef.current = completedPoly;

    // Remaining segment (Rider -> Customer)
    const remainingPoly = L.polyline([riderLatLng, customerPos], {
      color: '#F59E42',
      weight: 4,
      dashArray: '8, 8',
      opacity: 0.85,
      lineCap: 'round',
    }).addTo(map);
    remainingPolylineRef.current = remainingPoly;

    // Fit map bounds smoothly
    const bounds = L.latLngBounds([kitchenPos, customerPos]).pad(0.3);
    map.fitBounds(bounds);

    return () => {
      map.remove();
      mapInstanceRef.current = null;
    };
  }, [customerPos[0], customerPos[1], kitchenPos[0], kitchenPos[1], kitchenLabel, destinationLabel, riderName]);

  // Update Rider position & polyline dynamically when routeProgress updates
  useEffect(() => {
    if (!mapInstanceRef.current || !riderMarkerRef.current) return;

    const currentPos = getInterpolatedLatLng(routeProgress);
    riderMarkerRef.current.setLatLng(currentPos);

    if (completedPolylineRef.current) {
      completedPolylineRef.current.setLatLngs([kitchenPos, currentPos]);
    }
    if (remainingPolylineRef.current) {
      remainingPolylineRef.current.setLatLngs([currentPos, customerPos]);
    }
  }, [routeProgress, kitchenPos, customerPos]);

  return (
    <div className="bg-white rounded-3xl border border-hb-green-100 shadow-soft overflow-hidden">
      
      {/* Top Header Bar */}
      <div className="p-4 sm:p-5 border-b border-gray-100 bg-gradient-to-r from-hb-cream/60 via-white to-hb-cream/40 flex flex-wrap items-center justify-between gap-3">
        <div className="flex items-center gap-2.5">
          <div className="w-8 h-8 rounded-xl bg-hb-green-600 text-white flex items-center justify-center shadow-xs">
            <Route className="w-4 h-4" />
          </div>
          <div>
            <h3 className="text-xs sm:text-sm font-extrabold text-gray-900 flex items-center gap-2">
              <span>Live Leaflet OpenStreetMap Tracker</span>
              <span className="inline-flex items-center gap-1 px-2 py-0.5 rounded-full bg-emerald-100 text-emerald-800 text-[10px] font-bold">
                <span className="w-1.5 h-1.5 rounded-full bg-emerald-600 animate-pulse"></span>
                <span>Realtime GPS</span>
              </span>
            </h3>
            <p className="text-[11px] text-gray-500">
              Interactive OpenStreetMap view of <strong>{kitchenLabel}</strong> to <strong>{destinationLabel}</strong>
            </p>
          </div>
        </div>

        {/* Live Metrics HUD */}
        <div className="flex items-center gap-2 sm:gap-4 text-xs">
          <div className="bg-white px-3 py-1.5 rounded-xl border border-hb-green-200 shadow-xs flex items-center gap-2">
            <span className="text-gray-400 font-medium">Remaining:</span>
            <span className="font-extrabold text-hb-green-800">{remainingDistanceKm} km</span>
            <span className="text-gray-300">•</span>
            <span className="font-extrabold text-amber-600">~{remainingMins} mins</span>
          </div>

          <div className="hidden sm:flex items-center gap-1.5 px-3 py-1.5 bg-gray-50 rounded-xl border border-gray-200 text-gray-700 font-semibold text-[11px]">
            <Zap className="w-3.5 h-3.5 text-amber-500" />
            <span>Speed: {order.status === 'out_for_delivery' ? `${riderSpeed} km/h` : order.status === 'delivered' ? 'Delivered' : 'At Kitchen'}</span>
          </div>
        </div>
      </div>

      {/* Real Interactive Leaflet Map Container */}
      <div className="relative w-full h-80 sm:h-96">
        <div ref={mapContainerRef} className="w-full h-full z-10" />

        {/* Floating Route Telemetry HUD */}
        <div className="absolute bottom-3 left-3 bg-white/95 backdrop-blur-md p-3 rounded-2xl border border-hb-green-200 shadow-md max-w-xs z-[500] pointer-events-none">
          <div className="flex items-center gap-2 mb-1.5">
            <Navigation className="w-3.5 h-3.5 text-hb-green-600" />
            <span className="text-[10px] font-extrabold uppercase text-gray-500 tracking-wider">Live Route Telemetry</span>
          </div>
          <p className="text-xs font-bold text-gray-900 leading-snug">
            {order.status === 'out_for_delivery'
              ? `Rider en route with your fresh dabba towards ${destinationLabel}`
              : order.status === 'ready_for_pickup'
              ? 'Rider arriving at kitchen to pick up your warm packed dabba'
              : order.status === 'delivered'
              ? `Your home meal has arrived safely at ${destinationLabel}!`
              : `Meal currently under fresh hygienic preparation at ${kitchenLabel}`}
          </p>
          <div className="flex items-center gap-2 mt-2 pt-2 border-t border-gray-100 text-[10px] text-gray-500">
            <span>Rider: <strong>{riderName}</strong></span>
            <span>•</span>
            <span className="text-emerald-700 font-bold">GPS: Live</span>
          </div>
        </div>

        {/* Floating Recenter Map Button */}
        <button
          onClick={() => {
            if (mapInstanceRef.current) {
              const bounds = L.latLngBounds([kitchenPos, customerPos]).pad(0.3);
              mapInstanceRef.current.fitBounds(bounds);
            }
          }}
          className="absolute top-3 right-3 bg-white hover:bg-gray-50 text-gray-700 p-2 rounded-xl shadow-md border border-gray-200 z-[500] transition active:scale-95"
          title="Recenter Map Route"
        >
          <Compass className="w-4 h-4 text-hb-green-700" />
        </button>
      </div>

      {/* Step-by-Step Waypoint Timeline */}
      <div className="p-4 sm:p-5 bg-hb-cream/30 border-t border-hb-green-100">
        <div className="grid grid-cols-1 sm:grid-cols-3 gap-3">
          
          {/* Step 1: Kitchen */}
          <div className="flex items-start gap-2.5 p-2.5 rounded-xl bg-white border border-gray-100 shadow-xs">
            <div className={`w-7 h-7 rounded-lg flex items-center justify-center flex-shrink-0 ${
              routeProgress >= 0.2 ? 'bg-hb-green-600 text-white' : 'bg-gray-100 text-gray-400'
            }`}>
              <ChefHat className="w-4 h-4" />
            </div>
            <div className="min-w-0">
              <span className="text-[10px] font-bold text-gray-400 uppercase block">1. Origin</span>
              <p className="text-xs font-bold text-gray-900 truncate" title={kitchenLabel}>{kitchenLabel}</p>
              <span className="text-[10px] text-emerald-700 font-medium truncate block" title={kitchenAddress}>
                {provider?.locality || 'SNIST Cluster'}
              </span>
            </div>
          </div>

          {/* Step 2: In Transit */}
          <div className={`flex items-start gap-2.5 p-2.5 rounded-xl border shadow-xs ${
            order.status === 'out_for_delivery'
              ? 'bg-amber-50/70 border-amber-200'
              : 'bg-white border-gray-100'
          }`}>
            <div className={`w-7 h-7 rounded-lg flex items-center justify-center flex-shrink-0 ${
              order.status === 'out_for_delivery' ? 'bg-hb-orange text-white animate-pulse' : 'bg-gray-100 text-gray-400'
            }`}>
              <Bike className="w-4 h-4" />
            </div>
            <div className="min-w-0">
              <span className="text-[10px] font-bold text-gray-400 uppercase block">2. In-Transit Route</span>
              <p className="text-xs font-bold text-gray-900 truncate">Via Local Street Route</p>
              <span className="text-[10px] text-gray-600">
                {order.status === 'out_for_delivery' ? `${remainingDistanceKm} km remaining` : order.status === 'delivered' ? 'Route complete' : 'Awaiting transit'}
              </span>
            </div>
          </div>

          {/* Step 3: Destination Drop Point */}
          <div className="flex items-start gap-2.5 p-2.5 rounded-xl bg-white border border-gray-100 shadow-xs">
            <div className={`w-7 h-7 rounded-lg flex items-center justify-center flex-shrink-0 ${
              order.status === 'delivered' ? 'bg-hb-green-600 text-white' : 'bg-gray-100 text-gray-400'
            }`}>
              <MapPin className="w-4 h-4" />
            </div>
            <div className="min-w-0">
              <span className="text-[10px] font-bold text-gray-400 uppercase block">3. Drop Destination</span>
              <p className="text-xs font-bold text-gray-900 truncate" title={destinationLabel}>{destinationLabel}</p>
              <span className="text-[10px] text-gray-500 truncate block" title={deliveryAddressSnippet}>
                {deliveryAddressSnippet}
              </span>
            </div>
          </div>

        </div>
      </div>

    </div>
  );
};

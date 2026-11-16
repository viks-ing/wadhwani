import React, { useEffect, useRef, useState } from 'react';
import L from 'leaflet';
import { Order } from '../../types';
import { LatLon } from '../../lib/geoService';
import { 
  Bike, 
  MapPin, 
  ChefHat, 
  Navigation, 
  Route, 
  Zap, 
  Maximize2,
  Compass,
  CheckCircle2
} from 'lucide-react';

interface LiveDeliveryMapProps {
  order: Order;
  currentCampus: string;
  userCoords?: LatLon | null;
}

export const LiveDeliveryMap: React.FC<LiveDeliveryMapProps> = ({ order, currentCampus, userCoords }) => {
  const mapContainerRef = useRef<HTMLDivElement>(null);
  const mapInstanceRef = useRef<L.Map | null>(null);
  const riderMarkerRef = useRef<L.Marker | null>(null);
  const completedPolylineRef = useRef<L.Polyline | null>(null);
  const remainingPolylineRef = useRef<L.Polyline | null>(null);

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

  const [riderSpeed, setRiderSpeed] = useState<number>(26);

  // Sync route progress with order status
  useEffect(() => {
    switch (order.status) {
      case 'order_placed':
        setRouteProgress(0.05);
        break;
      case 'chef_preparing':
        setRouteProgress(0.20);
        break;
      case 'ready_for_pickup':
        setRouteProgress(0.40);
        break;
      case 'out_for_delivery':
        setRouteProgress((prev) => (prev < 0.45 ? 0.65 : prev));
        break;
      case 'delivered':
        setRouteProgress(1.0);
        break;
    }
  }, [order.status]);

  // Subtle live GPS movement simulation during "out_for_delivery"
  useEffect(() => {
    if (order.status !== 'out_for_delivery') return;

    const interval = setInterval(() => {
      setRouteProgress((prev) => {
        if (prev >= 0.95) return 0.65;
        return Number((prev + 0.012).toFixed(3));
      });
      setRiderSpeed(Math.floor(22 + Math.random() * 9));
    }, 1200);

    return () => clearInterval(interval);
  }, [order.status]);

  // Determine Real GPS Anchor Coordinates
  // Customer position: User's actual GPS or default to detected Meerpet/Hyderabad area
  const customerPos: [number, number] = userCoords
    ? [userCoords.lat, userCoords.lon]
    : [17.3297, 78.5332]; // Ward 4 Meerpet H.B Colony

  // Kitchen position: ~1.4km offset north-west in the same locality
  const kitchenPos: [number, number] = [
    customerPos[0] + 0.0092,
    customerPos[1] - 0.0084,
  ];

  // Realistic street waypoints between kitchen and customer
  const waypoints: [number, number][] = [
    kitchenPos,
    [kitchenPos[0] - 0.0022, kitchenPos[1] + 0.0018],
    [kitchenPos[0] - 0.0048, kitchenPos[1] + 0.0035],
    [kitchenPos[0] - 0.0068, kitchenPos[1] + 0.0052],
    [kitchenPos[0] - 0.0081, kitchenPos[1] + 0.0071],
    customerPos,
  ];

  // Compute rider position along waypoints given progress (0 to 1)
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

  // Initialize and manage Leaflet Map
  useEffect(() => {
    if (!mapContainerRef.current) return;

    // Clean up any existing map instance
    if (mapInstanceRef.current) {
      mapInstanceRef.current.remove();
      mapInstanceRef.current = null;
    }

    // Create Leaflet Map Instance
    const map = L.map(mapContainerRef.current, {
      center: customerPos,
      zoom: 15,
      zoomControl: true,
      scrollWheelZoom: false,
    });

    mapInstanceRef.current = map;

    // OpenStreetMap Tile Layer
    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
      maxZoom: 19,
      attribution: '&copy; OpenStreetMap contributors',
    }).addTo(map);

    // 1. Kitchen Custom DivIcon Marker
    const kitchenIcon = L.divIcon({
      className: 'custom-leaflet-marker',
      html: `
        <div style="position: relative; display: flex; flex-direction: column; align-items: center; transform: translate(-50%, -100%);">
          <div style="background-color: #ffffff; border: 2px solid #238B57; border-radius: 12px; padding: 4px 8px; box-shadow: 0 4px 12px rgba(0,0,0,0.15); display: flex; align-items: center; gap: 4px; white-space: nowrap;">
            <span style="color: #238B57; font-size: 11px;">🍳</span>
            <span style="font-size: 11px; font-weight: 800; color: #1e3a29;">${order.kitchenName || 'Kitchen'}</span>
          </div>
          <div style="width: 14px; height: 14px; background-color: #238B57; border: 2px solid #ffffff; border-radius: 50%; box-shadow: 0 2px 6px rgba(0,0,0,0.3); margin-top: -2px;"></div>
        </div>
      `,
      iconSize: [0, 0],
    });

    L.marker(kitchenPos, { icon: kitchenIcon }).addTo(map);

    // 2. Customer Destination Custom DivIcon Marker
    const customerIcon = L.divIcon({
      className: 'custom-leaflet-marker',
      html: `
        <div style="position: relative; display: flex; flex-direction: column; align-items: center; transform: translate(-50%, -100%);">
          <div style="background-color: #ffffff; border: 2px solid #F59E42; border-radius: 12px; padding: 4px 8px; box-shadow: 0 4px 12px rgba(0,0,0,0.15); display: flex; align-items: center; gap: 4px; white-space: nowrap;">
            <span style="color: #F59E42; font-size: 11px;">📍</span>
            <span style="font-size: 11px; font-weight: 800; color: #1e293b;">${(currentCampus || order.collegeOrWorkplace || 'Delivery Gate').split(',')[0]}</span>
          </div>
          <div style="width: 14px; height: 14px; background-color: #F59E42; border: 2px solid #ffffff; border-radius: 50%; box-shadow: 0 2px 6px rgba(0,0,0,0.3); margin-top: -2px;"></div>
        </div>
      `,
      iconSize: [0, 0],
    });

    L.marker(customerPos, { icon: customerIcon }).addTo(map);

    // 3. Moving Rider Custom DivIcon Marker
    const riderIcon = L.divIcon({
      className: 'custom-leaflet-marker',
      html: `
        <div style="position: relative; display: flex; flex-direction: column; align-items: center; transform: translate(-50%, -100%);">
          <div style="background-color: #1e3a29; color: #ffffff; border-radius: 14px; padding: 4px 10px; box-shadow: 0 4px 14px rgba(35,139,87,0.4); display: flex; align-items: center; gap: 6px; white-space: nowrap; border: 1.5px solid #ffffff;">
            <span style="font-size: 12px;">🛵</span>
            <div style="text-align: left;">
              <span style="font-size: 10px; font-weight: 800; display: block; line-height: 1;">${order.deliveryPartner?.name || 'Rider'}</span>
              <span style="font-size: 8px; opacity: 0.8; display: block; line-height: 1; margin-top: 2px;">${order.status === 'out_for_delivery' ? 'On Route • 26 km/h' : 'At Kitchen'}</span>
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
      opacity: 0.9,
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

    // Fit map bounds to encompass kitchen, rider, and customer nicely
    const bounds = L.latLngBounds([kitchenPos, customerPos]).pad(0.25);
    map.fitBounds(bounds);

    return () => {
      map.remove();
      mapInstanceRef.current = null;
    };
  }, [customerPos[0], customerPos[1], kitchenPos[0], kitchenPos[1], order.kitchenName, order.deliveryPartner?.name]);

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
  }, [routeProgress]);

  // Metrics
  const totalDistanceKm = 2.4;
  const remainingDistanceKm = Math.max(0, Number((totalDistanceKm * (1 - routeProgress)).toFixed(1)));
  const remainingMins = Math.max(1, Math.round(remainingDistanceKm * 3.5));

  const destinationLabel = currentCampus || order.collegeOrWorkplace || 'Campus Drop Point';
  const kitchenLabel = order.kitchenName || 'Home Kitchen';

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
              Interactive OpenStreetMap view of {kitchenLabel} to {destinationLabel.split(',')[0]}
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
            <span>Speed: {order.status === 'out_for_delivery' ? `${riderSpeed} km/h` : 'At Kitchen'}</span>
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
              ? `Rider en route with your fresh dabba towards ${destinationLabel.split(',')[0]}`
              : order.status === 'ready_for_pickup'
              ? 'Rider arriving at kitchen to pick up your packed dabba'
              : 'Meal currently under fresh hygienic preparation'}
          </p>
          <div className="flex items-center gap-2 mt-2 pt-2 border-t border-gray-100 text-[10px] text-gray-500">
            <span>Rider: <strong>{order.deliveryPartner?.name || 'Ramesh Kumar'}</strong></span>
            <span>•</span>
            <span className="text-emerald-700 font-bold">GPS: Live</span>
          </div>
        </div>

        {/* Floating Recenter Map Button */}
        <button
          onClick={() => {
            if (mapInstanceRef.current) {
              const bounds = L.latLngBounds([kitchenPos, customerPos]).pad(0.25);
              mapInstanceRef.current.fitBounds(bounds);
            }
          }}
          className="absolute top-3 right-3 bg-white hover:bg-gray-50 text-gray-700 p-2 rounded-xl shadow-md border border-gray-200 z-[500] transition"
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
              <p className="text-xs font-bold text-gray-900 truncate">{kitchenLabel}</p>
              <span className="text-[10px] text-emerald-700 font-medium">Packed & Handed Over</span>
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
                {order.status === 'out_for_delivery' ? `${remainingDistanceKm} km remaining` : 'Awaiting transit'}
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
              <p className="text-xs font-bold text-gray-900 truncate">{destinationLabel.split(',')[0]}</p>
              <span className="text-[10px] text-gray-500">Contactless gate delivery</span>
            </div>
          </div>

        </div>
      </div>

    </div>
  );
};

export type UserRole = 'customer' | 'chef' | 'delivery' | 'admin' | 'restaurant_owner';

export type ProviderType = 
  | 'home_kitchen' 
  | 'cloud_kitchen' 
  | 'tiffin_service' 
  | 'healthy_restaurant' 
  | 'restaurant';

export type DiscoveryStatus = 'discovered' | 'researched' | 'verified' | 'rejected';
export type PartnershipStatus = 'not_contacted' | 'contacted' | 'pending' | 'approved' | 'rejected';
export type VerificationStatus = 'unverified' | 'verification_pending' | 'verified';
export type DiscoveryZone = 'zone_1_core' | 'zone_2_nearby' | 'zone_3_extended' | 'zone_4_hyderabad_wide';

export interface FoodProvider {
  id: string;
  name: string;
  slug?: string;
  type: ProviderType;
  description: string;
  address: string;
  locality: string;
  city?: string;
  state?: string;
  pincode?: string;
  lat: number;
  lon: number;
  cuisine: string[];
  rating: number;
  reviewsCount: number;
  prepTimeMinutes: number;
  minOrderAmount: number;
  isDeliveryAvailable: boolean;
  deliveryRadiusKm?: number;
  openingHours: string;
  coverImage: string;
  isVerified: boolean;
  isDemo: boolean;
  discoveryStatus?: DiscoveryStatus;
  partnershipStatus?: PartnershipStatus;
  verificationStatus?: VerificationStatus;
  zone?: DiscoveryZone;
  phone?: string;
  email?: string;
  status: 'pending' | 'approved' | 'rejected'; // mapped to partnershipStatus
  ownerId?: string;
  distanceKm?: number;
  menu?: ProviderMenuItem[];
}

export interface ProviderMenuItem {
  id: string;
  providerId: string;
  name: string;
  description: string;
  price: number;
  imageUrl: string;
  cuisine: string;
  category: 'breakfast' | 'lunch' | 'dinner' | 'snacks' | 'high-protein';
  dietary: 'veg' | 'non-veg' | 'vegan';
  tags: string[];
  calories?: number;
  protein?: number;
  isAvailable: boolean;
}

export interface UserProfile {
  id: string;
  name: string;
  email: string;
  role: UserRole;
  phone: string;
  avatarUrl: string;
  address: string;
  collegeOrWorkplace?: string;
  
  // Chef specific fields
  kitchenName?: string;
  bio?: string;
  isVerified?: boolean;
  hygieneScore?: number; // e.g. 4.9
  fssaiNumber?: string;
  specialty?: string;
  earnings?: number;
  totalOrdersCount?: number;

  // Delivery partner specific fields
  vehicleType?: 'Motorcycle' | 'Scooter' | 'Bicycle' | 'Electric Bike';
  vehicleNumber?: string;
  deliveryRating?: number;
  completedDeliveriesCount?: number;
  deliveryEarnings?: number;
  isOnline?: boolean;
}

export type MealCategory = 'all' | 'breakfast' | 'lunch' | 'dinner' | 'snacks' | 'high-protein';
export type DietaryPreference = 'all' | 'veg' | 'non-veg' | 'vegan';

export interface NutritionInfo {
  calories: number;
  protein: number; // in grams
  carbs: number;   // in grams
  fats: number;    // in grams
  fiber?: number;  // in grams
}

export interface Meal {
  id: string;
  chefId: string;
  chefName: string;
  chefAvatar: string;
  kitchenName: string;
  isChefVerified: boolean;
  name: string;
  description: string;
  category: 'breakfast' | 'lunch' | 'dinner' | 'snacks' | 'high-protein';
  dietary: 'veg' | 'non-veg' | 'vegan';
  price: number;
  originalPrice?: number;
  rating: number;
  reviewsCount: number;
  prepTimeMinutes: number;
  imageUrl: string;
  ingredients: string[];
  nutrition: NutritionInfo;
  isAvailable: boolean;
  tags: string[];
  spiceLevel: 'Mild' | 'Medium' | 'Spicy';
  servingSize: string;
  campusDistanceKm: number;
}

export interface CartItem {
  meal: Meal;
  quantity: number;
  specialInstructions?: string;
}

export type OrderStatus = 
  | 'order_placed'
  | 'chef_preparing'
  | 'ready_for_pickup'
  | 'out_for_delivery'
  | 'delivered'
  | 'cancelled';

export interface OrderItem {
  mealId: string;
  name: string;
  price: number;
  quantity: number;
  dietary: 'veg' | 'non-veg' | 'vegan';
  imageUrl: string;
}

export interface DeliveryPartner {
  id?: string;
  name: string;
  phone: string;
  vehicleNumber: string;
  vehicleType?: string;
  rating: number;
  avatarUrl: string;
}

export interface Order {
  id: string;
  customerId: string;
  customerName: string;
  customerPhone: string;
  deliveryAddress: string;
  collegeOrWorkplace: string;
  chefId: string;
  chefName: string;
  kitchenName: string;
  items: OrderItem[];
  subtotal: number;
  deliveryFee: number;
  packagingFee: number;
  discount: number;
  totalAmount: number;
  status: OrderStatus;
  paymentMethod: 'UPI (GPay / PhonePe)' | 'Credit / Debit Card' | 'Net Banking' | 'Cash on Delivery';
  paymentStatus: 'paid' | 'pending';
  orderNotes?: string;
  createdAt: string;
  updatedAt: string;
  estimatedDeliveryTime: string;
  deliveryPartnerId?: string;
  deliveryPartner?: DeliveryPartner;
  deliveryPayout?: number; // e.g. ₹45
  deliveryStep?: 'awaiting_assignment' | 'accepted' | 'picked_up' | 'arrived_campus' | 'delivered';
  statusTimestamps: {
    order_placed: string;
    chef_preparing?: string;
    ready_for_pickup?: string;
    out_for_delivery?: string;
    delivered?: string;
  };
}

export interface SubscriptionPlan {
  id: string;
  title: string;
  tagline: string;
  type: 'daily' | 'weekly' | 'monthly';
  mealType: 'lunch' | 'dinner' | 'both';
  mealsPerDay: number;
  durationDays: number;
  pricePerMeal: number;
  totalPrice: number;
  originalPrice: number;
  savings: number;
  popular?: boolean;
  features: string[];
  description: string;
}

export interface Review {
  id: string;
  mealId: string;
  chefId: string;
  userName: string;
  userAvatar: string;
  rating: number;
  comment: string;
  date: string;
  college?: string;
}

export interface ChefApplication {
  id: string;
  fullName: string;
  kitchenName: string;
  phone: string;
  address: string;
  fssaiNumber: string;
  specialty: string;
  status: 'pending' | 'approved' | 'rejected';
  appliedDate: string;
  hygieneChecklistCompleted: boolean;
}

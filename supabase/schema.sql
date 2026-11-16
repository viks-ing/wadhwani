-- ====================================================================
-- HomeBite Database Schema & Role-Based Access Control (RLS)
-- PostgreSQL / Supabase
-- ====================================================================

-- 1. Create Enums
CREATE TYPE user_role AS ENUM ('customer', 'chef', 'delivery', 'admin');
CREATE TYPE order_status AS ENUM (
  'order_placed',
  'chef_preparing',
  'ready_for_pickup',
  'out_for_delivery',
  'delivered',
  'cancelled'
);
CREATE TYPE meal_category AS ENUM (
  'breakfast',
  'lunch',
  'dinner',
  'snacks',
  'high-protein'
);
CREATE TYPE dietary_type AS ENUM ('veg', 'non-veg', 'vegan');
CREATE TYPE subscription_type AS ENUM ('daily', 'weekly', 'monthly');

-- 2. Profiles Table (extends auth.users)
CREATE TABLE IF NOT EXISTS public.profiles (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  role user_role NOT NULL DEFAULT 'customer',
  full_name TEXT NOT NULL,
  email TEXT NOT NULL,
  phone TEXT,
  avatar_url TEXT,
  delivery_address TEXT,
  college_or_workplace TEXT,
  
  -- Chef specific fields
  kitchen_name TEXT,
  bio TEXT,
  fssai_license TEXT,
  is_verified BOOLEAN DEFAULT FALSE,
  hygiene_score NUMERIC(3, 2) DEFAULT 4.8,
  specialty TEXT,
  total_orders_count INTEGER DEFAULT 0,
  earnings_inr NUMERIC(10, 2) DEFAULT 0.00,
  
  -- Delivery Partner specific fields
  vehicle_type TEXT DEFAULT 'Motorcycle',
  vehicle_number TEXT,
  delivery_rating NUMERIC(3, 2) DEFAULT 4.9,
  completed_deliveries_count INTEGER DEFAULT 0,
  delivery_earnings_inr NUMERIC(10, 2) DEFAULT 0.00,
  is_online BOOLEAN DEFAULT TRUE,
  
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- 3. Security Trigger: Prevent Users from Changing Their Own Role
CREATE OR REPLACE FUNCTION public.protect_user_role()
RETURNS TRIGGER AS $$
BEGIN
  -- If role is modified and updater is not a service_role / super admin, reject
  IF NEW.role <> OLD.role AND (auth.jwt() ->> 'role' <> 'service_role') THEN
    IF NOT EXISTS (
      SELECT 1 FROM public.profiles 
      WHERE id = auth.uid() AND role = 'admin'
    ) THEN
      RAISE EXCEPTION 'Unauthorized: Users cannot modify their own system role.';
    END IF;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS tr_protect_user_role ON public.profiles;
CREATE TRIGGER tr_protect_user_role
  BEFORE UPDATE ON public.profiles
  FOR EACH ROW
  EXECUTE FUNCTION public.protect_user_role();

-- 4. Meals Table
CREATE TABLE IF NOT EXISTS public.meals (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  chef_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  description TEXT NOT NULL,
  category meal_category NOT NULL DEFAULT 'lunch',
  dietary dietary_type NOT NULL DEFAULT 'veg',
  price NUMERIC(8, 2) NOT NULL CHECK (price >= 0),
  original_price NUMERIC(8, 2),
  rating NUMERIC(3, 2) DEFAULT 4.8,
  reviews_count INTEGER DEFAULT 0,
  prep_time_minutes INTEGER DEFAULT 20,
  image_url TEXT NOT NULL,
  ingredients TEXT[] DEFAULT '{}',
  
  -- Nutritional macros
  calories INTEGER DEFAULT 450,
  protein_grams NUMERIC(5, 1) DEFAULT 15,
  carbs_grams NUMERIC(5, 1) DEFAULT 60,
  fats_grams NUMERIC(5, 1) DEFAULT 12,
  fiber_grams NUMERIC(5, 1) DEFAULT 6,
  
  spice_level TEXT DEFAULT 'Medium',
  serving_size TEXT DEFAULT '1 Portion',
  is_available BOOLEAN DEFAULT TRUE,
  tags TEXT[] DEFAULT '{}',
  
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- 5. Orders Table
CREATE TABLE IF NOT EXISTS public.orders (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  order_number TEXT UNIQUE NOT NULL,
  customer_id UUID NOT NULL REFERENCES public.profiles(id),
  chef_id UUID NOT NULL REFERENCES public.profiles(id),
  delivery_partner_id UUID REFERENCES public.profiles(id),
  delivery_address TEXT NOT NULL,
  college_or_workplace TEXT,
  order_notes TEXT,
  
  subtotal NUMERIC(8, 2) NOT NULL,
  delivery_fee NUMERIC(8, 2) DEFAULT 15.00,
  packaging_fee NUMERIC(8, 2) DEFAULT 10.00,
  discount NUMERIC(8, 2) DEFAULT 0.00,
  total_amount NUMERIC(8, 2) NOT NULL,
  delivery_payout NUMERIC(8, 2) DEFAULT 45.00,
  
  status order_status NOT NULL DEFAULT 'order_placed',
  payment_method TEXT NOT NULL DEFAULT 'UPI',
  payment_status TEXT NOT NULL DEFAULT 'paid',
  
  estimated_delivery_time TEXT DEFAULT '20-25 mins',
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- 6. Order Items Table
CREATE TABLE IF NOT EXISTS public.order_items (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  order_id UUID NOT NULL REFERENCES public.orders(id) ON DELETE CASCADE,
  meal_id UUID REFERENCES public.meals(id) ON DELETE SET NULL,
  meal_name TEXT NOT NULL,
  price NUMERIC(8, 2) NOT NULL,
  quantity INTEGER NOT NULL CHECK (quantity > 0),
  dietary dietary_type NOT NULL,
  image_url TEXT
);

-- 7. Subscriptions Table
CREATE TABLE IF NOT EXISTS public.subscriptions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  customer_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  plan_title TEXT NOT NULL,
  plan_type subscription_type NOT NULL,
  meal_type TEXT NOT NULL,
  price_inr NUMERIC(8, 2) NOT NULL,
  start_date DATE NOT NULL DEFAULT CURRENT_DATE,
  end_date DATE NOT NULL,
  status TEXT NOT NULL DEFAULT 'active',
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 8. Reviews Table
CREATE TABLE IF NOT EXISTS public.reviews (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  meal_id UUID REFERENCES public.meals(id) ON DELETE CASCADE,
  chef_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE,
  customer_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE,
  rating INTEGER CHECK (rating >= 1 AND rating <= 5),
  comment TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 9. Chef Verification Applications
CREATE TABLE IF NOT EXISTS public.chef_applications (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES public.profiles(id),
  full_name TEXT NOT NULL,
  kitchen_name TEXT NOT NULL,
  phone TEXT NOT NULL,
  address TEXT NOT NULL,
  fssai_license TEXT NOT NULL,
  specialty TEXT,
  status TEXT DEFAULT 'pending',
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ====================================================================
-- ROW LEVEL SECURITY (RLS) POLICIES
-- ====================================================================

ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.meals ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.order_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.subscriptions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.reviews ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.chef_applications ENABLE ROW LEVEL SECURITY;

-- Profiles: Anyone can view public profiles; users can update own non-role fields; admins can manage all
CREATE POLICY "Public profiles are viewable by everyone" 
  ON public.profiles FOR SELECT USING (true);

CREATE POLICY "Users can update own profile" 
  ON public.profiles FOR UPDATE USING (auth.uid() = id);

-- Meals: Anyone can view available meals; chefs can insert/update/delete their own meals; admins manage all
CREATE POLICY "Meals viewable by all" 
  ON public.meals FOR SELECT USING (true);

CREATE POLICY "Chefs can insert their own meals" 
  ON public.meals FOR INSERT WITH CHECK (
    auth.uid() = chef_id OR 
    EXISTS (SELECT 1 FROM public.profiles WHERE id = auth.uid() AND role = 'admin')
  );

CREATE POLICY "Chefs can update their own meals" 
  ON public.meals FOR UPDATE USING (
    auth.uid() = chef_id OR 
    EXISTS (SELECT 1 FROM public.profiles WHERE id = auth.uid() AND role = 'admin')
  );

CREATE POLICY "Chefs can delete their own meals" 
  ON public.meals FOR DELETE USING (
    auth.uid() = chef_id OR 
    EXISTS (SELECT 1 FROM public.profiles WHERE id = auth.uid() AND role = 'admin')
  );

-- Orders: Customers see own orders; chefs see kitchen orders; delivery partners see assigned orders; admins see all
CREATE POLICY "Orders viewable by authorized participants" 
  ON public.orders FOR SELECT USING (
    auth.uid() = customer_id OR 
    auth.uid() = chef_id OR 
    auth.uid() = delivery_partner_id OR
    (status = 'ready_for_pickup' AND EXISTS (SELECT 1 FROM public.profiles WHERE id = auth.uid() AND role = 'delivery')) OR
    EXISTS (SELECT 1 FROM public.profiles WHERE id = auth.uid() AND role = 'admin')
  );

CREATE POLICY "Customers can create orders" 
  ON public.orders FOR INSERT WITH CHECK (auth.uid() = customer_id);

CREATE POLICY "Chefs, Riders and Admins can update order status" 
  ON public.orders FOR UPDATE USING (
    auth.uid() = chef_id OR 
    auth.uid() = delivery_partner_id OR
    (status = 'ready_for_pickup' AND EXISTS (SELECT 1 FROM public.profiles WHERE id = auth.uid() AND role = 'delivery')) OR
    EXISTS (SELECT 1 FROM public.profiles WHERE id = auth.uid() AND role = 'admin')
  );

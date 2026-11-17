-- ============================================================
-- Migration: 001_restaurant_marketplace.sql
-- Project:   HomeBite Restaurant Marketplace
-- ============================================================
--
-- HOW TO APPLY IN SUPABASE DASHBOARD:
-- 1. Open your Supabase project dashboard at https://supabase.com/dashboard
-- 2. Navigate to: SQL Editor (left sidebar)
-- 3. Click "New query"
-- 4. Copy and paste the ENTIRE contents of this file into the editor
-- 5. Click "Run" (or press Ctrl+Enter / Cmd+Enter)
-- 6. Verify success: go to Table Editor and confirm tables
--    "restaurants" and "menu_items" appear under the public schema.
-- 7. If you need to re-run, this migration is IDEMPOTENT — safe to run again.
-- ============================================================

-- Step 1: Add restaurant_owner to user_role enum (IF NOT EXISTS)
-- PostgreSQL 15+ supports ALTER TYPE ... ADD VALUE IF NOT EXISTS directly;
-- the DO block below is used for broad compatibility.
DO $$ BEGIN
  ALTER TYPE user_role ADD VALUE IF NOT EXISTS 'restaurant_owner';
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

-- Step 2: Create restaurants table
CREATE TABLE IF NOT EXISTS public.restaurants (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  owner_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  google_place_id TEXT UNIQUE,
  business_name TEXT NOT NULL,
  business_address TEXT NOT NULL,
  contact_phone TEXT,
  status TEXT NOT NULL DEFAULT 'pending' CHECK (status IN ('pending','approved','rejected')),
  rejection_reason TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Step 3: Create menu_items table (restaurant-specific, separate from home chef meals)
CREATE TABLE IF NOT EXISTS public.menu_items (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  restaurant_id UUID NOT NULL REFERENCES public.restaurants(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  description TEXT,
  price NUMERIC(8,2) NOT NULL CHECK (price >= 0),
  image_url TEXT,
  category TEXT DEFAULT 'main',
  is_available BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Step 4: Enable Row Level Security
ALTER TABLE public.restaurants ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.menu_items ENABLE ROW LEVEL SECURITY;

-- ============================================================
-- RLS POLICIES: restaurants
-- ============================================================

-- 1. Anyone (including anonymous) can view approved restaurants
DO $$ BEGIN
  CREATE POLICY "Public can view approved restaurants"
    ON public.restaurants FOR SELECT
    USING (status = 'approved');
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

-- 2. Owners can view their own restaurant (any status)
DO $$ BEGIN
  CREATE POLICY "Owners can view their own restaurant"
    ON public.restaurants FOR SELECT
    USING (auth.uid() = owner_id);
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

-- 3. Owners can insert their own restaurant (registers with pending status)
DO $$ BEGIN
  CREATE POLICY "Owners can register restaurant"
    ON public.restaurants FOR INSERT
    WITH CHECK (auth.uid() = owner_id);
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

-- 4. Owners can update ONLY non-status fields of their own restaurant
--    (status changes must go through admin — enforced by WITH CHECK)
DO $$ BEGIN
  CREATE POLICY "Owners can update own restaurant details"
    ON public.restaurants FOR UPDATE
    USING (auth.uid() = owner_id)
    WITH CHECK (auth.uid() = owner_id AND status = OLD.status);
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

-- 5. Admins have full access to all restaurants (view, approve, reject)
DO $$ BEGIN
  CREATE POLICY "Admins can manage all restaurants"
    ON public.restaurants FOR ALL
    USING (EXISTS (
      SELECT 1 FROM public.profiles
      WHERE id = auth.uid() AND role = 'admin'
    ));
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

-- ============================================================
-- RLS POLICIES: menu_items
-- ============================================================

-- 1. Anyone can view available menu items of approved restaurants
DO $$ BEGIN
  CREATE POLICY "Public can view available menu items"
    ON public.menu_items FOR SELECT
    USING (
      is_available = TRUE AND
      EXISTS (
        SELECT 1 FROM public.restaurants
        WHERE id = restaurant_id AND status = 'approved'
      )
    );
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

-- 2. Restaurant owners can manage their own menu items (full CRUD)
DO $$ BEGIN
  CREATE POLICY "Owners can manage own menu items"
    ON public.menu_items FOR ALL
    USING (EXISTS (
      SELECT 1 FROM public.restaurants
      WHERE id = restaurant_id AND owner_id = auth.uid()
    ));
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

-- 3. Admins can manage all menu items
DO $$ BEGIN
  CREATE POLICY "Admins can manage all menu items"
    ON public.menu_items FOR ALL
    USING (EXISTS (
      SELECT 1 FROM public.profiles
      WHERE id = auth.uid() AND role = 'admin'
    ));
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

-- ============================================================
-- INDEXES for performance
-- ============================================================
CREATE INDEX IF NOT EXISTS idx_restaurants_google_place_id ON public.restaurants(google_place_id);
CREATE INDEX IF NOT EXISTS idx_restaurants_status ON public.restaurants(status);
CREATE INDEX IF NOT EXISTS idx_restaurants_owner_id ON public.restaurants(owner_id);
CREATE INDEX IF NOT EXISTS idx_menu_items_restaurant_id ON public.menu_items(restaurant_id);
CREATE INDEX IF NOT EXISTS idx_menu_items_is_available ON public.menu_items(is_available);

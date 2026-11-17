-- ====================================================================
-- HomeBite Migration: 002_admin_dashboard.sql
-- Admin Role-Based Access Control (RLS) & Management Security Policies
-- ====================================================================

-- 1. Ensure 'admin' exists in user_role enum
DO $$ BEGIN
  ALTER TYPE user_role ADD VALUE IF NOT EXISTS 'admin';
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

-- 2. Function to check if the executing user has admin role
CREATE OR REPLACE FUNCTION public.is_admin()
RETURNS BOOLEAN AS $$
BEGIN
  RETURN EXISTS (
    SELECT 1 FROM public.profiles
    WHERE id = auth.uid() AND role = 'admin'
  );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 3. Security Trigger: Strictly prevent non-admins from assigning themselves the admin role
CREATE OR REPLACE FUNCTION public.check_admin_role_assignment()
RETURNS TRIGGER AS $$
BEGIN
  -- If role is being changed to 'admin'
  IF NEW.role = 'admin' AND (OLD.role IS NULL OR OLD.role <> 'admin') THEN
    -- Check if current authenticated user is an admin or service_role
    IF (auth.jwt() ->> 'role' <> 'service_role') AND NOT public.is_admin() THEN
      RAISE EXCEPTION 'Access Denied: Only existing Platform Admins can assign the admin role.';
    END IF;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS tr_check_admin_role_assignment ON public.profiles;
CREATE TRIGGER tr_check_admin_role_assignment
  BEFORE INSERT OR UPDATE ON public.profiles
  FOR EACH ROW
  EXECUTE FUNCTION public.check_admin_role_assignment();

-- 4. Admin Management Policies on Providers / Restaurants
-- Allows admins to view, insert, update and delete any provider record
DO $$ BEGIN
  DROP POLICY IF EXISTS "Admins full management on providers" ON public.providers;
  CREATE POLICY "Admins full management on providers"
    ON public.providers FOR ALL
    USING (public.is_admin());
EXCEPTION WHEN undefined_table THEN NULL; END $$;

DO $$ BEGIN
  DROP POLICY IF EXISTS "Admins full management on restaurants" ON public.restaurants;
  CREATE POLICY "Admins full management on restaurants"
    ON public.restaurants FOR ALL
    USING (public.is_admin());
EXCEPTION WHEN undefined_table THEN NULL; END $$;

-- 5. Admin Management Policies on Menu Items
DO $$ BEGIN
  DROP POLICY IF EXISTS "Admins full management on provider_menu_items" ON public.provider_menu_items;
  CREATE POLICY "Admins full management on provider_menu_items"
    ON public.provider_menu_items FOR ALL
    USING (public.is_admin());
EXCEPTION WHEN undefined_table THEN NULL; END $$;

DO $$ BEGIN
  DROP POLICY IF EXISTS "Admins full management on menu_items" ON public.menu_items;
  CREATE POLICY "Admins full management on menu_items"
    ON public.menu_items FOR ALL
    USING (public.is_admin());
EXCEPTION WHEN undefined_table THEN NULL; END $$;

-- 6. Admin Management Policies on Orders
DO $$ BEGIN
  DROP POLICY IF EXISTS "Admins view and manage all orders" ON public.orders;
  CREATE POLICY "Admins view and manage all orders"
    ON public.orders FOR ALL
    USING (public.is_admin());
EXCEPTION WHEN undefined_table THEN NULL; END $$;

-- 7. Admin Policies on Profiles (Customers and Providers)
DO $$ BEGIN
  DROP POLICY IF EXISTS "Admins view and update all profiles" ON public.profiles;
  CREATE POLICY "Admins view and update all profiles"
    ON public.profiles FOR ALL
    USING (public.is_admin());
EXCEPTION WHEN undefined_table THEN NULL; END $$;

-- 8. Admin Policies on Chef Applications
DO $$ BEGIN
  DROP POLICY IF EXISTS "Admins manage chef applications" ON public.chef_applications;
  CREATE POLICY "Admins manage chef applications"
    ON public.chef_applications FOR ALL
    USING (public.is_admin());
EXCEPTION WHEN undefined_table THEN NULL; END $$;

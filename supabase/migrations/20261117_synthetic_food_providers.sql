-- ====================================================================
-- HomeBite – Synthetic Food Provider Database & Location-Based Feed
-- PostgreSQL / Supabase Migration & Seed Script
-- Locality Cluster: Sreenidhi Institute of Science & Technology (SNIST),
-- Ghatkesar, Narapally, Peerzadiguda, Boduppal, Uppal, Telangana
-- ====================================================================

-- 1. Ensure user_role enum includes 'restaurant_owner'
DO $$ BEGIN
  ALTER TYPE user_role ADD VALUE IF NOT EXISTS 'restaurant_owner';
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

-- 2. Providers / Restaurants Table
CREATE TABLE IF NOT EXISTS public.providers (
  id TEXT PRIMARY KEY,
  owner_id UUID REFERENCES public.profiles(id) ON DELETE SET NULL,
  name TEXT NOT NULL,
  type TEXT NOT NULL CHECK (type IN ('home_kitchen', 'cloud_kitchen', 'healthy_restaurant')),
  description TEXT,
  address TEXT NOT NULL,
  locality TEXT NOT NULL,
  lat DOUBLE PRECISION NOT NULL,
  lon DOUBLE PRECISION NOT NULL,
  cuisine TEXT[] DEFAULT '{}',
  rating NUMERIC(3, 2) DEFAULT 4.8,
  reviews_count INTEGER DEFAULT 120,
  prep_time_minutes INTEGER DEFAULT 20,
  min_order_amount NUMERIC(8, 2) DEFAULT 50.00,
  is_delivery_available BOOLEAN DEFAULT TRUE,
  opening_hours TEXT DEFAULT '8:00 AM - 10:00 PM',
  cover_image TEXT,
  is_verified BOOLEAN DEFAULT TRUE,
  is_demo BOOLEAN DEFAULT TRUE,
  status TEXT NOT NULL DEFAULT 'approved' CHECK (status IN ('pending', 'approved', 'rejected')),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- 3. Menu Items Table
CREATE TABLE IF NOT EXISTS public.provider_menu_items (
  id TEXT PRIMARY KEY,
  provider_id TEXT NOT NULL REFERENCES public.providers(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  description TEXT,
  price NUMERIC(8, 2) NOT NULL CHECK (price >= 0),
  image_url TEXT,
  cuisine TEXT,
  category TEXT DEFAULT 'lunch' CHECK (category IN ('breakfast', 'lunch', 'dinner', 'snacks', 'high-protein')),
  dietary TEXT DEFAULT 'veg' CHECK (dietary IN ('veg', 'non-veg', 'vegan')),
  tags TEXT[] DEFAULT '{}',
  calories INTEGER,
  protein_grams NUMERIC(5, 1),
  is_available BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 4. Enable Row Level Security (RLS)
ALTER TABLE public.providers ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.provider_menu_items ENABLE ROW LEVEL SECURITY;

-- Providers Policies
DROP POLICY IF EXISTS "Public can view approved providers" ON public.providers;
CREATE POLICY "Public can view approved providers"
  ON public.providers FOR SELECT
  USING (status = 'approved');

DROP POLICY IF EXISTS "Providers can manage own business" ON public.providers;
CREATE POLICY "Providers can manage own business"
  ON public.providers FOR ALL
  USING (auth.uid() = owner_id);

DROP POLICY IF EXISTS "Admins can manage all providers" ON public.providers;
CREATE POLICY "Admins can manage all providers"
  ON public.providers FOR ALL
  USING (EXISTS (SELECT 1 FROM public.profiles WHERE id = auth.uid() AND role = 'admin'));

-- Menu Items Policies
DROP POLICY IF EXISTS "Public can view available menu items" ON public.provider_menu_items;
CREATE POLICY "Public can view available menu items"
  ON public.provider_menu_items FOR SELECT
  USING (
    is_available = TRUE AND
    EXISTS (SELECT 1 FROM public.providers WHERE id = provider_id AND status = 'approved')
  );

DROP POLICY IF EXISTS "Providers can manage own menu items" ON public.provider_menu_items;
CREATE POLICY "Providers can manage own menu items"
  ON public.provider_menu_items FOR ALL
  USING (EXISTS (SELECT 1 FROM public.providers WHERE id = provider_id AND owner_id = auth.uid()));

DROP POLICY IF EXISTS "Admins can manage all menu items" ON public.provider_menu_items;
CREATE POLICY "Admins can manage all menu items"
  ON public.provider_menu_items FOR ALL
  USING (EXISTS (SELECT 1 FROM public.profiles WHERE id = auth.uid() AND role = 'admin'));

-- 5. Spatial & Fast Lookup Indexes
CREATE INDEX IF NOT EXISTS idx_providers_locality ON public.providers(locality);
CREATE INDEX IF NOT EXISTS idx_providers_lat_lon ON public.providers(lat, lon);
CREATE INDEX IF NOT EXISTS idx_providers_status ON public.providers(status);
CREATE INDEX IF NOT EXISTS idx_menu_items_provider_id ON public.provider_menu_items(provider_id);

-- ====================================================================
-- SEED DATA: 50 SYNTHETIC FOOD PROVIDERS (Telangana / SNIST Hub)
-- ====================================================================

INSERT INTO public.providers (
  id, name, type, description, address, locality, lat, lon, cuisine, 
  rating, reviews_count, prep_time_minutes, min_order_amount, is_delivery_available, 
  opening_hours, cover_image, is_verified, is_demo, status
) VALUES
-- SNIST / Yamnampet Cluster (Highest Concentration: 14 providers)
('prov-snist-1', 'Sreenidhi Home Tiffins & Dabba', 'home_kitchen', 'Homestyle breakfast and student lunch dabbas made by aunty with low oil and pure ghee. Soft hot idlis and comforting sambar rice.', 'H.No 3-45, SNIST College Main Gate Road, Yamnampet, Ghatkesar', 'SNIST / Yamnampet', 17.4585, 78.6372, ARRAY['South Indian', 'Tiffins', 'Homestyle Thalis'], 4.88, 164, 15, 50, true, '7:00 AM - 9:30 PM', 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=800&q=80', true, true, 'approved'),
('prov-snist-2', 'Anasuya Amma''s Kitchen', 'home_kitchen', 'Authentic Telangana homemade thalis, pachi pulusu, mudda pappu, and fresh rotis prepared fresh daily with mom''s love.', 'Plot 12, Behind SNIST Girls Hostel, Yamnampet, Ghatkesar', 'SNIST / Yamnampet', 17.4592, 78.6358, ARRAY['Telangana Homestyle', 'Comfort Food', 'Veg Thalis'], 4.92, 218, 20, 60, true, '11:30 AM - 10:00 PM', 'https://images.unsplash.com/photo-1610057099431-d73a1c9d2f2f?auto=format&fit=crop&w=800&q=80', true, true, 'approved'),
('prov-snist-3', 'Yamnampet Student Rasoi', 'cloud_kitchen', 'Affordable and wholesome student lunch and dinner dabbas with generous portions. Zero soda, zero palm oil.', 'Opp. Primary Health Center, Yamnampet Village, Ghatkesar', 'SNIST / Yamnampet', 17.4561, 78.6391, ARRAY['North Indian', 'Homestyle', 'Combo Meals'], 4.75, 142, 18, 70, true, '8:00 AM - 10:30 PM', 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=800&q=80', true, true, 'approved'),
('prov-snist-4', 'FitBite High-Protein Kitchen', 'cloud_kitchen', 'Macro-calculated gym diet meals designed for hostellers and athletes. High protein, grilled paneer, soya chunks, boiled sprouts.', 'Engineering Enclave, SNIST Bypass Road, Yamnampet', 'SNIST / Yamnampet', 17.4552, 78.6345, ARRAY['High Protein', 'Gym Diet', 'Healthy Bowls'], 4.86, 189, 22, 99, true, '9:00 AM - 10:00 PM', 'https://images.unsplash.com/photo-1631452180519-c014fe946bc7?auto=format&fit=crop&w=800&q=80', true, true, 'approved'),
('prov-snist-5', 'Green Leaf Millet Cafe', 'healthy_restaurant', 'Wholesome gluten-free millet dosas, ragi sangati with natukodi style curry, and jowar rotis. Pure wholesome nutrition.', 'Survey 112, SNIST Arch Junction, Yamnampet Road, Ghatkesar', 'SNIST / Yamnampet', 17.4601, 78.6385, ARRAY['Millet Meals', 'South Indian', 'Healthy Diners'], 4.81, 95, 20, 80, true, '7:30 AM - 9:30 PM', 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?auto=format&fit=crop&w=800&q=80', true, true, 'approved'),
('prov-snist-6', 'Sai Krupa Homely Mess', 'home_kitchen', 'Daily hot tiffin carrier service. Unlimited sambar, rasam, curd, and seasonal vegetable vepudu for engineering students.', 'Near Water Tank, Yamnampet Village, Ghatkesar', 'SNIST / Yamnampet', 17.4539, 78.6402, ARRAY['South Indian', 'Mess Food', 'Unlimited Rice Combos'], 4.79, 110, 15, 60, true, '11:00 AM - 3:30 PM', 'https://images.unsplash.com/photo-1626777552726-4a6b54c97e46?auto=format&fit=crop&w=800&q=80', true, true, 'approved'),
('prov-snist-7', 'Aunty''s Special Dabba Service', 'home_kitchen', 'Clean homestyle lunch dabbas delivered hot to college campus gates. Loved by hostellers for comforting Rajma, Dal and soft rotis.', 'H.No 2-88, Teachers Colony, Yamnampet, Ghatkesar', 'SNIST / Yamnampet', 17.4572, 78.6338, ARRAY['Homestyle', 'North Indian', 'Dabba Service'], 4.93, 230, 20, 70, true, '10:30 AM - 9:30 PM', 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=800&q=80', true, true, 'approved'),
('prov-snist-8', 'NutriBowl Healthy Bowls', 'cloud_kitchen', 'Fresh vegetable salads, sprout chaats, multigrain khichdi, and detox bowls. Low calorie and nutrient dense.', 'Lake View Road, Yamnampet, Ghatkesar', 'SNIST / Yamnampet', 17.4528, 78.6375, ARRAY['Salads', 'Low Calorie', 'Khichdi & Bowls'], 4.72, 78, 15, 80, true, '8:00 AM - 9:00 PM', 'https://images.unsplash.com/photo-1540420773420-3366772f4999?auto=format&fit=crop&w=800&q=80', true, true, 'approved'),
('prov-snist-9', 'Satvik Bhojanam Home Cook', 'home_kitchen', 'No onion, no garlic pure sattvic home-cooked meals prepared with clean water and fresh market produce.', 'Near Sri Anjaneya Swamy Temple, Yamnampet, Ghatkesar', 'SNIST / Yamnampet', 17.4565, 78.6421, ARRAY['Sattvic', 'Pure Veg', 'South Indian'], 4.85, 89, 25, 65, true, '11:30 AM - 8:30 PM', 'https://images.unsplash.com/photo-1610057099431-d73a1c9d2f2f?auto=format&fit=crop&w=800&q=80', true, true, 'approved'),
('prov-snist-10', 'Sreenidhi Tiffin Centre & Dosa Point', 'healthy_restaurant', 'Traditional crispy ghee karam dosas, steamed button idlis, and hot pesarattu with ginger pachadi.', 'Yamnampet Bus Stop, SNIST Road, Ghatkesar', 'SNIST / Yamnampet', 17.4589, 78.6341, ARRAY['Tiffins', 'South Indian', 'Breakfast'], 4.82, 175, 12, 40, true, '6:30 AM - 10:00 PM', 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=800&q=80', true, true, 'approved'),
('prov-snist-11', 'Mother''s Touch Home Meals', 'home_kitchen', 'Tender chicken curry cooked with dry roasted spices and zero food colors, served with steaming bagara rice.', 'H.No 5-112, Gram Panchayat Road, Yamnampet, Ghatkesar', 'SNIST / Yamnampet', 17.4545, 78.6322, ARRAY['Homestyle Non-Veg', 'Telangana', 'Rice Bowls'], 4.90, 198, 25, 90, true, '12:00 PM - 10:00 PM', 'https://images.unsplash.com/photo-1603894584373-5ac82b2ae398?auto=format&fit=crop&w=800&q=80', true, true, 'approved'),
('prov-snist-12', 'Protein Hub Cloud Kitchen', 'cloud_kitchen', 'Custom boiled eggs, grilled chicken breast, brown rice thalis, and peanut butter oats bowls for hostel fitness buffs.', 'Tech Colony, Yamnampet X Roads, Ghatkesar', 'SNIST / Yamnampet', 17.4612, 78.6355, ARRAY['High Protein', 'Fitness', 'Bowls'], 4.84, 132, 20, 80, true, '7:00 AM - 10:30 PM', 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?auto=format&fit=crop&w=800&q=80', true, true, 'approved'),
('prov-snist-13', 'Telangana Ruchulu Home Kitchen', 'home_kitchen', 'Jowar rotis with spicy brinjal curry (gutthi vankaya) and gongura pappu. Pure authentic village taste.', 'Old Village Road, Yamnampet, Ghatkesar', 'SNIST / Yamnampet', 17.4532, 78.6388, ARRAY['Telangana', 'Jowar Rotis', 'Vegetarian'], 4.87, 145, 22, 70, true, '11:30 AM - 9:30 PM', 'https://images.unsplash.com/photo-1626777552726-4a6b54c97e46?auto=format&fit=crop&w=800&q=80', true, true, 'approved'),
('prov-snist-14', 'Shanti Pure Veg Healthy Diner', 'healthy_restaurant', 'Hygienic multi-cuisine vegetarian restaurant serving dalia khichdi, curd rice bowls, and fresh seasonal juices.', 'SNIST College Bypass Corner, Yamnampet', 'SNIST / Yamnampet', 17.4598, 78.6398, ARRAY['Pure Veg', 'Healthy Bowls', 'Fresh Juices'], 4.76, 92, 18, 60, true, '8:00 AM - 10:00 PM', 'https://images.unsplash.com/photo-1540420773420-3366772f4999?auto=format&fit=crop&w=800&q=80', true, true, 'approved'),

-- Ghatkesar Town & Station Cluster (12 providers)
('prov-ghat-1', 'Ghatkesar Homely Tiffin House', 'home_kitchen', 'Generations-old recipe for soft ghee idli, crispy medu vada, and rich peanut chutney. Clean family-run kitchen.', 'Station Road, Near Railway Overbridge, Ghatkesar', 'Ghatkesar', 17.4485, 78.6825, ARRAY['South Indian', 'Tiffins', 'Breakfast'], 4.89, 240, 15, 50, true, '6:30 AM - 9:00 PM', 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=800&q=80', true, true, 'approved'),
('prov-ghat-2', 'Padmavati Ammavari Kitchen', 'home_kitchen', 'Homestyle full lunch thalis with 2 vegetable curries, dal, sambar, rasam, curd, and papad. Just like eating at home.', 'Opp. RTC Bus Stand, Main Road, Ghatkesar', 'Ghatkesar', 17.4468, 78.6805, ARRAY['South Indian Thalis', 'Homestyle', 'Vegetarian'], 4.85, 178, 20, 70, true, '11:00 AM - 10:00 PM', 'https://images.unsplash.com/photo-1610057099431-d73a1c9d2f2f?auto=format&fit=crop&w=800&q=80', true, true, 'approved'),
('prov-ghat-3', 'Healthy Harvest Millet Cafe', 'healthy_restaurant', 'Millet based biryani, foxtail millet lemon rice, and barnyard millet upma. Diabetic friendly, heart healthy.', 'Shop 14, Main Commercial Complex, Shivaji Chowk, Ghatkesar', 'Ghatkesar', 17.4492, 78.6841, ARRAY['Millets', 'Diabetic Friendly', 'Healthy Rice Bowls'], 4.80, 115, 22, 90, true, '8:00 AM - 9:30 PM', 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?auto=format&fit=crop&w=800&q=80', true, true, 'approved'),
('prov-ghat-4', 'Sri Rama Daily Dabba Service', 'home_kitchen', 'Monthly and daily dabba provider for corporate workers and students in Ghatkesar. Hygienic stainless steel packed meals.', 'Subhash Nagar, Behind Police Station, Ghatkesar', 'Ghatkesar', 17.4455, 78.6792, ARRAY['Daily Dabba', 'North & South Indian', 'Homestyle'], 4.78, 135, 20, 65, true, '10:30 AM - 9:00 PM', 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=800&q=80', true, true, 'approved'),
('prov-ghat-5', 'Fresh & Lean Cloud Kitchen', 'cloud_kitchen', 'Grilled cottage cheese wraps, egg white bhurji with multigrain parathas, and high protein sprouted moong salads.', 'Bypass Road, Near Highway Toll Plaza, Ghatkesar', 'Ghatkesar', 17.4435, 78.6855, ARRAY['High Protein', 'Salads', 'Healthy Wraps'], 4.83, 96, 18, 85, true, '9:00 AM - 10:30 PM', 'https://images.unsplash.com/photo-1631452180519-c014fe946bc7?auto=format&fit=crop&w=800&q=80', true, true, 'approved'),
('prov-ghat-6', 'Kavitha''s South Indian Home Mess', 'home_kitchen', 'Traditional spicy Andhra style chicken fry, tomato rasam, and fresh steaming white rice with pure ghee.', 'H.No 4-12, Old Post Office Road, Ghatkesar', 'Ghatkesar', 17.4470, 78.6830, ARRAY['Andhra Homestyle', 'Chicken Specials', 'Meals'], 4.91, 205, 25, 90, true, '12:00 PM - 10:00 PM', 'https://images.unsplash.com/photo-1603894584373-5ac82b2ae398?auto=format&fit=crop&w=800&q=80', true, true, 'approved'),
('prov-ghat-7', 'Pure Veg Bhojan Shala', 'healthy_restaurant', 'Authentic Marwari & North Indian satvik thalis. Phulkas smeared with light cow ghee, dal fry, jeera rice.', 'Near Grain Market, Ghatkesar Town', 'Ghatkesar', 17.4489, 78.6780, ARRAY['Pure Veg', 'North Indian', 'Thalis'], 4.79, 150, 20, 80, true, '11:00 AM - 10:30 PM', 'https://images.unsplash.com/photo-1610057099431-d73a1c9d2f2f?auto=format&fit=crop&w=800&q=80', true, true, 'approved'),
('prov-ghat-8', 'Desi Ghee Phulka & Curry Point', 'home_kitchen', 'Hot, puffed phulkas straight off the tawa, paired with aromatic methi paneer and slow-simmered tadka dal.', 'Opp. Railway Station Gate, Ghatkesar', 'Ghatkesar', 17.4498, 78.6815, ARRAY['Roti & Curries', 'Comfort Food', 'Veg'], 4.86, 168, 18, 60, true, '12:00 PM - 10:30 PM', 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=800&q=80', true, true, 'approved'),
('prov-ghat-9', 'NutriDiet Home Kitchen', 'cloud_kitchen', 'Low-sodium, heart-friendly steamed meals, vegetable poha, oats upma, and seasonal vegetable soups.', 'Shanti Nagar Colony, Ghatkesar', 'Ghatkesar', 17.4460, 78.6860, ARRAY['Low Sodium', 'Healthy Breakfast', 'Soups & Salads'], 4.73, 65, 20, 75, true, '7:00 AM - 8:30 PM', 'https://images.unsplash.com/photo-1540420773420-3366772f4999?auto=format&fit=crop&w=800&q=80', true, true, 'approved'),
('prov-ghat-10', 'Ghatkesar Curd Rice & Meal Box', 'home_kitchen', 'Cooling homemade curd rice with mustard tempering, pomegranate seeds, served with tender potato fry.', 'Gandhi Statue Road, Ghatkesar', 'Ghatkesar', 17.4478, 78.6810, ARRAY['Curd Rice', 'Comfort Food', 'Quick Meals'], 4.88, 190, 12, 50, true, '10:00 AM - 10:00 PM', 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=800&q=80', true, true, 'approved'),
('prov-ghat-11', 'The Healthy Thali Co.', 'healthy_restaurant', 'Clean, calorie-conscious executive lunch boxes with whole grains, raw salads, and balanced nutrition.', 'Ghatkesar Bypass Road, Near Indian Oil Bunk', 'Ghatkesar', 17.4425, 78.6840, ARRAY['Executive Meals', 'Calorie Conscious', 'Thalis'], 4.82, 112, 20, 99, true, '11:00 AM - 10:00 PM', 'https://images.unsplash.com/photo-1610057099431-d73a1c9d2f2f?auto=format&fit=crop&w=800&q=80', true, true, 'approved'),
('prov-ghat-12', 'Wholesome Grains Kitchen', 'cloud_kitchen', 'Multi-millet khichdi, red rice lemon rice, and organic cold-pressed oil curries.', 'Sector 3, Housing Board, Ghatkesar', 'Ghatkesar', 17.4502, 78.6795, ARRAY['Organic', 'Millet Khichdi', 'Healthy'], 4.77, 88, 22, 80, true, '8:30 AM - 9:30 PM', 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?auto=format&fit=crop&w=800&q=80', true, true, 'approved'),

-- Narapally Cluster (8 providers)
('prov-nara-1', 'Narapally Homestyle Dabba', 'home_kitchen', 'Homestyle student lunch and dinner tiffins cooked in home kitchens by certified homemakers. Pure hygienic taste.', 'Near Pocharam Infopath Cross, Warangal Highway, Narapally', 'Narapally', 17.4295, 78.6265, ARRAY['Homestyle', 'South Indian', 'Tiffin Service'], 4.90, 220, 18, 65, true, '7:00 AM - 10:00 PM', 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=800&q=80', true, true, 'approved'),
('prov-nara-2', 'Siri Pure Veg Cloud Kitchen', 'cloud_kitchen', 'Fresh palak paneer, dal makhani, jeera rice and whole wheat rotis. Zero preservatives.', 'Plot 45, Nandanavanam Colony, Narapally', 'Narapally', 17.4278, 78.6245, ARRAY['Pure Veg', 'North Indian', 'Homestyle'], 4.84, 165, 20, 70, true, '11:00 AM - 10:30 PM', 'https://images.unsplash.com/photo-1610057099431-d73a1c9d2f2f?auto=format&fit=crop&w=800&q=80', true, true, 'approved'),
('prov-nara-3', 'Athidhi Home Kitchen', 'home_kitchen', 'Authentic Andhra meals with avakaya pickle, mudda pappu, majjiga pulusu and crispy papad.', 'Bank Colony, Narapally, Hyderabad', 'Narapally', 17.4265, 78.6280, ARRAY['Andhra Meals', 'Vegetarian', 'Traditional'], 4.87, 140, 20, 75, true, '11:30 AM - 9:30 PM', 'https://images.unsplash.com/photo-1626777552726-4a6b54c97e46?auto=format&fit=crop&w=800&q=80', true, true, 'approved'),
('prov-nara-4', 'FitFuel Bowls & Salads', 'cloud_kitchen', 'Clean nutrition bowls: high-protein paneer salad, boiled eggs with pepper seasoning, hummus & multigrain pita.', 'Warangal Highway Main Road, Narapally', 'Narapally', 17.4305, 78.6235, ARRAY['Salads', 'Gym Diet', 'Clean Eating'], 4.79, 105, 15, 90, true, '9:00 AM - 10:00 PM', 'https://images.unsplash.com/photo-1540420773420-3366772f4999?auto=format&fit=crop&w=800&q=80', true, true, 'approved'),
('prov-nara-5', 'Grandma''s Dal & Roti Corner', 'home_kitchen', 'Just simple, comforting phulkas with dal tadka and seasonal aloo methi. Easy on digestion, student friendly.', 'H.No 1-78, Sri Sai Nagar, Narapally', 'Narapally', 17.4282, 78.6272, ARRAY['Comfort Food', 'Dal Roti', 'Budget'], 4.88, 180, 16, 50, true, '11:00 AM - 10:00 PM', 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=800&q=80', true, true, 'approved'),
('prov-nara-6', 'Bhojanam Healthy Food Point', 'healthy_restaurant', 'Nutritious brown rice plates, vegetable sambar, sprouts stir fry, and fresh buttermilk.', 'Near Narapally Junction, Warangal Highway', 'Narapally', 17.4290, 78.6295, ARRAY['Healthy Rice', 'South Indian', 'Buttermilk'], 4.76, 98, 18, 70, true, '8:00 AM - 9:30 PM', 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?auto=format&fit=crop&w=800&q=80', true, true, 'approved'),
('prov-nara-7', 'Millet Magic Tiffin Hub', 'healthy_restaurant', 'Kodo millet idlis, foxtail millet upma, and ragi malt. 100% wholesome, nutrient packed breakfast.', 'Warangal Highway, Narapally X Roads', 'Narapally', 17.4312, 78.6248, ARRAY['Millets', 'Tiffins', 'Ragi Malt'], 4.83, 112, 14, 50, true, '6:30 AM - 9:30 PM', 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=800&q=80', true, true, 'approved'),
('prov-nara-8', 'Protein Box Cloud Kitchen', 'cloud_kitchen', 'Loaded gym boxes with 35g+ natural protein. Grilled chicken, boiled eggs, sweet potato wedges.', 'Pocharam IT Corridor Road, Narapally', 'Narapally', 17.4258, 78.6260, ARRAY['High Protein', 'Fitness', 'Keto'], 4.89, 176, 20, 110, true, '10:00 AM - 11:00 PM', 'https://images.unsplash.com/photo-1631452180519-c014fe946bc7?auto=format&fit=crop&w=800&q=80', true, true, 'approved'),

-- Peerzadiguda Cluster (6 providers)
('prov-peer-1', 'Peerzadiguda Homely Kitchen', 'home_kitchen', 'Comforting family meals: tomato dal, crispy potato roast, hot phulkas, and fresh raita prepared by home cooks.', 'Medipally Main Road, Peerzadiguda, Hyderabad', 'Peerzadiguda', 17.4135, 78.5885, ARRAY['Homestyle', 'South Indian', 'Veg Thalis'], 4.85, 195, 20, 60, true, '11:00 AM - 10:00 PM', 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=800&q=80', true, true, 'approved'),
('prov-peer-2', 'Sattvic Spoons Cloud Kitchen', 'cloud_kitchen', 'Pure vegetarian, low-spice meals made with cow ghee and rock salt. Wholesome khichdi and fresh chapati combos.', 'Municipal Office Road, Peerzadiguda', 'Peerzadiguda', 17.4118, 78.5862, ARRAY['Sattvic', 'Pure Veg', 'Khichdi'], 4.81, 120, 18, 70, true, '11:30 AM - 9:30 PM', 'https://images.unsplash.com/photo-1610057099431-d73a1c9d2f2f?auto=format&fit=crop&w=800&q=80', true, true, 'approved'),
('prov-peer-3', 'NutriBowl Healthy Salads', 'cloud_kitchen', 'Gourmet sprout bowls, paneer tikka salad, chickpea protein cups, and cucumber mint detox juices.', 'Sai Priya Colony, Peerzadiguda', 'Peerzadiguda', 17.4142, 78.5898, ARRAY['Salads', 'Healthy Bowls', 'Detox Juices'], 4.78, 88, 15, 85, true, '8:00 AM - 9:30 PM', 'https://images.unsplash.com/photo-1540420773420-3366772f4999?auto=format&fit=crop&w=800&q=80', true, true, 'approved'),
('prov-peer-4', 'Amma Chethi Vanta', 'home_kitchen', 'Traditional Telugu home cooking: perugu pachadi, bendakaya vepudu, and piping hot rasam rice.', 'Main Road, Peerzadiguda, Hyderabad', 'Peerzadiguda', 17.4108, 78.5870, ARRAY['Telugu Homestyle', 'Rasam Rice', 'Curries'], 4.92, 210, 22, 65, true, '11:00 AM - 10:00 PM', 'https://images.unsplash.com/photo-1626777552726-4a6b54c97e46?auto=format&fit=crop&w=800&q=80', true, true, 'approved'),
('prov-peer-5', 'The Millet Table Restaurant', 'healthy_restaurant', 'Full service organic millet restaurant serving millet pulav, ragi sankati, and sprouted lentil dosas.', 'Warangal Highway, Peerzadiguda', 'Peerzadiguda', 17.4150, 78.5855, ARRAY['Millets', 'Organic', 'South Indian'], 4.84, 142, 22, 90, true, '7:30 AM - 10:00 PM', 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?auto=format&fit=crop&w=800&q=80', true, true, 'approved'),
('prov-peer-6', 'Daily Balanced Diet Dabba', 'cloud_kitchen', 'Subscription friendly lunch dabbas with brown rice, 2 rotis, boiled dal, green vegetable, and buttermilk.', 'Peerzadiguda Extension, Near Kaman', 'Peerzadiguda', 17.4095, 78.5888, ARRAY['Balanced Diet', 'Thalis', 'Low Oil'], 4.80, 95, 18, 70, true, '10:30 AM - 9:30 PM', 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=800&q=80', true, true, 'approved'),

-- Boduppal Cluster (5 providers)
('prov-bodu-1', 'Boduppal Healthy Home Meals', 'home_kitchen', 'Freshly rolled hot phulkas, nutritious dal palak, jeera rice, and curd. Zero heavy cream or soda.', 'Srinivas Nagar Colony, Boduppal, Hyderabad', 'Boduppal', 17.4155, 78.5725, ARRAY['Homestyle', 'Veg Meals', 'Dal Phulka'], 4.87, 185, 18, 60, true, '11:00 AM - 10:00 PM', 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=800&q=80', true, true, 'approved'),
('prov-bodu-2', 'Green Garden Cloud Kitchen', 'cloud_kitchen', 'Hygienic steamed sprouts, vegetable quinoa bowls, and low-oil paneer bhurji meal boxes.', 'Boduppal Ring Road, Near Ambedkar Statue', 'Boduppal', 17.4138, 78.5702, ARRAY['Healthy Bowls', 'Quinoa & Salads', 'Fitness'], 4.82, 110, 16, 85, true, '9:00 AM - 10:00 PM', 'https://images.unsplash.com/photo-1540420773420-3366772f4999?auto=format&fit=crop&w=800&q=80', true, true, 'approved'),
('prov-bodu-3', 'Gayatri Homely Mess', 'home_kitchen', 'Authentic Andhra student mess with unlimited sambar, gun powder (karam podi), pure ghee, and rice.', 'Main Road, Boduppal, Hyderabad', 'Boduppal', 17.4162, 78.5735, ARRAY['South Indian Mess', 'Andhra', 'Vegetarian'], 4.89, 230, 15, 55, true, '11:30 AM - 10:30 PM', 'https://images.unsplash.com/photo-1626777552726-4a6b54c97e46?auto=format&fit=crop&w=800&q=80', true, true, 'approved'),
('prov-bodu-4', 'NutriPlate High Protein Hub', 'cloud_kitchen', '30g-40g protein meal boxes for gym-goers. Chicken breast thali, boiled egg bowls, soya chunks biryani.', 'Shirdi Sai Nagar, Boduppal', 'Boduppal', 17.4125, 78.5695, ARRAY['High Protein', 'Gym Meals', 'Non-Veg'], 4.86, 145, 22, 99, true, '10:30 AM - 11:00 PM', 'https://images.unsplash.com/photo-1631452180519-c014fe946bc7?auto=format&fit=crop&w=800&q=80', true, true, 'approved'),
('prov-bodu-5', 'Vasavi Pure Veg Healthy Diner', 'healthy_restaurant', 'Hygienic traditional vegetarian food: moong dal chilla, multi-grain dosas, vegetable khichdi.', 'Mallikarjuna Nagar, Boduppal', 'Boduppal', 17.4170, 78.5718, ARRAY['Pure Veg', 'Moong Chilla', 'Healthy Tiffins'], 4.79, 102, 15, 60, true, '7:00 AM - 10:00 PM', 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=800&q=80', true, true, 'approved'),

-- Uppal Cluster (5 providers)
('prov-uppal-1', 'Uppal Metro Health Bowl Co.', 'healthy_restaurant', 'Modern health cafe near Uppal metro serving macro-counted salad bowls, avocado toast, and protein smoothies.', 'Pillar 920, Inner Ring Road, Uppal Metro Station', 'Uppal', 17.4025, 78.5615, ARRAY['Healthy Bowls', 'Smoothies', 'Salads'], 4.88, 215, 15, 99, true, '8:00 AM - 10:30 PM', 'https://images.unsplash.com/photo-1540420773420-3366772f4999?auto=format&fit=crop&w=800&q=80', true, true, 'approved'),
('prov-uppal-2', 'Swadist Homestyle Thalis', 'home_kitchen', 'Hearty North Indian & Gujarati thalis made with low oil and pure ghee. Soft phulkas, Gujarati kadhi, khichdi.', 'Survey of India Road, Uppal', 'Uppal', 17.4010, 78.5588, ARRAY['Homestyle Thalis', 'North Indian', 'Comfort Food'], 4.85, 198, 20, 70, true, '11:30 AM - 10:00 PM', 'https://images.unsplash.com/photo-1610057099431-d73a1c9d2f2f?auto=format&fit=crop&w=800&q=80', true, true, 'approved'),
('prov-uppal-3', 'Organic Roots Healthy Restaurant', 'healthy_restaurant', 'Farm-to-table organic dining. Desi cow ghee meals, organic brown rice, cold pressed oil vegetables.', 'Near Uppal Ring Road Junction, Hyderabad', 'Uppal', 17.4035, 78.5630, ARRAY['Organic', 'Farm-to-Table', 'South Indian'], 4.82, 160, 22, 110, true, '8:00 AM - 10:00 PM', 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?auto=format&fit=crop&w=800&q=80', true, true, 'approved'),
('prov-uppal-4', 'The Protein Factory Cloud Kitchen', 'cloud_kitchen', 'Clean calorie-counted high-protein meals: grilled chicken rice box, boiled egg curry, high-protein paneer wraps.', 'Ramanthapur Main Road, Uppal', 'Uppal', 17.3995, 78.5575, ARRAY['High Protein', 'Fitness Bowls', 'Diet Meals'], 4.87, 175, 18, 90, true, '10:00 AM - 11:00 PM', 'https://images.unsplash.com/photo-1631452180519-c014fe946bc7?auto=format&fit=crop&w=800&q=80', true, true, 'approved'),
('prov-uppal-5', 'Aarogya Millet Bhojanam', 'healthy_restaurant', 'Complete 5-millet traditional thali with ragi sangati, jowar roti, sajja rotti, native dal and leafy greens.', 'Chilkanagar Main Road, Uppal', 'Uppal', 17.4042, 78.5645, ARRAY['Millets', 'Traditional Telugu', 'Pure Veg'], 4.84, 135, 20, 80, true, '7:30 AM - 9:30 PM', 'https://images.unsplash.com/photo-1626777552726-4a6b54c97e46?auto=format&fit=crop&w=800&q=80', true, true, 'approved')
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  rating = EXCLUDED.rating,
  lat = EXCLUDED.lat,
  lon = EXCLUDED.lon,
  updated_at = NOW();

-- ====================================================================
-- SEED DATA: SAMPLE MENU ITEMS
-- ====================================================================

INSERT INTO public.provider_menu_items (
  id, provider_id, name, description, price, image_url, cuisine, category, dietary, tags, calories, protein_grams, is_available
) VALUES
('item-snist-1-1', 'prov-snist-1', 'Steamed Button Ghee Idli (4 pcs)', 'Melt-in-mouth steamed idlis drizzled with pure cow ghee, served with thick peanut chutney and piping hot drumstick sambar.', 49.00, 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=600&q=80', 'South Indian', 'breakfast', 'veg', ARRAY['Homemade', 'Low Oil', 'Pure Ghee', 'Student Special'], 280, 8.0, true),
('item-snist-1-2', 'prov-snist-1', 'Homestyle Sambar Rice & Potato Vepudu', 'Comforting slow-cooked lentils and rice cooked with drumsticks, carrots, and shallots, paired with crispy roasted spiced potato.', 79.00, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80', 'South Indian', 'lunch', 'veg', ARRAY['Homemade', 'Comfort Food', 'Best Seller'], 460, 12.0, true),
('item-snist-1-3', 'prov-snist-1', 'Crispy Ghee Karam Dosa', 'Crispy golden dosa roasted with pure desi ghee and coated with spicy garlic karam powder, served with two chutneys.', 59.00, 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=600&q=80', 'South Indian', 'breakfast', 'veg', ARRAY['Crispy', 'Pure Ghee', 'Tiffin'], 340, 7.0, true),
('item-snist-1-4', 'prov-snist-1', 'Daily Student Executive Dabba', '3 whole wheat phulkas, homestyle tadka dal, seasonal vegetable sabzi, steamed rice, and homemade curd.', 99.00, 'https://images.unsplash.com/photo-1610057099431-d73a1c9d2f2f?auto=format&fit=crop&w=600&q=80', 'Homestyle', 'lunch', 'veg', ARRAY['Balanced Meal', 'Complete Thali', 'Affordable'], 540, 18.0, true),
('item-snist-2-1', 'prov-snist-2', 'Amma''s Special Mudda Pappu & Avakaya Rice', 'Hot steamed rice mixed with thick yellow toor dal, dollop of fresh cow ghee, and spicy homemade Andhra avakaya mango pickle.', 89.00, 'https://images.unsplash.com/photo-1626777552726-4a6b54c97e46?auto=format&fit=crop&w=600&q=80', 'Telangana Homestyle', 'lunch', 'veg', ARRAY['Traditional', 'Pure Ghee', 'Mom''s Recipe'], 490, 14.0, true),
('item-snist-2-2', 'prov-snist-2', 'Jowar Roti (2 pcs) with Gutthi Vankaya Curry', 'Gluten-free traditional sorghum rotis served with stuffed baby brinjal gravy made with sesame and roasted peanuts.', 99.00, 'https://images.unsplash.com/photo-1610057099431-d73a1c9d2f2f?auto=format&fit=crop&w=600&q=80', 'Telangana Homestyle', 'dinner', 'vegan', ARRAY['Gluten-Free', 'Millet', 'High Fiber'], 420, 13.0, true),
('item-snist-3-1', 'prov-snist-3', 'Special Rajma Chawal Student Combo', 'Slow-simmered Kashmiri red kidney beans in tomato ginger gravy served with fragrant basmati jeera rice and spiced onion salad.', 89.00, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80', 'North Indian', 'lunch', 'veg', ARRAY['High Fiber', 'Hostel Favorite', 'Affordable'], 510, 18.0, true),
('item-snist-4-1', 'prov-snist-4', 'Gym Bro Paneer Bhurji Meal (32g Protein)', '180g fresh cottage cheese scrambled with tomatoes, onions, spinach and roasted jeera. Served with 3 whole wheat rotis.', 139.00, 'https://images.unsplash.com/photo-1631452180519-c014fe946bc7?auto=format&fit=crop&w=600&q=80', 'High Protein', 'high-protein', 'veg', ARRAY['Gym Diet', '32g Protein', 'Low Carb'], 540, 32.0, true),
('item-snist-4-2', 'prov-snist-4', 'Grilled Chicken Breast Bowl (38g Protein)', '200g tender herb-grilled chicken breast served with steamed brown rice, sauteed broccoli, bell peppers, and low-fat garlic yogurt.', 159.00, 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?auto=format&fit=crop&w=600&q=80', 'High Protein', 'high-protein', 'non-veg', ARRAY['Gym Diet', '38g Protein', 'Lean Meat'], 480, 38.0, true),
('item-snist-5-1', 'prov-snist-5', 'Foxtail Millet Lemon Rice with Peanut Chutney', 'Nutrient-packed Korra (foxtail millet) tempered with curry leaves, crunchy peanuts, green chillies, and fresh lemon juice.', 79.00, 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?auto=format&fit=crop&w=600&q=80', 'Millet Meals', 'lunch', 'vegan', ARRAY['Gluten-Free', 'Millet', 'Diabetic Friendly'], 360, 11.0, true)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  price = EXCLUDED.price,
  is_available = EXCLUDED.is_available;

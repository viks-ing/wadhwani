-- ====================================================================
-- HomeBite – Hybrid Real + Synthetic Restaurant Menu System Migration
-- Schema: menu_items with source tracking and verified/sample badges
-- ====================================================================

-- 1. Create or Update menu_items table
CREATE TABLE IF NOT EXISTS public.menu_items (
  id TEXT PRIMARY KEY,
  restaurant_id TEXT NOT NULL,
  name TEXT NOT NULL,
  description TEXT,
  category TEXT DEFAULT 'lunch' CHECK (category IN ('breakfast', 'lunch', 'dinner', 'snacks', 'high-protein', 'main', 'drinks')),
  price NUMERIC(8, 2) NOT NULL CHECK (price >= 0),
  image_url TEXT,
  is_vegetarian BOOLEAN DEFAULT TRUE,
  dietary_tags TEXT[] DEFAULT '{}',
  is_available BOOLEAN DEFAULT TRUE,
  menu_source TEXT NOT NULL DEFAULT 'synthetic' CHECK (menu_source IN ('google_business_profile', 'official_website', 'official_pdf', 'provider', 'synthetic')),
  menu_status TEXT NOT NULL DEFAULT 'sample' CHECK (menu_status IN ('verified', 'unverified', 'sample')),
  source_url TEXT,
  last_updated_at TIMESTAMPTZ DEFAULT NOW(),
  is_demo BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- 2. Indexes for high performance querying
CREATE INDEX IF NOT EXISTS idx_menu_items_restaurant_id ON public.menu_items(restaurant_id);
CREATE INDEX IF NOT EXISTS idx_menu_items_category ON public.menu_items(category);
CREATE INDEX IF NOT EXISTS idx_menu_items_menu_status ON public.menu_items(menu_status);
CREATE INDEX IF NOT EXISTS idx_menu_items_is_vegetarian ON public.menu_items(is_vegetarian);

-- 3. Enable RLS
ALTER TABLE public.menu_items ENABLE ROW LEVEL SECURITY;

DO $$ BEGIN
  CREATE POLICY "Public read menu_items"
    ON public.menu_items FOR SELECT
    USING (true);
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

-- 4. Upsert Hybrid Real + Synthetic Menu Items

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-1-m1', 'disc-real-1', 'Amma Special Veg Thali Box', '4 Whole wheat rotis, homestyle yellow dal, aloo beans fry, steamed rice, sambar, and home pickle.', 'lunch', 95, 'https://images.unsplash.com/photo-1610057099431-d73a1c9d2f2f?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Zero Soda', 'Mom''s Cooking', 'Balanced Meal'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-1-m2', 'disc-real-1', 'Pachi Pulusu with Hot Rice & Ghee', 'Raw tamarind extract simmered with charred onions, jaggery, and crushed green chillies. Supreme comfort.', 'lunch', 70, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Telangana Heritage', 'Raw Rasam'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-1-m3', 'disc-real-1', 'Homestyle Egg Curry with Rice', '2 Boiled eggs simmered in onion-tomato homestyle gravy, served with portion of steamed rice.', 'dinner', 90, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  false, ARRAY['High Protein', 'Affordable'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-1-m4', 'disc-real-1', 'Palak Pappu with Phulkas (3 pcs)', 'Fresh garden spinach cooked with toor dal and mild cumin garlic seasoning, served with soft puffed phulkas.', 'dinner', 80, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Iron Rich', 'Low Calorie'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-1-m5', 'disc-real-1', 'Kandi Podi Ghee Rice Meal', 'Steamed rice served with homemade roasted lentil gun powder, clarified cow ghee, and crunchy appalam.', 'lunch', 65, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Dry Lentil Podi', 'Quick Lunch'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-1-m6', 'disc-real-1', 'Dondakaya Fry (Tindora Peanut)', 'Ivy gourd roundels stir-fried slowly with crunchy roasted peanuts and mild red chilli.', 'dinner', 60, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Homestyle Sabzi', 'Crisp'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-1-m7', 'disc-real-1', 'Menthi Kura Pappu (Fenugreek Dal)', 'Warm yellow lentils infused with slightly bitter fresh methi leaves and garlic tempering.', 'lunch', 60, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Herbal', 'Digestive'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-1-m8', 'disc-real-1', 'Kobbari Annam (Coconut Rice)', 'Short grain rice flavored with fresh grated coconut, cashews, mustard seeds, and whole green chillies.', 'lunch', 80, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Festive Flavor', 'Aromatic'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-1-m9', 'disc-real-1', 'Telangana Sarva Pindi (Snack)', 'Traditional savoury pancake made with rice flour, chana dal, sesame seeds, and spring onion.', 'snacks', 40, 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Telangana Specialty', 'Crisp Crust'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-2-m1', 'disc-real-2', 'Authentic Andhra Bhojanam (Full Meal)', 'Steamed Sona Masoori rice, Mudda Pappu, Neyyi (ghee), Avakaya pickle, Veg Iguru, Sambar, Charu, Majjiga, and Appalam.', 'lunch', 110, 'https://images.unsplash.com/photo-1610057099431-d73a1c9d2f2f?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Unlimited Style', 'Traditional Telugu', 'Pure Ghee'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-2-m2', 'disc-real-2', 'Mudda Pappu & Avakaya Annam Bowl', 'Comfort classic: hot steamed rice mixed with thick yellow dal, mango avakaya pickle, and dollop of country cow ghee.', 'lunch', 85, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Comfort Food', 'Mom Made'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-2-m3', 'disc-real-2', 'Gutthi Vankaya Curry with 3 Phulkas', 'Tender stuffed brinjals simmered in rich peanut, sesame, and dry coconut gravy.', 'dinner', 115, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Rayalaseema Specialty', 'Peanut Gravy'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-2-m4', 'disc-real-2', 'Andhra Natukodi Chicken Curry', 'Country chicken cooked on slow flame with crushed black pepper, dry red chillies, and ginger garlic paste.', 'lunch', 180, 'https://images.unsplash.com/photo-1626777552726-4a6b54c97e46?auto=format&fit=crop&w=600&q=80',
  false, ARRAY['Country Chicken', 'Spicy Gravy'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-2-m5', 'disc-real-2', 'Bagara Rice with Chicken Gravy Box', 'Aromatic basmati rice cooked with whole spices, served with homestyle spicy chicken curry and onion raita.', 'lunch', 165, 'https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?auto=format&fit=crop&w=600&q=80',
  false, ARRAY['Telangana Favorite', 'Party Classic'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-2-m6', 'disc-real-2', 'Tomato Pappu with Steamed Rice', 'Lentils cooked with ripe tomatoes, garlic, and red chili tadka. Served with fried papad.', 'dinner', 75, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Student Friendly', 'Tangy & Warm'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-2-m7', 'disc-real-2', 'Royyala Vepudu (Andhra Prawn Fry)', 'Fresh prawns tossed in a wok with caramelized onions, curry leaves, and freshly ground coriander spice.', 'dinner', 220, 'https://images.unsplash.com/photo-1565557623262-b51c2513a641?auto=format&fit=crop&w=600&q=80',
  false, ARRAY['Coastal Andhra', 'Seafood'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-2-m8', 'disc-real-2', 'Gongura Chicken Curry with Rice', 'Tender chicken cooked with tart roselle (gongura) leaves, giving the iconic Andhra tangy kick.', 'lunch', 175, 'https://images.unsplash.com/photo-1626777552726-4a6b54c97e46?auto=format&fit=crop&w=600&q=80',
  false, ARRAY['Gongura', 'Iconic Andhra'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-2-m9', 'disc-real-2', 'Spiced Majjiga (Chilled Buttermilk)', 'Hand-churned refreshing buttermilk infused with crushed ginger, green chili, and fresh coriander.', 'drinks', 20, 'https://images.unsplash.com/photo-1550547660-d9450f859349?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Hydration', 'Digestive'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-2-m10', 'disc-real-2', 'Bendakaya Vepudu (Crispy Okra Fry)', 'Thinly sliced ladyfinger roasted golden with peanuts, garlic, and curry leaves.', 'lunch', 65, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Crunchy', 'Low Calorie'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-3-m1', 'disc-real-3', 'Ghar Ka Khana Roti Thali (4 Phulkas)', '4 Whole wheat hot tawa phulkas, tadka dal, dry seasonal sabzi, salad, and pickle.', 'dinner', 85, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Whole Wheat', 'Zero Oil Roti', 'Comfort Meal'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-3-m2', 'disc-real-3', 'Paneer Butter Masala Meal Box', 'Soft cottage cheese cubes in mildly spiced butter gravy, served with 3 rotis and jeera rice.', 'dinner', 140, 'https://images.unsplash.com/photo-1631452180519-c014fe946bc7?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['North Indian Favorite', 'Rich Gravy'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-3-m3', 'disc-real-3', 'Punjabi Rajma Masala & Chawal', 'Slow-cooked Kashmiri red kidney beans in thick onion-tomato gravy with basmati rice.', 'lunch', 95, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Student Classic', 'High Protein'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-3-m4', 'disc-real-3', 'Yellow Dal Tadka & Jeera Rice Bowl', 'Arhar dal tempered with cumin, garlic, dry red chilli, and cow ghee with fragrant cumin rice.', 'lunch', 85, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Comforting', 'Homestyle'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-3-m5', 'disc-real-3', 'Aloo Paratha with Curd & Makkhan (2 pcs)', 'Whole wheat stuffed spiced potato flatbread roasted golden, served with fresh curd and pickle.', 'breakfast', 80, 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Breakfast Hit', 'Filling'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-3-m6', 'disc-real-3', 'Moong Dal Khichdi with Pure Ghee', 'Light, soothing yellow moong dal and rice cooked soft with a touch of turmeric and asafoetida.', 'dinner', 80, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Digestible', 'Light Supper'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-3-m7', 'disc-real-3', 'Kadhi Pakora with Steamed Rice', 'Besan dumplings simmered in tangy spiced yogurt gravy, served with portion of steamed rice.', 'lunch', 90, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Tangy Yogurt', 'Homestyle'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-3-m8', 'disc-real-3', 'Tawa Phulkas (Pack of 5)', 'Soft, puffed 100% whole wheat rotis brushed lightly with cow ghee.', 'dinner', 40, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['100% Atta', 'Ghee Brushed'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-5-m1', 'disc-real-5', 'Godavari Royyala Iguru with Rice', 'Tender freshwater prawns cooked in rich thick onion-green chili masala with fresh coriander.', 'lunch', 210, 'https://images.unsplash.com/photo-1565557623262-b51c2513a641?auto=format&fit=crop&w=600&q=80',
  false, ARRAY['Godavari Delta', 'Fresh Catch'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-5-m2', 'disc-real-5', 'Kodi Vepudu (Godavari Country Chicken Fry)', 'Chicken pieces tossed in roasted spice blend of pepper, clove, and shallots.', 'dinner', 175, 'https://images.unsplash.com/photo-1626777552726-4a6b54c97e46?auto=format&fit=crop&w=600&q=80',
  false, ARRAY['Crispy Fry', 'Spicy Andhra'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-5-m3', 'disc-real-5', 'Godavari Veg Bhojanam', 'Steamed rice, Vankaya Kothimeera Karam, Pappu, Pulusu, Ghee, Avakaya, Curd & Vadiyalu.', 'lunch', 100, 'https://images.unsplash.com/photo-1610057099431-d73a1c9d2f2f?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Delta Ruchulu', 'Full Meal'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-5-m4', 'disc-real-5', 'Chepala Pulusu (Fish in Tamarind Gravy)', 'Fresh fish cutlet simmered overnight in spiced sour tamarind gravy with green chillies.', 'lunch', 190, 'https://images.unsplash.com/photo-1565557623262-b51c2513a641?auto=format&fit=crop&w=600&q=80',
  false, ARRAY['Claypot Cooked', 'Signature Godavari'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-5-m5', 'disc-real-5', 'Panasa Pottu Kura (Raw Jackfruit Curry)', 'Tender shredded jackfruit cooked with mustard seed paste and mild green chillies.', 'lunch', 85, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Seasonal Heritage', 'Plant Based'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-5-m6', 'disc-real-5', 'Kaja Sweet from Tapeswaram (2 pcs)', 'Crispy flaky golden pastry drenched in flavored sugar syrup.', 'snacks', 40, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Famous Godavari Sweet'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-5-m7', 'disc-real-5', 'Ulava Charu with Cream', 'Thick savory horsegram extract topped with fresh cream, served with steamed rice.', 'dinner', 90, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Creamy Horsegram', 'Andhra Pride'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-5-m8', 'disc-real-5', 'Majjiga Pulusu with Rice', 'Sour yogurt soup cooked with turmeric, bottle gourd, and mustard seed tadka.', 'lunch', 70, 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Cooling', 'Village Style'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-6-m1', 'disc-real-6', 'Special Hyderabadi Chicken Dum Biryani', 'Long grain aromatic basmati rice cooked on dum with marinated chicken, saffron, mint, and whole spices. Served with Mirchi ka Salan & Raita.', 'lunch', 170, 'https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?auto=format&fit=crop&w=600&q=80',
  false, ARRAY['Dum Cooked', 'Hyderabadi Classic'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-6-m2', 'disc-real-6', 'Hyderabadi Veg Dum Biryani', 'Garden vegetables, fried onions, and paneer cubes layered with spiced basmati rice and saffron milk.', 'lunch', 130, 'https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Dum Veg', 'Aromatic'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-6-m3', 'disc-real-6', 'Executive North Indian Thali', '3 Tawa Parathas, Shahi Paneer, Dal Makhani, Veg Pulao, Gulab Jamun, Salad & Raita.', 'lunch', 160, 'https://images.unsplash.com/photo-1610057099431-d73a1c9d2f2f?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Executive Thali', 'Rich & Filling'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-6-m4', 'disc-real-6', 'Chicken Tikka Kebab Plate (6 pcs)', 'Boneless chicken chunks marinated in spiced yogurt and grilled juicy in tandoor.', 'snacks', 180, 'https://images.unsplash.com/photo-1565557623262-b51c2513a641?auto=format&fit=crop&w=600&q=80',
  false, ARRAY['Tandoori', 'Smoky'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-6-m5', 'disc-real-6', 'Dal Makhani with 2 Butter Naans', 'Slow simmered black lentils in butter and cream, served with 2 fluffy butter naans.', 'dinner', 145, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Creamy Dal', 'Dinner Special'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-6-m6', 'disc-real-6', 'Egg Dum Biryani Box', '2 Spiced golden boiled eggs layered with biryani rice, served with raita and salan.', 'lunch', 120, 'https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?auto=format&fit=crop&w=600&q=80',
  false, ARRAY['Egg Biryani', 'Student Value'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-6-m7', 'disc-real-6', 'Paneer Tikka Roll', 'Grilled cottage cheese cubes, sliced onions, and mint chutney wrapped in whole wheat paratha.', 'snacks', 90, 'https://images.unsplash.com/photo-1631452180519-c014fe946bc7?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Grab & Go', 'Fresh Kati Roll'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-6-m8', 'disc-real-6', 'Gulab Jamun (2 pcs)', 'Warm milk-solid dumplings soaked in rose and cardamom sugar syrup.', 'snacks', 40, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Dessert', 'Sweet Tooth'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-8-m1', 'disc-real-8', 'Ghee Thatte Idli (2 pcs)', 'Steamed fluffy idlis bathed in fragrant melted cow ghee, served with coconut chutney & piping hot sambar.', 'breakfast', 50, 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Pure Ghee', 'Steamed', 'Digestible'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-8-m2', 'disc-real-8', 'Crispy Medu Vada (2 pcs)', 'Golden fried crispy lentil vadas with ginger and whole black pepper notes, served with spicy red chutney.', 'breakfast', 55, 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Crispy', 'Traditional', 'Protein Rich'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-8-m3', 'disc-real-8', 'Special Ghee Masala Dosa', 'Crispy fermented rice-lentil crepe smeared with spicy red chilli-garlic chutney and filled with spiced mashed potato.', 'breakfast', 75, 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Signature', 'Golden Crisp', 'Zero Soda'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-8-m4', 'disc-real-8', 'Andhra Upma Pesarattu', 'Whole green gram crepe cooked crisp, filled with aromatic rava upma and served with allam (ginger) pachadi.', 'breakfast', 80, 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['High Fiber', 'Green Moong', 'Authentic Andhra'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-8-m5', 'disc-real-8', 'Onion Rava Dosa', 'Cracked semolina batter griddled thin and crispy with diced shallots, cumin, and fresh green chillies.', 'breakfast', 85, 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Extra Crispy', 'Fresh Herbs'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-8-m6', 'disc-real-8', 'Poori with Potato Sagu (2 pcs)', 'Freshly puffed golden pooris served with mild Karnataka-style Bombay potato sagu.', 'breakfast', 65, 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Hot & Fresh', 'Breakfast Classic'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-8-m7', 'disc-real-8', 'Mysore Bonda (4 pcs)', 'Golden fluffy fried dumplings served hot with ginger chutney and coconut dip.', 'snacks', 45, 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Evening Special', 'Crunchy Outside'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-8-m8', 'disc-real-8', 'Homestyle Sambar Rice', 'Short-grain rice simmered with drumstick sambar, shallots, and ghee tempering. Served with appalam.', 'lunch', 70, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Comfort Meal', 'Pure Ghee'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-8-m9', 'disc-real-8', 'Tadka Curd Rice with Pomegranate', 'Cooling creamy curd rice tempered with mustard seeds, ginger, curry leaves, and crunchy pomegranate pearls.', 'dinner', 60, 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Probiotic', 'Light & Cooling'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-8-m10', 'disc-real-8', 'South Indian Filter Coffee', 'Fresh chicory-blended decoction frothed with thick boiling milk in brass tumbler.', 'snacks', 25, 'https://images.unsplash.com/photo-1514432324607-a09d9b4aefdd?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Aromatic', 'Brass Frothed'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-9-m1', 'disc-real-9', 'Ammamma Bhojana Thali', 'Hot steamed rice, Mudda Pappu, sweet tomato charu, fresh cauliflower fry, homemade mango pickle, and appalam.', 'lunch', 90, 'https://images.unsplash.com/photo-1610057099431-d73a1c9d2f2f?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Grandma Recipe', 'Zero Preservatives', 'Pure Comfort'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-9-m2', 'disc-real-9', 'Pappu Charu with Vadiyalu Bowl', 'Tangy slow-simmered lentil broth with drumstick and shallots, served with steaming rice and sun-dried rice crisps.', 'lunch', 75, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Homestyle Sambar', 'Sun Dried Crisps'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-9-m3', 'disc-real-9', 'Aratikaya Vepudu (Raw Banana Roast)', 'Raw plantain cubes roasted crisp in cast iron skillet with crushed garlic and red chilli podi.', 'lunch', 60, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Iron Skillet Roasted', 'Crispy'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-9-m4', 'disc-real-9', 'Ulavacharu Rice with Cow Ghee', 'Rich horsegram soup thickened and seasoned, poured over steaming hot rice with dollop of pure ghee.', 'lunch', 95, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Horsegram Soup', 'Warm Energy'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-9-m5', 'disc-real-9', 'Kakarakaya Karam (Bittergourd Roast)', 'Finely sliced bittergourd roasted till sweet and crispy with roasted peanut garlic spice powder.', 'dinner', 65, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Diabetic Friendly', 'Crispy Not Bitter'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-9-m6', 'disc-real-9', 'Pala Thalikalu (Jaggery Dessert)', 'Hand-rolled rice noodles cooked in sweet jaggery cardamom milk.', 'snacks', 45, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Village Recipe', 'Iron Sweet'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-9-m7', 'disc-real-9', 'Ghee Sambar Rice with Curd Rice Combo', 'Half portion drumstick sambar rice + half portion tempered cooling curd rice.', 'lunch', 80, 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Combo Classic', 'Satisfying'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-9-m8', 'disc-real-9', 'Allam Pachadi with Rice Crackers', 'Sweet-spicy-tangy Andhra ginger chutney paired with crunchy rice papadums.', 'snacks', 35, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Digestive', 'Traditional Dip'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-10-m1', 'disc-real-10', 'Student Budget Mini Meal', 'Steamed rice, daily dal tadka, potato fry, and papad. Wholesome and easy on the pocket.', 'lunch', 65, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Pocket Friendly', 'Student Favorite'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-10-m2', 'disc-real-10', 'Schezwan Veg Fried Rice & Manchurian', 'Wok-tossed spicy Indo-Chinese fried rice paired with dry vegetable manchurian balls.', 'dinner', 110, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Indo Chinese', 'Spicy Wok'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-10-m3', 'disc-real-10', 'Chicken Fried Rice & Chilli Chicken Combo', 'Egg & shredded chicken wok rice with 4 pcs of Andhra style dry chilli chicken.', 'dinner', 145, 'https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?auto=format&fit=crop&w=600&q=80',
  false, ARRAY['Student Hit', 'High Energy'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-10-m4', 'disc-real-10', 'Paneer Paratha Meal (2 pcs with Pickle)', '2 Stuffed paneer parathas cooked with butter, served with chilled curd and lime pickle.', 'breakfast', 85, 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Heavy Breakfast', 'Filling'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-10-m5', 'disc-real-10', 'Cheese Maggi Double Masala', 'Double portion masala noodles topped with melted cheddar cheese, sweet corn, and green chillies.', 'snacks', 55, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Late Night Craving', 'Comfort Snack'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-10-m6', 'disc-real-10', 'Crispy Samosa Plate (2 pcs)', 'Flaky crust stuffed with cumin-spiced potatoes and green peas, served with sweet-tangy chutney.', 'snacks', 30, 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Campus Chai Time', 'Crisp'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-10-m7', 'disc-real-10', 'Single Omelette Bread Toast', '2-Egg fluffy masala omelette sandwiched between toasted whole wheat slices.', 'breakfast', 50, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  false, ARRAY['Quick Energy', 'High Protein'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-10-m8', 'disc-real-10', 'Masala Chai Flask (Serves 2)', 'Cardamom and crushed ginger boiled in creamy milk, packed warm in insulated flask.', 'drinks', 35, 'https://images.unsplash.com/photo-1514432324607-a09d9b4aefdd?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Kadak Chai', 'Energy'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-11-m1', 'disc-real-11', 'North-South Fusion Executive Thali', '2 Whole wheat phulkas, Paneer butter masala, Sambar rice bowl, curd, papad, and gulab jamun.', 'lunch', 140, 'https://images.unsplash.com/photo-1610057099431-d73a1c9d2f2f?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Best of Both', 'Full Meal'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-11-m2', 'disc-real-11', 'Dal Makhani & Phulka Combo (3 pcs)', 'Slow cooked buttery black lentils paired with 3 puffed whole wheat rotis.', 'dinner', 110, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Comfort Dinner', 'Homestyle'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-11-m3', 'disc-real-11', 'Ghee Sambar Idli & Medu Vada Combo', '2 Soft idlis and 1 crispy medu vada soaked in piping hot sambar with chutney.', 'breakfast', 65, 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Breakfast Hit', 'Pure Ghee'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-11-m4', 'disc-real-11', 'Butter Chicken Masala with Jeera Rice', 'Tender boneless chicken in rich mild tomato cream gravy with aromatic cumin rice.', 'dinner', 170, 'https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?auto=format&fit=crop&w=600&q=80',
  false, ARRAY['Classic North Indian', 'Rich'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-11-m5', 'disc-real-11', 'Chole Bhature Platter (2 Bhature)', 'Spiced Punjabi chickpea curry served with puffed golden bhatures, pickled onions, and green chilli.', 'lunch', 115, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Weekend Special', 'Punjabi Chole'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-11-m6', 'disc-real-11', 'Crispy Masala Dosa with Sambar', 'Fermented crepe griddled with spiced potato filling, coconut chutney and sambar.', 'breakfast', 70, 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['South Indian Classic'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-11-m7', 'disc-real-11', 'Curd Rice with Pomegranate & Boondi', 'Cooling tempered yogurt rice topped with crispy boondi and juicy pomegranate.', 'dinner', 60, 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Probiotic', 'Cooling'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-11-m8', 'disc-real-11', 'Special Cutting Chai & Samosa', '1 Hot ginger chai with 1 freshly fried potato samosa and tangy chutney.', 'snacks', 35, 'https://images.unsplash.com/photo-1514432324607-a09d9b4aefdd?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Evening Tea', 'Campus Favorite'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-12-m1', 'disc-real-12', 'Ghar Ka Khana Roti Thali (4 Phulkas)', '4 Whole wheat hot tawa phulkas, tadka dal, dry seasonal sabzi, salad, and pickle.', 'dinner', 85, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Whole Wheat', 'Zero Oil Roti', 'Comfort Meal'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-12-m2', 'disc-real-12', 'Paneer Butter Masala Meal Box', 'Soft cottage cheese cubes in mildly spiced butter gravy, served with 3 rotis and jeera rice.', 'dinner', 140, 'https://images.unsplash.com/photo-1631452180519-c014fe946bc7?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['North Indian Favorite', 'Rich Gravy'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-12-m3', 'disc-real-12', 'Punjabi Rajma Masala & Chawal', 'Slow-cooked Kashmiri red kidney beans in thick onion-tomato gravy with basmati rice.', 'lunch', 95, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Student Classic', 'High Protein'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-12-m4', 'disc-real-12', 'Yellow Dal Tadka & Jeera Rice Bowl', 'Arhar dal tempered with cumin, garlic, dry red chilli, and cow ghee with fragrant cumin rice.', 'lunch', 85, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Comforting', 'Homestyle'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-12-m5', 'disc-real-12', 'Aloo Paratha with Curd & Makkhan (2 pcs)', 'Whole wheat stuffed spiced potato flatbread roasted golden, served with fresh curd and pickle.', 'breakfast', 80, 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Breakfast Hit', 'Filling'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-12-m6', 'disc-real-12', 'Moong Dal Khichdi with Pure Ghee', 'Light, soothing yellow moong dal and rice cooked soft with a touch of turmeric and asafoetida.', 'dinner', 80, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Digestible', 'Light Supper'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-12-m7', 'disc-real-12', 'Kadhi Pakora with Steamed Rice', 'Besan dumplings simmered in tangy spiced yogurt gravy, served with portion of steamed rice.', 'lunch', 90, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Tangy Yogurt', 'Homestyle'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-12-m8', 'disc-real-12', 'Tawa Phulkas (Pack of 5)', 'Soft, puffed 100% whole wheat rotis brushed lightly with cow ghee.', 'dinner', 40, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['100% Atta', 'Ghee Brushed'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-13-m1', 'disc-real-13', 'Sattvic Jain Thali (Zero Onion Garlic)', '4 Whole wheat rotis, moong dal with cumin & hing, lauki (bottle gourd) sabzi, steamed rice, and fresh curd.', 'lunch', 110, 'https://images.unsplash.com/photo-1610057099431-d73a1c9d2f2f?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['No Onion No Garlic', 'Pure Sattvic', 'Jain Friendly'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-13-m2', 'disc-real-13', 'Jain Paneer Makhani with 3 Phulkas', 'Fresh cottage cheese cubes in rich tomato, cashew, and pure cow ghee gravy without onion or garlic.', 'dinner', 140, 'https://images.unsplash.com/photo-1631452180519-c014fe946bc7?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Cashew Gravy', 'Jain Approved'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-13-m3', 'disc-real-13', 'Jain Moong Dal Khichdi Bowl', 'Equal proportions of rice and split yellow lentils cooked with cow ghee and roasted cumin.', 'dinner', 85, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Soothing', 'Easy Digestion'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-13-m4', 'disc-real-13', 'Kela Methi Thepla (3 pcs)', 'Raw banana and fresh fenugreek leaves kneaded in whole wheat dough, griddled with pure ghee.', 'breakfast', 70, 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Travel Friendly', 'Sattvic'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-13-m5', 'disc-real-13', 'Cucumber Mint Chaas (Buttermilk)', 'Fresh homemade churned curd seasoned with roasted cumin and fresh mint leaves.', 'drinks', 25, 'https://images.unsplash.com/photo-1550547660-d9450f859349?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Cooling', 'Probiotic'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-13-m6', 'disc-real-13', 'Poha with Roasted Peanuts (Jain)', 'Flattened rice tempered with mustard, green chillies, curry leaves, and crunchy peanuts. No potatoes.', 'breakfast', 55, 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Light Breakfast', 'Zero Onion'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-13-m7', 'disc-real-13', 'Jain Turmeric Milk (Golden Milk)', 'Boiled cow milk infused with organic turmeric, crushed black pepper, and saffron strands.', 'drinks', 40, 'https://images.unsplash.com/photo-1514432324607-a09d9b4aefdd?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Immunity', 'Night Sleep'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-13-m8', 'disc-real-13', 'Sweet Makhana Kheer', 'Fox nuts simmered in thickened cow milk with cardamom, almonds, and pistachios.', 'snacks', 65, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Healthy Dessert', 'Fasting Food'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-14-m1', 'disc-real-14', 'North-South Fusion Executive Thali', '2 Whole wheat phulkas, Paneer butter masala, Sambar rice bowl, curd, papad, and gulab jamun.', 'lunch', 140, 'https://images.unsplash.com/photo-1610057099431-d73a1c9d2f2f?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Best of Both', 'Full Meal'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-14-m2', 'disc-real-14', 'Dal Makhani & Phulka Combo (3 pcs)', 'Slow cooked buttery black lentils paired with 3 puffed whole wheat rotis.', 'dinner', 110, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Comfort Dinner', 'Homestyle'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-14-m3', 'disc-real-14', 'Ghee Sambar Idli & Medu Vada Combo', '2 Soft idlis and 1 crispy medu vada soaked in piping hot sambar with chutney.', 'breakfast', 65, 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Breakfast Hit', 'Pure Ghee'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-14-m4', 'disc-real-14', 'Butter Chicken Masala with Jeera Rice', 'Tender boneless chicken in rich mild tomato cream gravy with aromatic cumin rice.', 'dinner', 170, 'https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?auto=format&fit=crop&w=600&q=80',
  false, ARRAY['Classic North Indian', 'Rich'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-14-m5', 'disc-real-14', 'Chole Bhature Platter (2 Bhature)', 'Spiced Punjabi chickpea curry served with puffed golden bhatures, pickled onions, and green chilli.', 'lunch', 115, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Weekend Special', 'Punjabi Chole'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-14-m6', 'disc-real-14', 'Crispy Masala Dosa with Sambar', 'Fermented crepe griddled with spiced potato filling, coconut chutney and sambar.', 'breakfast', 70, 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['South Indian Classic'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-14-m7', 'disc-real-14', 'Curd Rice with Pomegranate & Boondi', 'Cooling tempered yogurt rice topped with crispy boondi and juicy pomegranate.', 'dinner', 60, 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Probiotic', 'Cooling'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-14-m8', 'disc-real-14', 'Special Cutting Chai & Samosa', '1 Hot ginger chai with 1 freshly fried potato samosa and tangy chutney.', 'snacks', 35, 'https://images.unsplash.com/photo-1514432324607-a09d9b4aefdd?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Evening Tea', 'Campus Favorite'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-15-m1', 'disc-real-15', 'Amma Special Veg Thali Box', '4 Whole wheat rotis, homestyle yellow dal, aloo beans fry, steamed rice, sambar, and home pickle.', 'lunch', 95, 'https://images.unsplash.com/photo-1610057099431-d73a1c9d2f2f?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Zero Soda', 'Mom''s Cooking', 'Balanced Meal'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-15-m2', 'disc-real-15', 'Pachi Pulusu with Hot Rice & Ghee', 'Raw tamarind extract simmered with charred onions, jaggery, and crushed green chillies. Supreme comfort.', 'lunch', 70, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Telangana Heritage', 'Raw Rasam'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-15-m3', 'disc-real-15', 'Homestyle Egg Curry with Rice', '2 Boiled eggs simmered in onion-tomato homestyle gravy, served with portion of steamed rice.', 'dinner', 90, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  false, ARRAY['High Protein', 'Affordable'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-15-m4', 'disc-real-15', 'Palak Pappu with Phulkas (3 pcs)', 'Fresh garden spinach cooked with toor dal and mild cumin garlic seasoning, served with soft puffed phulkas.', 'dinner', 80, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Iron Rich', 'Low Calorie'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-15-m5', 'disc-real-15', 'Kandi Podi Ghee Rice Meal', 'Steamed rice served with homemade roasted lentil gun powder, clarified cow ghee, and crunchy appalam.', 'lunch', 65, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Dry Lentil Podi', 'Quick Lunch'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-15-m6', 'disc-real-15', 'Dondakaya Fry (Tindora Peanut)', 'Ivy gourd roundels stir-fried slowly with crunchy roasted peanuts and mild red chilli.', 'dinner', 60, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Homestyle Sabzi', 'Crisp'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-15-m7', 'disc-real-15', 'Menthi Kura Pappu (Fenugreek Dal)', 'Warm yellow lentils infused with slightly bitter fresh methi leaves and garlic tempering.', 'lunch', 60, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Herbal', 'Digestive'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-15-m8', 'disc-real-15', 'Kobbari Annam (Coconut Rice)', 'Short grain rice flavored with fresh grated coconut, cashews, mustard seeds, and whole green chillies.', 'lunch', 80, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Festive Flavor', 'Aromatic'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-15-m9', 'disc-real-15', 'Telangana Sarva Pindi (Snack)', 'Traditional savoury pancake made with rice flour, chana dal, sesame seeds, and spring onion.', 'snacks', 40, 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Telangana Specialty', 'Crisp Crust'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-18-m1', 'disc-real-18', 'Student Budget Mini Meal', 'Steamed rice, daily dal tadka, potato fry, and papad. Wholesome and easy on the pocket.', 'lunch', 65, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Pocket Friendly', 'Student Favorite'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-18-m2', 'disc-real-18', 'Schezwan Veg Fried Rice & Manchurian', 'Wok-tossed spicy Indo-Chinese fried rice paired with dry vegetable manchurian balls.', 'dinner', 110, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Indo Chinese', 'Spicy Wok'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-18-m3', 'disc-real-18', 'Chicken Fried Rice & Chilli Chicken Combo', 'Egg & shredded chicken wok rice with 4 pcs of Andhra style dry chilli chicken.', 'dinner', 145, 'https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?auto=format&fit=crop&w=600&q=80',
  false, ARRAY['Student Hit', 'High Energy'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-18-m4', 'disc-real-18', 'Paneer Paratha Meal (2 pcs with Pickle)', '2 Stuffed paneer parathas cooked with butter, served with chilled curd and lime pickle.', 'breakfast', 85, 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Heavy Breakfast', 'Filling'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-18-m5', 'disc-real-18', 'Cheese Maggi Double Masala', 'Double portion masala noodles topped with melted cheddar cheese, sweet corn, and green chillies.', 'snacks', 55, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Late Night Craving', 'Comfort Snack'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-18-m6', 'disc-real-18', 'Crispy Samosa Plate (2 pcs)', 'Flaky crust stuffed with cumin-spiced potatoes and green peas, served with sweet-tangy chutney.', 'snacks', 30, 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Campus Chai Time', 'Crisp'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-18-m7', 'disc-real-18', 'Single Omelette Bread Toast', '2-Egg fluffy masala omelette sandwiched between toasted whole wheat slices.', 'breakfast', 50, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  false, ARRAY['Quick Energy', 'High Protein'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-18-m8', 'disc-real-18', 'Masala Chai Flask (Serves 2)', 'Cardamom and crushed ginger boiled in creamy milk, packed warm in insulated flask.', 'drinks', 35, 'https://images.unsplash.com/photo-1514432324607-a09d9b4aefdd?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Kadak Chai', 'Energy'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-20-m1', 'disc-real-20', 'Authentic Andhra Bhojanam (Full Meal)', 'Steamed Sona Masoori rice, Mudda Pappu, Neyyi (ghee), Avakaya pickle, Veg Iguru, Sambar, Charu, Majjiga, and Appalam.', 'lunch', 110, 'https://images.unsplash.com/photo-1610057099431-d73a1c9d2f2f?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Unlimited Style', 'Traditional Telugu', 'Pure Ghee'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-20-m2', 'disc-real-20', 'Mudda Pappu & Avakaya Annam Bowl', 'Comfort classic: hot steamed rice mixed with thick yellow dal, mango avakaya pickle, and dollop of country cow ghee.', 'lunch', 85, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Comfort Food', 'Mom Made'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-20-m3', 'disc-real-20', 'Gutthi Vankaya Curry with 3 Phulkas', 'Tender stuffed brinjals simmered in rich peanut, sesame, and dry coconut gravy.', 'dinner', 115, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Rayalaseema Specialty', 'Peanut Gravy'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-20-m4', 'disc-real-20', 'Andhra Natukodi Chicken Curry', 'Country chicken cooked on slow flame with crushed black pepper, dry red chillies, and ginger garlic paste.', 'lunch', 180, 'https://images.unsplash.com/photo-1626777552726-4a6b54c97e46?auto=format&fit=crop&w=600&q=80',
  false, ARRAY['Country Chicken', 'Spicy Gravy'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-20-m5', 'disc-real-20', 'Bagara Rice with Chicken Gravy Box', 'Aromatic basmati rice cooked with whole spices, served with homestyle spicy chicken curry and onion raita.', 'lunch', 165, 'https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?auto=format&fit=crop&w=600&q=80',
  false, ARRAY['Telangana Favorite', 'Party Classic'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-20-m6', 'disc-real-20', 'Tomato Pappu with Steamed Rice', 'Lentils cooked with ripe tomatoes, garlic, and red chili tadka. Served with fried papad.', 'dinner', 75, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Student Friendly', 'Tangy & Warm'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-20-m7', 'disc-real-20', 'Royyala Vepudu (Andhra Prawn Fry)', 'Fresh prawns tossed in a wok with caramelized onions, curry leaves, and freshly ground coriander spice.', 'dinner', 220, 'https://images.unsplash.com/photo-1565557623262-b51c2513a641?auto=format&fit=crop&w=600&q=80',
  false, ARRAY['Coastal Andhra', 'Seafood'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-20-m8', 'disc-real-20', 'Gongura Chicken Curry with Rice', 'Tender chicken cooked with tart roselle (gongura) leaves, giving the iconic Andhra tangy kick.', 'lunch', 175, 'https://images.unsplash.com/photo-1626777552726-4a6b54c97e46?auto=format&fit=crop&w=600&q=80',
  false, ARRAY['Gongura', 'Iconic Andhra'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-20-m9', 'disc-real-20', 'Spiced Majjiga (Chilled Buttermilk)', 'Hand-churned refreshing buttermilk infused with crushed ginger, green chili, and fresh coriander.', 'drinks', 20, 'https://images.unsplash.com/photo-1550547660-d9450f859349?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Hydration', 'Digestive'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-20-m10', 'disc-real-20', 'Bendakaya Vepudu (Crispy Okra Fry)', 'Thinly sliced ladyfinger roasted golden with peanuts, garlic, and curry leaves.', 'lunch', 65, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Crunchy', 'Low Calorie'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-21-m1', 'disc-real-21', 'Foxtail Millet (Korra) Khichdi', 'Slow-cooked foxtail millet and moong dal infused with mild ginger, cumin, and vegetables. Served with curd.', 'lunch', 99, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Diabetic Friendly', 'Low GI', 'Gluten Free'], true, 'official_website', 'verified',
  'https://petalbox.in', NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-21-m2', 'disc-real-21', 'Ragi Sankati with Spiced Sambar', 'Finger millet ragi balls cooked traditionally, served with steaming hot vegetable drumstick sambar.', 'lunch', 85, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Calcium Rich', 'Traditional Telugu', 'Iron'], true, 'official_website', 'verified',
  'https://petalbox.in', NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-21-m3', 'disc-real-21', 'Multi-Millet Crispy Dosa', 'Nutrient-packed fermented batter made with little millet, kodo millet, and lentils. Zero white rice.', 'breakfast', 75, 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Zero Rice', 'Crispy', 'Healthy Heart'], true, 'official_website', 'verified',
  'https://petalbox.in', NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-21-m4', 'disc-real-21', 'Barnyard Millet Sambar Rice', 'Sanwa millet simmered in tangy lentil stew with shallots, carrot, and cow ghee tempering.', 'dinner', 89, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Light on Stomach', 'Pure Ghee'], true, 'official_website', 'verified',
  'https://petalbox.in', NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-21-m5', 'disc-real-21', 'Little Millet (Samalu) Upma', 'Wholesome breakfast upma cooked with samalu grains, mustard, ginger, cashew bits, and curry leaves.', 'breakfast', 65, 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Breakfast', 'Fiber Rich'], true, 'official_website', 'verified',
  'https://petalbox.in', NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-21-m6', 'disc-real-21', 'Pearl Millet (Bajra) Roti (2 pcs)', 'Warm hand-patted bajra rotis served with brinjal curry and garlic flaxseed chutney podi.', 'dinner', 80, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Winter Warmth', 'High Fiber'], true, 'official_website', 'verified',
  'https://petalbox.in', NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-21-m7', 'disc-real-21', 'Millet Vegetable Pulao Bowl', 'Aromatic foxtail millet cooked with whole spices, green peas, carrots, and mint leaves.', 'lunch', 110, 'https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Low Carb', 'Flavorful'], true, 'official_website', 'verified',
  'https://petalbox.in', NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-21-m8', 'disc-real-21', 'Ragi Ambali (Summer Cooler)', 'Hydrating fermented finger millet malt seasoned with buttermilk, chopped onions, and cumin.', 'drinks', 30, 'https://images.unsplash.com/photo-1550547660-d9450f859349?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Hydrating', 'Cooling Drink'], true, 'official_website', 'verified',
  'https://petalbox.in', NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-21-m9', 'disc-real-21', 'Jowar Flakes Poha', 'Sorghum flakes sautéed with mustard, peanuts, green chillies, and fresh lemon squeeze.', 'breakfast', 60, 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Gluten Free', 'Quick Bite'], true, 'official_website', 'verified',
  'https://petalbox.in', NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-23-m1', 'disc-real-23', 'Avocado Toast on Sourdough', 'Crushed Hass avocado on toasted whole wheat sourdough with cherry tomatoes, feta, and pumpkin seeds.', 'breakfast', 140, 'https://images.unsplash.com/photo-1540420773420-3366772f4999?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Sourdough', 'Healthy Fats'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-23-m2', 'disc-real-23', 'Grilled Chicken Pesto Sandwich', 'Herb-grilled chicken breast, housemade basil walnut pesto, and mozzarella on toasted multigrain.', 'lunch', 165, 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?auto=format&fit=crop&w=600&q=80',
  false, ARRAY['28g Protein', 'Fresh Pesto'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-23-m3', 'disc-real-23', 'Super Green Detox Salad', 'Baby arugula, spinach, green apple slices, walnuts, and lemon olive oil dressing.', 'lunch', 135, 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Raw Enzyme', 'Low Carb'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-23-m4', 'disc-real-23', 'Berry Açai Energy Bowl', 'Thick organic berry blend topped with rolled oats, cacao nibs, banana slices, and honey.', 'breakfast', 160, 'https://images.unsplash.com/photo-1550547660-d9450f859349?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Antioxidant Rich', 'Superfood'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-23-m5', 'disc-real-23', 'Iced Cold Brew with Oat Milk', '18-Hour steeped single origin Arabica coffee over ice with creamy unsweetened oat milk.', 'drinks', 95, 'https://images.unsplash.com/photo-1514432324607-a09d9b4aefdd?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Single Origin', 'Plant Milk'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-23-m6', 'disc-real-23', 'Warm Quinoa Vegetable Bowl', 'Steamed quinoa, sautéed mushrooms, edamame beans, and roasted cherry tomatoes with tahini dressing.', 'dinner', 155, 'https://images.unsplash.com/photo-1540420773420-3366772f4999?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['High Fiber', 'Vegan Friendly'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-23-m7', 'disc-real-23', 'Gluten-Free Carrot Walnut Cake Slice', 'Fresh baked almond flour carrot cake sweetened with honey and jaggery.', 'snacks', 85, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Refined Sugar Free', 'Healthy Treat'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-23-m8', 'disc-real-23', 'Matcha Green Tea Latte', 'Ceremonial Japanese matcha whisked with warm skimmed milk.', 'drinks', 110, 'https://images.unsplash.com/photo-1514432324607-a09d9b4aefdd?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Clean Energy', 'Focus'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-24-m1', 'disc-real-24', 'Mediterranean Falafel & Hummus Bowl', 'Baked herb falafels, velvety garlic chickpea hummus, pickled beets, cucumber, and multigrain pita chips.', 'lunch', 165, 'https://images.unsplash.com/photo-1540420773420-3366772f4999?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Heart Healthy', 'Olive Oil', 'Vegan'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-24-m2', 'disc-real-24', 'Grilled Paneer & Quinoa Harvest Bowl', 'Low-fat grilled paneer cubes, roasted bell peppers, steamed corn, and tri-color quinoa in basil vinaigrette.', 'dinner', 175, 'https://images.unsplash.com/photo-1540420773420-3366772f4999?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['22g Protein', 'Supergrain'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-24-m3', 'disc-real-24', 'Tex-Mex Bean & Brown Rice Burrito Bowl', 'Black beans, sweet corn, salsa fresca, guacamole, and cilantro lime brown rice.', 'lunch', 155, 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['High Fiber', 'Immunity Boost'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-24-m4', 'disc-real-24', 'Smoked Chicken Salad Bowl', 'Smoked shredded chicken breast, crunchy romaine lettuce, cherry tomatoes, and honey mustard dressing.', 'lunch', 185, 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?auto=format&fit=crop&w=600&q=80',
  false, ARRAY['31g Protein', 'Keto Friendly'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-24-m5', 'disc-real-24', 'Avocado & Chickpea Protein Salad', 'Ripe avocado chunks, boiled chickpeas, diced cucumbers, and lemon tahini dressing.', 'dinner', 160, 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Good Fats', 'Antioxidants'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-24-m6', 'disc-real-24', 'Super Green Detox Soup (Bowl)', 'Broccoli, baby spinach, and zucchini puréed with almond milk and roasted pumpkin seeds.', 'dinner', 95, 'https://images.unsplash.com/photo-1540420773420-3366772f4999?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Cleansing', 'Immunity Booster'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-24-m7', 'disc-real-24', 'Nutty Chia Seed Pudding Bowl', 'Overnight chia seeds steeped in almond milk, topped with kiwi, berries, and roasted almond slivers.', 'breakfast', 120, 'https://images.unsplash.com/photo-1550547660-d9450f859349?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Omega 3', 'No White Sugar'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-24-m8', 'disc-real-24', 'Cold Pressed Orange Carrot Juice', '100% Raw unpasteurized juice with zero added water and zero sugar.', 'drinks', 75, 'https://images.unsplash.com/photo-1550547660-d9450f859349?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Vitamin C', 'Pure Juice'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-25-m1', 'disc-real-25', '35g Protein Grilled Chicken Breast Box', '180g Lean herb-marinated chicken breast served with steamed broccoli, carrots, and portion of brown rice.', 'high-protein', 210, 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?auto=format&fit=crop&w=600&q=80',
  false, ARRAY['38g Protein', 'Lean Meat', 'Gym Diet'], true, 'official_website', 'verified',
  'https://fooddarzee.com', NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-25-m2', 'disc-real-25', 'High-Protein Paneer & Soya Bhurji', 'Crumbled low-fat paneer and minced soya granules sautéed with bell peppers and 3 multigrain rotis.', 'high-protein', 160, 'https://images.unsplash.com/photo-1631452180519-c014fe946bc7?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['30g Protein', 'Vegetarian Muscle', 'Multigrain'], true, 'official_website', 'verified',
  'https://fooddarzee.com', NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-25-m3', 'disc-real-25', '6-Egg Whites Plate with Black Pepper', '6 Farm fresh steamed egg whites tossed in olive oil, crushed black pepper, pink salt, and side salad.', 'high-protein', 80, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  false, ARRAY['24g Protein', 'Zero Fat', 'Keto'], true, 'official_website', 'verified',
  'https://fooddarzee.com', NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-25-m4', 'disc-real-25', 'Sprouted Moong & Roasted Paneer Salad', 'Sprouted moong beans, diced grilled paneer, cucumber, tomatoes, and lime-mint vinaigrette.', 'lunch', 125, 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['20g Protein', 'High Fiber', 'Raw Enzymes'], true, 'official_website', 'verified',
  'https://fooddarzee.com', NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-25-m5', 'disc-real-25', 'Grilled Tofu & Quinoa Teriyaki Bowl', 'Organic firm tofu pan-grilled with light low-sodium teriyaki glaze on fluffy quinoa base.', 'dinner', 185, 'https://images.unsplash.com/photo-1540420773420-3366772f4999?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Vegan Protein', 'Gluten Free', 'Superfood'], true, 'official_website', 'verified',
  'https://fooddarzee.com', NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-25-m6', 'disc-real-25', 'Protein Whey & Peanut Butter Shake', '1 Scoop isolate whey, unsweetened peanut butter, banana, and skimmed milk (30g protein).', 'drinks', 120, 'https://images.unsplash.com/photo-1550547660-d9450f859349?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Post Workout', 'No Added Sugar'], true, 'official_website', 'verified',
  'https://fooddarzee.com', NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-25-m7', 'disc-real-25', 'Keto Chicken Tikka Salad', 'Tandoori seasoned chicken breast skewers over crisp lettuce, cucumber ribbons, and olive oil.', 'dinner', 175, 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?auto=format&fit=crop&w=600&q=80',
  false, ARRAY['Keto Friendly', 'Low Carb'], true, 'official_website', 'verified',
  'https://fooddarzee.com', NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-25-m8', 'disc-real-25', 'High Fiber Soya Chunk Curry & Rice', 'Nutritious textured soya chunks simmered in aromatic onion tomato curry with brown basmati rice.', 'lunch', 110, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['High Fiber', 'Plant Protein'], true, 'official_website', 'verified',
  'https://fooddarzee.com', NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-25-m9', 'disc-real-25', 'Boiled Chickpea & Peanut Chaat', 'Warm boiled kabuli chana and peanuts tossed with chopped onions, green chillies, and lemon juice.', 'snacks', 60, 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Pre Workout Snack', 'Clean Carbs'], true, 'official_website', 'verified',
  'https://fooddarzee.com', NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-26-m1', 'disc-real-26', 'Amma Special Veg Thali Box', '4 Whole wheat rotis, homestyle yellow dal, aloo beans fry, steamed rice, sambar, and home pickle.', 'lunch', 95, 'https://images.unsplash.com/photo-1610057099431-d73a1c9d2f2f?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Zero Soda', 'Mom''s Cooking', 'Balanced Meal'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-26-m2', 'disc-real-26', 'Pachi Pulusu with Hot Rice & Ghee', 'Raw tamarind extract simmered with charred onions, jaggery, and crushed green chillies. Supreme comfort.', 'lunch', 70, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Telangana Heritage', 'Raw Rasam'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-26-m3', 'disc-real-26', 'Homestyle Egg Curry with Rice', '2 Boiled eggs simmered in onion-tomato homestyle gravy, served with portion of steamed rice.', 'dinner', 90, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  false, ARRAY['High Protein', 'Affordable'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-26-m4', 'disc-real-26', 'Palak Pappu with Phulkas (3 pcs)', 'Fresh garden spinach cooked with toor dal and mild cumin garlic seasoning, served with soft puffed phulkas.', 'dinner', 80, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Iron Rich', 'Low Calorie'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-26-m5', 'disc-real-26', 'Kandi Podi Ghee Rice Meal', 'Steamed rice served with homemade roasted lentil gun powder, clarified cow ghee, and crunchy appalam.', 'lunch', 65, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Dry Lentil Podi', 'Quick Lunch'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-26-m6', 'disc-real-26', 'Dondakaya Fry (Tindora Peanut)', 'Ivy gourd roundels stir-fried slowly with crunchy roasted peanuts and mild red chilli.', 'dinner', 60, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Homestyle Sabzi', 'Crisp'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-26-m7', 'disc-real-26', 'Menthi Kura Pappu (Fenugreek Dal)', 'Warm yellow lentils infused with slightly bitter fresh methi leaves and garlic tempering.', 'lunch', 60, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Herbal', 'Digestive'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-26-m8', 'disc-real-26', 'Kobbari Annam (Coconut Rice)', 'Short grain rice flavored with fresh grated coconut, cashews, mustard seeds, and whole green chillies.', 'lunch', 80, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Festive Flavor', 'Aromatic'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-26-m9', 'disc-real-26', 'Telangana Sarva Pindi (Snack)', 'Traditional savoury pancake made with rice flour, chana dal, sesame seeds, and spring onion.', 'snacks', 40, 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Telangana Specialty', 'Crisp Crust'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-27-m1', 'disc-real-27', 'Dilli Kulcha Matar Bowl', 'Amritsari whole wheat baked kulcha paired with slow-cooked spiced white peas (matar) and pickled salad.', 'lunch', 149, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Clean Eating', 'No Palm Oil'], true, 'official_website', 'verified',
  'https://eatfit.in', NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-27-m2', 'disc-real-27', 'High-Protein Chicken & Moong Khichdi', 'Juicy shredded chicken breast cooked with yellow moong dal and broken brown rice with light ghee.', 'high-protein', 189, 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?auto=format&fit=crop&w=600&q=80',
  false, ARRAY['32g Protein', 'Light & Nutritious'], true, 'official_website', 'verified',
  'https://eatfit.in', NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-27-m3', 'disc-real-27', 'Dal Makhani & Jeera Rice Fit Bowl', 'Low-cream, slow-cooked black lentils simmered with aromatics and brown basmati rice.', 'dinner', 159, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Macro Counted', 'Zero Cream Overload'], true, 'official_website', 'verified',
  'https://eatfit.in', NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-27-m4', 'disc-real-27', 'Paneer Tikka Brown Rice Bowl', 'Tandoor roasted paneer cubes, sautéed bell peppers, and brown basmati with mint dip.', 'lunch', 179, 'https://images.unsplash.com/photo-1631452180519-c014fe946bc7?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['22g Protein', 'High Fiber'], true, 'official_website', 'verified',
  'https://eatfit.in', NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-27-m5', 'disc-real-27', 'Homestyle Rajma & Rice Bowl', 'Clean Kashmiri rajma cooked with minimal cold-pressed oil and whole spices.', 'lunch', 139, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Protein Rich', 'Plant Based'], true, 'official_website', 'verified',
  'https://eatfit.in', NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-27-m6', 'disc-real-27', 'Chicken Keema Multigrain Paratha', '2 Whole grain parathas stuffed with spiced lean minced chicken, served with cucumber raita.', 'dinner', 179, 'https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?auto=format&fit=crop&w=600&q=80',
  false, ARRAY['26g Protein', 'Lean Keema'], true, 'official_website', 'verified',
  'https://eatfit.in', NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-27-m7', 'disc-real-27', 'Fruit Pop Mango & Chia Bowl', 'Real mango purée with chia seeds, low-fat Greek yogurt, and roasted pumpkin seeds.', 'breakfast', 119, 'https://images.unsplash.com/photo-1550547660-d9450f859349?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Dessert', 'Guilt Free'], true, 'official_website', 'verified',
  'https://eatfit.in', NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-27-m8', 'disc-real-27', 'Buttermilk with Roasted Jeera', 'Light, churned probiotic buttermilk seasoned with rock salt and toasted cumin.', 'drinks', 35, 'https://images.unsplash.com/photo-1550547660-d9450f859349?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Probiotic', 'Refreshing'], true, 'official_website', 'verified',
  'https://eatfit.in', NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-28-m1', 'disc-real-28', '35g Protein Grilled Chicken Breast Box', '180g Lean herb-marinated chicken breast served with steamed broccoli, carrots, and portion of brown rice.', 'high-protein', 210, 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?auto=format&fit=crop&w=600&q=80',
  false, ARRAY['38g Protein', 'Lean Meat', 'Gym Diet'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-28-m2', 'disc-real-28', 'High-Protein Paneer & Soya Bhurji', 'Crumbled low-fat paneer and minced soya granules sautéed with bell peppers and 3 multigrain rotis.', 'high-protein', 160, 'https://images.unsplash.com/photo-1631452180519-c014fe946bc7?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['30g Protein', 'Vegetarian Muscle', 'Multigrain'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-28-m3', 'disc-real-28', '6-Egg Whites Plate with Black Pepper', '6 Farm fresh steamed egg whites tossed in olive oil, crushed black pepper, pink salt, and side salad.', 'high-protein', 80, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  false, ARRAY['24g Protein', 'Zero Fat', 'Keto'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-28-m4', 'disc-real-28', 'Sprouted Moong & Roasted Paneer Salad', 'Sprouted moong beans, diced grilled paneer, cucumber, tomatoes, and lime-mint vinaigrette.', 'lunch', 125, 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['20g Protein', 'High Fiber', 'Raw Enzymes'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-28-m5', 'disc-real-28', 'Grilled Tofu & Quinoa Teriyaki Bowl', 'Organic firm tofu pan-grilled with light low-sodium teriyaki glaze on fluffy quinoa base.', 'dinner', 185, 'https://images.unsplash.com/photo-1540420773420-3366772f4999?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Vegan Protein', 'Gluten Free', 'Superfood'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-28-m6', 'disc-real-28', 'Protein Whey & Peanut Butter Shake', '1 Scoop isolate whey, unsweetened peanut butter, banana, and skimmed milk (30g protein).', 'drinks', 120, 'https://images.unsplash.com/photo-1550547660-d9450f859349?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Post Workout', 'No Added Sugar'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-28-m7', 'disc-real-28', 'Keto Chicken Tikka Salad', 'Tandoori seasoned chicken breast skewers over crisp lettuce, cucumber ribbons, and olive oil.', 'dinner', 175, 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?auto=format&fit=crop&w=600&q=80',
  false, ARRAY['Keto Friendly', 'Low Carb'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-28-m8', 'disc-real-28', 'High Fiber Soya Chunk Curry & Rice', 'Nutritious textured soya chunks simmered in aromatic onion tomato curry with brown basmati rice.', 'lunch', 110, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['High Fiber', 'Plant Protein'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-28-m9', 'disc-real-28', 'Boiled Chickpea & Peanut Chaat', 'Warm boiled kabuli chana and peanuts tossed with chopped onions, green chillies, and lemon juice.', 'snacks', 60, 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Pre Workout Snack', 'Clean Carbs'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-29-m1', 'disc-real-29', 'Mediterranean Falafel & Hummus Bowl', 'Baked herb falafels, velvety garlic chickpea hummus, pickled beets, cucumber, and multigrain pita chips.', 'lunch', 165, 'https://images.unsplash.com/photo-1540420773420-3366772f4999?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Heart Healthy', 'Olive Oil', 'Vegan'], true, 'official_website', 'verified',
  'https://eatclub.com/brands/wefit', NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-29-m2', 'disc-real-29', 'Grilled Paneer & Quinoa Harvest Bowl', 'Low-fat grilled paneer cubes, roasted bell peppers, steamed corn, and tri-color quinoa in basil vinaigrette.', 'dinner', 175, 'https://images.unsplash.com/photo-1540420773420-3366772f4999?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['22g Protein', 'Supergrain'], true, 'official_website', 'verified',
  'https://eatclub.com/brands/wefit', NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-29-m3', 'disc-real-29', 'Tex-Mex Bean & Brown Rice Burrito Bowl', 'Black beans, sweet corn, salsa fresca, guacamole, and cilantro lime brown rice.', 'lunch', 155, 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['High Fiber', 'Immunity Boost'], true, 'official_website', 'verified',
  'https://eatclub.com/brands/wefit', NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-29-m4', 'disc-real-29', 'Smoked Chicken Salad Bowl', 'Smoked shredded chicken breast, crunchy romaine lettuce, cherry tomatoes, and honey mustard dressing.', 'lunch', 185, 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?auto=format&fit=crop&w=600&q=80',
  false, ARRAY['31g Protein', 'Keto Friendly'], true, 'official_website', 'verified',
  'https://eatclub.com/brands/wefit', NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-29-m5', 'disc-real-29', 'Avocado & Chickpea Protein Salad', 'Ripe avocado chunks, boiled chickpeas, diced cucumbers, and lemon tahini dressing.', 'dinner', 160, 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Good Fats', 'Antioxidants'], true, 'official_website', 'verified',
  'https://eatclub.com/brands/wefit', NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-29-m6', 'disc-real-29', 'Super Green Detox Soup (Bowl)', 'Broccoli, baby spinach, and zucchini puréed with almond milk and roasted pumpkin seeds.', 'dinner', 95, 'https://images.unsplash.com/photo-1540420773420-3366772f4999?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Cleansing', 'Immunity Booster'], true, 'official_website', 'verified',
  'https://eatclub.com/brands/wefit', NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-29-m7', 'disc-real-29', 'Nutty Chia Seed Pudding Bowl', 'Overnight chia seeds steeped in almond milk, topped with kiwi, berries, and roasted almond slivers.', 'breakfast', 120, 'https://images.unsplash.com/photo-1550547660-d9450f859349?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Omega 3', 'No White Sugar'], true, 'official_website', 'verified',
  'https://eatclub.com/brands/wefit', NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-29-m8', 'disc-real-29', 'Cold Pressed Orange Carrot Juice', '100% Raw unpasteurized juice with zero added water and zero sugar.', 'drinks', 75, 'https://images.unsplash.com/photo-1550547660-d9450f859349?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Vitamin C', 'Pure Juice'], true, 'official_website', 'verified',
  'https://eatclub.com/brands/wefit', NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-30-m1', 'disc-real-30', 'Tropical Dragon Fruit & Papaya Bowl', 'Fresh cubes of pink dragon fruit, ripe honey papaya, pineapple, and soaked chia seeds.', 'breakfast', 110, 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Antioxidant', 'Hydrating', 'Raw'], true, 'google_business_profile', 'verified',
  NULL, NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-30-m2', 'disc-real-30', 'ABC Immunity Detox Juice (350ml)', 'Fresh Apple, Beetroot, and Carrot slow pressed with a dash of ginger and lemon.', 'drinks', 80, 'https://images.unsplash.com/photo-1550547660-d9450f859349?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Glow Skin', 'Cold Pressed'], true, 'google_business_profile', 'verified',
  NULL, NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-30-m3', 'disc-real-30', 'Avocado & Banana Nut Smoothie', 'Creamy Hass avocado blended with robosta banana, honey, and crushed walnuts.', 'drinks', 130, 'https://images.unsplash.com/photo-1550547660-d9450f859349?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Energy Dense', 'Good Fats'], true, 'google_business_profile', 'verified',
  NULL, NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-30-m4', 'disc-real-30', 'Pomegranate Pearl Vitamin Platter', 'Freshly peeled ruby pomegranate arils served with lime wedge and pink salt.', 'snacks', 90, 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Iron Booster', 'Freshly Cut'], true, 'google_business_profile', 'verified',
  NULL, NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-30-m5', 'disc-real-30', 'Watermelon Mint Hydration Cooler', 'Pure cold-crushed watermelon pulp with fresh garden mint leaves. Zero added sugar.', 'drinks', 60, 'https://images.unsplash.com/photo-1550547660-d9450f859349?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Summer Refresh', 'Hydrating'], true, 'google_business_profile', 'verified',
  NULL, NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-30-m6', 'disc-real-30', 'Green Goodness Spinach Cucumber Detox', 'Baby spinach, English cucumber, green apple, celery, and lemon cold pressed juice.', 'drinks', 85, 'https://images.unsplash.com/photo-1550547660-d9450f859349?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Alkalizing', 'Detox'], true, 'google_business_profile', 'verified',
  NULL, NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-30-m7', 'disc-real-30', 'Berry Berry Acai Smoothie Bowl', 'Blueberries, strawberries, and black grapes thick blend topped with granola and flax seeds.', 'breakfast', 150, 'https://images.unsplash.com/photo-1550547660-d9450f859349?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Superfood', 'Energy Bowl'], true, 'google_business_profile', 'verified',
  NULL, NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-30-m8', 'disc-real-30', 'Citrus Orange & Sweet Lime Blend', 'Valencia oranges and fresh mosambi pressed fresh upon ordering.', 'drinks', 70, 'https://images.unsplash.com/photo-1550547660-d9450f859349?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Vitamin C', '100% Natural'], true, 'google_business_profile', 'verified',
  NULL, NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-31-m1', 'disc-real-31', 'Tropical Dragon Fruit & Papaya Bowl', 'Fresh cubes of pink dragon fruit, ripe honey papaya, pineapple, and soaked chia seeds.', 'breakfast', 110, 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Antioxidant', 'Hydrating', 'Raw'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-31-m2', 'disc-real-31', 'ABC Immunity Detox Juice (350ml)', 'Fresh Apple, Beetroot, and Carrot slow pressed with a dash of ginger and lemon.', 'drinks', 80, 'https://images.unsplash.com/photo-1550547660-d9450f859349?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Glow Skin', 'Cold Pressed'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-31-m3', 'disc-real-31', 'Avocado & Banana Nut Smoothie', 'Creamy Hass avocado blended with robosta banana, honey, and crushed walnuts.', 'drinks', 130, 'https://images.unsplash.com/photo-1550547660-d9450f859349?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Energy Dense', 'Good Fats'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-31-m4', 'disc-real-31', 'Pomegranate Pearl Vitamin Platter', 'Freshly peeled ruby pomegranate arils served with lime wedge and pink salt.', 'snacks', 90, 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Iron Booster', 'Freshly Cut'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-31-m5', 'disc-real-31', 'Watermelon Mint Hydration Cooler', 'Pure cold-crushed watermelon pulp with fresh garden mint leaves. Zero added sugar.', 'drinks', 60, 'https://images.unsplash.com/photo-1550547660-d9450f859349?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Summer Refresh', 'Hydrating'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-31-m6', 'disc-real-31', 'Green Goodness Spinach Cucumber Detox', 'Baby spinach, English cucumber, green apple, celery, and lemon cold pressed juice.', 'drinks', 85, 'https://images.unsplash.com/photo-1550547660-d9450f859349?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Alkalizing', 'Detox'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-31-m7', 'disc-real-31', 'Berry Berry Acai Smoothie Bowl', 'Blueberries, strawberries, and black grapes thick blend topped with granola and flax seeds.', 'breakfast', 150, 'https://images.unsplash.com/photo-1550547660-d9450f859349?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Superfood', 'Energy Bowl'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-31-m8', 'disc-real-31', 'Citrus Orange & Sweet Lime Blend', 'Valencia oranges and fresh mosambi pressed fresh upon ordering.', 'drinks', 70, 'https://images.unsplash.com/photo-1550547660-d9450f859349?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Vitamin C', '100% Natural'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-32-m1', 'disc-real-32', 'Tropical Dragon Fruit & Papaya Bowl', 'Fresh cubes of pink dragon fruit, ripe honey papaya, pineapple, and soaked chia seeds.', 'breakfast', 110, 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Antioxidant', 'Hydrating', 'Raw'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-32-m2', 'disc-real-32', 'ABC Immunity Detox Juice (350ml)', 'Fresh Apple, Beetroot, and Carrot slow pressed with a dash of ginger and lemon.', 'drinks', 80, 'https://images.unsplash.com/photo-1550547660-d9450f859349?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Glow Skin', 'Cold Pressed'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-32-m3', 'disc-real-32', 'Avocado & Banana Nut Smoothie', 'Creamy Hass avocado blended with robosta banana, honey, and crushed walnuts.', 'drinks', 130, 'https://images.unsplash.com/photo-1550547660-d9450f859349?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Energy Dense', 'Good Fats'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-32-m4', 'disc-real-32', 'Pomegranate Pearl Vitamin Platter', 'Freshly peeled ruby pomegranate arils served with lime wedge and pink salt.', 'snacks', 90, 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Iron Booster', 'Freshly Cut'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-32-m5', 'disc-real-32', 'Watermelon Mint Hydration Cooler', 'Pure cold-crushed watermelon pulp with fresh garden mint leaves. Zero added sugar.', 'drinks', 60, 'https://images.unsplash.com/photo-1550547660-d9450f859349?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Summer Refresh', 'Hydrating'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-32-m6', 'disc-real-32', 'Green Goodness Spinach Cucumber Detox', 'Baby spinach, English cucumber, green apple, celery, and lemon cold pressed juice.', 'drinks', 85, 'https://images.unsplash.com/photo-1550547660-d9450f859349?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Alkalizing', 'Detox'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-32-m7', 'disc-real-32', 'Berry Berry Acai Smoothie Bowl', 'Blueberries, strawberries, and black grapes thick blend topped with granola and flax seeds.', 'breakfast', 150, 'https://images.unsplash.com/photo-1550547660-d9450f859349?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Superfood', 'Energy Bowl'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-32-m8', 'disc-real-32', 'Citrus Orange & Sweet Lime Blend', 'Valencia oranges and fresh mosambi pressed fresh upon ordering.', 'drinks', 70, 'https://images.unsplash.com/photo-1550547660-d9450f859349?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Vitamin C', '100% Natural'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-33-m1', 'disc-real-33', 'Foxtail Millet (Korra) Khichdi', 'Slow-cooked foxtail millet and moong dal infused with mild ginger, cumin, and vegetables. Served with curd.', 'lunch', 99, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Diabetic Friendly', 'Low GI', 'Gluten Free'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-33-m2', 'disc-real-33', 'Ragi Sankati with Spiced Sambar', 'Finger millet ragi balls cooked traditionally, served with steaming hot vegetable drumstick sambar.', 'lunch', 85, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Calcium Rich', 'Traditional Telugu', 'Iron'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-33-m3', 'disc-real-33', 'Multi-Millet Crispy Dosa', 'Nutrient-packed fermented batter made with little millet, kodo millet, and lentils. Zero white rice.', 'breakfast', 75, 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Zero Rice', 'Crispy', 'Healthy Heart'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-33-m4', 'disc-real-33', 'Barnyard Millet Sambar Rice', 'Sanwa millet simmered in tangy lentil stew with shallots, carrot, and cow ghee tempering.', 'dinner', 89, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Light on Stomach', 'Pure Ghee'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-33-m5', 'disc-real-33', 'Little Millet (Samalu) Upma', 'Wholesome breakfast upma cooked with samalu grains, mustard, ginger, cashew bits, and curry leaves.', 'breakfast', 65, 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Breakfast', 'Fiber Rich'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-33-m6', 'disc-real-33', 'Pearl Millet (Bajra) Roti (2 pcs)', 'Warm hand-patted bajra rotis served with brinjal curry and garlic flaxseed chutney podi.', 'dinner', 80, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Winter Warmth', 'High Fiber'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-33-m7', 'disc-real-33', 'Millet Vegetable Pulao Bowl', 'Aromatic foxtail millet cooked with whole spices, green peas, carrots, and mint leaves.', 'lunch', 110, 'https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Low Carb', 'Flavorful'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-33-m8', 'disc-real-33', 'Ragi Ambali (Summer Cooler)', 'Hydrating fermented finger millet malt seasoned with buttermilk, chopped onions, and cumin.', 'drinks', 30, 'https://images.unsplash.com/photo-1550547660-d9450f859349?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Hydrating', 'Cooling Drink'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-33-m9', 'disc-real-33', 'Jowar Flakes Poha', 'Sorghum flakes sautéed with mustard, peanuts, green chillies, and fresh lemon squeeze.', 'breakfast', 60, 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Gluten Free', 'Quick Bite'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-34-m1', 'disc-real-34', '35g Protein Grilled Chicken Breast Box', '180g Lean herb-marinated chicken breast served with steamed broccoli, carrots, and portion of brown rice.', 'high-protein', 210, 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?auto=format&fit=crop&w=600&q=80',
  false, ARRAY['38g Protein', 'Lean Meat', 'Gym Diet'], true, 'official_website', 'verified',
  'https://bhookr.com', NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-34-m2', 'disc-real-34', 'High-Protein Paneer & Soya Bhurji', 'Crumbled low-fat paneer and minced soya granules sautéed with bell peppers and 3 multigrain rotis.', 'high-protein', 160, 'https://images.unsplash.com/photo-1631452180519-c014fe946bc7?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['30g Protein', 'Vegetarian Muscle', 'Multigrain'], true, 'official_website', 'verified',
  'https://bhookr.com', NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-34-m3', 'disc-real-34', '6-Egg Whites Plate with Black Pepper', '6 Farm fresh steamed egg whites tossed in olive oil, crushed black pepper, pink salt, and side salad.', 'high-protein', 80, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  false, ARRAY['24g Protein', 'Zero Fat', 'Keto'], true, 'official_website', 'verified',
  'https://bhookr.com', NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-34-m4', 'disc-real-34', 'Sprouted Moong & Roasted Paneer Salad', 'Sprouted moong beans, diced grilled paneer, cucumber, tomatoes, and lime-mint vinaigrette.', 'lunch', 125, 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['20g Protein', 'High Fiber', 'Raw Enzymes'], true, 'official_website', 'verified',
  'https://bhookr.com', NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-34-m5', 'disc-real-34', 'Grilled Tofu & Quinoa Teriyaki Bowl', 'Organic firm tofu pan-grilled with light low-sodium teriyaki glaze on fluffy quinoa base.', 'dinner', 185, 'https://images.unsplash.com/photo-1540420773420-3366772f4999?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Vegan Protein', 'Gluten Free', 'Superfood'], true, 'official_website', 'verified',
  'https://bhookr.com', NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-34-m6', 'disc-real-34', 'Protein Whey & Peanut Butter Shake', '1 Scoop isolate whey, unsweetened peanut butter, banana, and skimmed milk (30g protein).', 'drinks', 120, 'https://images.unsplash.com/photo-1550547660-d9450f859349?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Post Workout', 'No Added Sugar'], true, 'official_website', 'verified',
  'https://bhookr.com', NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-34-m7', 'disc-real-34', 'Keto Chicken Tikka Salad', 'Tandoori seasoned chicken breast skewers over crisp lettuce, cucumber ribbons, and olive oil.', 'dinner', 175, 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?auto=format&fit=crop&w=600&q=80',
  false, ARRAY['Keto Friendly', 'Low Carb'], true, 'official_website', 'verified',
  'https://bhookr.com', NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-34-m8', 'disc-real-34', 'High Fiber Soya Chunk Curry & Rice', 'Nutritious textured soya chunks simmered in aromatic onion tomato curry with brown basmati rice.', 'lunch', 110, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['High Fiber', 'Plant Protein'], true, 'official_website', 'verified',
  'https://bhookr.com', NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-34-m9', 'disc-real-34', 'Boiled Chickpea & Peanut Chaat', 'Warm boiled kabuli chana and peanuts tossed with chopped onions, green chillies, and lemon juice.', 'snacks', 60, 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Pre Workout Snack', 'Clean Carbs'], true, 'official_website', 'verified',
  'https://bhookr.com', NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-35-m1', 'disc-real-35', '35g Protein Grilled Chicken Breast Box', '180g Lean herb-marinated chicken breast served with steamed broccoli, carrots, and portion of brown rice.', 'high-protein', 210, 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?auto=format&fit=crop&w=600&q=80',
  false, ARRAY['38g Protein', 'Lean Meat', 'Gym Diet'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-35-m2', 'disc-real-35', 'High-Protein Paneer & Soya Bhurji', 'Crumbled low-fat paneer and minced soya granules sautéed with bell peppers and 3 multigrain rotis.', 'high-protein', 160, 'https://images.unsplash.com/photo-1631452180519-c014fe946bc7?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['30g Protein', 'Vegetarian Muscle', 'Multigrain'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-35-m3', 'disc-real-35', '6-Egg Whites Plate with Black Pepper', '6 Farm fresh steamed egg whites tossed in olive oil, crushed black pepper, pink salt, and side salad.', 'high-protein', 80, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  false, ARRAY['24g Protein', 'Zero Fat', 'Keto'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-35-m4', 'disc-real-35', 'Sprouted Moong & Roasted Paneer Salad', 'Sprouted moong beans, diced grilled paneer, cucumber, tomatoes, and lime-mint vinaigrette.', 'lunch', 125, 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['20g Protein', 'High Fiber', 'Raw Enzymes'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-35-m5', 'disc-real-35', 'Grilled Tofu & Quinoa Teriyaki Bowl', 'Organic firm tofu pan-grilled with light low-sodium teriyaki glaze on fluffy quinoa base.', 'dinner', 185, 'https://images.unsplash.com/photo-1540420773420-3366772f4999?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Vegan Protein', 'Gluten Free', 'Superfood'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-35-m6', 'disc-real-35', 'Protein Whey & Peanut Butter Shake', '1 Scoop isolate whey, unsweetened peanut butter, banana, and skimmed milk (30g protein).', 'drinks', 120, 'https://images.unsplash.com/photo-1550547660-d9450f859349?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Post Workout', 'No Added Sugar'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-35-m7', 'disc-real-35', 'Keto Chicken Tikka Salad', 'Tandoori seasoned chicken breast skewers over crisp lettuce, cucumber ribbons, and olive oil.', 'dinner', 175, 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?auto=format&fit=crop&w=600&q=80',
  false, ARRAY['Keto Friendly', 'Low Carb'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-35-m8', 'disc-real-35', 'High Fiber Soya Chunk Curry & Rice', 'Nutritious textured soya chunks simmered in aromatic onion tomato curry with brown basmati rice.', 'lunch', 110, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['High Fiber', 'Plant Protein'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-35-m9', 'disc-real-35', 'Boiled Chickpea & Peanut Chaat', 'Warm boiled kabuli chana and peanuts tossed with chopped onions, green chillies, and lemon juice.', 'snacks', 60, 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Pre Workout Snack', 'Clean Carbs'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-36-m1', 'disc-real-36', 'Mediterranean Falafel & Hummus Bowl', 'Baked herb falafels, velvety garlic chickpea hummus, pickled beets, cucumber, and multigrain pita chips.', 'lunch', 165, 'https://images.unsplash.com/photo-1540420773420-3366772f4999?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Heart Healthy', 'Olive Oil', 'Vegan'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-36-m2', 'disc-real-36', 'Grilled Paneer & Quinoa Harvest Bowl', 'Low-fat grilled paneer cubes, roasted bell peppers, steamed corn, and tri-color quinoa in basil vinaigrette.', 'dinner', 175, 'https://images.unsplash.com/photo-1540420773420-3366772f4999?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['22g Protein', 'Supergrain'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-36-m3', 'disc-real-36', 'Tex-Mex Bean & Brown Rice Burrito Bowl', 'Black beans, sweet corn, salsa fresca, guacamole, and cilantro lime brown rice.', 'lunch', 155, 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['High Fiber', 'Immunity Boost'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-36-m4', 'disc-real-36', 'Smoked Chicken Salad Bowl', 'Smoked shredded chicken breast, crunchy romaine lettuce, cherry tomatoes, and honey mustard dressing.', 'lunch', 185, 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?auto=format&fit=crop&w=600&q=80',
  false, ARRAY['31g Protein', 'Keto Friendly'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-36-m5', 'disc-real-36', 'Avocado & Chickpea Protein Salad', 'Ripe avocado chunks, boiled chickpeas, diced cucumbers, and lemon tahini dressing.', 'dinner', 160, 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Good Fats', 'Antioxidants'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-36-m6', 'disc-real-36', 'Super Green Detox Soup (Bowl)', 'Broccoli, baby spinach, and zucchini puréed with almond milk and roasted pumpkin seeds.', 'dinner', 95, 'https://images.unsplash.com/photo-1540420773420-3366772f4999?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Cleansing', 'Immunity Booster'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-36-m7', 'disc-real-36', 'Nutty Chia Seed Pudding Bowl', 'Overnight chia seeds steeped in almond milk, topped with kiwi, berries, and roasted almond slivers.', 'breakfast', 120, 'https://images.unsplash.com/photo-1550547660-d9450f859349?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Omega 3', 'No White Sugar'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-36-m8', 'disc-real-36', 'Cold Pressed Orange Carrot Juice', '100% Raw unpasteurized juice with zero added water and zero sugar.', 'drinks', 75, 'https://images.unsplash.com/photo-1550547660-d9450f859349?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Vitamin C', 'Pure Juice'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-37-m1', 'disc-real-37', 'Foxtail Millet (Korra) Khichdi', 'Slow-cooked foxtail millet and moong dal infused with mild ginger, cumin, and vegetables. Served with curd.', 'lunch', 99, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Diabetic Friendly', 'Low GI', 'Gluten Free'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-37-m2', 'disc-real-37', 'Ragi Sankati with Spiced Sambar', 'Finger millet ragi balls cooked traditionally, served with steaming hot vegetable drumstick sambar.', 'lunch', 85, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Calcium Rich', 'Traditional Telugu', 'Iron'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-37-m3', 'disc-real-37', 'Multi-Millet Crispy Dosa', 'Nutrient-packed fermented batter made with little millet, kodo millet, and lentils. Zero white rice.', 'breakfast', 75, 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Zero Rice', 'Crispy', 'Healthy Heart'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-37-m4', 'disc-real-37', 'Barnyard Millet Sambar Rice', 'Sanwa millet simmered in tangy lentil stew with shallots, carrot, and cow ghee tempering.', 'dinner', 89, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Light on Stomach', 'Pure Ghee'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-37-m5', 'disc-real-37', 'Little Millet (Samalu) Upma', 'Wholesome breakfast upma cooked with samalu grains, mustard, ginger, cashew bits, and curry leaves.', 'breakfast', 65, 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Breakfast', 'Fiber Rich'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-37-m6', 'disc-real-37', 'Pearl Millet (Bajra) Roti (2 pcs)', 'Warm hand-patted bajra rotis served with brinjal curry and garlic flaxseed chutney podi.', 'dinner', 80, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Winter Warmth', 'High Fiber'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-37-m7', 'disc-real-37', 'Millet Vegetable Pulao Bowl', 'Aromatic foxtail millet cooked with whole spices, green peas, carrots, and mint leaves.', 'lunch', 110, 'https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Low Carb', 'Flavorful'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-37-m8', 'disc-real-37', 'Ragi Ambali (Summer Cooler)', 'Hydrating fermented finger millet malt seasoned with buttermilk, chopped onions, and cumin.', 'drinks', 30, 'https://images.unsplash.com/photo-1550547660-d9450f859349?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Hydrating', 'Cooling Drink'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-37-m9', 'disc-real-37', 'Jowar Flakes Poha', 'Sorghum flakes sautéed with mustard, peanuts, green chillies, and fresh lemon squeeze.', 'breakfast', 60, 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Gluten Free', 'Quick Bite'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-38-m1', 'disc-real-38', 'Tropical Dragon Fruit & Papaya Bowl', 'Fresh cubes of pink dragon fruit, ripe honey papaya, pineapple, and soaked chia seeds.', 'breakfast', 110, 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Antioxidant', 'Hydrating', 'Raw'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-38-m2', 'disc-real-38', 'ABC Immunity Detox Juice (350ml)', 'Fresh Apple, Beetroot, and Carrot slow pressed with a dash of ginger and lemon.', 'drinks', 80, 'https://images.unsplash.com/photo-1550547660-d9450f859349?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Glow Skin', 'Cold Pressed'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-38-m3', 'disc-real-38', 'Avocado & Banana Nut Smoothie', 'Creamy Hass avocado blended with robosta banana, honey, and crushed walnuts.', 'drinks', 130, 'https://images.unsplash.com/photo-1550547660-d9450f859349?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Energy Dense', 'Good Fats'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-38-m4', 'disc-real-38', 'Pomegranate Pearl Vitamin Platter', 'Freshly peeled ruby pomegranate arils served with lime wedge and pink salt.', 'snacks', 90, 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Iron Booster', 'Freshly Cut'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-38-m5', 'disc-real-38', 'Watermelon Mint Hydration Cooler', 'Pure cold-crushed watermelon pulp with fresh garden mint leaves. Zero added sugar.', 'drinks', 60, 'https://images.unsplash.com/photo-1550547660-d9450f859349?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Summer Refresh', 'Hydrating'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-38-m6', 'disc-real-38', 'Green Goodness Spinach Cucumber Detox', 'Baby spinach, English cucumber, green apple, celery, and lemon cold pressed juice.', 'drinks', 85, 'https://images.unsplash.com/photo-1550547660-d9450f859349?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Alkalizing', 'Detox'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-38-m7', 'disc-real-38', 'Berry Berry Acai Smoothie Bowl', 'Blueberries, strawberries, and black grapes thick blend topped with granola and flax seeds.', 'breakfast', 150, 'https://images.unsplash.com/photo-1550547660-d9450f859349?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Superfood', 'Energy Bowl'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-38-m8', 'disc-real-38', 'Citrus Orange & Sweet Lime Blend', 'Valencia oranges and fresh mosambi pressed fresh upon ordering.', 'drinks', 70, 'https://images.unsplash.com/photo-1550547660-d9450f859349?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Vitamin C', '100% Natural'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-39-m1', 'disc-real-39', 'Udupi Special Button Sambar Idli', '14 mini steamed button idlis immersed in piping hot Udupi sweet-tangy lentil sambar and coriander.', 'breakfast', 60, 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Udupi Classic', 'Steamed', 'Digestible'], true, 'official_website', 'verified',
  NULL, NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-39-m2', 'disc-real-39', 'Malgudi Ghee Roast Dosa', 'Thin paper-crisp dosa roasted in pure clarified butter with spiced gun powder (karam podi).', 'breakfast', 85, 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Cow Ghee', 'Gunpowder', 'Crispy'], true, 'official_website', 'verified',
  NULL, NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-39-m3', 'disc-real-39', 'Udupi Bisi Bele Bath with Boondi', 'Karnataka special slow-cooked spiced rice, toor dal, seasonal vegetables, and pure ghee topped with crispy kara boondi.', 'lunch', 90, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Signature Dish', 'Slow Cooked'], true, 'official_website', 'verified',
  NULL, NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-39-m4', 'disc-real-39', 'Ven Pongal with Ghee & Cashews', 'Wholesome moong dal and rice porridge tempered with crushed black pepper, cumin seeds, and golden roasted cashews.', 'breakfast', 75, 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Cashew Nut', 'Zero Spice'], true, 'official_website', 'verified',
  NULL, NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-39-m5', 'disc-real-39', 'Udupi Thali Meals (Pure Veg)', 'Steamed rice, kosambari, palya vegetable, rasam, Udupi sambar, papad, curd, and payasam.', 'lunch', 130, 'https://images.unsplash.com/photo-1610057099431-d73a1c9d2f2f?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Complete Thali', 'Pure Vegetarian'], true, 'official_website', 'verified',
  NULL, NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-39-m6', 'disc-real-39', 'Rava Kesari Bath', 'Traditional semolina dessert cooked with cow ghee, saffron essence, cardamom, and roasted raisins.', 'snacks', 45, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Sweet', 'Ghee Rich'], true, 'official_website', 'verified',
  NULL, NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-39-m7', 'disc-real-39', 'Dahi Vada (2 pcs)', 'Lentil fritters soaked in chilled whipped yogurt, seasoned with roasted cumin and sweet tamarind glaze.', 'snacks', 65, 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Cooling', 'Probiotic'], true, 'official_website', 'verified',
  NULL, NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-39-m8', 'disc-real-39', 'Mysore Filter Kapi', 'Strong brew made with dark roasted coffee beans and thick milk, served steaming hot.', 'breakfast', 25, 'https://images.unsplash.com/photo-1514432324607-a09d9b4aefdd?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Fresh Decoction'], true, 'official_website', 'verified',
  NULL, NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-39-m9', 'disc-real-39', 'Set Dosa with Sagu (3 mini pcs)', 'Soft, spongy pancakes served in sets of three with vegetable coconut sagu.', 'breakfast', 70, 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Soft Texture', 'No Oil Fry'], true, 'official_website', 'verified',
  NULL, NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-39-m10', 'disc-real-39', 'Mirchi Bajji Plate', 'Large mild Bhavnagri chillies dipped in spiced gram flour and fried crisp, stuffed with onion & lemon.', 'snacks', 40, 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Street Favorite', 'Hot & Tangy'], true, 'official_website', 'verified',
  NULL, NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-40-m1', 'disc-real-40', 'Ghee Thatte Idli (2 pcs)', 'Steamed fluffy idlis bathed in fragrant melted cow ghee, served with coconut chutney & piping hot sambar.', 'breakfast', 50, 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Pure Ghee', 'Steamed', 'Digestible'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-40-m2', 'disc-real-40', 'Crispy Medu Vada (2 pcs)', 'Golden fried crispy lentil vadas with ginger and whole black pepper notes, served with spicy red chutney.', 'breakfast', 55, 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Crispy', 'Traditional', 'Protein Rich'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-40-m3', 'disc-real-40', 'Special Ghee Masala Dosa', 'Crispy fermented rice-lentil crepe smeared with spicy red chilli-garlic chutney and filled with spiced mashed potato.', 'breakfast', 75, 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Signature', 'Golden Crisp', 'Zero Soda'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-40-m4', 'disc-real-40', 'Andhra Upma Pesarattu', 'Whole green gram crepe cooked crisp, filled with aromatic rava upma and served with allam (ginger) pachadi.', 'breakfast', 80, 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['High Fiber', 'Green Moong', 'Authentic Andhra'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-40-m5', 'disc-real-40', 'Onion Rava Dosa', 'Cracked semolina batter griddled thin and crispy with diced shallots, cumin, and fresh green chillies.', 'breakfast', 85, 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Extra Crispy', 'Fresh Herbs'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-40-m6', 'disc-real-40', 'Poori with Potato Sagu (2 pcs)', 'Freshly puffed golden pooris served with mild Karnataka-style Bombay potato sagu.', 'breakfast', 65, 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Hot & Fresh', 'Breakfast Classic'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-40-m7', 'disc-real-40', 'Mysore Bonda (4 pcs)', 'Golden fluffy fried dumplings served hot with ginger chutney and coconut dip.', 'snacks', 45, 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Evening Special', 'Crunchy Outside'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-40-m8', 'disc-real-40', 'Homestyle Sambar Rice', 'Short-grain rice simmered with drumstick sambar, shallots, and ghee tempering. Served with appalam.', 'lunch', 70, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Comfort Meal', 'Pure Ghee'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-40-m9', 'disc-real-40', 'Tadka Curd Rice with Pomegranate', 'Cooling creamy curd rice tempered with mustard seeds, ginger, curry leaves, and crunchy pomegranate pearls.', 'dinner', 60, 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Probiotic', 'Light & Cooling'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-40-m10', 'disc-real-40', 'South Indian Filter Coffee', 'Fresh chicory-blended decoction frothed with thick boiling milk in brass tumbler.', 'snacks', 25, 'https://images.unsplash.com/photo-1514432324607-a09d9b4aefdd?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Aromatic', 'Brass Frothed'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-41-m1', 'disc-real-41', 'Authentic Andhra Bhojanam (Full Meal)', 'Steamed Sona Masoori rice, Mudda Pappu, Neyyi (ghee), Avakaya pickle, Veg Iguru, Sambar, Charu, Majjiga, and Appalam.', 'lunch', 110, 'https://images.unsplash.com/photo-1610057099431-d73a1c9d2f2f?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Unlimited Style', 'Traditional Telugu', 'Pure Ghee'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-41-m2', 'disc-real-41', 'Mudda Pappu & Avakaya Annam Bowl', 'Comfort classic: hot steamed rice mixed with thick yellow dal, mango avakaya pickle, and dollop of country cow ghee.', 'lunch', 85, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Comfort Food', 'Mom Made'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-41-m3', 'disc-real-41', 'Gutthi Vankaya Curry with 3 Phulkas', 'Tender stuffed brinjals simmered in rich peanut, sesame, and dry coconut gravy.', 'dinner', 115, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Rayalaseema Specialty', 'Peanut Gravy'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-41-m4', 'disc-real-41', 'Andhra Natukodi Chicken Curry', 'Country chicken cooked on slow flame with crushed black pepper, dry red chillies, and ginger garlic paste.', 'lunch', 180, 'https://images.unsplash.com/photo-1626777552726-4a6b54c97e46?auto=format&fit=crop&w=600&q=80',
  false, ARRAY['Country Chicken', 'Spicy Gravy'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-41-m5', 'disc-real-41', 'Bagara Rice with Chicken Gravy Box', 'Aromatic basmati rice cooked with whole spices, served with homestyle spicy chicken curry and onion raita.', 'lunch', 165, 'https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?auto=format&fit=crop&w=600&q=80',
  false, ARRAY['Telangana Favorite', 'Party Classic'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-41-m6', 'disc-real-41', 'Tomato Pappu with Steamed Rice', 'Lentils cooked with ripe tomatoes, garlic, and red chili tadka. Served with fried papad.', 'dinner', 75, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Student Friendly', 'Tangy & Warm'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-41-m7', 'disc-real-41', 'Royyala Vepudu (Andhra Prawn Fry)', 'Fresh prawns tossed in a wok with caramelized onions, curry leaves, and freshly ground coriander spice.', 'dinner', 220, 'https://images.unsplash.com/photo-1565557623262-b51c2513a641?auto=format&fit=crop&w=600&q=80',
  false, ARRAY['Coastal Andhra', 'Seafood'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-41-m8', 'disc-real-41', 'Gongura Chicken Curry with Rice', 'Tender chicken cooked with tart roselle (gongura) leaves, giving the iconic Andhra tangy kick.', 'lunch', 175, 'https://images.unsplash.com/photo-1626777552726-4a6b54c97e46?auto=format&fit=crop&w=600&q=80',
  false, ARRAY['Gongura', 'Iconic Andhra'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-41-m9', 'disc-real-41', 'Spiced Majjiga (Chilled Buttermilk)', 'Hand-churned refreshing buttermilk infused with crushed ginger, green chili, and fresh coriander.', 'drinks', 20, 'https://images.unsplash.com/photo-1550547660-d9450f859349?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Hydration', 'Digestive'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-41-m10', 'disc-real-41', 'Bendakaya Vepudu (Crispy Okra Fry)', 'Thinly sliced ladyfinger roasted golden with peanuts, garlic, and curry leaves.', 'lunch', 65, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Crunchy', 'Low Calorie'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-42-m1', 'disc-real-42', 'Telangana Bagara Rice with Chicken Curry', 'Fragrant rice tempered with shahjeera, cinnamon, cloves, and mint, paired with spicy Telangana chicken gravy.', 'lunch', 165, 'https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?auto=format&fit=crop&w=600&q=80',
  false, ARRAY['Telangana Specialty', 'Spicy Chicken'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-42-m2', 'disc-real-42', 'Bagara Rice with Gutthi Vankaya Curry', 'Aromatic tempered rice paired with baby brinjals stuffed with peanut, sesame, and coriander paste.', 'lunch', 125, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Vegetarian Feast', 'Peanut Masala'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-42-m3', 'disc-real-42', 'Telangana Mutton Curry with Bagara Rice', 'Slow-braised mutton with bone in fiery Telangana masala, served with warm bagara rice.', 'dinner', 230, 'https://images.unsplash.com/photo-1626777552726-4a6b54c97e46?auto=format&fit=crop&w=600&q=80',
  false, ARRAY['Sunday Special', 'Rich Gravy'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-42-m4', 'disc-real-42', 'Dalcha with Bagara Rice', 'Slow-simmered chana dal and bottle gourd stew flavored with whole aromatic spices and tamarind.', 'lunch', 95, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Hyderabad Classic', 'Tangy Dal'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-42-m5', 'disc-real-42', 'Chicken Fry Piece Box', 'Boneless chicken marinated with crushed pepper, coriander seeds, and fried crisp with curry leaves.', 'snacks', 160, 'https://images.unsplash.com/photo-1565557623262-b51c2513a641?auto=format&fit=crop&w=600&q=80',
  false, ARRAY['Curry Leaves', 'Crisp Fry'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-42-m6', 'disc-real-42', 'Mirchi ka Salan (Side Bowl)', 'Traditional Hyderabad gravy made with roasted peanuts, sesame seeds, coconut, and fried banana chillies.', 'lunch', 45, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Rich Gravy', 'Biryani Companion'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-42-m7', 'disc-real-42', 'Spiced Majjiga (Buttermilk)', 'Fresh buttermilk with green chillies, ginger, and coriander tempering.', 'drinks', 20, 'https://images.unsplash.com/photo-1550547660-d9450f859349?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Digestive', 'Cooling'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-42-m8', 'disc-real-42', 'Double ka Meetha', 'Hyderabadi bread pudding fried in ghee, steeped in thickened saffron rabdi and silver varq.', 'snacks', 50, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Dessert', 'Hyderabadi Royalty'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-43-m1', 'disc-real-43', 'Amma Special Veg Thali Box', '4 Whole wheat rotis, homestyle yellow dal, aloo beans fry, steamed rice, sambar, and home pickle.', 'lunch', 95, 'https://images.unsplash.com/photo-1610057099431-d73a1c9d2f2f?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Zero Soda', 'Mom''s Cooking', 'Balanced Meal'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-43-m2', 'disc-real-43', 'Pachi Pulusu with Hot Rice & Ghee', 'Raw tamarind extract simmered with charred onions, jaggery, and crushed green chillies. Supreme comfort.', 'lunch', 70, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Telangana Heritage', 'Raw Rasam'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-43-m3', 'disc-real-43', 'Homestyle Egg Curry with Rice', '2 Boiled eggs simmered in onion-tomato homestyle gravy, served with portion of steamed rice.', 'dinner', 90, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  false, ARRAY['High Protein', 'Affordable'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-43-m4', 'disc-real-43', 'Palak Pappu with Phulkas (3 pcs)', 'Fresh garden spinach cooked with toor dal and mild cumin garlic seasoning, served with soft puffed phulkas.', 'dinner', 80, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Iron Rich', 'Low Calorie'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-43-m5', 'disc-real-43', 'Kandi Podi Ghee Rice Meal', 'Steamed rice served with homemade roasted lentil gun powder, clarified cow ghee, and crunchy appalam.', 'lunch', 65, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Dry Lentil Podi', 'Quick Lunch'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-43-m6', 'disc-real-43', 'Dondakaya Fry (Tindora Peanut)', 'Ivy gourd roundels stir-fried slowly with crunchy roasted peanuts and mild red chilli.', 'dinner', 60, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Homestyle Sabzi', 'Crisp'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-43-m7', 'disc-real-43', 'Menthi Kura Pappu (Fenugreek Dal)', 'Warm yellow lentils infused with slightly bitter fresh methi leaves and garlic tempering.', 'lunch', 60, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Herbal', 'Digestive'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-43-m8', 'disc-real-43', 'Kobbari Annam (Coconut Rice)', 'Short grain rice flavored with fresh grated coconut, cashews, mustard seeds, and whole green chillies.', 'lunch', 80, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Festive Flavor', 'Aromatic'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-43-m9', 'disc-real-43', 'Telangana Sarva Pindi (Snack)', 'Traditional savoury pancake made with rice flour, chana dal, sesame seeds, and spring onion.', 'snacks', 40, 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Telangana Specialty', 'Crisp Crust'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-44-m1', 'disc-real-44', 'Special Hyderabadi Chicken Dum Biryani', 'Long grain aromatic basmati rice cooked on dum with marinated chicken, saffron, mint, and whole spices. Served with Mirchi ka Salan & Raita.', 'lunch', 170, 'https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?auto=format&fit=crop&w=600&q=80',
  false, ARRAY['Dum Cooked', 'Hyderabadi Classic'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-44-m2', 'disc-real-44', 'Hyderabadi Veg Dum Biryani', 'Garden vegetables, fried onions, and paneer cubes layered with spiced basmati rice and saffron milk.', 'lunch', 130, 'https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Dum Veg', 'Aromatic'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-44-m3', 'disc-real-44', 'Executive North Indian Thali', '3 Tawa Parathas, Shahi Paneer, Dal Makhani, Veg Pulao, Gulab Jamun, Salad & Raita.', 'lunch', 160, 'https://images.unsplash.com/photo-1610057099431-d73a1c9d2f2f?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Executive Thali', 'Rich & Filling'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-44-m4', 'disc-real-44', 'Chicken Tikka Kebab Plate (6 pcs)', 'Boneless chicken chunks marinated in spiced yogurt and grilled juicy in tandoor.', 'snacks', 180, 'https://images.unsplash.com/photo-1565557623262-b51c2513a641?auto=format&fit=crop&w=600&q=80',
  false, ARRAY['Tandoori', 'Smoky'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-44-m5', 'disc-real-44', 'Dal Makhani with 2 Butter Naans', 'Slow simmered black lentils in butter and cream, served with 2 fluffy butter naans.', 'dinner', 145, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Creamy Dal', 'Dinner Special'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-44-m6', 'disc-real-44', 'Egg Dum Biryani Box', '2 Spiced golden boiled eggs layered with biryani rice, served with raita and salan.', 'lunch', 120, 'https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?auto=format&fit=crop&w=600&q=80',
  false, ARRAY['Egg Biryani', 'Student Value'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-44-m7', 'disc-real-44', 'Paneer Tikka Roll', 'Grilled cottage cheese cubes, sliced onions, and mint chutney wrapped in whole wheat paratha.', 'snacks', 90, 'https://images.unsplash.com/photo-1631452180519-c014fe946bc7?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Grab & Go', 'Fresh Kati Roll'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-44-m8', 'disc-real-44', 'Gulab Jamun (2 pcs)', 'Warm milk-solid dumplings soaked in rose and cardamom sugar syrup.', 'snacks', 40, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Dessert', 'Sweet Tooth'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-45-m1', 'disc-real-45', 'Student Budget Mini Meal', 'Steamed rice, daily dal tadka, potato fry, and papad. Wholesome and easy on the pocket.', 'lunch', 65, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Pocket Friendly', 'Student Favorite'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-45-m2', 'disc-real-45', 'Schezwan Veg Fried Rice & Manchurian', 'Wok-tossed spicy Indo-Chinese fried rice paired with dry vegetable manchurian balls.', 'dinner', 110, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Indo Chinese', 'Spicy Wok'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-45-m3', 'disc-real-45', 'Chicken Fried Rice & Chilli Chicken Combo', 'Egg & shredded chicken wok rice with 4 pcs of Andhra style dry chilli chicken.', 'dinner', 145, 'https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?auto=format&fit=crop&w=600&q=80',
  false, ARRAY['Student Hit', 'High Energy'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-45-m4', 'disc-real-45', 'Paneer Paratha Meal (2 pcs with Pickle)', '2 Stuffed paneer parathas cooked with butter, served with chilled curd and lime pickle.', 'breakfast', 85, 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Heavy Breakfast', 'Filling'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-45-m5', 'disc-real-45', 'Cheese Maggi Double Masala', 'Double portion masala noodles topped with melted cheddar cheese, sweet corn, and green chillies.', 'snacks', 55, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Late Night Craving', 'Comfort Snack'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-45-m6', 'disc-real-45', 'Crispy Samosa Plate (2 pcs)', 'Flaky crust stuffed with cumin-spiced potatoes and green peas, served with sweet-tangy chutney.', 'snacks', 30, 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Campus Chai Time', 'Crisp'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-45-m7', 'disc-real-45', 'Single Omelette Bread Toast', '2-Egg fluffy masala omelette sandwiched between toasted whole wheat slices.', 'breakfast', 50, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  false, ARRAY['Quick Energy', 'High Protein'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-45-m8', 'disc-real-45', 'Masala Chai Flask (Serves 2)', 'Cardamom and crushed ginger boiled in creamy milk, packed warm in insulated flask.', 'drinks', 35, 'https://images.unsplash.com/photo-1514432324607-a09d9b4aefdd?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Kadak Chai', 'Energy'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-46-m1', 'disc-real-46', 'Ghee Thatte Idli (2 pcs)', 'Steamed fluffy idlis bathed in fragrant melted cow ghee, served with coconut chutney & piping hot sambar.', 'breakfast', 50, 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Pure Ghee', 'Steamed', 'Digestible'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-46-m2', 'disc-real-46', 'Crispy Medu Vada (2 pcs)', 'Golden fried crispy lentil vadas with ginger and whole black pepper notes, served with spicy red chutney.', 'breakfast', 55, 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Crispy', 'Traditional', 'Protein Rich'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-46-m3', 'disc-real-46', 'Special Ghee Masala Dosa', 'Crispy fermented rice-lentil crepe smeared with spicy red chilli-garlic chutney and filled with spiced mashed potato.', 'breakfast', 75, 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Signature', 'Golden Crisp', 'Zero Soda'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-46-m4', 'disc-real-46', 'Andhra Upma Pesarattu', 'Whole green gram crepe cooked crisp, filled with aromatic rava upma and served with allam (ginger) pachadi.', 'breakfast', 80, 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['High Fiber', 'Green Moong', 'Authentic Andhra'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-46-m5', 'disc-real-46', 'Onion Rava Dosa', 'Cracked semolina batter griddled thin and crispy with diced shallots, cumin, and fresh green chillies.', 'breakfast', 85, 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Extra Crispy', 'Fresh Herbs'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-46-m6', 'disc-real-46', 'Poori with Potato Sagu (2 pcs)', 'Freshly puffed golden pooris served with mild Karnataka-style Bombay potato sagu.', 'breakfast', 65, 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Hot & Fresh', 'Breakfast Classic'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-46-m7', 'disc-real-46', 'Mysore Bonda (4 pcs)', 'Golden fluffy fried dumplings served hot with ginger chutney and coconut dip.', 'snacks', 45, 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Evening Special', 'Crunchy Outside'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-46-m8', 'disc-real-46', 'Homestyle Sambar Rice', 'Short-grain rice simmered with drumstick sambar, shallots, and ghee tempering. Served with appalam.', 'lunch', 70, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Comfort Meal', 'Pure Ghee'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-46-m9', 'disc-real-46', 'Tadka Curd Rice with Pomegranate', 'Cooling creamy curd rice tempered with mustard seeds, ginger, curry leaves, and crunchy pomegranate pearls.', 'dinner', 60, 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Probiotic', 'Light & Cooling'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-46-m10', 'disc-real-46', 'South Indian Filter Coffee', 'Fresh chicory-blended decoction frothed with thick boiling milk in brass tumbler.', 'snacks', 25, 'https://images.unsplash.com/photo-1514432324607-a09d9b4aefdd?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Aromatic', 'Brass Frothed'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-47-m1', 'disc-real-47', 'Amma Special Veg Thali Box', '4 Whole wheat rotis, homestyle yellow dal, aloo beans fry, steamed rice, sambar, and home pickle.', 'lunch', 95, 'https://images.unsplash.com/photo-1610057099431-d73a1c9d2f2f?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Zero Soda', 'Mom''s Cooking', 'Balanced Meal'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-47-m2', 'disc-real-47', 'Pachi Pulusu with Hot Rice & Ghee', 'Raw tamarind extract simmered with charred onions, jaggery, and crushed green chillies. Supreme comfort.', 'lunch', 70, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Telangana Heritage', 'Raw Rasam'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-47-m3', 'disc-real-47', 'Homestyle Egg Curry with Rice', '2 Boiled eggs simmered in onion-tomato homestyle gravy, served with portion of steamed rice.', 'dinner', 90, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  false, ARRAY['High Protein', 'Affordable'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-47-m4', 'disc-real-47', 'Palak Pappu with Phulkas (3 pcs)', 'Fresh garden spinach cooked with toor dal and mild cumin garlic seasoning, served with soft puffed phulkas.', 'dinner', 80, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Iron Rich', 'Low Calorie'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-47-m5', 'disc-real-47', 'Kandi Podi Ghee Rice Meal', 'Steamed rice served with homemade roasted lentil gun powder, clarified cow ghee, and crunchy appalam.', 'lunch', 65, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Dry Lentil Podi', 'Quick Lunch'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-47-m6', 'disc-real-47', 'Dondakaya Fry (Tindora Peanut)', 'Ivy gourd roundels stir-fried slowly with crunchy roasted peanuts and mild red chilli.', 'dinner', 60, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Homestyle Sabzi', 'Crisp'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-47-m7', 'disc-real-47', 'Menthi Kura Pappu (Fenugreek Dal)', 'Warm yellow lentils infused with slightly bitter fresh methi leaves and garlic tempering.', 'lunch', 60, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Herbal', 'Digestive'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-47-m8', 'disc-real-47', 'Kobbari Annam (Coconut Rice)', 'Short grain rice flavored with fresh grated coconut, cashews, mustard seeds, and whole green chillies.', 'lunch', 80, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Festive Flavor', 'Aromatic'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-47-m9', 'disc-real-47', 'Telangana Sarva Pindi (Snack)', 'Traditional savoury pancake made with rice flour, chana dal, sesame seeds, and spring onion.', 'snacks', 40, 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Telangana Specialty', 'Crisp Crust'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-48-m1', 'disc-real-48', 'Ghee Thatte Idli (2 pcs)', 'Steamed fluffy idlis bathed in fragrant melted cow ghee, served with coconut chutney & piping hot sambar.', 'breakfast', 50, 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Pure Ghee', 'Steamed', 'Digestible'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-48-m2', 'disc-real-48', 'Crispy Medu Vada (2 pcs)', 'Golden fried crispy lentil vadas with ginger and whole black pepper notes, served with spicy red chutney.', 'breakfast', 55, 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Crispy', 'Traditional', 'Protein Rich'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-48-m3', 'disc-real-48', 'Special Ghee Masala Dosa', 'Crispy fermented rice-lentil crepe smeared with spicy red chilli-garlic chutney and filled with spiced mashed potato.', 'breakfast', 75, 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Signature', 'Golden Crisp', 'Zero Soda'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-48-m4', 'disc-real-48', 'Andhra Upma Pesarattu', 'Whole green gram crepe cooked crisp, filled with aromatic rava upma and served with allam (ginger) pachadi.', 'breakfast', 80, 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['High Fiber', 'Green Moong', 'Authentic Andhra'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-48-m5', 'disc-real-48', 'Onion Rava Dosa', 'Cracked semolina batter griddled thin and crispy with diced shallots, cumin, and fresh green chillies.', 'breakfast', 85, 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Extra Crispy', 'Fresh Herbs'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-48-m6', 'disc-real-48', 'Poori with Potato Sagu (2 pcs)', 'Freshly puffed golden pooris served with mild Karnataka-style Bombay potato sagu.', 'breakfast', 65, 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Hot & Fresh', 'Breakfast Classic'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-48-m7', 'disc-real-48', 'Mysore Bonda (4 pcs)', 'Golden fluffy fried dumplings served hot with ginger chutney and coconut dip.', 'snacks', 45, 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Evening Special', 'Crunchy Outside'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-48-m8', 'disc-real-48', 'Homestyle Sambar Rice', 'Short-grain rice simmered with drumstick sambar, shallots, and ghee tempering. Served with appalam.', 'lunch', 70, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Comfort Meal', 'Pure Ghee'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-48-m9', 'disc-real-48', 'Tadka Curd Rice with Pomegranate', 'Cooling creamy curd rice tempered with mustard seeds, ginger, curry leaves, and crunchy pomegranate pearls.', 'dinner', 60, 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Probiotic', 'Light & Cooling'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-48-m10', 'disc-real-48', 'South Indian Filter Coffee', 'Fresh chicory-blended decoction frothed with thick boiling milk in brass tumbler.', 'snacks', 25, 'https://images.unsplash.com/photo-1514432324607-a09d9b4aefdd?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Aromatic', 'Brass Frothed'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-49-m1', 'disc-real-49', 'Ghee Thatte Idli (2 pcs)', 'Steamed fluffy idlis bathed in fragrant melted cow ghee, served with coconut chutney & piping hot sambar.', 'breakfast', 50, 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Pure Ghee', 'Steamed', 'Digestible'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-49-m2', 'disc-real-49', 'Crispy Medu Vada (2 pcs)', 'Golden fried crispy lentil vadas with ginger and whole black pepper notes, served with spicy red chutney.', 'breakfast', 55, 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Crispy', 'Traditional', 'Protein Rich'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-49-m3', 'disc-real-49', 'Special Ghee Masala Dosa', 'Crispy fermented rice-lentil crepe smeared with spicy red chilli-garlic chutney and filled with spiced mashed potato.', 'breakfast', 75, 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Signature', 'Golden Crisp', 'Zero Soda'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-49-m4', 'disc-real-49', 'Andhra Upma Pesarattu', 'Whole green gram crepe cooked crisp, filled with aromatic rava upma and served with allam (ginger) pachadi.', 'breakfast', 80, 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['High Fiber', 'Green Moong', 'Authentic Andhra'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-49-m5', 'disc-real-49', 'Onion Rava Dosa', 'Cracked semolina batter griddled thin and crispy with diced shallots, cumin, and fresh green chillies.', 'breakfast', 85, 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Extra Crispy', 'Fresh Herbs'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-49-m6', 'disc-real-49', 'Poori with Potato Sagu (2 pcs)', 'Freshly puffed golden pooris served with mild Karnataka-style Bombay potato sagu.', 'breakfast', 65, 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Hot & Fresh', 'Breakfast Classic'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-49-m7', 'disc-real-49', 'Mysore Bonda (4 pcs)', 'Golden fluffy fried dumplings served hot with ginger chutney and coconut dip.', 'snacks', 45, 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Evening Special', 'Crunchy Outside'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-49-m8', 'disc-real-49', 'Homestyle Sambar Rice', 'Short-grain rice simmered with drumstick sambar, shallots, and ghee tempering. Served with appalam.', 'lunch', 70, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Comfort Meal', 'Pure Ghee'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-49-m9', 'disc-real-49', 'Tadka Curd Rice with Pomegranate', 'Cooling creamy curd rice tempered with mustard seeds, ginger, curry leaves, and crunchy pomegranate pearls.', 'dinner', 60, 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Probiotic', 'Light & Cooling'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-49-m10', 'disc-real-49', 'South Indian Filter Coffee', 'Fresh chicory-blended decoction frothed with thick boiling milk in brass tumbler.', 'snacks', 25, 'https://images.unsplash.com/photo-1514432324607-a09d9b4aefdd?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Aromatic', 'Brass Frothed'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-50-m1', 'disc-real-50', 'Ghee Thatte Idli (2 pcs)', 'Steamed fluffy idlis bathed in fragrant melted cow ghee, served with coconut chutney & piping hot sambar.', 'breakfast', 50, 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Pure Ghee', 'Steamed', 'Digestible'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-50-m2', 'disc-real-50', 'Crispy Medu Vada (2 pcs)', 'Golden fried crispy lentil vadas with ginger and whole black pepper notes, served with spicy red chutney.', 'breakfast', 55, 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Crispy', 'Traditional', 'Protein Rich'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-50-m3', 'disc-real-50', 'Special Ghee Masala Dosa', 'Crispy fermented rice-lentil crepe smeared with spicy red chilli-garlic chutney and filled with spiced mashed potato.', 'breakfast', 75, 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Signature', 'Golden Crisp', 'Zero Soda'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-50-m4', 'disc-real-50', 'Andhra Upma Pesarattu', 'Whole green gram crepe cooked crisp, filled with aromatic rava upma and served with allam (ginger) pachadi.', 'breakfast', 80, 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['High Fiber', 'Green Moong', 'Authentic Andhra'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-50-m5', 'disc-real-50', 'Onion Rava Dosa', 'Cracked semolina batter griddled thin and crispy with diced shallots, cumin, and fresh green chillies.', 'breakfast', 85, 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Extra Crispy', 'Fresh Herbs'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-50-m6', 'disc-real-50', 'Poori with Potato Sagu (2 pcs)', 'Freshly puffed golden pooris served with mild Karnataka-style Bombay potato sagu.', 'breakfast', 65, 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Hot & Fresh', 'Breakfast Classic'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-50-m7', 'disc-real-50', 'Mysore Bonda (4 pcs)', 'Golden fluffy fried dumplings served hot with ginger chutney and coconut dip.', 'snacks', 45, 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Evening Special', 'Crunchy Outside'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-50-m8', 'disc-real-50', 'Homestyle Sambar Rice', 'Short-grain rice simmered with drumstick sambar, shallots, and ghee tempering. Served with appalam.', 'lunch', 70, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Comfort Meal', 'Pure Ghee'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-50-m9', 'disc-real-50', 'Tadka Curd Rice with Pomegranate', 'Cooling creamy curd rice tempered with mustard seeds, ginger, curry leaves, and crunchy pomegranate pearls.', 'dinner', 60, 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Probiotic', 'Light & Cooling'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-50-m10', 'disc-real-50', 'South Indian Filter Coffee', 'Fresh chicory-blended decoction frothed with thick boiling milk in brass tumbler.', 'snacks', 25, 'https://images.unsplash.com/photo-1514432324607-a09d9b4aefdd?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Aromatic', 'Brass Frothed'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-51-m1', 'disc-real-51', 'Ghee Thatte Idli (2 pcs)', 'Steamed fluffy idlis bathed in fragrant melted cow ghee, served with coconut chutney & piping hot sambar.', 'breakfast', 50, 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Pure Ghee', 'Steamed', 'Digestible'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-51-m2', 'disc-real-51', 'Crispy Medu Vada (2 pcs)', 'Golden fried crispy lentil vadas with ginger and whole black pepper notes, served with spicy red chutney.', 'breakfast', 55, 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Crispy', 'Traditional', 'Protein Rich'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-51-m3', 'disc-real-51', 'Special Ghee Masala Dosa', 'Crispy fermented rice-lentil crepe smeared with spicy red chilli-garlic chutney and filled with spiced mashed potato.', 'breakfast', 75, 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Signature', 'Golden Crisp', 'Zero Soda'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-51-m4', 'disc-real-51', 'Andhra Upma Pesarattu', 'Whole green gram crepe cooked crisp, filled with aromatic rava upma and served with allam (ginger) pachadi.', 'breakfast', 80, 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['High Fiber', 'Green Moong', 'Authentic Andhra'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-51-m5', 'disc-real-51', 'Onion Rava Dosa', 'Cracked semolina batter griddled thin and crispy with diced shallots, cumin, and fresh green chillies.', 'breakfast', 85, 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Extra Crispy', 'Fresh Herbs'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-51-m6', 'disc-real-51', 'Poori with Potato Sagu (2 pcs)', 'Freshly puffed golden pooris served with mild Karnataka-style Bombay potato sagu.', 'breakfast', 65, 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Hot & Fresh', 'Breakfast Classic'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-51-m7', 'disc-real-51', 'Mysore Bonda (4 pcs)', 'Golden fluffy fried dumplings served hot with ginger chutney and coconut dip.', 'snacks', 45, 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Evening Special', 'Crunchy Outside'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-51-m8', 'disc-real-51', 'Homestyle Sambar Rice', 'Short-grain rice simmered with drumstick sambar, shallots, and ghee tempering. Served with appalam.', 'lunch', 70, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Comfort Meal', 'Pure Ghee'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-51-m9', 'disc-real-51', 'Tadka Curd Rice with Pomegranate', 'Cooling creamy curd rice tempered with mustard seeds, ginger, curry leaves, and crunchy pomegranate pearls.', 'dinner', 60, 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Probiotic', 'Light & Cooling'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-51-m10', 'disc-real-51', 'South Indian Filter Coffee', 'Fresh chicory-blended decoction frothed with thick boiling milk in brass tumbler.', 'snacks', 25, 'https://images.unsplash.com/photo-1514432324607-a09d9b4aefdd?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Aromatic', 'Brass Frothed'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-52-m1', 'disc-real-52', 'Ghee Thatte Idli (2 pcs)', 'Steamed fluffy idlis bathed in fragrant melted cow ghee, served with coconut chutney & piping hot sambar.', 'breakfast', 50, 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Pure Ghee', 'Steamed', 'Digestible'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-52-m2', 'disc-real-52', 'Crispy Medu Vada (2 pcs)', 'Golden fried crispy lentil vadas with ginger and whole black pepper notes, served with spicy red chutney.', 'breakfast', 55, 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Crispy', 'Traditional', 'Protein Rich'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-52-m3', 'disc-real-52', 'Special Ghee Masala Dosa', 'Crispy fermented rice-lentil crepe smeared with spicy red chilli-garlic chutney and filled with spiced mashed potato.', 'breakfast', 75, 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Signature', 'Golden Crisp', 'Zero Soda'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-52-m4', 'disc-real-52', 'Andhra Upma Pesarattu', 'Whole green gram crepe cooked crisp, filled with aromatic rava upma and served with allam (ginger) pachadi.', 'breakfast', 80, 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['High Fiber', 'Green Moong', 'Authentic Andhra'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-52-m5', 'disc-real-52', 'Onion Rava Dosa', 'Cracked semolina batter griddled thin and crispy with diced shallots, cumin, and fresh green chillies.', 'breakfast', 85, 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Extra Crispy', 'Fresh Herbs'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-52-m6', 'disc-real-52', 'Poori with Potato Sagu (2 pcs)', 'Freshly puffed golden pooris served with mild Karnataka-style Bombay potato sagu.', 'breakfast', 65, 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Hot & Fresh', 'Breakfast Classic'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-52-m7', 'disc-real-52', 'Mysore Bonda (4 pcs)', 'Golden fluffy fried dumplings served hot with ginger chutney and coconut dip.', 'snacks', 45, 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Evening Special', 'Crunchy Outside'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-52-m8', 'disc-real-52', 'Homestyle Sambar Rice', 'Short-grain rice simmered with drumstick sambar, shallots, and ghee tempering. Served with appalam.', 'lunch', 70, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Comfort Meal', 'Pure Ghee'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-52-m9', 'disc-real-52', 'Tadka Curd Rice with Pomegranate', 'Cooling creamy curd rice tempered with mustard seeds, ginger, curry leaves, and crunchy pomegranate pearls.', 'dinner', 60, 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Probiotic', 'Light & Cooling'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-52-m10', 'disc-real-52', 'South Indian Filter Coffee', 'Fresh chicory-blended decoction frothed with thick boiling milk in brass tumbler.', 'snacks', 25, 'https://images.unsplash.com/photo-1514432324607-a09d9b4aefdd?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Aromatic', 'Brass Frothed'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-53-m1', 'disc-real-53', 'Ghee Thatte Idli (2 pcs)', 'Steamed fluffy idlis bathed in fragrant melted cow ghee, served with coconut chutney & piping hot sambar.', 'breakfast', 50, 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Pure Ghee', 'Steamed', 'Digestible'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-53-m2', 'disc-real-53', 'Crispy Medu Vada (2 pcs)', 'Golden fried crispy lentil vadas with ginger and whole black pepper notes, served with spicy red chutney.', 'breakfast', 55, 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Crispy', 'Traditional', 'Protein Rich'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-53-m3', 'disc-real-53', 'Special Ghee Masala Dosa', 'Crispy fermented rice-lentil crepe smeared with spicy red chilli-garlic chutney and filled with spiced mashed potato.', 'breakfast', 75, 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Signature', 'Golden Crisp', 'Zero Soda'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-53-m4', 'disc-real-53', 'Andhra Upma Pesarattu', 'Whole green gram crepe cooked crisp, filled with aromatic rava upma and served with allam (ginger) pachadi.', 'breakfast', 80, 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['High Fiber', 'Green Moong', 'Authentic Andhra'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-53-m5', 'disc-real-53', 'Onion Rava Dosa', 'Cracked semolina batter griddled thin and crispy with diced shallots, cumin, and fresh green chillies.', 'breakfast', 85, 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Extra Crispy', 'Fresh Herbs'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-53-m6', 'disc-real-53', 'Poori with Potato Sagu (2 pcs)', 'Freshly puffed golden pooris served with mild Karnataka-style Bombay potato sagu.', 'breakfast', 65, 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Hot & Fresh', 'Breakfast Classic'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-53-m7', 'disc-real-53', 'Mysore Bonda (4 pcs)', 'Golden fluffy fried dumplings served hot with ginger chutney and coconut dip.', 'snacks', 45, 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Evening Special', 'Crunchy Outside'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-53-m8', 'disc-real-53', 'Homestyle Sambar Rice', 'Short-grain rice simmered with drumstick sambar, shallots, and ghee tempering. Served with appalam.', 'lunch', 70, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Comfort Meal', 'Pure Ghee'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-53-m9', 'disc-real-53', 'Tadka Curd Rice with Pomegranate', 'Cooling creamy curd rice tempered with mustard seeds, ginger, curry leaves, and crunchy pomegranate pearls.', 'dinner', 60, 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Probiotic', 'Light & Cooling'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-53-m10', 'disc-real-53', 'South Indian Filter Coffee', 'Fresh chicory-blended decoction frothed with thick boiling milk in brass tumbler.', 'snacks', 25, 'https://images.unsplash.com/photo-1514432324607-a09d9b4aefdd?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Aromatic', 'Brass Frothed'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-54-m1', 'disc-real-54', 'Udupi Special Button Sambar Idli', '14 mini steamed button idlis immersed in piping hot Udupi sweet-tangy lentil sambar and coriander.', 'breakfast', 60, 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Udupi Classic', 'Steamed', 'Digestible'], true, 'official_website', 'verified',
  'https://taazatiffins.com', NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-54-m2', 'disc-real-54', 'Malgudi Ghee Roast Dosa', 'Thin paper-crisp dosa roasted in pure clarified butter with spiced gun powder (karam podi).', 'breakfast', 85, 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Cow Ghee', 'Gunpowder', 'Crispy'], true, 'official_website', 'verified',
  'https://taazatiffins.com', NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-54-m3', 'disc-real-54', 'Udupi Bisi Bele Bath with Boondi', 'Karnataka special slow-cooked spiced rice, toor dal, seasonal vegetables, and pure ghee topped with crispy kara boondi.', 'lunch', 90, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Signature Dish', 'Slow Cooked'], true, 'official_website', 'verified',
  'https://taazatiffins.com', NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-54-m4', 'disc-real-54', 'Ven Pongal with Ghee & Cashews', 'Wholesome moong dal and rice porridge tempered with crushed black pepper, cumin seeds, and golden roasted cashews.', 'breakfast', 75, 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Cashew Nut', 'Zero Spice'], true, 'official_website', 'verified',
  'https://taazatiffins.com', NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-54-m5', 'disc-real-54', 'Udupi Thali Meals (Pure Veg)', 'Steamed rice, kosambari, palya vegetable, rasam, Udupi sambar, papad, curd, and payasam.', 'lunch', 130, 'https://images.unsplash.com/photo-1610057099431-d73a1c9d2f2f?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Complete Thali', 'Pure Vegetarian'], true, 'official_website', 'verified',
  'https://taazatiffins.com', NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-54-m6', 'disc-real-54', 'Rava Kesari Bath', 'Traditional semolina dessert cooked with cow ghee, saffron essence, cardamom, and roasted raisins.', 'snacks', 45, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Sweet', 'Ghee Rich'], true, 'official_website', 'verified',
  'https://taazatiffins.com', NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-54-m7', 'disc-real-54', 'Dahi Vada (2 pcs)', 'Lentil fritters soaked in chilled whipped yogurt, seasoned with roasted cumin and sweet tamarind glaze.', 'snacks', 65, 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Cooling', 'Probiotic'], true, 'official_website', 'verified',
  'https://taazatiffins.com', NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-54-m8', 'disc-real-54', 'Mysore Filter Kapi', 'Strong brew made with dark roasted coffee beans and thick milk, served steaming hot.', 'breakfast', 25, 'https://images.unsplash.com/photo-1514432324607-a09d9b4aefdd?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Fresh Decoction'], true, 'official_website', 'verified',
  'https://taazatiffins.com', NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-54-m9', 'disc-real-54', 'Set Dosa with Sagu (3 mini pcs)', 'Soft, spongy pancakes served in sets of three with vegetable coconut sagu.', 'breakfast', 70, 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Soft Texture', 'No Oil Fry'], true, 'official_website', 'verified',
  'https://taazatiffins.com', NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-54-m10', 'disc-real-54', 'Mirchi Bajji Plate', 'Large mild Bhavnagri chillies dipped in spiced gram flour and fried crisp, stuffed with onion & lemon.', 'snacks', 40, 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Street Favorite', 'Hot & Tangy'], true, 'official_website', 'verified',
  'https://taazatiffins.com', NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-55-m1', 'disc-real-55', 'Ghee Thatte Idli (2 pcs)', 'Steamed fluffy idlis bathed in fragrant melted cow ghee, served with coconut chutney & piping hot sambar.', 'breakfast', 50, 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Pure Ghee', 'Steamed', 'Digestible'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-55-m2', 'disc-real-55', 'Crispy Medu Vada (2 pcs)', 'Golden fried crispy lentil vadas with ginger and whole black pepper notes, served with spicy red chutney.', 'breakfast', 55, 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Crispy', 'Traditional', 'Protein Rich'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-55-m3', 'disc-real-55', 'Special Ghee Masala Dosa', 'Crispy fermented rice-lentil crepe smeared with spicy red chilli-garlic chutney and filled with spiced mashed potato.', 'breakfast', 75, 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Signature', 'Golden Crisp', 'Zero Soda'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-55-m4', 'disc-real-55', 'Andhra Upma Pesarattu', 'Whole green gram crepe cooked crisp, filled with aromatic rava upma and served with allam (ginger) pachadi.', 'breakfast', 80, 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['High Fiber', 'Green Moong', 'Authentic Andhra'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-55-m5', 'disc-real-55', 'Onion Rava Dosa', 'Cracked semolina batter griddled thin and crispy with diced shallots, cumin, and fresh green chillies.', 'breakfast', 85, 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Extra Crispy', 'Fresh Herbs'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-55-m6', 'disc-real-55', 'Poori with Potato Sagu (2 pcs)', 'Freshly puffed golden pooris served with mild Karnataka-style Bombay potato sagu.', 'breakfast', 65, 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Hot & Fresh', 'Breakfast Classic'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-55-m7', 'disc-real-55', 'Mysore Bonda (4 pcs)', 'Golden fluffy fried dumplings served hot with ginger chutney and coconut dip.', 'snacks', 45, 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Evening Special', 'Crunchy Outside'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-55-m8', 'disc-real-55', 'Homestyle Sambar Rice', 'Short-grain rice simmered with drumstick sambar, shallots, and ghee tempering. Served with appalam.', 'lunch', 70, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Comfort Meal', 'Pure Ghee'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-55-m9', 'disc-real-55', 'Tadka Curd Rice with Pomegranate', 'Cooling creamy curd rice tempered with mustard seeds, ginger, curry leaves, and crunchy pomegranate pearls.', 'dinner', 60, 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Probiotic', 'Light & Cooling'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'disc-real-55-m10', 'disc-real-55', 'South Indian Filter Coffee', 'Fresh chicory-blended decoction frothed with thick boiling milk in brass tumbler.', 'snacks', 25, 'https://images.unsplash.com/photo-1514432324607-a09d9b4aefdd?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Aromatic', 'Brass Frothed'], true, 'synthetic', 'sample',
  NULL, NOW(), true
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'demo-part-1-m1', 'demo-part-1', 'Ghee Thatte Idli (2 pcs)', 'Steamed fluffy idlis bathed in fragrant melted cow ghee, served with coconut chutney & piping hot sambar.', 'breakfast', 50, 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Pure Ghee', 'Steamed', 'Digestible'], true, 'provider', 'verified',
  NULL, NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'demo-part-1-m2', 'demo-part-1', 'Crispy Medu Vada (2 pcs)', 'Golden fried crispy lentil vadas with ginger and whole black pepper notes, served with spicy red chutney.', 'breakfast', 55, 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Crispy', 'Traditional', 'Protein Rich'], true, 'provider', 'verified',
  NULL, NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'demo-part-1-m3', 'demo-part-1', 'Special Ghee Masala Dosa', 'Crispy fermented rice-lentil crepe smeared with spicy red chilli-garlic chutney and filled with spiced mashed potato.', 'breakfast', 75, 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Signature', 'Golden Crisp', 'Zero Soda'], true, 'provider', 'verified',
  NULL, NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'demo-part-1-m4', 'demo-part-1', 'Andhra Upma Pesarattu', 'Whole green gram crepe cooked crisp, filled with aromatic rava upma and served with allam (ginger) pachadi.', 'breakfast', 80, 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['High Fiber', 'Green Moong', 'Authentic Andhra'], true, 'provider', 'verified',
  NULL, NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'demo-part-1-m5', 'demo-part-1', 'Onion Rava Dosa', 'Cracked semolina batter griddled thin and crispy with diced shallots, cumin, and fresh green chillies.', 'breakfast', 85, 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Extra Crispy', 'Fresh Herbs'], true, 'provider', 'verified',
  NULL, NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'demo-part-1-m6', 'demo-part-1', 'Poori with Potato Sagu (2 pcs)', 'Freshly puffed golden pooris served with mild Karnataka-style Bombay potato sagu.', 'breakfast', 65, 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Hot & Fresh', 'Breakfast Classic'], true, 'provider', 'verified',
  NULL, NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'demo-part-1-m7', 'demo-part-1', 'Mysore Bonda (4 pcs)', 'Golden fluffy fried dumplings served hot with ginger chutney and coconut dip.', 'snacks', 45, 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Evening Special', 'Crunchy Outside'], true, 'provider', 'verified',
  NULL, NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'demo-part-1-m8', 'demo-part-1', 'Homestyle Sambar Rice', 'Short-grain rice simmered with drumstick sambar, shallots, and ghee tempering. Served with appalam.', 'lunch', 70, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Comfort Meal', 'Pure Ghee'], true, 'provider', 'verified',
  NULL, NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'demo-part-1-m9', 'demo-part-1', 'Tadka Curd Rice with Pomegranate', 'Cooling creamy curd rice tempered with mustard seeds, ginger, curry leaves, and crunchy pomegranate pearls.', 'dinner', 60, 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Probiotic', 'Light & Cooling'], true, 'provider', 'verified',
  NULL, NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'demo-part-1-m10', 'demo-part-1', 'South Indian Filter Coffee', 'Fresh chicory-blended decoction frothed with thick boiling milk in brass tumbler.', 'snacks', 25, 'https://images.unsplash.com/photo-1514432324607-a09d9b4aefdd?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Aromatic', 'Brass Frothed'], true, 'provider', 'verified',
  NULL, NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'demo-part-3-m1', 'demo-part-3', 'Ghar Ka Khana Roti Thali (4 Phulkas)', '4 Whole wheat hot tawa phulkas, tadka dal, dry seasonal sabzi, salad, and pickle.', 'dinner', 85, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Whole Wheat', 'Zero Oil Roti', 'Comfort Meal'], true, 'provider', 'verified',
  NULL, NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'demo-part-3-m2', 'demo-part-3', 'Paneer Butter Masala Meal Box', 'Soft cottage cheese cubes in mildly spiced butter gravy, served with 3 rotis and jeera rice.', 'dinner', 140, 'https://images.unsplash.com/photo-1631452180519-c014fe946bc7?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['North Indian Favorite', 'Rich Gravy'], true, 'provider', 'verified',
  NULL, NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'demo-part-3-m3', 'demo-part-3', 'Punjabi Rajma Masala & Chawal', 'Slow-cooked Kashmiri red kidney beans in thick onion-tomato gravy with basmati rice.', 'lunch', 95, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Student Classic', 'High Protein'], true, 'provider', 'verified',
  NULL, NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'demo-part-3-m4', 'demo-part-3', 'Yellow Dal Tadka & Jeera Rice Bowl', 'Arhar dal tempered with cumin, garlic, dry red chilli, and cow ghee with fragrant cumin rice.', 'lunch', 85, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Comforting', 'Homestyle'], true, 'provider', 'verified',
  NULL, NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'demo-part-3-m5', 'demo-part-3', 'Aloo Paratha with Curd & Makkhan (2 pcs)', 'Whole wheat stuffed spiced potato flatbread roasted golden, served with fresh curd and pickle.', 'breakfast', 80, 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Breakfast Hit', 'Filling'], true, 'provider', 'verified',
  NULL, NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'demo-part-3-m6', 'demo-part-3', 'Moong Dal Khichdi with Pure Ghee', 'Light, soothing yellow moong dal and rice cooked soft with a touch of turmeric and asafoetida.', 'dinner', 80, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Digestible', 'Light Supper'], true, 'provider', 'verified',
  NULL, NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'demo-part-3-m7', 'demo-part-3', 'Kadhi Pakora with Steamed Rice', 'Besan dumplings simmered in tangy spiced yogurt gravy, served with portion of steamed rice.', 'lunch', 90, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Tangy Yogurt', 'Homestyle'], true, 'provider', 'verified',
  NULL, NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'demo-part-3-m8', 'demo-part-3', 'Tawa Phulkas (Pack of 5)', 'Soft, puffed 100% whole wheat rotis brushed lightly with cow ghee.', 'dinner', 40, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['100% Atta', 'Ghee Brushed'], true, 'provider', 'verified',
  NULL, NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'demo-part-4-m1', 'demo-part-4', '35g Protein Grilled Chicken Breast Box', '180g Lean herb-marinated chicken breast served with steamed broccoli, carrots, and portion of brown rice.', 'high-protein', 210, 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?auto=format&fit=crop&w=600&q=80',
  false, ARRAY['38g Protein', 'Lean Meat', 'Gym Diet'], true, 'provider', 'verified',
  NULL, NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'demo-part-4-m2', 'demo-part-4', 'High-Protein Paneer & Soya Bhurji', 'Crumbled low-fat paneer and minced soya granules sautéed with bell peppers and 3 multigrain rotis.', 'high-protein', 160, 'https://images.unsplash.com/photo-1631452180519-c014fe946bc7?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['30g Protein', 'Vegetarian Muscle', 'Multigrain'], true, 'provider', 'verified',
  NULL, NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'demo-part-4-m3', 'demo-part-4', '6-Egg Whites Plate with Black Pepper', '6 Farm fresh steamed egg whites tossed in olive oil, crushed black pepper, pink salt, and side salad.', 'high-protein', 80, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  false, ARRAY['24g Protein', 'Zero Fat', 'Keto'], true, 'provider', 'verified',
  NULL, NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'demo-part-4-m4', 'demo-part-4', 'Sprouted Moong & Roasted Paneer Salad', 'Sprouted moong beans, diced grilled paneer, cucumber, tomatoes, and lime-mint vinaigrette.', 'lunch', 125, 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['20g Protein', 'High Fiber', 'Raw Enzymes'], true, 'provider', 'verified',
  NULL, NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'demo-part-4-m5', 'demo-part-4', 'Grilled Tofu & Quinoa Teriyaki Bowl', 'Organic firm tofu pan-grilled with light low-sodium teriyaki glaze on fluffy quinoa base.', 'dinner', 185, 'https://images.unsplash.com/photo-1540420773420-3366772f4999?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Vegan Protein', 'Gluten Free', 'Superfood'], true, 'provider', 'verified',
  NULL, NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'demo-part-4-m6', 'demo-part-4', 'Protein Whey & Peanut Butter Shake', '1 Scoop isolate whey, unsweetened peanut butter, banana, and skimmed milk (30g protein).', 'drinks', 120, 'https://images.unsplash.com/photo-1550547660-d9450f859349?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Post Workout', 'No Added Sugar'], true, 'provider', 'verified',
  NULL, NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'demo-part-4-m7', 'demo-part-4', 'Keto Chicken Tikka Salad', 'Tandoori seasoned chicken breast skewers over crisp lettuce, cucumber ribbons, and olive oil.', 'dinner', 175, 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?auto=format&fit=crop&w=600&q=80',
  false, ARRAY['Keto Friendly', 'Low Carb'], true, 'provider', 'verified',
  NULL, NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'demo-part-4-m8', 'demo-part-4', 'High Fiber Soya Chunk Curry & Rice', 'Nutritious textured soya chunks simmered in aromatic onion tomato curry with brown basmati rice.', 'lunch', 110, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['High Fiber', 'Plant Protein'], true, 'provider', 'verified',
  NULL, NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'demo-part-4-m9', 'demo-part-4', 'Boiled Chickpea & Peanut Chaat', 'Warm boiled kabuli chana and peanuts tossed with chopped onions, green chillies, and lemon juice.', 'snacks', 60, 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Pre Workout Snack', 'Clean Carbs'], true, 'provider', 'verified',
  NULL, NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'demo-part-5-m1', 'demo-part-5', 'Foxtail Millet (Korra) Khichdi', 'Slow-cooked foxtail millet and moong dal infused with mild ginger, cumin, and vegetables. Served with curd.', 'lunch', 99, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Diabetic Friendly', 'Low GI', 'Gluten Free'], true, 'provider', 'verified',
  NULL, NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'demo-part-5-m2', 'demo-part-5', 'Ragi Sankati with Spiced Sambar', 'Finger millet ragi balls cooked traditionally, served with steaming hot vegetable drumstick sambar.', 'lunch', 85, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Calcium Rich', 'Traditional Telugu', 'Iron'], true, 'provider', 'verified',
  NULL, NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'demo-part-5-m3', 'demo-part-5', 'Multi-Millet Crispy Dosa', 'Nutrient-packed fermented batter made with little millet, kodo millet, and lentils. Zero white rice.', 'breakfast', 75, 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Zero Rice', 'Crispy', 'Healthy Heart'], true, 'provider', 'verified',
  NULL, NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'demo-part-5-m4', 'demo-part-5', 'Barnyard Millet Sambar Rice', 'Sanwa millet simmered in tangy lentil stew with shallots, carrot, and cow ghee tempering.', 'dinner', 89, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Light on Stomach', 'Pure Ghee'], true, 'provider', 'verified',
  NULL, NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'demo-part-5-m5', 'demo-part-5', 'Little Millet (Samalu) Upma', 'Wholesome breakfast upma cooked with samalu grains, mustard, ginger, cashew bits, and curry leaves.', 'breakfast', 65, 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Breakfast', 'Fiber Rich'], true, 'provider', 'verified',
  NULL, NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'demo-part-5-m6', 'demo-part-5', 'Pearl Millet (Bajra) Roti (2 pcs)', 'Warm hand-patted bajra rotis served with brinjal curry and garlic flaxseed chutney podi.', 'dinner', 80, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Winter Warmth', 'High Fiber'], true, 'provider', 'verified',
  NULL, NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'demo-part-5-m7', 'demo-part-5', 'Millet Vegetable Pulao Bowl', 'Aromatic foxtail millet cooked with whole spices, green peas, carrots, and mint leaves.', 'lunch', 110, 'https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Low Carb', 'Flavorful'], true, 'provider', 'verified',
  NULL, NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'demo-part-5-m8', 'demo-part-5', 'Ragi Ambali (Summer Cooler)', 'Hydrating fermented finger millet malt seasoned with buttermilk, chopped onions, and cumin.', 'drinks', 30, 'https://images.unsplash.com/photo-1550547660-d9450f859349?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Hydrating', 'Cooling Drink'], true, 'provider', 'verified',
  NULL, NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'demo-part-5-m9', 'demo-part-5', 'Jowar Flakes Poha', 'Sorghum flakes sautéed with mustard, peanuts, green chillies, and fresh lemon squeeze.', 'breakfast', 60, 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Gluten Free', 'Quick Bite'], true, 'provider', 'verified',
  NULL, NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'demo-part-6-m1', 'demo-part-6', 'Authentic Andhra Bhojanam (Full Meal)', 'Steamed Sona Masoori rice, Mudda Pappu, Neyyi (ghee), Avakaya pickle, Veg Iguru, Sambar, Charu, Majjiga, and Appalam.', 'lunch', 110, 'https://images.unsplash.com/photo-1610057099431-d73a1c9d2f2f?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Unlimited Style', 'Traditional Telugu', 'Pure Ghee'], true, 'provider', 'verified',
  NULL, NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'demo-part-6-m2', 'demo-part-6', 'Mudda Pappu & Avakaya Annam Bowl', 'Comfort classic: hot steamed rice mixed with thick yellow dal, mango avakaya pickle, and dollop of country cow ghee.', 'lunch', 85, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Comfort Food', 'Mom Made'], true, 'provider', 'verified',
  NULL, NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'demo-part-6-m3', 'demo-part-6', 'Gutthi Vankaya Curry with 3 Phulkas', 'Tender stuffed brinjals simmered in rich peanut, sesame, and dry coconut gravy.', 'dinner', 115, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Rayalaseema Specialty', 'Peanut Gravy'], true, 'provider', 'verified',
  NULL, NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'demo-part-6-m4', 'demo-part-6', 'Andhra Natukodi Chicken Curry', 'Country chicken cooked on slow flame with crushed black pepper, dry red chillies, and ginger garlic paste.', 'lunch', 180, 'https://images.unsplash.com/photo-1626777552726-4a6b54c97e46?auto=format&fit=crop&w=600&q=80',
  false, ARRAY['Country Chicken', 'Spicy Gravy'], true, 'provider', 'verified',
  NULL, NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'demo-part-6-m5', 'demo-part-6', 'Bagara Rice with Chicken Gravy Box', 'Aromatic basmati rice cooked with whole spices, served with homestyle spicy chicken curry and onion raita.', 'lunch', 165, 'https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?auto=format&fit=crop&w=600&q=80',
  false, ARRAY['Telangana Favorite', 'Party Classic'], true, 'provider', 'verified',
  NULL, NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'demo-part-6-m6', 'demo-part-6', 'Tomato Pappu with Steamed Rice', 'Lentils cooked with ripe tomatoes, garlic, and red chili tadka. Served with fried papad.', 'dinner', 75, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Student Friendly', 'Tangy & Warm'], true, 'provider', 'verified',
  NULL, NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'demo-part-6-m7', 'demo-part-6', 'Royyala Vepudu (Andhra Prawn Fry)', 'Fresh prawns tossed in a wok with caramelized onions, curry leaves, and freshly ground coriander spice.', 'dinner', 220, 'https://images.unsplash.com/photo-1565557623262-b51c2513a641?auto=format&fit=crop&w=600&q=80',
  false, ARRAY['Coastal Andhra', 'Seafood'], true, 'provider', 'verified',
  NULL, NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'demo-part-6-m8', 'demo-part-6', 'Gongura Chicken Curry with Rice', 'Tender chicken cooked with tart roselle (gongura) leaves, giving the iconic Andhra tangy kick.', 'lunch', 175, 'https://images.unsplash.com/photo-1626777552726-4a6b54c97e46?auto=format&fit=crop&w=600&q=80',
  false, ARRAY['Gongura', 'Iconic Andhra'], true, 'provider', 'verified',
  NULL, NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'demo-part-6-m9', 'demo-part-6', 'Spiced Majjiga (Chilled Buttermilk)', 'Hand-churned refreshing buttermilk infused with crushed ginger, green chili, and fresh coriander.', 'drinks', 20, 'https://images.unsplash.com/photo-1550547660-d9450f859349?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Hydration', 'Digestive'], true, 'provider', 'verified',
  NULL, NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'demo-part-6-m10', 'demo-part-6', 'Bendakaya Vepudu (Crispy Okra Fry)', 'Thinly sliced ladyfinger roasted golden with peanuts, garlic, and curry leaves.', 'lunch', 65, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Crunchy', 'Low Calorie'], true, 'provider', 'verified',
  NULL, NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'demo-part-8-m1', 'demo-part-8', 'Ghee Thatte Idli (2 pcs)', 'Steamed fluffy idlis bathed in fragrant melted cow ghee, served with coconut chutney & piping hot sambar.', 'breakfast', 50, 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Pure Ghee', 'Steamed', 'Digestible'], true, 'provider', 'verified',
  NULL, NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'demo-part-8-m2', 'demo-part-8', 'Crispy Medu Vada (2 pcs)', 'Golden fried crispy lentil vadas with ginger and whole black pepper notes, served with spicy red chutney.', 'breakfast', 55, 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Crispy', 'Traditional', 'Protein Rich'], true, 'provider', 'verified',
  NULL, NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'demo-part-8-m3', 'demo-part-8', 'Special Ghee Masala Dosa', 'Crispy fermented rice-lentil crepe smeared with spicy red chilli-garlic chutney and filled with spiced mashed potato.', 'breakfast', 75, 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Signature', 'Golden Crisp', 'Zero Soda'], true, 'provider', 'verified',
  NULL, NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'demo-part-8-m4', 'demo-part-8', 'Andhra Upma Pesarattu', 'Whole green gram crepe cooked crisp, filled with aromatic rava upma and served with allam (ginger) pachadi.', 'breakfast', 80, 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['High Fiber', 'Green Moong', 'Authentic Andhra'], true, 'provider', 'verified',
  NULL, NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'demo-part-8-m5', 'demo-part-8', 'Onion Rava Dosa', 'Cracked semolina batter griddled thin and crispy with diced shallots, cumin, and fresh green chillies.', 'breakfast', 85, 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Extra Crispy', 'Fresh Herbs'], true, 'provider', 'verified',
  NULL, NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'demo-part-8-m6', 'demo-part-8', 'Poori with Potato Sagu (2 pcs)', 'Freshly puffed golden pooris served with mild Karnataka-style Bombay potato sagu.', 'breakfast', 65, 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Hot & Fresh', 'Breakfast Classic'], true, 'provider', 'verified',
  NULL, NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'demo-part-8-m7', 'demo-part-8', 'Mysore Bonda (4 pcs)', 'Golden fluffy fried dumplings served hot with ginger chutney and coconut dip.', 'snacks', 45, 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Evening Special', 'Crunchy Outside'], true, 'provider', 'verified',
  NULL, NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'demo-part-8-m8', 'demo-part-8', 'Homestyle Sambar Rice', 'Short-grain rice simmered with drumstick sambar, shallots, and ghee tempering. Served with appalam.', 'lunch', 70, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Comfort Meal', 'Pure Ghee'], true, 'provider', 'verified',
  NULL, NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'demo-part-8-m9', 'demo-part-8', 'Tadka Curd Rice with Pomegranate', 'Cooling creamy curd rice tempered with mustard seeds, ginger, curry leaves, and crunchy pomegranate pearls.', 'dinner', 60, 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Probiotic', 'Light & Cooling'], true, 'provider', 'verified',
  NULL, NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'demo-part-8-m10', 'demo-part-8', 'South Indian Filter Coffee', 'Fresh chicory-blended decoction frothed with thick boiling milk in brass tumbler.', 'snacks', 25, 'https://images.unsplash.com/photo-1514432324607-a09d9b4aefdd?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Aromatic', 'Brass Frothed'], true, 'provider', 'verified',
  NULL, NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'demo-part-9-m1', 'demo-part-9', 'Ammamma Bhojana Thali', 'Hot steamed rice, Mudda Pappu, sweet tomato charu, fresh cauliflower fry, homemade mango pickle, and appalam.', 'lunch', 90, 'https://images.unsplash.com/photo-1610057099431-d73a1c9d2f2f?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Grandma Recipe', 'Zero Preservatives', 'Pure Comfort'], true, 'provider', 'verified',
  NULL, NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'demo-part-9-m2', 'demo-part-9', 'Pappu Charu with Vadiyalu Bowl', 'Tangy slow-simmered lentil broth with drumstick and shallots, served with steaming rice and sun-dried rice crisps.', 'lunch', 75, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Homestyle Sambar', 'Sun Dried Crisps'], true, 'provider', 'verified',
  NULL, NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'demo-part-9-m3', 'demo-part-9', 'Aratikaya Vepudu (Raw Banana Roast)', 'Raw plantain cubes roasted crisp in cast iron skillet with crushed garlic and red chilli podi.', 'lunch', 60, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Iron Skillet Roasted', 'Crispy'], true, 'provider', 'verified',
  NULL, NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'demo-part-9-m4', 'demo-part-9', 'Ulavacharu Rice with Cow Ghee', 'Rich horsegram soup thickened and seasoned, poured over steaming hot rice with dollop of pure ghee.', 'lunch', 95, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Horsegram Soup', 'Warm Energy'], true, 'provider', 'verified',
  NULL, NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'demo-part-9-m5', 'demo-part-9', 'Kakarakaya Karam (Bittergourd Roast)', 'Finely sliced bittergourd roasted till sweet and crispy with roasted peanut garlic spice powder.', 'dinner', 65, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Diabetic Friendly', 'Crispy Not Bitter'], true, 'provider', 'verified',
  NULL, NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'demo-part-9-m6', 'demo-part-9', 'Pala Thalikalu (Jaggery Dessert)', 'Hand-rolled rice noodles cooked in sweet jaggery cardamom milk.', 'snacks', 45, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Village Recipe', 'Iron Sweet'], true, 'provider', 'verified',
  NULL, NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'demo-part-9-m7', 'demo-part-9', 'Ghee Sambar Rice with Curd Rice Combo', 'Half portion drumstick sambar rice + half portion tempered cooling curd rice.', 'lunch', 80, 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Combo Classic', 'Satisfying'], true, 'provider', 'verified',
  NULL, NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'demo-part-9-m8', 'demo-part-9', 'Allam Pachadi with Rice Crackers', 'Sweet-spicy-tangy Andhra ginger chutney paired with crunchy rice papadums.', 'snacks', 35, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Digestive', 'Traditional Dip'], true, 'provider', 'verified',
  NULL, NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'demo-part-10-m1', 'demo-part-10', 'Amma Special Veg Thali Box', '4 Whole wheat rotis, homestyle yellow dal, aloo beans fry, steamed rice, sambar, and home pickle.', 'lunch', 95, 'https://images.unsplash.com/photo-1610057099431-d73a1c9d2f2f?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Zero Soda', 'Mom''s Cooking', 'Balanced Meal'], true, 'provider', 'verified',
  NULL, NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'demo-part-10-m2', 'demo-part-10', 'Pachi Pulusu with Hot Rice & Ghee', 'Raw tamarind extract simmered with charred onions, jaggery, and crushed green chillies. Supreme comfort.', 'lunch', 70, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Telangana Heritage', 'Raw Rasam'], true, 'provider', 'verified',
  NULL, NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'demo-part-10-m3', 'demo-part-10', 'Homestyle Egg Curry with Rice', '2 Boiled eggs simmered in onion-tomato homestyle gravy, served with portion of steamed rice.', 'dinner', 90, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  false, ARRAY['High Protein', 'Affordable'], true, 'provider', 'verified',
  NULL, NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'demo-part-10-m4', 'demo-part-10', 'Palak Pappu with Phulkas (3 pcs)', 'Fresh garden spinach cooked with toor dal and mild cumin garlic seasoning, served with soft puffed phulkas.', 'dinner', 80, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Iron Rich', 'Low Calorie'], true, 'provider', 'verified',
  NULL, NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'demo-part-10-m5', 'demo-part-10', 'Kandi Podi Ghee Rice Meal', 'Steamed rice served with homemade roasted lentil gun powder, clarified cow ghee, and crunchy appalam.', 'lunch', 65, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Dry Lentil Podi', 'Quick Lunch'], true, 'provider', 'verified',
  NULL, NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'demo-part-10-m6', 'demo-part-10', 'Dondakaya Fry (Tindora Peanut)', 'Ivy gourd roundels stir-fried slowly with crunchy roasted peanuts and mild red chilli.', 'dinner', 60, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Homestyle Sabzi', 'Crisp'], true, 'provider', 'verified',
  NULL, NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'demo-part-10-m7', 'demo-part-10', 'Menthi Kura Pappu (Fenugreek Dal)', 'Warm yellow lentils infused with slightly bitter fresh methi leaves and garlic tempering.', 'lunch', 60, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Herbal', 'Digestive'], true, 'provider', 'verified',
  NULL, NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'demo-part-10-m8', 'demo-part-10', 'Kobbari Annam (Coconut Rice)', 'Short grain rice flavored with fresh grated coconut, cashews, mustard seeds, and whole green chillies.', 'lunch', 80, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Festive Flavor', 'Aromatic'], true, 'provider', 'verified',
  NULL, NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'demo-part-10-m9', 'demo-part-10', 'Telangana Sarva Pindi (Snack)', 'Traditional savoury pancake made with rice flour, chana dal, sesame seeds, and spring onion.', 'snacks', 40, 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Telangana Specialty', 'Crisp Crust'], true, 'provider', 'verified',
  NULL, NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'demo-part-11-m1', 'demo-part-11', 'Amma Special Veg Thali Box', '4 Whole wheat rotis, homestyle yellow dal, aloo beans fry, steamed rice, sambar, and home pickle.', 'lunch', 95, 'https://images.unsplash.com/photo-1610057099431-d73a1c9d2f2f?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Zero Soda', 'Mom''s Cooking', 'Balanced Meal'], true, 'provider', 'verified',
  NULL, NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'demo-part-11-m2', 'demo-part-11', 'Pachi Pulusu with Hot Rice & Ghee', 'Raw tamarind extract simmered with charred onions, jaggery, and crushed green chillies. Supreme comfort.', 'lunch', 70, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Telangana Heritage', 'Raw Rasam'], true, 'provider', 'verified',
  NULL, NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'demo-part-11-m3', 'demo-part-11', 'Homestyle Egg Curry with Rice', '2 Boiled eggs simmered in onion-tomato homestyle gravy, served with portion of steamed rice.', 'dinner', 90, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  false, ARRAY['High Protein', 'Affordable'], true, 'provider', 'verified',
  NULL, NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'demo-part-11-m4', 'demo-part-11', 'Palak Pappu with Phulkas (3 pcs)', 'Fresh garden spinach cooked with toor dal and mild cumin garlic seasoning, served with soft puffed phulkas.', 'dinner', 80, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Iron Rich', 'Low Calorie'], true, 'provider', 'verified',
  NULL, NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'demo-part-11-m5', 'demo-part-11', 'Kandi Podi Ghee Rice Meal', 'Steamed rice served with homemade roasted lentil gun powder, clarified cow ghee, and crunchy appalam.', 'lunch', 65, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Dry Lentil Podi', 'Quick Lunch'], true, 'provider', 'verified',
  NULL, NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'demo-part-11-m6', 'demo-part-11', 'Dondakaya Fry (Tindora Peanut)', 'Ivy gourd roundels stir-fried slowly with crunchy roasted peanuts and mild red chilli.', 'dinner', 60, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Homestyle Sabzi', 'Crisp'], true, 'provider', 'verified',
  NULL, NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'demo-part-11-m7', 'demo-part-11', 'Menthi Kura Pappu (Fenugreek Dal)', 'Warm yellow lentils infused with slightly bitter fresh methi leaves and garlic tempering.', 'lunch', 60, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Herbal', 'Digestive'], true, 'provider', 'verified',
  NULL, NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'demo-part-11-m8', 'demo-part-11', 'Kobbari Annam (Coconut Rice)', 'Short grain rice flavored with fresh grated coconut, cashews, mustard seeds, and whole green chillies.', 'lunch', 80, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Festive Flavor', 'Aromatic'], true, 'provider', 'verified',
  NULL, NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'demo-part-11-m9', 'demo-part-11', 'Telangana Sarva Pindi (Snack)', 'Traditional savoury pancake made with rice flour, chana dal, sesame seeds, and spring onion.', 'snacks', 40, 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Telangana Specialty', 'Crisp Crust'], true, 'provider', 'verified',
  NULL, NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'demo-part-12-m1', 'demo-part-12', 'Ghar Ka Khana Roti Thali (4 Phulkas)', '4 Whole wheat hot tawa phulkas, tadka dal, dry seasonal sabzi, salad, and pickle.', 'dinner', 85, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Whole Wheat', 'Zero Oil Roti', 'Comfort Meal'], true, 'provider', 'verified',
  NULL, NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'demo-part-12-m2', 'demo-part-12', 'Paneer Butter Masala Meal Box', 'Soft cottage cheese cubes in mildly spiced butter gravy, served with 3 rotis and jeera rice.', 'dinner', 140, 'https://images.unsplash.com/photo-1631452180519-c014fe946bc7?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['North Indian Favorite', 'Rich Gravy'], true, 'provider', 'verified',
  NULL, NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'demo-part-12-m3', 'demo-part-12', 'Punjabi Rajma Masala & Chawal', 'Slow-cooked Kashmiri red kidney beans in thick onion-tomato gravy with basmati rice.', 'lunch', 95, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Student Classic', 'High Protein'], true, 'provider', 'verified',
  NULL, NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'demo-part-12-m4', 'demo-part-12', 'Yellow Dal Tadka & Jeera Rice Bowl', 'Arhar dal tempered with cumin, garlic, dry red chilli, and cow ghee with fragrant cumin rice.', 'lunch', 85, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Comforting', 'Homestyle'], true, 'provider', 'verified',
  NULL, NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'demo-part-12-m5', 'demo-part-12', 'Aloo Paratha with Curd & Makkhan (2 pcs)', 'Whole wheat stuffed spiced potato flatbread roasted golden, served with fresh curd and pickle.', 'breakfast', 80, 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Breakfast Hit', 'Filling'], true, 'provider', 'verified',
  NULL, NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'demo-part-12-m6', 'demo-part-12', 'Moong Dal Khichdi with Pure Ghee', 'Light, soothing yellow moong dal and rice cooked soft with a touch of turmeric and asafoetida.', 'dinner', 80, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Digestible', 'Light Supper'], true, 'provider', 'verified',
  NULL, NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'demo-part-12-m7', 'demo-part-12', 'Kadhi Pakora with Steamed Rice', 'Besan dumplings simmered in tangy spiced yogurt gravy, served with portion of steamed rice.', 'lunch', 90, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Tangy Yogurt', 'Homestyle'], true, 'provider', 'verified',
  NULL, NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'demo-part-12-m8', 'demo-part-12', 'Tawa Phulkas (Pack of 5)', 'Soft, puffed 100% whole wheat rotis brushed lightly with cow ghee.', 'dinner', 40, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['100% Atta', 'Ghee Brushed'], true, 'provider', 'verified',
  NULL, NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'demo-part-13-m1', 'demo-part-13', 'Mediterranean Falafel & Hummus Bowl', 'Baked herb falafels, velvety garlic chickpea hummus, pickled beets, cucumber, and multigrain pita chips.', 'lunch', 165, 'https://images.unsplash.com/photo-1540420773420-3366772f4999?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Heart Healthy', 'Olive Oil', 'Vegan'], true, 'provider', 'verified',
  NULL, NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'demo-part-13-m2', 'demo-part-13', 'Grilled Paneer & Quinoa Harvest Bowl', 'Low-fat grilled paneer cubes, roasted bell peppers, steamed corn, and tri-color quinoa in basil vinaigrette.', 'dinner', 175, 'https://images.unsplash.com/photo-1540420773420-3366772f4999?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['22g Protein', 'Supergrain'], true, 'provider', 'verified',
  NULL, NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'demo-part-13-m3', 'demo-part-13', 'Tex-Mex Bean & Brown Rice Burrito Bowl', 'Black beans, sweet corn, salsa fresca, guacamole, and cilantro lime brown rice.', 'lunch', 155, 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['High Fiber', 'Immunity Boost'], true, 'provider', 'verified',
  NULL, NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'demo-part-13-m4', 'demo-part-13', 'Smoked Chicken Salad Bowl', 'Smoked shredded chicken breast, crunchy romaine lettuce, cherry tomatoes, and honey mustard dressing.', 'lunch', 185, 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?auto=format&fit=crop&w=600&q=80',
  false, ARRAY['31g Protein', 'Keto Friendly'], true, 'provider', 'verified',
  NULL, NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'demo-part-13-m5', 'demo-part-13', 'Avocado & Chickpea Protein Salad', 'Ripe avocado chunks, boiled chickpeas, diced cucumbers, and lemon tahini dressing.', 'dinner', 160, 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Good Fats', 'Antioxidants'], true, 'provider', 'verified',
  NULL, NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'demo-part-13-m6', 'demo-part-13', 'Super Green Detox Soup (Bowl)', 'Broccoli, baby spinach, and zucchini puréed with almond milk and roasted pumpkin seeds.', 'dinner', 95, 'https://images.unsplash.com/photo-1540420773420-3366772f4999?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Cleansing', 'Immunity Booster'], true, 'provider', 'verified',
  NULL, NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'demo-part-13-m7', 'demo-part-13', 'Nutty Chia Seed Pudding Bowl', 'Overnight chia seeds steeped in almond milk, topped with kiwi, berries, and roasted almond slivers.', 'breakfast', 120, 'https://images.unsplash.com/photo-1550547660-d9450f859349?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Omega 3', 'No White Sugar'], true, 'provider', 'verified',
  NULL, NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'demo-part-13-m8', 'demo-part-13', 'Cold Pressed Orange Carrot Juice', '100% Raw unpasteurized juice with zero added water and zero sugar.', 'drinks', 75, 'https://images.unsplash.com/photo-1550547660-d9450f859349?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Vitamin C', 'Pure Juice'], true, 'provider', 'verified',
  NULL, NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'demo-part-14-m1', 'demo-part-14', 'Special Hyderabadi Chicken Dum Biryani', 'Long grain aromatic basmati rice cooked on dum with marinated chicken, saffron, mint, and whole spices. Served with Mirchi ka Salan & Raita.', 'lunch', 170, 'https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?auto=format&fit=crop&w=600&q=80',
  false, ARRAY['Dum Cooked', 'Hyderabadi Classic'], true, 'provider', 'verified',
  NULL, NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'demo-part-14-m2', 'demo-part-14', 'Hyderabadi Veg Dum Biryani', 'Garden vegetables, fried onions, and paneer cubes layered with spiced basmati rice and saffron milk.', 'lunch', 130, 'https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Dum Veg', 'Aromatic'], true, 'provider', 'verified',
  NULL, NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'demo-part-14-m3', 'demo-part-14', 'Executive North Indian Thali', '3 Tawa Parathas, Shahi Paneer, Dal Makhani, Veg Pulao, Gulab Jamun, Salad & Raita.', 'lunch', 160, 'https://images.unsplash.com/photo-1610057099431-d73a1c9d2f2f?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Executive Thali', 'Rich & Filling'], true, 'provider', 'verified',
  NULL, NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'demo-part-14-m4', 'demo-part-14', 'Chicken Tikka Kebab Plate (6 pcs)', 'Boneless chicken chunks marinated in spiced yogurt and grilled juicy in tandoor.', 'snacks', 180, 'https://images.unsplash.com/photo-1565557623262-b51c2513a641?auto=format&fit=crop&w=600&q=80',
  false, ARRAY['Tandoori', 'Smoky'], true, 'provider', 'verified',
  NULL, NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'demo-part-14-m5', 'demo-part-14', 'Dal Makhani with 2 Butter Naans', 'Slow simmered black lentils in butter and cream, served with 2 fluffy butter naans.', 'dinner', 145, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Creamy Dal', 'Dinner Special'], true, 'provider', 'verified',
  NULL, NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'demo-part-14-m6', 'demo-part-14', 'Egg Dum Biryani Box', '2 Spiced golden boiled eggs layered with biryani rice, served with raita and salan.', 'lunch', 120, 'https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?auto=format&fit=crop&w=600&q=80',
  false, ARRAY['Egg Biryani', 'Student Value'], true, 'provider', 'verified',
  NULL, NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'demo-part-14-m7', 'demo-part-14', 'Paneer Tikka Roll', 'Grilled cottage cheese cubes, sliced onions, and mint chutney wrapped in whole wheat paratha.', 'snacks', 90, 'https://images.unsplash.com/photo-1631452180519-c014fe946bc7?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Grab & Go', 'Fresh Kati Roll'], true, 'provider', 'verified',
  NULL, NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'demo-part-14-m8', 'demo-part-14', 'Gulab Jamun (2 pcs)', 'Warm milk-solid dumplings soaked in rose and cardamom sugar syrup.', 'snacks', 40, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Dessert', 'Sweet Tooth'], true, 'provider', 'verified',
  NULL, NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'demo-part-15-m1', 'demo-part-15', 'Foxtail Millet (Korra) Khichdi', 'Slow-cooked foxtail millet and moong dal infused with mild ginger, cumin, and vegetables. Served with curd.', 'lunch', 99, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Diabetic Friendly', 'Low GI', 'Gluten Free'], true, 'provider', 'verified',
  NULL, NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'demo-part-15-m2', 'demo-part-15', 'Ragi Sankati with Spiced Sambar', 'Finger millet ragi balls cooked traditionally, served with steaming hot vegetable drumstick sambar.', 'lunch', 85, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Calcium Rich', 'Traditional Telugu', 'Iron'], true, 'provider', 'verified',
  NULL, NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'demo-part-15-m3', 'demo-part-15', 'Multi-Millet Crispy Dosa', 'Nutrient-packed fermented batter made with little millet, kodo millet, and lentils. Zero white rice.', 'breakfast', 75, 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Zero Rice', 'Crispy', 'Healthy Heart'], true, 'provider', 'verified',
  NULL, NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'demo-part-15-m4', 'demo-part-15', 'Barnyard Millet Sambar Rice', 'Sanwa millet simmered in tangy lentil stew with shallots, carrot, and cow ghee tempering.', 'dinner', 89, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Light on Stomach', 'Pure Ghee'], true, 'provider', 'verified',
  NULL, NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'demo-part-15-m5', 'demo-part-15', 'Little Millet (Samalu) Upma', 'Wholesome breakfast upma cooked with samalu grains, mustard, ginger, cashew bits, and curry leaves.', 'breakfast', 65, 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Breakfast', 'Fiber Rich'], true, 'provider', 'verified',
  NULL, NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'demo-part-15-m6', 'demo-part-15', 'Pearl Millet (Bajra) Roti (2 pcs)', 'Warm hand-patted bajra rotis served with brinjal curry and garlic flaxseed chutney podi.', 'dinner', 80, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Winter Warmth', 'High Fiber'], true, 'provider', 'verified',
  NULL, NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'demo-part-15-m7', 'demo-part-15', 'Millet Vegetable Pulao Bowl', 'Aromatic foxtail millet cooked with whole spices, green peas, carrots, and mint leaves.', 'lunch', 110, 'https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Low Carb', 'Flavorful'], true, 'provider', 'verified',
  NULL, NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'demo-part-15-m8', 'demo-part-15', 'Ragi Ambali (Summer Cooler)', 'Hydrating fermented finger millet malt seasoned with buttermilk, chopped onions, and cumin.', 'drinks', 30, 'https://images.unsplash.com/photo-1550547660-d9450f859349?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Hydrating', 'Cooling Drink'], true, 'provider', 'verified',
  NULL, NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

INSERT INTO public.menu_items (
  id, restaurant_id, name, description, category, price, image_url,
  is_vegetarian, dietary_tags, is_available, menu_source, menu_status,
  source_url, last_updated_at, is_demo
) VALUES (
  'demo-part-15-m9', 'demo-part-15', 'Jowar Flakes Poha', 'Sorghum flakes sautéed with mustard, peanuts, green chillies, and fresh lemon squeeze.', 'breakfast', 60, 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=600&q=80',
  true, ARRAY['Gluten Free', 'Quick Bite'], true, 'provider', 'verified',
  NULL, NOW(), false
)
ON CONFLICT (id) DO UPDATE SET
  restaurant_id = EXCLUDED.restaurant_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  image_url = EXCLUDED.image_url,
  is_vegetarian = EXCLUDED.is_vegetarian,
  dietary_tags = EXCLUDED.dietary_tags,
  is_available = EXCLUDED.is_available,
  menu_source = EXCLUDED.menu_source,
  menu_status = EXCLUDED.menu_status,
  source_url = EXCLUDED.source_url,
  last_updated_at = NOW(),
  is_demo = EXCLUDED.is_demo;

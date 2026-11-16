# HomeBite 🍲 | Homemade Goodness, Delivered Daily

> A modern, responsive, full-stack food-tech web application connecting college students and young professionals with verified neighborhood home chefs and campus delivery partners for fresh, hygienic, affordable daily meals and dabba subscriptions.

---

## 🌟 The Problem & Solution

* **The Problem**: College students and young professionals face expensive food delivery apps (₹250–₹400/meal), unhealthy/oily restaurant food, repetitive canteen/hostel mess menus, and a lack of kitchen facilities or cooking time.
* **The Solution**: **HomeBite** is a hyperlocal homemade food marketplace connecting:
  1. **Students & Young Professionals**: Access to wholesome, low-oil, nutritious daily thalis starting at just ₹79.
  2. **Home Chefs & Local Food Providers**: Passionate home cooks (e.g. Anita Aunty, Sunita Devi) who prepare fresh homestyle meals in FSSAI-audited kitchens.
  3. **Delivery Partners**: Campus motorcycle/scooter riders who deliver hot dabbas straight to hostel gates and earn ₹45/trip + tips.

---

## 🔐 Authentication & Role-Based Access Control (RBAC)

HomeBite features a dedicated, modern authentication and role-based access control system powered by **Supabase Authentication** with PostgreSQL Row Level Security (RLS) and persistent local fallback:

### 1. Dedicated Login & Register Flow
* **Food-Themed UI**: Warm cream (`#FFF9EF`), green (`#238B57`), and orange (`#F59E42`) branding with rounded cards and soft elevations.
* **Input Validation**: Show/hide password eye toggle, email formatting, and clear error banners.
* **Password Recovery**: Secure password reset flow with email link dispatch.
* **1-Click Hackathon Quick-Login Pills**: Instant demo credentials to test each role without typing:
  * 🎓 **Student / Customer**: `aarav@dtu.ac.in` / `student123`
  * 👩‍🍳 **Home Chef / Cook**: `anita@homebite.in` / `chef123`
  * 🛵 **Delivery Partner**: `ramesh@homebite.in` / `rider123`
  * 🛡️ **Platform Administrator**: `admin@homebite.in` / `admin123`

### 2. Multi-Role Registration
During registration, users choose their account type from interactive cards:
* **🎓 Student / Customer**: Specify college campus and hostel room for seamless gate delivery.
* **👩‍🍳 Home Chef**: Enter kitchen name, specialty, and FSSAI number.
* **🛵 Delivery Partner**: Enter motorcycle/scooter model and license plate number.
* **🛡️ Security Rule (Strictly Enforced)**: *Administrator accounts cannot be self-registered from the public form; they are managed exclusively by platform operations.*

### 3. Automatic Role-Based Redirection
After logging in, HomeBite identifies the user's registered role and automatically navigates them to their authorized dashboard:
* `customer` $\rightarrow$ **Customer Dashboard** (Meal discovery, nutrition inspector, cart & dabba subscriptions)
* `chef` $\rightarrow$ **Home Chef Dashboard** (Menu editor, dish availability, live incoming kitchen queue)
* `delivery` $\rightarrow$ **Delivery Partner Dashboard** (Trip acceptance, pickup/dropoff navigation, handover & earnings)
* `admin` $\rightarrow$ **Admin Command Center** (Chef verification approvals, platform GMV telemetry, orders monitor)

---

## 🛵 Delivery Partner Dashboard

HomeBite includes a dedicated workspace for campus delivery riders:
* **Online / Offline Toggle**: Switch availability with live status indicator.
* **Available Delivery Board**: View orders ready for pickup with pickup kitchen, dropoff hostel, and trip payout (₹45–₹55).
* **Active Trip Workflow**:
  1. *Step 1: Confirm Pickup from Kitchen* (updates status to `out_for_delivery`).
  2. *Step 2: Arrived at Campus Gate* (dispatches notification to student).
  3. *Step 3: Handover & Mark Delivered* (disburses payout, completes order, and updates customer live tracker).
* **Rider Earnings Log**: Track daily trips, weekly earnings (₹14,250), and average rating (4.92 ★).

---

## 🗄️ Database Schema & Row Level Security (RLS)

The database schema in [`supabase/schema.sql`](file:///c:/Users/vikra/OneDrive/Desktop/homebite/supabase/schema.sql) enforces:
* `user_role` enum: `'customer' | 'chef' | 'delivery' | 'admin'`
* **Role Protection Trigger** (`protect_user_role`): Prevents users from escalating their own role via API or client updates.
* **Order Visibility Policies**:
  * Customers only view their own orders.
  * Chefs only view orders destined for their home kitchen.
  * Delivery partners only view orders assigned to them or waiting for pickup.
  * Admins maintain full platform visibility.

---

## 🚀 Running the Full Stack Locally

```bash
# 1. Install dependencies
npm install

# 2. Start Full Stack (Backend API on :5000 + Frontend on :5173 concurrently)
npm run dev
```

* **Frontend App**: [http://localhost:5173/](http://localhost:5173/)
* **Backend API**: [http://localhost:5000/api/health](http://localhost:5000/api/health)

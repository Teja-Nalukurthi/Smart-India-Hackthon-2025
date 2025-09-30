# Database Issues Debugging Guide

## Issue Summary
Users are being created in Supabase Auth but profiles are not being saved to the `user_profiles` table.

## ✅ ISSUE IDENTIFIED: ROW LEVEL SECURITY (RLS) POLICY VIOLATION

**Root Cause**: The insert is failing due to Row Level Security policy that requires `auth.uid() = id` for profile creation.

**Error**: `new row violates row-level security policy for table "user_profiles" (code: 42501)`

## 🔧 SOLUTION OPTIONS

### Option 1: Update RLS Policy (Recommended)
Run this SQL in your Supabase SQL Editor:

```sql
-- Update the existing insert policy to be more permissive
DROP POLICY IF EXISTS "Users can insert own profile" ON user_profiles;

CREATE POLICY "Users can insert own profile" ON user_profiles
  FOR INSERT WITH CHECK (
    auth.uid() = id OR 
    auth.role() = 'authenticated'
  );
```

### Option 2: Temporarily Disable RLS (Quick Fix)
```sql
-- Disable RLS temporarily (NOT recommended for production)
ALTER TABLE user_profiles DISABLE ROW LEVEL SECURITY;
```

### Option 3: Use Service Role Key
Update your Supabase client to use the service role key instead of anon key for profile creation operations.

## 🛠 Complete Database Setup

If you haven't run the complete database schema yet, run this in your Supabase SQL Editor:

### Step 1: Create the user_role enum type
```sql
CREATE TYPE public.user_role AS ENUM ('customer', 'artisan', 'admin');
```

### Step 2: Create user_profiles table
```sql
CREATE TABLE public.user_profiles (
  id uuid not null,
  email text not null,
  full_name text not null,
  avatar_url text null,
  phone_number text null,
  location text null,
  bio text null,
  role public.user_role null default 'customer'::user_role,
  is_verified boolean null default false,
  location_point geometry null,
  created_at timestamp with time zone null default now(),
  updated_at timestamp with time zone null default now(),
  constraint user_profiles_pkey primary key (id),
  constraint user_profiles_email_key unique (email),
  constraint user_profiles_id_fkey foreign KEY (id) references auth.users (id) on delete CASCADE
);
```

### Step 3: Enable RLS with proper policies
```sql
-- Enable RLS
ALTER TABLE user_profiles ENABLE ROW LEVEL SECURITY;

-- Create permissive policies
CREATE POLICY "Users can view all profiles" ON user_profiles
  FOR SELECT USING (TRUE);

CREATE POLICY "Users can insert own profile" ON user_profiles
  FOR INSERT WITH CHECK (
    auth.uid() = id OR 
    auth.role() = 'authenticated'
  );

CREATE POLICY "Users can update own profile" ON user_profiles
  FOR UPDATE USING (auth.uid() = id);
```

### Step 4: Create update trigger
```sql
-- Function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ language 'plpgsql';

-- Apply trigger
CREATE TRIGGER update_user_profiles_updated_at 
  BEFORE UPDATE ON user_profiles 
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
```

## 📋 Current Status

- ✅ Profile data is being correctly formatted
- ✅ Database connection is working
- ✅ UserProfile model matches database schema
- ❌ **RLS Policy is blocking the insert operation**

## 🧪 Next Steps

1. **Run Option 1 SQL above** in your Supabase SQL Editor
2. **Test signup again** - should work immediately
3. **Check Supabase dashboard** - profile should appear in user_profiles table

The profile creation will work once the RLS policy is updated!

## Potential Issues to Check

1. **RLS (Row Level Security)**
   - Check if Row Level Security is enabled on `user_profiles` table
   - Make sure there are policies allowing INSERT for authenticated users

2. **Column Names**
   - Verify column names match exactly (snake_case vs camelCase)

3. **Data Types**
   - Check if `role` column accepts string values ('customer', 'artisan', 'admin')
   - Verify timestamp columns accept ISO8601 strings

4. **Permissions**
   - Ensure the service role has INSERT permissions on `user_profiles`

## Testing Steps

1. **Run the app**: `flutter run`
2. **Go to signup screen**
3. **Create a new account**
4. **Check the debug console** for error messages
5. **Go to `/debug-db`** to test database connectivity
6. **Check Supabase dashboard** to see if profile was created

## If Issues Persist

Check these in Supabase Dashboard:
1. **Authentication > Users** - User should be there
2. **Table Editor > user_profiles** - Profile should be there
3. **Database > Policies** - Check RLS policies
4. **Logs** - Check for database errors

The debugging logs will show exactly where the process is failing.
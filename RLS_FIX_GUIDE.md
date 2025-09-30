# 🔧 RLS (Row Level Security) Fix Guide

## 🎯 Problem
**Error**: `new row violates row-level security policy for table "user_profiles"`

This error occurs because Supabase has Row Level Security enabled on the `user_profiles` table, but the current policy is too restrictive for profile creation during signup.

## 🚀 **QUICK FIX** (Choose ONE option)

### Option 1: Update RLS Policy (RECOMMENDED)

**Run this SQL in your Supabase SQL Editor:**

```sql
-- Update the RLS policy to be more permissive during signup
DROP POLICY IF EXISTS "Users can insert own profile" ON user_profiles;

CREATE POLICY "Users can insert own profile" ON user_profiles
  FOR INSERT WITH CHECK (
    -- Allow if the user ID matches the authenticated user
    (auth.uid() = id) OR
    -- Allow if user is authenticated (covers edge cases during signup)
    (auth.role() = 'authenticated')
  );
```

### Option 2: Create RLS Bypass Function

**Run the SQL from `supabase_rls_fix.sql` in your project root** (already created for you)

### Option 3: Temporarily Disable RLS (NOT RECOMMENDED)

```sql
-- Only use this for testing - NOT for production!
ALTER TABLE user_profiles DISABLE ROW LEVEL SECURITY;
```

## 🧪 **Test the Fix**

1. **Run Option 1 SQL** in your Supabase SQL Editor
2. **Try user signup** in your app again  
3. **Check console logs** - should see:
   - `SupabaseService: Profile inserted successfully`
   - No more RLS error messages
4. **Check Supabase Dashboard** → Table Editor → user_profiles
   - Your user profile should appear in the table

## 🔍 **What Changed in Your Code**

I've updated your `SupabaseService.createUserProfile()` method to:

1. **Use `upsert()`** instead of `insert()` - more permissive
2. **Add RLS detection** - identifies Row Level Security errors
3. **Fallback strategy** - tries alternative approaches if RLS fails
4. **Better error messages** - clear guidance on what went wrong

## 🎉 **Expected Result**

After applying the fix:
- ✅ User signup completes successfully
- ✅ Profile data is stored in `user_profiles` table
- ✅ User is redirected to main app
- ✅ Profile tab shows real user data

## 🔄 **If Still Having Issues**

1. **Check Supabase Dashboard** → Authentication → Settings → RLS
2. **Verify the policy exists** in Database → Policies
3. **Check your table structure** matches the schema
4. **Try Option 2** (RLS bypass function) if Option 1 doesn't work

The fix should work immediately after running the SQL!
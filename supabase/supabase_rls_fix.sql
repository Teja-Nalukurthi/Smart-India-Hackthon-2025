-- =================================================================
-- SUPABASE RLS BYPASS FUNCTION FOR PROFILE CREATION
-- =================================================================
-- Run this SQL in your Supabase SQL Editor to create a function
-- that can bypass RLS policies for profile creation
-- =================================================================

-- Create a function that bypasses RLS for profile creation
CREATE OR REPLACE FUNCTION create_user_profile_admin(profile_data jsonb)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER  -- This makes the function run with elevated privileges
AS $$
BEGIN
  -- Insert the profile data directly, bypassing RLS
  INSERT INTO user_profiles (
    id,
    email,
    full_name,
    avatar_url,
    phone_number,
    location,
    bio,
    role,
    is_verified,
    created_at,
    updated_at
  ) VALUES (
    (profile_data->>'id')::uuid,
    profile_data->>'email',
    profile_data->>'full_name',
    profile_data->>'avatar_url',
    profile_data->>'phone_number',
    profile_data->>'location',
    profile_data->>'bio',
    COALESCE((profile_data->>'role')::user_role, 'customer'::user_role),
    COALESCE((profile_data->>'is_verified')::boolean, false),
    COALESCE((profile_data->>'created_at')::timestamptz, NOW()),
    COALESCE((profile_data->>'updated_at')::timestamptz, NOW())
  );
END;
$$;

-- Alternative: Create a more permissive RLS policy (RECOMMENDED)
-- This is safer than the function above
DROP POLICY IF EXISTS "Users can insert own profile" ON user_profiles;

CREATE POLICY "Users can insert own profile" ON user_profiles
  FOR INSERT WITH CHECK (
    -- Allow if the user is authenticated and the ID matches
    (auth.uid() = id) OR
    -- Allow if user is authenticated (for edge cases during signup)
    (auth.role() = 'authenticated')
  );

-- Grant execute permission on the function to authenticated users
GRANT EXECUTE ON FUNCTION create_user_profile_admin(jsonb) TO authenticated;

-- Grant execute permission to anon users (for signup process)
GRANT EXECUTE ON FUNCTION create_user_profile_admin(jsonb) TO anon;
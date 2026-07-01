-- =====================================================
-- 회원 관리: Supabase Auth + members 프로필 테이블
-- =====================================================

CREATE TABLE IF NOT EXISTS public.members (
  id           UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  email        TEXT NOT NULL,
  name         TEXT NOT NULL DEFAULT '',
  phone        TEXT NOT NULL DEFAULT '',
  birthdate    DATE,
  address      TEXT NOT NULL DEFAULT '',
  organization TEXT NOT NULL DEFAULT '',
  job          TEXT NOT NULL DEFAULT '',
  role         TEXT NOT NULL DEFAULT 'member',
  status       TEXT NOT NULL DEFAULT 'email_verification_pending',
  created_at   TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at   TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

ALTER TABLE public.members ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Members can read own profile" ON public.members;
CREATE POLICY "Members can read own profile"
ON public.members
FOR SELECT
TO authenticated
USING (auth.uid() = id);

DROP POLICY IF EXISTS "Members can insert own profile" ON public.members;
CREATE POLICY "Members can insert own profile"
ON public.members
FOR INSERT
TO authenticated
WITH CHECK (auth.uid() = id);

DROP POLICY IF EXISTS "Members can update own profile" ON public.members;
CREATE POLICY "Members can update own profile"
ON public.members
FOR UPDATE
TO authenticated
USING (auth.uid() = id)
WITH CHECK (auth.uid() = id);

CREATE OR REPLACE FUNCTION public.set_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS members_set_updated_at ON public.members;
CREATE TRIGGER members_set_updated_at
BEFORE UPDATE ON public.members
FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

CREATE OR REPLACE FUNCTION public.create_member_profile()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.members (
    id,
    email,
    name,
    phone,
    birthdate,
    address,
    organization,
    job,
    status
  ) VALUES (
    NEW.id,
    COALESCE(NEW.email,''),
    COALESCE(NEW.raw_user_meta_data->>'name',''),
    COALESCE(NEW.raw_user_meta_data->>'phone',''),
    NULLIF(NEW.raw_user_meta_data->>'birthdate','')::DATE,
    COALESCE(NEW.raw_user_meta_data->>'address',''),
    COALESCE(NEW.raw_user_meta_data->>'organization',''),
    COALESCE(NEW.raw_user_meta_data->>'job',''),
    'email_verification_pending'
  )
  ON CONFLICT (id) DO UPDATE SET
    email = EXCLUDED.email,
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    birthdate = EXCLUDED.birthdate,
    address = EXCLUDED.address,
    organization = EXCLUDED.organization,
    job = EXCLUDED.job,
    updated_at = NOW();

  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS create_member_profile_on_signup ON auth.users;
CREATE TRIGGER create_member_profile_on_signup
AFTER INSERT ON auth.users
FOR EACH ROW EXECUTE FUNCTION public.create_member_profile();

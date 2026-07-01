-- =====================================================
-- 보도자료 테이블
-- =====================================================
CREATE TABLE IF NOT EXISTS press_releases (
  id         BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  cat        TEXT          NOT NULL DEFAULT '보도자료',
  title      TEXT          NOT NULL,
  author     TEXT          NOT NULL DEFAULT '관리자',
  content    TEXT          NOT NULL,
  pinned     BOOLEAN       NOT NULL DEFAULT FALSE,
  views      INTEGER       NOT NULL DEFAULT 0,
  file_url   TEXT,
  file_name  TEXT,
  created_at TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ  NOT NULL DEFAULT NOW()
);
ALTER TABLE press_releases ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Anyone can read press_releases" ON press_releases FOR SELECT USING (TRUE);
CREATE POLICY "Auth users can insert press_releases" ON press_releases FOR INSERT WITH CHECK (auth.uid() IS NOT NULL);
CREATE POLICY "Auth users can update press_releases" ON press_releases FOR UPDATE USING (auth.uid() IS NOT NULL);
CREATE POLICY "Auth users can delete press_releases" ON press_releases FOR DELETE USING (auth.uid() IS NOT NULL);

CREATE OR REPLACE FUNCTION increment_press_views(rec_id BIGINT)
RETURNS VOID AS $$ BEGIN UPDATE press_releases SET views = views + 1 WHERE id = rec_id; END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- =====================================================
-- 자료실 테이블
-- =====================================================
CREATE TABLE IF NOT EXISTS resources (
  id         BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  cat        TEXT          NOT NULL DEFAULT '교육자료',
  title      TEXT          NOT NULL,
  author     TEXT          NOT NULL DEFAULT '관리자',
  content    TEXT          NOT NULL,
  pinned     BOOLEAN       NOT NULL DEFAULT FALSE,
  views      INTEGER       NOT NULL DEFAULT 0,
  file_url   TEXT,
  file_name  TEXT,
  created_at TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ  NOT NULL DEFAULT NOW()
);
ALTER TABLE resources ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Anyone can read resources" ON resources FOR SELECT USING (TRUE);
CREATE POLICY "Auth users can insert resources" ON resources FOR INSERT WITH CHECK (auth.uid() IS NOT NULL);
CREATE POLICY "Auth users can update resources" ON resources FOR UPDATE USING (auth.uid() IS NOT NULL);
CREATE POLICY "Auth users can delete resources" ON resources FOR DELETE USING (auth.uid() IS NOT NULL);

CREATE OR REPLACE FUNCTION increment_resource_views(rec_id BIGINT)
RETURNS VOID AS $$ BEGIN UPDATE resources SET views = views + 1 WHERE id = rec_id; END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- =====================================================
-- 첨부파일 Storage 버킷
-- =====================================================
-- 공지사항, 보도자료, 자료실이 모두 notice-attachments 버킷을 공유합니다.
-- "bucket not found" 오류가 발생하면 이 블록이 아직 적용되지 않은 상태입니다.
INSERT INTO storage.buckets (id, name, public, file_size_limit)
VALUES ('notice-attachments', 'notice-attachments', TRUE, 10485760)
ON CONFLICT (id) DO UPDATE
SET public = TRUE,
    file_size_limit = 10485760;

DROP POLICY IF EXISTS "Public read notice attachments" ON storage.objects;
CREATE POLICY "Public read notice attachments"
ON storage.objects
FOR SELECT
TO public
USING (bucket_id = 'notice-attachments');

DROP POLICY IF EXISTS "Auth users can upload notice attachments" ON storage.objects;
CREATE POLICY "Auth users can upload notice attachments"
ON storage.objects
FOR INSERT
TO authenticated
WITH CHECK (bucket_id = 'notice-attachments');

DROP POLICY IF EXISTS "Auth users can update notice attachments" ON storage.objects;
CREATE POLICY "Auth users can update notice attachments"
ON storage.objects
FOR UPDATE
TO authenticated
USING (bucket_id = 'notice-attachments')
WITH CHECK (bucket_id = 'notice-attachments');

DROP POLICY IF EXISTS "Auth users can delete notice attachments" ON storage.objects;
CREATE POLICY "Auth users can delete notice attachments"
ON storage.objects
FOR DELETE
TO authenticated
USING (bucket_id = 'notice-attachments');

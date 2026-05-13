-- 注文テーブル
CREATE TABLE orders (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  name TEXT NOT NULL,
  libecity_url TEXT,
  items JSONB NOT NULL,
  total_price INTEGER NOT NULL,
  memo TEXT,
  ordered_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  is_paid BOOLEAN DEFAULT FALSE,
  paid_at TIMESTAMPTZ
);

-- updated_at 自動更新トリガー
CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER set_updated_at
BEFORE UPDATE ON orders
FOR EACH ROW EXECUTE FUNCTION update_updated_at();

-- Row Level Security（誰でも INSERT・SELECT・UPDATE 可能）
ALTER TABLE orders ENABLE ROW LEVEL SECURITY;
CREATE POLICY "allow_all" ON orders FOR ALL USING (true) WITH CHECK (true);

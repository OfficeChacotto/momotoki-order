-- settings テーブル（締め切り日時など設定値を格納）
CREATE TABLE IF NOT EXISTS settings (
  key TEXT PRIMARY KEY,
  value TEXT
);
INSERT INTO settings (key, value) VALUES ('order_cutoff', null)
ON CONFLICT (key) DO NOTHING;

ALTER TABLE settings ENABLE ROW LEVEL SECURITY;
CREATE POLICY "allow_all" ON settings FOR ALL USING (true) WITH CHECK (true);

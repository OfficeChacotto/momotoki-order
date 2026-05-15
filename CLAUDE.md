# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this project is

静的サイト（GitHub Pages）+ Supabase によるオフ会向けネット注文システム。ビルドステップなし・フレームワークなし。

- **デプロイ先**: GitHub Pages（`main` ブランチへ push すれば自動反映）
- **DB**: Supabase（PostgreSQL）。接続情報は `supabase-config.js`（gitignore 対象外・実ファイルをコミット済み）

## ファイル構成

| ファイル | 役割 |
|---|---|
| `index.html` | 注文者向け画面。単一ファイルに HTML/CSS/JS を内包 |
| `admin.html` | 店主向け管理画面。同上 |
| `supabase-config.js` | Supabase URL と anon key の定数定義。両 HTML から `<script src>` で読み込む |
| `supabase-config.example.js` | 上記のテンプレート |
| `supabase_setup.sql` | `orders` テーブルと RLS ポリシーの初期 SQL |
| `supabase_settings.sql` | `settings` テーブルの初期 SQL（締め切り日時の格納に使用） |

## Supabase テーブル構造

**`orders`**: 注文データ。`items` カラムは JSONB（`{id, name, price, qty}` の配列）。`is_paid` / `paid_at` で支払い管理。`updated_at` はトリガーで自動更新。

**`settings`**: キーバリュー形式の設定テーブル。現在使用しているキーは `order_cutoff`（ISO 8601 文字列、null = 締め切りなし）。

RLS は両テーブルとも `allow_all` ポリシーで全操作を許可（認証なし）。

## アーキテクチャ上の注意点

**index.html の状態管理**
- `myOrderId` / `myOrderData`: 自分の注文（localStorage の `order_id` キーで永続化）
- `cutoffISO`: settings テーブルから取得した締め切り日時
- `isEditing`: 新規注文(false) と変更(true) を区別するフラグ
- 画面は `form-screen`（注文フォーム）と `main-screen`（注文確認）の2つを `display` で切り替え

**admin.html の注意点**
- `sortOrders()` で「未払い→名前順、支払い済→名前順（下）」に並べる。fetch 後と `togglePaid` 後に必ず呼ぶこと
- iOS Safari では `disabled` 属性のボタンでも `onclick` が発火するため、`openEdit` / `deleteOrder` の関数先頭で `is_paid` を再チェックしている
- 支払い済への変更は確認なし、支払い済→未払いへの戻しは `confirm()` で確認する

**Supabase SDK の読み込み**
CDN（`https://cdn.jsdelivr.net/npm/@supabase/supabase-js@2`）から UMD ビルドを読み込み、グローバルの `supabase.createClient()` で初期化。anon key は legacy 形式（`eyJ...`）を使用すること（新形式 `sb_publishable_` は動作しない）。

## デプロイ

```bash
git add <files>
git commit -m "..."
git push
```

GitHub Pages は `main` ブランチのルートを自動配信。反映まで数分かかる場合がある。

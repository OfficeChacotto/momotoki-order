# 古民家cafe 百時 ネット注文システム

リベシティ オフ会向けの注文管理システムです。

## ファイル構成

| ファイル | 説明 |
|----------|------|
| `index.html` | 注文者向け画面（メニュー選択・注文送信・変更） |
| `admin.html` | 店主向け管理画面（注文一覧・支払い管理） |
| `supabase-config.js` | Supabase接続設定（**Gitには含まれません**） |
| `supabase-config.example.js` | 設定ファイルのテンプレート |
| `supabase_setup.sql` | DBテーブル作成SQL |

---

## セットアップ手順

### 1. Supabaseプロジェクトの作成

1. [https://supabase.com](https://supabase.com) にアクセスしてサインイン
2. 「New project」でプロジェクトを作成
3. プロジェクト作成後、左メニュー **Settings → API** を開く
4. 以下の2つの値をコピーしておく
   - **Project URL**（例: `https://abcdefgh.supabase.co`）
   - **anon public** キー（`eyJ...` で始まる長い文字列）

### 2. テーブルの作成（SQL実行）

1. Supabaseダッシュボード左メニュー **SQL Editor** を開く
2. `supabase_setup.sql` の内容を全てコピーして貼り付け
3. 「Run」ボタンをクリックして実行

### 3. supabase-config.js の設定

`supabase-config.example.js` をコピーして `supabase-config.js` を作成し、値を書き換えます：

```bash
cp supabase-config.example.js supabase-config.js
```

`supabase-config.js` を開いて編集：

```javascript
const SUPABASE_URL = 'https://あなたのProject URL';
const SUPABASE_ANON_KEY = 'あなたのanon publicキー';
```

> ⚠️ `supabase-config.js` は `.gitignore` に含まれているため、GitHubにはpushされません。

### 4. GitHub Pages へのデプロイ

1. GitHubリポジトリを作成（または既存リポジトリを使用）
2. 全ファイルをpush（`supabase-config.js` は除外されます）
3. リポジトリの **Settings → Pages** を開く
4. Source を `main` ブランチ / `/ (root)` に設定して「Save」
5. 数分後にURLが発行される

### 5. 各画面のURL

GitHub Pages のURL形式（例: `https://username.github.io/repo-name/`）

| 画面 | URL |
|------|-----|
| 注文画面（来店者用） | `https://username.github.io/repo-name/index.html` |
| 管理画面（店主用） | `https://username.github.io/repo-name/admin.html` |

> 管理画面のURLは店主のみが知っていれば十分です（認証なし）。
> セキュリティが必要な場合はSupabaseのRLS設定を追加してください。

---

## 使い方

### 注文者（来店者）

1. 注文画面を開く
2. お名前・リベシティURLを入力
3. メニューから飲み物・フードを選ぶ（`＋` / `−` ボタン）
4. 「注文する」ボタンを押して完了
5. 注文後も「注文を変更する」ボタンで変更可能（ページを閉じても再開できます）

### 店主（管理画面）

1. 管理画面を開く
2. 注文一覧が表示される（注文日時の新しい順）
3. 支払いが完了したら「⬜ 未払い」ボタンをクリック → 「✅ 支払い済み」に変わる
4. 上部の集計で未払い人数・金額を確認
5. 「↻ 更新」ボタンで最新の注文を取得

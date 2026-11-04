# 実行基盤（ホスティング・DB・認証）

uchiaji を 0 円で動かすための実行基盤の候補と、無料枠の条件。

## 調査の前提

- 調査日：2026-11-02。価格と枠はすべてこの日の値。
- 想定する使い方：
  - 家族数人が、主にスマホの PWA から使う。
  - 複数の端末でデータを同期する。
  - URL 取り込み（F-IN-01）のため、サーバー側で本人の操作により 1 件ずつページを取得する中継が要る。ブラウザからは CORS で他サイトを直接取得できない。
  - データ量は小さい。レシピは 1 件数 KB、写真は版ごとに 1 枚程度。
- 開発とテストは Claude Code で回すため、ローカルで再現しやすいことも見る。

## 無料枠の比較

| 候補 | DB | ファイル（写真） | URL 取得の中継 | 認証 | 静的ホスティング | ローカル開発 |
|---|---|---|---|---|---|---|
| Supabase Free | Postgres 500MB。アクティブなプロジェクトは 2 つまで | Storage 1GB、1 ファイル 50MB まで。転送量は月 5GB | Edge Functions 月 50 万回。CPU 2 秒、実行 150 秒、メモリ 256MB | 月間利用者 5 万人。Google OAuth、マジックリンク | なし | `supabase start`。Docker などのコンテナ実行環境が要る |
| Cloudflare（Workers Free） | D1：1 DB 500MB、合計 5GB。読み取り 1 日 500 万行、書き込み 1 日 10 万行。Time Travel（復元）7 日 | R2：月 10GB。転送量は無料 | Workers：1 日 10 万リクエスト。CPU 10ms／リクエスト。サブリクエスト 50 回／リクエスト | Access（Zero Trust Free）は 50 人まで。メールのワンタイム PIN、Google | Pages：ビルド月 500 回。Workers の静的アセットへのリクエストは無料で無制限 | wrangler（Miniflare）。Docker は不要（【推測】） |
| Firebase Spark | Firestore 1GiB。読み取り 1 日 5 万、書き込み 1 日 2 万 | 不可。Cloud Storage は Blaze プランが必須（2026-02-03 から） | 不可。Cloud Functions は Spark の対象外 | 月間利用者 5 万人。メールリンクのログインは 1 日 5 通 | Hosting 10GB、転送 1 日 360MB | Emulator Suite（詳細は未確認） |
| Turso Free | DB 100 個、5GB | なし | なし | なし | なし | libSQL／SQLite |
| Vercel Hobby | なし | Blob（無料枠は未確認） | Functions 月 100 万回 | なし | あり。転送 100GB | `vercel dev` |
| Deno Deploy Free | KV（無料枠は未確認） | なし | 月 100 万リクエスト | なし | あり | `deno` |
| GitHub Pages | なし | なし | なし | なし | GitHub Free では公開リポジトリのみ | 静的ファイルのみ |

出所は各サービスの公式文書（【事実】）。「未確認」のセルと、ローカル開発の欄の「【推測】」を除く。

## GitHub の無料枠

- 【事実】GitHub Pages は、GitHub Free だと公開リポジトリからしか公開できない。公開されたサイトは誰でも見られる。
- 【事実】GitHub Actions の標準ランナーは、公開リポジトリなら無料。
- 【事実】私有リポジトリは、GitHub Free だと月 12 ドル分が含まれる。Linux のランナーで約 2,000 分に当たる（分数は換算した値）。
- Actions はテストやデプロイを回す仕組みであり、サービスの公開先ではない。

## 無料枠の落とし穴

| 候補 | 落とし穴 | 内容 | uchiaji への影響 |
|---|---|---|---|
| Supabase | 非アクティブ時の一時停止 | 【事実】7 日間 DB の利用が少ないと停止する。停止の約 1 週間前に警告メールが届く。ダッシュボードの Resume で戻す | 家族の利用が週 1 回より少ないと止まる |
| Supabase | 停止後の復元期限 | 【事実】現行の公式文書では、停止から 1 年以内なら復元できる。第三者の記事には「90 日」とある。【推測】改定されたとみられる | N-02 の観点から、外部への定期バックアップが要る |
| Supabase | メール送信 | 【事実】標準 SMTP は 1 時間に 2 通まで。宛先は組織のメンバーだけ | 家族のマジックリンクには向かない。Google ログインが無難（【推測】） |
| Supabase | ローカル開発 | 【事実】Docker などが要る | Windows では Docker Desktop を用意する |
| Cloudflare | 支払い情報の登録 | 【事実】Zero Trust の開始時に支払い情報の入力を求められる。Free プランなら請求されない。R2 も登録を求められるという第三者の記事がある（公式では未確認） | カードなどの登録が要る可能性が高い。請求は起きない |
| Cloudflare | 上限を超えたとき | 【事実】D1 は 1 日の上限でクエリがエラーになる。Workers は Error 1027 を返す。無料プランに超過料金の記述はない | 0 円は保たれる。家族数人で上限に届く見込みはない（【推測】） |
| Cloudflare | Workers からの外部 fetch | 【事実】すべてのサブリクエストに `CF-Worker` ヘッダーが付く。受け手は Workers 由来の通信をブロックできる。CPU は 10ms まで（I/O 待ちは含まない） | 一部のサイトで取得を拒否されうる（【推測】）。HTML の解析はクライアント側で行う |
| Cloudflare | 独自ドメイン | 【推測】`*.workers.dev` と `*.pages.dev` なら 0 円。独自ドメインは年額がかかる | 0 円にこだわるなら既定のサブドメインを使う |
| Firebase | Spark の機能制限 | 【事実】Cloud Functions と Cloud Storage は Blaze プラン（従量課金）が必須 | 中継と写真の保存ができない |
| Vercel | 用途の制限 | 【事実】Hobby は非商用・個人利用のみ | 私的利用なら問題ない（【推測】）。DB と認証は別に要る |
| PocketBase | 無料のホスティング | 第三者の記事によると、PocketHost は 2026 年に有料の枠制へ移った | 家庭内のマシンで動かせば 0 円だが、公開と保守の手間がかかる |

## 構成案

調査担当の推奨順は A、B、C（【推測】）。

### 案 A：Cloudflare 一本（ローカルファースト）

| 要素 | 内容 |
|---|---|
| 配信 | Workers の静的アセット（または Pages）で PWA を配信する |
| 正のデータ | 各端末の IndexedDB。調理モードはオフラインで動く |
| 同期 | Worker の API と D1 |
| 写真 | R2。端末でリサイズしてから上げる |
| URL の中継 | Worker。本人の操作で 1 件ずつ取得し、robots.txt を確認して HTML を返す。解析はクライアントで行う |
| 認証 | Cloudflare Access で、許可するメールアドレスを家族に限る |
| ローカル | `wrangler dev` |

- 0 円で済むか：済む（【推測】）。支払い情報の登録は要る可能性が高い。停止や削除の条件はない。
- 弱点：
  - 同期のロジックを自前で書く。
  - Access のログインが、ホーム画面に置いた PWA（特に iOS）で通るかは未確認。

### 案 B：Supabase と静的ホスティング（クラウド DB を正にする）

| 要素 | 内容 |
|---|---|
| 配信 | Cloudflare Pages |
| 正のデータ | Supabase Postgres。RLS で家族に限る |
| 写真 | Supabase Storage |
| URL の中継 | Supabase Edge Functions。CPU に案 A より余裕がある |
| 認証 | Supabase Auth の Google ログイン |
| ローカル | `supabase start`（Docker が必須） |

- 0 円で済むか：済む（【推測】）。家族数人の使用量が無料枠に収まる前提。
- 弱点：
  - 7 日間あまり使わないと停止する。
  - Docker が必須。
  - 2 つのサービスにまたがる。
  - オフラインの調理モードには、キャッシュ層を別に作る。

### 案 C：ローカルファーストと最小限のクラウド

- 案 A から D1 と同期 API を除く。書き出した JSON（N-01）を R2 などに置き、手動で同期する。
- 実装はいちばん小さい。
- 同期が手動になり、「複数端末で同期したい」を十分には満たさない。

## uchiaji にとっての意味

- 【推測】版を追記のみにするデータ設計（変えない版と、可変な「いまの版」へのポインター）にすると、同期の衝突はポインターの最終更新だけになる。ローカルファーストの同期を小さくできる。
- 【推測】N-01 の全件書き出しを、バックアップと移行の形式にも使える。サービスの停止や規約変更への保険になる。
- 【推測】Cloudflare Access に家族のメールアドレスを登録すれば、アプリ側に認証を作らずに家族の範囲へ閉じられる。
- 【推測】中継が `CF-Worker` ヘッダーで拒否される場合に備え、テキストの貼り付け（F-IN-02）を代わりの経路として常に用意する。
- 【推測】iOS Safari には、操作のないサイトのストレージを消す方針がある。ホーム画面に追加した PWA は対象外とされる。出典は未確認。

## 未確認

- Cloudflare Access のログインが、iOS と Android のホーム画面 PWA で通るか。セッション切れのときに、サービスワーカーの fetch がどう振る舞うか。
- Workers Free と R2 の利用開始に、支払い情報の登録が必須か。
- Supabase の停止から 1 年を過ぎた後のデータの扱い。定期 ping で停止を避けることの規約上の扱い。
- 主要なレシピサイトが、Workers や Edge Functions からの取得を拒否するか。
- iOS WebKit のストレージ削除の現行仕様。
- `wrangler dev` で D1 と R2 を完全にローカルで再現できるか。
- Vercel Blob と Deno KV の無料枠。Netlify Functions。
- Google OAuth のクライアントを「テスト」状態のまま家族で使う場合の制約。

## 参考 URL

- https://supabase.com/pricing
- https://supabase.com/docs/guides/platform/free-project-pausing
- https://supabase.com/docs/guides/functions/limits
- https://supabase.com/docs/guides/auth/rate-limits
- https://supabase.com/docs/guides/auth/auth-smtp
- https://supabase.com/docs/guides/local-development/cli/getting-started
- https://github.com/orgs/supabase/discussions/39271
- https://simplebackups.com/blog/supabase-free-tier-paused （第三者の記事）
- https://developers.cloudflare.com/workers/platform/limits/
- https://developers.cloudflare.com/workers/platform/pricing/
- https://developers.cloudflare.com/d1/platform/limits/
- https://developers.cloudflare.com/d1/platform/pricing/
- https://developers.cloudflare.com/r2/pricing/
- https://developers.cloudflare.com/kv/platform/limits/
- https://developers.cloudflare.com/pages/platform/limits/
- https://developers.cloudflare.com/fundamentals/reference/http-headers/
- https://www.cloudflare.com/plans/sase-zero-trust/
- https://developers.cloudflare.com/cloudflare-one/setup/
- https://dev.to/leonwong282/the-complete-beginners-guide-to-cloudflare-r2-image-hosting-2025-2g4k （第三者の記事）
- https://firebase.google.com/pricing
- https://firebase.google.com/docs/storage/faqs-storage-changes-announced-sept-2024
- https://firebase.google.com/docs/auth/limits
- https://turso.tech/pricing
- https://vercel.com/docs/plans/hobby
- https://deno.com/deploy/pricing
- https://pockethost.io/blog/pockethost-30-preview
- https://pockethost.io/pricing
- https://docs.github.com/en/pages/getting-started-with-github-pages/github-pages-limits
- https://docs.github.com/en/pages/getting-started-with-github-pages/creating-a-github-pages-site
- https://docs.github.com/en/billing/concepts/product-billing/github-actions

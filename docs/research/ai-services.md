# AI サービス

取り込み（F-IN-08、F-IN-09）と知識（F-KN-02、F-KN-03）に使う AI サービスの比較。MVP には入れないが、サービスは先に選んでおく。

## 調査の前提

- 調査日：2026-11-02。価格は USD 建て。円は 1 ドル＝150 円と仮定して換算した（為替は未確認）。
- 判断の基準：
  - ランニングコストは極力 0 円。出ても月数百円まで。
  - 他サイトのレシピ本文や家族の手書きメモを送るので、入力が学習に使われないこと。ユーザーの関心による基準で、P-3 の本文（外部の LLM に本文を送る場合は、サイトの規約を確認する）にはない。
  - AI の出力は原文と区別して表示する（P-6）。

## サービスの比較

価格は 100 万トークンあたりの入力／出力。

| サービス／モデル | 料金 | 無料枠 | データの扱い | 画像入力 |
|---|---|---|---|---|
| Claude Haiku 5.5 | 0.10／0.50 ドル（プロンプト 10 万トークン以下）。Batch は半額 | 一般向けの無料枠はない。前払いクレジットで、有効期限は 1 年。Max、Ultra、Team プランには API クレジットが付く | 既定で学習に使わない。入出力は 30 日以内に削除 | 対応 |
| Claude Sonnet 5 | 2／10 ドル | 同上 | 同上 | 対応。難しい手書き向けの上位候補 |
| Gemini 3.5 Flash-Lite | 0.30／2.50 ドル。出力に思考トークンを含む | 無料枠あり。カード不要。レート上限の公式値は文書にない | **無料枠では学習・改善に使われ、人間のレビュアーが読む場合もある**。有料枠では学習に使わない | 対応。1 枚あたり既定 1,120 トークン |
| Gemini 3.8 Flash | 0.75／3.75 ドル。**2027-01-01 から 1.50／7.50 ドル** | 同上 | 同上 | 対応 |
| OpenAI gpt-5-nano | 0.05／0.40 ドル | テキストの無料枠はない | 既定で学習に使わない。ログは最長 30 日 | 未確認 |
| Cloudflare Workers AI | 例：Llama 4 Scout は 0.27／0.85 ドル | **1 日 10,000 Neurons まで無料。Workers Free でも使える** | 学習に使わない。処理後に保持しない | Llama 4 Scout などが対応 |
| Groq | 未確認 | 無料プランあり。上限は未確認 | 既定で推論データを保持しない | 一部のモデル |
| Mistral（無料モード） | ― | 無料（電話番号の認証が要るとの第三者情報） | 無料モードでは学習に使われうる | 一部のモデル |
| OpenRouter の `:free` モデル | 0 円 | 1 日 50 リクエスト | 中継先によって異なる（未確認） | モデルによる |

出所は各社の公式文書（【事実】）。Mistral の認証の条件だけ第三者の記事による。

### 前払いと支出上限

- 【事実】Gemini の前払いは最低 5 ドルで、有効期限は 12 か月。
- 【事実】Anthropic のクレジットも有効期限は 1 年。最低購入額は未確認。
- 【事実】Gemini はプロジェクト単位の支出上限（実験的機能）を持つ。Anthropic はワークスペースの支出上限を持つ。
- 【事実】Gemini API の規約は 18 歳以上が条件。18 歳未満が使う見込みのあるクライアントは許されていない。他社の年齢条件は未確認。

## 端末内で動く選択肢

| 手段 | 状況 | 評価 |
|---|---|---|
| Chrome Prompt API（Gemini Nano） | 【事実】デスクトップ専用。Android と iOS は未対応 | 【推測】台所のスマホでは使えない |
| Tesseract.js | 【事実】手書き日本語の実測値は見つからなかった | 【推測】手書きには期待できない |
| NDLOCR-Lite Web | 【事実】ブラウザ内で処理し、外部に送らない。活字に強く、手書きでは精度が落ちやすい（第三者の記事） | 手書きメモには不向き |

## 日本語の手書き・レシピ抽出の精度

| 出典 | 内容 | 読み方 |
|---|---|---|
| 【声】個人の記事（リベシティ、2026-04-12） | 手書きのパンのレシピを撮影した。Claude（モデルは不明）ではほとんど読めず、Gemini（2.5 Flash）ではほとんど文字起こしできた | 同じ用途の声。ただし 1 件で、モデルも古い |
| 【事実】ジンベイ社のリリース（VOIX、2026-09-10） | 手書き帳票 130 枚の完全一致の F1：Claude Opus 5 は 70.50、Claude Fable 5.1 は 68.18、Gemini 3.8 Flash は 65.93、自社製品は 75.55 | 宣伝を含み、帳票はレシピではない。最新モデルでも 7 割前後なので、人の確認は必須 |
| 【事実】厚労科研の分担研究報告書 | 手書きの文章はモデル間の差が大きく、クローズドモデルのほうが誤りが少なかった | 文章の手書きほど差が出る |
| レシピの抽出（大さじ・適量） | 出典のある評価は見つからなかった | 未確認 |

## 月額の概算

前提：レシピの抽出 30 件（入力 3,000／出力 800 トークン）、写真の取り込み 10 枚、知識の問い合わせ 30 回（入力 1,000／出力 500 トークン）。【推測】筆者の試算。

| モデル | 月額 |
|---|---|
| Claude Haiku 5.5 | 約 0.04 ドル（約 6 円） |
| Gemini 3.5 Flash-Lite（有料枠） | 約 0.16 ドル（約 24 円）。思考トークンが出ると増える |
| Gemini 3.8 Flash（2027 年 1 月以降の価格） | 約 0.56 ドル（約 84 円） |
| Cloudflare Workers AI | 0 円。1 日 70 件程度まで |
| Gemini 無料枠 | 0 円。ただし学習に使われ、個人情報は送れない |

- 【推測】従量の額より、前払いの最低額のほうが効く。Gemini なら年 5 ドル（月あたり約 63 円）が実質の下限になる。
- 【事実】Claude の Max、Ultra、Team プランには、月ごとの API クレジットが付く。
- 【推測】上の試算の使用量なら付属のクレジットに収まり、追加の費用はかからない。

## 用途ごとのおすすめ

調査担当の推奨（【推測】）。

| 用途 | おすすめ | 次点 | 理由 |
|---|---|---|---|
| テキスト・HTML からの抽出（F-IN-02、F-IN-09） | Claude Haiku 5.5 | Gemini 3.5 Flash-Lite の有料枠。0 円の試作なら Workers AI | 他サイトの本文を送るので、学習に使われないことが前提。Workers AI は日本語の精度が未確認 |
| 手書きメモ・スクショの写真（F-IN-08） | Gemini 3.8 Flash か 3.5 Flash-Lite の有料枠を評価する | Claude Haiku 5.5。読めないときは Sonnet 5 | 評価は割れている。家族の実物のメモ 5〜10 枚で比べて決める。家族の手書きは無料枠に送らない |
| 下処理・コツ・理由（F-KN-02、F-KN-03） | Claude Haiku 5.5（AI 生成と明示する） | Gemini の有料枠と Google 検索のグラウンディング | 外部の本文を送らないので、論点は誤情報が中心。グラウンディングは出典付きの参照に近づける |
| 端末内だけで処理する | MVP では採用しない | ― | スマホで使えない、手書きに弱い |

## tsukurou にとっての意味

- 【推測】AI の前に、構造化データ（JSON-LD）→ HTML の解析の順で、AI を使わない経路を先に通す。AI に送る件数と、本文が外に出る機会の両方が減る。
- 【推測】Gemini の無料枠に送ってよいのは、本文も個人情報も含まない検証用のデータだけ。本番の経路にしない。
- 【推測】クラシルは「営利目的での AI への直接・間接の入力」を禁止している（[legal.md](legal.md)）。ドメインごとに AI へ送ってよいかを持つ設計が考えられる。
- 【推測】API キーを PWA に埋め込まない。サーバー側の中継（Workers など）から呼ぶ。
- 【推測】モデル名と単価は設定値にする。Gemini は値上げと提供終了の予定があり、入れ替わりが速い。
- 【推測】用途単位のインターフェイス（例：抽出の入力 → 項目と出所）を 1 つ決め、プロバイダごとの実装を裏に置く。Vercel AI SDK は、Anthropic、Google、OpenAI の画像入力と構造化出力に対応している（【事実】）。
- 【推測】項目ごとに、原文から取ったか AI が補ったか、モデル ID、プロンプトの版を記録する。P-6 の表示の区別と、モデルを差し替えたときの比較にそのまま使える。
- 【推測】分量は、原文の文字列（「大さじ 1」「適量」「1 片」）を必ず残し、正規化した値（数量・単位・不定の印）を別の項目にする。P-5 の未完成のレシピとも合う。
- 【推測】支出上限と、自動チャージを切った前払いを組み合わせれば、損失の最大額は前払いの額に固定できる。

## 未確認

- Gemini 無料枠のレート上限の公式値。
- Anthropic の前払いの最低購入額。新規アカウントに無料クレジットが付くか。
- OpenAI の画像対応と画像トークンの計算方法。
- Groq の料金と無料プランの上限。
- Workers AI の各モデルの日本語の精度。画像入力の Neurons の換算。
- Claude の新しいトークナイザーで、日本語のトークン数がどれだけ増えるか。
- Gemini 3.5 Flash-Lite と 3.8 Flash で、思考が既定で有効か。
- 日本語レシピの抽出と家庭の手書きレシピについて、出典のある精度の評価。
- Anthropic、OpenAI、Cloudflare の年齢条件。

## 参考 URL

- https://ai.google.dev/gemini-api/docs/pricing
- https://ai.google.dev/gemini-api/terms
- https://ai.google.dev/gemini-api/docs/rate-limits
- https://ai.google.dev/gemini-api/docs/billing
- https://ai.google.dev/gemini-api/docs/available-regions
- https://ai.google.dev/gemini-api/docs/deprecations
- https://ai.google.dev/gemini-api/docs/tokens
- https://ai.google.dev/gemini-api/docs/media-resolution?hl=en
- https://ai.google.dev/gemini-api/docs/structured-output?hl=ja
- https://platform.claude.com/docs/en/about-claude/pricing
- https://platform.claude.com/docs/en/build-with-claude/vision
- https://platform.claude.com/docs/en/about-claude/api-credits-for-subscribers
- https://support.claude.com/en/articles/8977456-how-do-i-pay-for-my-api-usage
- https://privacy.claude.com/en/articles/7996868-is-my-data-used-for-model-training
- https://privacy.claude.com/en/articles/7996866-how-long-do-you-store-my-organization-s-data
- https://developers.openai.com/api/docs/pricing
- https://developers.openai.com/api/docs/guides/your-data
- https://developers.cloudflare.com/workers-ai/platform/pricing/
- https://developers.cloudflare.com/workers-ai/platform/data-usage/
- https://developers.cloudflare.com/workers-ai/models/
- https://developers.cloudflare.com/ai-gateway/reference/pricing/
- https://console.groq.com/docs/rate-limits
- https://console.groq.com/docs/your-data
- https://help.mistral.ai/en/articles/323757-do-you-use-my-user-data-to-train-your-artificial-intelligence-models
- https://openrouter.ai/docs/api-reference/limits
- https://developer.chrome.com/docs/ai/prompt-api
- https://ai-sdk.dev/providers/ai-sdk-providers
- https://library.libecity.com/articles/01KNYB87E99X7TF76JPZFWXK43 （個人の記事）
- https://voix.jp/business-cards/genocr-on-premise-accuracy-leader/ （企業のリリース）
- https://mhlw-grants.niph.go.jp/system/files/report_pdf/202515006A-buntan7_0.pdf
- https://research.aimultiple.com/ocr-accuracy （第三者の記事）
- https://gigazine.net/news/20260401-ndlocr-lite-web-ai （第三者の記事）
- https://www.issoh.co.jp/tech/details/11281/ （第三者の記事）

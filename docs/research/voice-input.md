# 声で残す手段

調査日：2026-11-02

食卓で「もっとこうしたほうが良かったね」と話した内容を、次に作るときの手順に出すための入力手段を調べた。きっかけはユーザーの発言「google homeに話しかけてメモさせるとかが一番続くかも。ちょっとメモをスマホに書くもできる」（[concept.md](../concept.md) の「体験の核」）。

## 結論

- 【事実】2026-11 時点で、Google には、家庭のスマートスピーカーから自作の Web アプリに自由な文を直接届ける公式の手段がない。Alexa はカスタムスキルで自由な文を受け取れるが、家族に配るにはベータ版を 90 日ごとに作り直す必要がある（下の比較表）。
- 【推測】どちらも、家庭で長く使う入力の本線には向かない。
- 【推測】最初の入力手段は、スマートスピーカーではなく「食卓でアプリに一言録音」にするのが確実で、費用もほぼ 0 円になる。iPhone の家族向けには、iOS ショートカットを補助にする。
- 【推測】アプリで録音する最大の利点は、「今日作った料理」にメモを自動で紐づけられることにある。スピーカー経由ではこれができない。

## 手段の比較

| 手段 | できること | 費用 | 手間 | 2026-11 時点の状況 |
|---|---|---|---|---|
| Gemini for Home（Nest）→ Google Keep | 【事実】声でメモやリストを作成・編集できる | 0 円 | 設定は少ない。Keep からアプリへ取り出す手段がない | 【事実】日本では 2026-04 から早期アクセス。【事実】Keep API は Workspace の管理者向けで、個人アカウントでは使えない。【事実】2026-08 に、声で Keep のリストに追加できない不具合が一部の利用者で報じられた（英語圏、9to5Google） |
| Gemini for Home → Google Tasks → Tasks API | 【事実】声でタスクを作成・編集できる | 【推測】0 円 | 大きい。OAuth クライアントを作り、家族が各自で認可する。【事実】公開ステータスが「テスト中」だと、リフレッシュトークンは 7 日で切れる | 【事実】2026-02 以降、作成したと答えたのに Tasks に無い、という第三者の報告がある。日本語での可否は未確認 |
| Google Home のルーティン、IFTTT | 決まった言葉で動作を起動する | 0 円〜 | ― | 【事実】IFTTT の Google Assistant V2 は 2022 年に可変入力を廃止した。自由な文は渡せない。Conversational Actions は終了済み |
| Alexa のリスト連携 | ― | ― | ― | 【事実】2024-07-01 に、List skills と List Management API のサポートが終了した（Amazon 開発者文書で確認） |
| Alexa のカスタムスキル（Alexa-hosted） | 【事実】AMAZON.SearchQuery で発話を文字列として受け取れる | 【事実】Lambda などが無料で用意される | 中程度。起動の言葉が要る。【事実】家族はベータテスターとして追加できるが、ベータは最長 90 日 | 【事実】日本では 2026-10-29 に Alexa+ の早期アクセスが始まった。Alexa+ でのカスタムスキルの扱いは未確認 |
| iOS ショートカット＋Siri | 【推測】音声入力 → POST で、「Hey Siri、料理メモ」から送れる | 0 円 | 小さい。家族の iPhone それぞれに入れる | 実機では未確認 |
| アプリ内で録音 → Workers AI Whisper | 【推測】食卓で一言録音し、文字起こしして、今日作った料理に紐づける | 【事実】0.0005 ドル／分。無料枠は 1 日 10,000 Neurons | 小さい。アプリ内で完結する | 現行の機能。料金は [ai-services.md](ai-services.md) も参照 |
| ブラウザの音声認識（Web Speech API） | 端末側で文字起こしする | 0 円 | 小さい | 【事実】iOS Safari は 14.5 から接頭辞付きで対応。ホーム画面の PWA で動くかは未確認 |
| キーボードの音声入力 | どの入力欄にも話して入力できる | 0 円 | 最小 | 【推測】iOS と Gboard の標準機能で、確実に使える |
| Android：Keep のメモを PWA に共有 | 【事実】Web Share Target は Chrome Android 76 以降で対応。iOS は非対応 | 0 円 | 毎回、手で共有する | スピーカーで溜めたメモを、後でまとめて取り込む橋渡しになる |

【声】Gemini for Home に Keep の 2 つのリストの統合を頼むと、頼んでいないのに複製した（Yahoo Tech の筆者）。

## tsukurou にとっての意味

- **活かす**
  - 【推測】入力の第一候補は「食卓でアプリに一言録音」。調理モードで開いた料理を「今日作ったもの」として覚えておき、録音をその料理に紐づける。
  - 【推測】「良かったね」「次はこうしたい」の分類と、手順への割り当ては、AI の下書きにして本人が確定する（[principles.md](../principles.md) P-6）。
  - 【推測】スピーカーで話したい人には、Keep に溜めてもらい、Android は共有シート、iOS はコピーで取り込む。
- **避ける**
  - Google Tasks API を入力の本線にしない。【事実】不具合の報告と、テスト中のトークンが 7 日で切れる制約がある。
  - Alexa のリスト連携に頼らない。【事実】2024 年に終了している。
  - カスタムスキルを本線にしない。【事実】ベータは 90 日ごとに作り直しが要る。
- **独自の機会**
  - 【推測】「誰が、どの料理について言ったか」を手順に結びつける仕組みは、スピーカーにも既存のレシピアプリにもない。

## 未確認

- Gemini for Home の日本での一般提供の状況。日本語で Tasks に声で追加できるか。Keep の不具合が直ったか。
- Google Tasks の OAuth スコープの分類と、未審査で本番にしたときの警告画面の扱い。
- Alexa+ でカスタムスキルが動くか。Alexa-hosted の利用上限。
- HomePod や AirPods から個人の iOS ショートカットを動かせるか。音声入力と POST を組み合わせたショートカットの実機での動作。
- iOS のホーム画面 PWA で、Web Speech API と録音（getUserMedia）が動くか。
- （解消）家族の端末は iPhone と Android の両方（2026-11-02 のユーザーの回答、[concept.md](../concept.md)）。iOS ショートカットと、Android の共有シートの両方が要る。

## 参考 URL

- https://support.google.com/googlenest/answer/16618650
- https://support.google.com/googlenest/answer/16722329
- https://blog.google/products-and-platforms/devices/google-nest/gemini-home-voice-assistant-tips/
- https://www.watch.impress.co.jp/docs/news/2100364.html
- https://helentech.jp/news-77341/
- https://9to5google.com/2026/08/25/google-home-keep-integration-broken-due-to-bug/
- https://tech.yahoo.com/ai/articles/gemini-google-home-needs-changes-100310307.html（第三者の記事）
- https://workalizer.com/insights/gemini/gemini-and-google-tasks-navigating-intermittent-issues-with-voice-reminders-in-google-workspace/（第三者の記事）
- https://developers.google.com/workspace/keep/api/guides
- https://developers.google.com/workspace/tasks/limits
- https://developers.google.com/identity/protocols/oauth2
- https://9to5google.com/2022/08/02/google-assistant-ifttt/（第三者の記事）
- https://developer.amazon.com/en-US/docs/alexa/ask-overviews/deprecated-features.html
- https://developer.amazon.com/en-US/docs/alexa/custom-skills/skills-beta-testing-for-alexa-skills.html
- https://developer.amazon.com/en-US/docs/alexa/hosted-skills/build-a-skill-end-to-end-using-an-alexa-hosted-skill.html
- https://developer.amazon.com/blogs/alexa/post/a2716002-0f50-4587-b038-31ce631c0c07/enhance-speech-recognition-of-your-alexa-skills-with-phrase-slots-and-amazon-searchquery
- https://press.aboutamazon.com/jp/2026/10/amazon-launches-alexa-its-generative-ai-powered-next-generation-personal-assistant-in-japan
- https://support.apple.com/en-ca/guide/shortcuts/apd43b69f337/ios
- https://gist.github.com/oaustegard/79d704d5359dee8617e41d0b10651fda（第三者）
- https://developers.cloudflare.com/workers-ai/platform/pricing/
- https://firt.dev/ios-14.5/（第三者）
- https://blog.addpipe.com/apple-speechanalyzer-api/（第三者）
- https://github.com/mdn/browser-compat-data/blob/main/manifests/webapp/share_target.json

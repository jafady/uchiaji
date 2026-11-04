# 調査

tsukurou のコンセプトと要件の根拠になる事実を、カテゴリ別に置く。ここから導いた示唆は [requirements/lessons.md](../requirements/lessons.md) にまとめる。

## カテゴリ

| ファイル | 内容 |
|---|---|
| [landscape.md](landscape.md) | 全体像：各サービスのコンセプト・対象ユーザ・重心と、空白地帯 |
| [recipe-media.md](recipe-media.md) | レシピサイト・メディア（作り手側）のプロフィール |
| [user-tools.md](user-tools.md) | 使う側の道具（レシピ管理アプリ）のプロフィール、活かす要素と反面教師 |
| [case-studies.md](case-studies.md) | 事例：クックパッドへの反発、レシピブログの終了、Recipeasly の閉鎖 |
| [import-sources.md](import-sources.md) | 取り込み元：構造化データの有無と品質 |
| [legal.md](legal.md) | 利用規約・robots.txt・著作権 |
| [cooking-ux.md](cooking-ux.md) | 調理中の UX のベストプラクティス |
| [hosting.md](hosting.md) | 実行基盤：ホスティング・DB・認証の無料枠と構成案 |
| [ai-services.md](ai-services.md) | AI サービス：料金、無料枠、データの扱い、用途ごとのおすすめ |
| [voice-input.md](voice-input.md) | 声で残す手段：スマートスピーカー、ショートカット、アプリ内録音 |
| [knowledge-sources.md](knowledge-sources.md) | 下処理・コツの知識源（番組・メーカー・公的機関）の形式と、読み取りの手段 |
| [naming.md](naming.md) | 名前の候補と、GitHub・アプリストア・ドメインでの重なり |

## 書き方のルール

- 調査を追加するときは、ファイルの末尾に足さずに、該当するカテゴリの該当箇所を更新する。どこにも当てはまらない場合は、カテゴリを増やす。
- 1 つのサービスの情報は、そのサービスのプロフィール（`recipe-media.md` / `user-tools.md`）に集める。横断的な比較は `landscape.md` に置く。
- 事実の出所を区別して書く。

  | 表記 | 意味 |
  |---|---|
  | 【事実】 | 出典あり |
  | 【声】 | 利用者のレビュー・発言 |
  | 【推測】 | 筆者の解釈 |

  確認できなかったことは「未確認」と書く。
- 価格や状況は変わるため、調べた日付を残す。

## 更新履歴

| 日付 | 内容 |
|---|---|
| 2026-10-04 | 初版。全体像、日本のレシピサイト、使う側の道具、クックパッドとレシピブログの事例、取り込み元の構造化データ、規約、調理中の UX |
| 2026-10-04 | Mela のデザインと調理モードを追加調査（user-tools.md、cooking-ux.md） |
| 2026-11-02 | 実行基盤の無料枠と構成案を追加（hosting.md） |
| 2026-11-02 | 家族での共有と私的複製、利用規約の再確認を追加（legal.md） |
| 2026-11-02 | AI サービスの比較を追加（ai-services.md） |
| 2026-11-02 | 声で残す手段を追加（voice-input.md）。下処理・コツの知識源と読み取りを追加（knowledge-sources.md、recipe-media.md のトリセツショー） |
| 2026-11-04 | 名前の候補の重なりを追加（naming.md） |

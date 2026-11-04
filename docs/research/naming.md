# 名前の候補と重なり

調査日：2026-11-04

公開リポジトリとして作り直す可能性があるため、名前を付け直す（[concept.md](../concept.md) の「体験の核」）。候補ごとに、既存のものと紛らわしくないか、検索で埋もれないかを調べた。商標の記述は一般論で、法的な助言ではない。

## 候補と結果

判定は【推測】で、紛らわしさと検索での埋もれにくさに照らしたもの。

| 候補 | 込めた意味 | GitHub | アプリストア | 国内の同名 | ドメイン（.com／.app／.dev） | 判定 |
|---|---|---|---|---|---|---|
| uchiaji（うちあじ） | うちの味 | 【事実】リポジトリ名に含むものは 0 件。近いものは `bokko-chan/uchino_aji` だけ | 【事実】App Store（日本・米国）、Google Play（日本）に同名・近い名前なし | 【事実】同名の商品・店・ブランドは見つからない | 【事実】すべて未登録（RDAP の応答が 404。2026-11-04 に再確認） | ◎ |
| itsunoma（いつのま） | 体験の軸の「いつのまにか」 | 【事実】1 件（個人の静的サイト、スター 0） | 【事実】同名なし。似た綴りの「itsumo」系が上位に出る | 【事実】見つからない | 【事実】.com は登録済み。.app と .dev は未登録 | ○ |
| najimu（なじむ） | 「味がなじむ」「うちになじむ」 | 【事実】料理系はない | 【事実】najimu.app に、AI で服装を判定する iOS アプリ「NAJIMU」（キャッチは「その場に、馴染む。」、近日公開）がある（2026-11-04 に確認） | 【事実】料理系の同名ブランドはない | 【事実】.com と .app は登録済み。.dev は未登録 | △ |
| meguri（めぐり） | 旬がめぐる、出会いのめぐり合わせ | 【事実】202 件。レシピ型ビジネス向けの基盤 `heartnet123/Meguri` もある | 【事実】「〜めぐり」のアプリが多数 | 【事実】ジェラート店、和菓子店、アプリ基盤「MGRe（メグリ）」など | 【事実】すべて登録済み | × |
| kakitome（かきとめ） | 食卓のひとことを書き留める | 【事実】7 件。同名のメモアプリのリポジトリがある | 【事実】同名のメモアプリが両ストアにある。Google Play では郵便局のアプリも上位に出る | 【事実】「書留（郵便）」と同音 | 【事実】.com と .app は使用中。.dev は未登録 | × |

## 気になった点

- 【推測】najimu は、公開後の App Store で、服装判定アプリ NAJIMU と正面から重なる。
- 【推測】uchiaji は「うちの味」をそのまま言う。わかりやすいが、軸の「いつのまにか」の時間感覚は名前に出ない。itsunoma はその逆で、余韻はあるが、料理のアプリだとは伝わりにくい。
- 【事実】meguri の名前のアプリ基盤 MGRe は、料理家の会社の公式アプリに採用されたと報じられている（PR TIMES）。料理とアプリの文脈で混同されうる。

## 未確認

- 商標（5 候補すべて）。J-PlatPat は画面操作が前提で、取得による確認ができなかった。アプリストアに出す前に、第 9 類・第 42 類・第 43 類・第 29 類・第 30 類で称呼検索をすることを勧める。
- 登録済みドメインの運営内容（najimu.com、itsunoma.com、meguri.com など）。
- NAJIMU アプリの公開日、運営者、商標の出願の有無。
- X・Instagram の同名アカウント。
- 英語圏での響き（ネイティブ話者には未確認）。

## 参考 URL

- https://api.github.com/search/repositories?q=meguri+in:name（GitHub Search API の例）
- https://github.com/heartnet123/Meguri
- https://github.com/Suyama-Daichi/kakitome
- https://github.com/kikunantoka/itsunomanika
- https://github.com/bokko-chan/uchino_aji
- https://itunes.apple.com/search?term=kakitome&country=jp&entity=software（iTunes Search API の例）
- https://play.google.com/store/search?q=kakitome&c=apps&hl=ja&gl=JP
- https://najimu.app
- https://kakitome.app
- https://kakitome.com
- https://rdap.verisign.com/com/v1/domain/uchiaji.com
- https://pubapi.registry.google/rdap/domain/uchiaji.app
- https://prtimes.jp/main/html/rd/p/000000003.000186678.html
- https://www.j-platpat.inpit.go.jp/

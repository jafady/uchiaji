# 取り込み元

取り込み元の候補となるサイトについて、構造化データ（schema.org Recipe）の有無と品質を確かめた結果。規約面は [legal.md](legal.md) を参照。

## 調査方法

- 調査日：2026-10-04
- 各サイトのレシピページを 1 件ずつ curl で取得し、JSON-LD と microdata を確認した。
- JavaScript で後から描画される内容は対象外。
- サンプルは 1 件だけなので、サイト全体の傾向は推測になる。

## 一覧

| サイト | 種別 | 構造化データ | 材料・手順 | 備考 |
|---|---|---|---|---|
| クックパッド | レシピサイト | JSON-LD Recipe | あり | |
| クラシル | レシピサイト | JSON-LD Recipe | あり | |
| DELISH KITCHEN | レシピサイト | JSON-LD Recipe | あり | |
| Nadia | レシピサイト | JSON-LD Recipe | あり | |
| E・レシピ | レシピサイト | JSON-LD Recipe | あり | |
| macaroni | 食メディア | JSON-LD Recipe | なし | 型だけがある。HTML の解析が必要 |
| 白ごはん.com | レシピサイト | microdata Recipe | なし | 名前と説明程度しかない。HTML の解析が必要 |
| ホクト | 食材メーカー | なし | — | HTML に材料と作り方がある。【A】のように調味料をまとめる表記がある |
| キッコーマン | 調味料 | JSON-LD Recipe | あり | 良好。著者・栄養・時間もある |
| 味の素パーク | 調味料 | JSON-LD Recipe | あり | 手順は文字列の配列 |
| ミツカン | 調味料 | JSON-LD Recipe | あり | 手順がまとめて 1 件に入っている。JSON に制御文字が混じり、厳密なパーサーでは失敗する |
| ヤマサ | 調味料 | microdata Recipe | あり | |
| キユーピー | 調味料 | JSON-LD Recipe | 一部 | 材料に分量がない。手順がない |
| ティファール | 調理器具 | なし | — | HTML に材料と分量がある |
| ル・クルーゼ | 調理器具 | microdata Recipe | あり | 旧形式の `ingredients` |
| STAUB（ツヴィリング） | 調理器具 | なし | — | HTML にある。使う鍋の記載がある |
| タイガー | 調理器具 | なし | — | HTML にある |
| 象印 | 調理器具 | なし | — | STAN. のレシピは JavaScript で描画される |
| みんなのきょうの料理 | 料理番組（NHK） | JSON-LD Recipe | あり | 良好。著者に料理家名が入る |
| キユーピー3分クッキング | 料理番組 | JSON-LD Recipe | あり | 良好。著者に講師名が入る |
| トリセツショー | 番組（NHK） | なし | — | レシピは PDF「読むトリセツ」に載っている |

## 傾向

- **レシピサイトと料理番組**：構造化データを持っていることが多く、品質も良い。
- **調味料メーカー**：構造化データを持っていることが多い。ただし品質にばらつきがあり、分量がない、手順がまとめて 1 件に入っている、JSON が壊れている、といった例がある。
- **食材メーカー・調理器具メーカー**：構造化データを持っていない例が多い。HTML の解析か、LLM による抽出が必要になる。

## 取り込みの実装で考慮すること

- 構造化データを先に試し、失敗したら HTML の解析か AI で補う二段構えにする（Mela 方式。[user-tools.md](user-tools.md)）。
- JSON の制御文字のような壊れ方を許容するパーサーにする。
- 手順が 1 件にまとめて入っている場合に備え、番号（`[1]` など）で分割する。
- 「【A】」のような調味料のグループ表記は、部品化（領域 3）の手がかりになる。
- 参考になるライブラリ：recipe-scrapers（Python、Mealie が使っている）。日本のサイトへの対応状況は未確認。

## 参考 URL（確認したページ）

- https://www.hokto-kinoko.co.jp/kinokorecipe/recipedetail/?id=3282
- https://www.kikkoman.co.jp/homecook/search/recipe/00001619/
- https://park.ajinomoto.co.jp/recipe/card/701794/
- https://www.mizkan.co.jp/ouchirecipe/recipe/?menu_id=13632
- https://recipe.yamasa.com/recipes/247
- https://www.kewpie.co.jp/recipes/recipe/QP00010453/
- https://www.t-fal.co.jp/cooking-appliances/handblenders/recipe/8142_01/
- https://www.lecreuset.co.jp/recipe/recipe/potaufeu/
- https://www.zwilling.com/jp/cocotte-recipes/steamed-new-potatoes-staub.html
- https://www.tiger-corporation.com/ja/jpn/feature/recipe/post25/
- https://www.zojirushi.co.jp/recipe/jar/syousai/rice_chakin.html
- https://www.kyounoryouri.jp/recipe/41462_ピーマンの肉詰め.html
- https://www.ntv.co.jp/3min/recipe/20261002/

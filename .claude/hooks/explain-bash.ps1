# PreToolUse hook: Bash コマンドの承認前に「意図」と「警告」をユーザーへ表示する。
# stdin から tool_input(JSON) を受け取り、systemMessage を出力する。
# モデルが書く description には依存せず、コマンド文字列を独自ロジックで解析する。

$ErrorActionPreference = 'Stop'

# stdin/stdout を UTF-8 に固定（日本語・絵文字の文字化け防止）
[Console]::InputEncoding  = [System.Text.UTF8Encoding]::new($false)
[Console]::OutputEncoding = [System.Text.UTF8Encoding]::new($false)

function Write-Json([string]$s) {
    [Console]::Out.Write($s)
    exit 0
}

function Write-Empty {
    # 何も表示しない（安全な読み取り専用コマンド等）
    Write-Json '{}'
}

try {
    $raw = [Console]::In.ReadToEnd()
    if ([string]::IsNullOrWhiteSpace($raw)) { Write-Empty }

    $json = $raw | ConvertFrom-Json
    $cmd  = [string]$json.tool_input.command
    $desc = [string]$json.tool_input.description
    if ([string]::IsNullOrWhiteSpace($cmd)) { Write-Empty }
}
catch {
    # 解析に失敗しても実行フローは止めない
    Write-Empty
}

# --- 危険パターン検出（コマンド全体を走査） --------------------------------
# 複合コマンド (cd x && rm y) でも rm を拾えるよう、全文に対して照合する。
$riskRules = [ordered]@{
    'git\s+push'                       = 'git push: リモートへ反映されます'
    'git\s+commit'                     = 'git commit: 履歴に記録されます'
    'git\s+reset\s+--hard'             = 'git reset --hard: 未コミット変更が失われます'
    'git\s+clean'                      = 'git clean: 追跡外ファイルが削除されます'
    'git\s+rebase'                     = 'git rebase: 履歴が書き換わります'
    '--force|-f\b(?!.*grep)'           = 'force/強制フラグ: 上書き・不可逆の可能性'
    '\brm\b|\brmdir\b|Remove-Item'     = 'ファイル/ディレクトリ削除'
    '\bmv\b|Move-Item'                 = 'ファイル移動/リネーム（上書きの可能性）'
    '>\s*\S|>>'                        = 'リダイレクト: ファイルへ書き込み/上書き'
    '\bcurl\b|\bwget\b|Invoke-WebRequest|Invoke-RestMethod|\biwr\b|\birm\b\s+http' = '外部ネットワーク通信'
    '\bsudo\b'                         = 'sudo: 権限昇格'
    '\bchmod\b|\bchown\b'              = '権限/所有者の変更'
    'kubectl\s+(apply|delete)'         = 'Kubernetes リソースの変更/削除'
    'terraform\s+(apply|destroy)'      = 'IaC の適用/破棄'
    'az\s+(deployment|role)'           = 'Azure デプロイ/権限操作'
    '(npm|pnpm)\s+(install|add|publish)|pip\s+install|uv\s+add' = '依存パッケージの追加/変更'
    'DROP\s+TABLE|DELETE\s+FROM|TRUNCATE' = 'DB データ破壊系 SQL'
    '\bdd\b|mkfs|Format-Volume'        = 'ディスク破壊的操作'
}

$warnings = @()
foreach ($pat in $riskRules.Keys) {
    if ($cmd -match $pat) { $warnings += $riskRules[$pat] }
}

# --- 意図の分類（先頭トークン） --------------------------------------------
$first = ($cmd.TrimStart() -split '\s+')[0]
$leaf  = ($first -split '[\\/]')[-1] -replace '\.exe$',''
switch -Regex ($leaf) {
    '^git$'        { $intent = 'Git 操作' }
    '^gh$'         { $intent = 'GitHub CLI 操作' }
    '^make$'       { $intent = 'ビルド/テスト/Lint (make)' }
    '^uv$'         { $intent = 'Python (uv) 実行' }
    '^(npm|pnpm|npx)$' { $intent = 'Node.js パッケージ操作' }
    '^docker'      { $intent = 'Docker 操作' }
    '^kubectl$'    { $intent = 'Kubernetes 操作' }
    '^terraform$'  { $intent = 'Terraform (IaC) 操作' }
    '^az$'         { $intent = 'Azure CLI 操作' }
    '^curl$'       { $intent = 'Web ページの取得（調査）' }
    '^(ls|cat|grep|rg|find|head|tail|wc|pwd|which|where)$' { $intent = 'ファイル閲覧/検索' }
    default        { $intent = 'コマンド実行' }
}

# --- 安全な読み取り専用コマンドは無音 --------------------------------------
$safePattern = '^(git\s+(status|diff|log|show)|ls|pwd|cat|echo|grep|rg|find|head|tail|wc|which|where|command\s+-v|git\s+branch\s+-vv|gh\s+(auth\s+status|repo\s+view|pr\s+view))\b'
if ($warnings.Count -eq 0 -and $cmd.TrimStart() -match $safePattern) {
    Write-Empty
}

# --- メッセージ組み立て ------------------------------------------------------
$lines = @()
$lines += "📋 意図: $intent"
if (-not [string]::IsNullOrWhiteSpace($desc)) {
    $lines += "📝 Claudeの説明: $desc"
}
if ($warnings.Count -gt 0) {
    $lines += "⚠️ 注意:"
    foreach ($w in ($warnings | Select-Object -Unique)) { $lines += "   - $w" }
}
$lines += "💻 コマンド: $cmd"

$out = @{
    hookSpecificOutput = @{ hookEventName = 'PreToolUse' }
    systemMessage      = ($lines -join "`n")
}
Write-Json ($out | ConvertTo-Json -Depth 5 -Compress)

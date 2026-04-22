param(
  [string]$Mensagem = ""
)

$ErrorActionPreference = "Stop"

$Root = Split-Path -Parent $PSScriptRoot
$Git = "C:\Program Files\Git\cmd\git.exe"

if (-not (Test-Path $Git)) {
  $GitCmd = Get-Command git -ErrorAction SilentlyContinue
  if (-not $GitCmd) {
    throw "Git nao encontrado. Instale o Git ou ajuste o caminho no script scripts/publicar.ps1."
  }
  $Git = $GitCmd.Source
}

if ([string]::IsNullOrWhiteSpace($Mensagem)) {
  $Mensagem = "Atualiza Check da Folha IA"
}

Set-Location $Root

Copy-Item -LiteralPath (Join-Path $Root "hub_rh_v7.html") -Destination (Join-Path $Root "index.html") -Force

& $Git add hub_rh_v7.html index.html README.md CHANGELOG.md .gitignore .github scripts

$Status = & $Git status --porcelain
if (-not $Status) {
  Write-Host "Nada novo para publicar."
  exit 0
}

& $Git commit -m $Mensagem
& $Git push

Write-Host "Publicado no GitHub com sucesso."

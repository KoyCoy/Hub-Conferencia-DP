$ErrorActionPreference = "Stop"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RepoRoot = Split-Path -Parent (Split-Path -Parent $ScriptDir)
$HtmlPath = Join-Path $RepoRoot "index.html"

if (-not (Test-Path -LiteralPath $HtmlPath)) {
  $HtmlPath = Join-Path $RepoRoot "hub_rh_v7.html"
}
if (-not (Test-Path -LiteralPath $HtmlPath)) {
  throw "Arquivo do Check Folha nao encontrado em: $RepoRoot"
}

$EdgeCandidates = @(
  "${env:ProgramFiles(x86)}\Microsoft\Edge\Application\msedge.exe",
  "$env:ProgramFiles\Microsoft\Edge\Application\msedge.exe",
  "$env:LOCALAPPDATA\Microsoft\Edge\Application\msedge.exe"
) | Where-Object { $_ -and (Test-Path -LiteralPath $_) }

if (-not $EdgeCandidates -or $EdgeCandidates.Count -eq 0) {
  Start-Process -FilePath $HtmlPath
  exit
}

$EdgeExe = $EdgeCandidates | Select-Object -First 1
$ProfileDir = Join-Path $env:LOCALAPPDATA "CheckFolha\DesktopProfile"
New-Item -ItemType Directory -Force -Path $ProfileDir | Out-Null

$HtmlUri = (New-Object System.Uri($HtmlPath)).AbsoluteUri

$Args = @(
  "--app=$HtmlUri",
  "--user-data-dir=$ProfileDir",
  "--no-first-run",
  "--disable-features=msEdgeNonDefaultBrowserTrigger"
)

Start-Process -FilePath $EdgeExe -ArgumentList $Args

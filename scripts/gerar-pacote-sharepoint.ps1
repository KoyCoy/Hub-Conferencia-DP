$ErrorActionPreference = "Stop"

$ScriptDir = $PSScriptRoot
$RepoRoot = Split-Path -Parent $ScriptDir
$PackageRoot = Join-Path $RepoRoot "dist\sharepoint\CheckDaFolhaIA-SharePoint"
$ZipPath = Join-Path $RepoRoot "dist\sharepoint\CheckDaFolhaIA-SharePoint.zip"

if (Test-Path -LiteralPath $PackageRoot) {
  Remove-Item -LiteralPath $PackageRoot -Recurse -Force
}
New-Item -ItemType Directory -Force -Path $PackageRoot | Out-Null
New-Item -ItemType Directory -Force -Path (Join-Path $PackageRoot "assets\icons") | Out-Null

$Files = @(
  "index.html",
  "hub_rh_v7.html",
  "manifest.webmanifest",
  "service-worker.js",
  "sharepoint\README.md",
  "sharepoint\INSTALAR-APP.md"
)

foreach ($File in $Files) {
  $Source = Join-Path $RepoRoot $File
  if (-not (Test-Path -LiteralPath $Source)) {
    throw "Arquivo obrigatorio nao encontrado: $File"
  }
  $Destination = Join-Path $PackageRoot $File
  New-Item -ItemType Directory -Force -Path (Split-Path -Parent $Destination) | Out-Null
  Copy-Item -LiteralPath $Source -Destination $Destination -Force
}

Copy-Item -LiteralPath (Join-Path $RepoRoot "assets\icons\check-da-folha-ia-192.png") -Destination (Join-Path $PackageRoot "assets\icons\check-da-folha-ia-192.png") -Force
Copy-Item -LiteralPath (Join-Path $RepoRoot "assets\icons\check-da-folha-ia-512.png") -Destination (Join-Path $PackageRoot "assets\icons\check-da-folha-ia-512.png") -Force

if (Test-Path -LiteralPath $ZipPath) {
  Remove-Item -LiteralPath $ZipPath -Force
}
Compress-Archive -Path (Join-Path $PackageRoot "*") -DestinationPath $ZipPath -Force

Write-Host "Pacote SharePoint gerado em: $ZipPath"

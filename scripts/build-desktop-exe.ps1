$ErrorActionPreference = "Stop"

$ScriptDir = $PSScriptRoot
$RepoRoot = Split-Path -Parent $ScriptDir
$NativeRoot = Join-Path $RepoRoot "desktop\native"
$PackageVersion = "1.0.2792.45"
$PackageDir = Join-Path $NativeRoot "packages\Microsoft.Web.WebView2.$PackageVersion"
$PackageFile = Join-Path $NativeRoot "packages\Microsoft.Web.WebView2.$PackageVersion.nupkg"
$PackageUrl = "https://www.nuget.org/api/v2/package/Microsoft.Web.WebView2/$PackageVersion"
$DistRoot = Join-Path $RepoRoot "dist\desktop"
$AppDist = Join-Path $DistRoot "HubRH-Windows"
$ZipPath = Join-Path $DistRoot "HubRH-Windows.zip"
$Csc = "C:\Windows\Microsoft.NET\Framework64\v4.0.30319\csc.exe"

if (-not (Test-Path -LiteralPath $Csc)) {
  throw "Compilador C# nao encontrado: $Csc"
}

New-Item -ItemType Directory -Force -Path (Split-Path -Parent $PackageFile) | Out-Null
if (-not (Test-Path -LiteralPath $PackageFile)) {
  Invoke-WebRequest -Uri $PackageUrl -OutFile $PackageFile
}

if (-not (Test-Path -LiteralPath $PackageDir)) {
  New-Item -ItemType Directory -Force -Path $PackageDir | Out-Null
  Add-Type -AssemblyName System.IO.Compression.FileSystem
  [System.IO.Compression.ZipFile]::ExtractToDirectory($PackageFile, $PackageDir)
}

$WebViewLib = Join-Path $PackageDir "lib\net462"
$WebViewNative = Join-Path $PackageDir "runtimes\win-x64\native\WebView2Loader.dll"
$Source = Join-Path $NativeRoot "src\Program.cs"

foreach ($Required in @(
  $Source,
  (Join-Path $WebViewLib "Microsoft.Web.WebView2.Core.dll"),
  (Join-Path $WebViewLib "Microsoft.Web.WebView2.WinForms.dll"),
  $WebViewNative
)) {
  if (-not (Test-Path -LiteralPath $Required)) {
    throw "Arquivo necessario nao encontrado: $Required"
  }
}

if (Test-Path -LiteralPath $AppDist) {
  Remove-Item -LiteralPath $AppDist -Recurse -Force
}
New-Item -ItemType Directory -Force -Path $AppDist | Out-Null
New-Item -ItemType Directory -Force -Path (Join-Path $AppDist "app\assets\icons") | Out-Null

$ExePath = Join-Path $AppDist "HubRH.exe"

& $Csc `
  /nologo `
  /target:winexe `
  /platform:x64 `
  /out:$ExePath `
  /reference:System.dll `
  /reference:System.Core.dll `
  /reference:System.Drawing.dll `
  /reference:System.Windows.Forms.dll `
  /reference:"$(Join-Path $WebViewLib 'Microsoft.Web.WebView2.Core.dll')" `
  /reference:"$(Join-Path $WebViewLib 'Microsoft.Web.WebView2.WinForms.dll')" `
  $Source

if ($LASTEXITCODE -ne 0) {
  throw "Falha ao compilar HubRH.exe"
}

Copy-Item -LiteralPath (Join-Path $WebViewLib "Microsoft.Web.WebView2.Core.dll") -Destination $AppDist -Force
Copy-Item -LiteralPath (Join-Path $WebViewLib "Microsoft.Web.WebView2.WinForms.dll") -Destination $AppDist -Force
Copy-Item -LiteralPath $WebViewNative -Destination $AppDist -Force

$AppFiles = @(
  "index.html",
  "hub_rh_v7.html",
  "manifest.webmanifest",
  "service-worker.js"
)

foreach ($File in $AppFiles) {
  Copy-Item -LiteralPath (Join-Path $RepoRoot $File) -Destination (Join-Path $AppDist "app\$File") -Force
}
Copy-Item -LiteralPath (Join-Path $RepoRoot "assets\icons\hub-rh-192.png") -Destination (Join-Path $AppDist "app\assets\icons\hub-rh-192.png") -Force
Copy-Item -LiteralPath (Join-Path $RepoRoot "assets\icons\hub-rh-512.png") -Destination (Join-Path $AppDist "app\assets\icons\hub-rh-512.png") -Force

if (Test-Path -LiteralPath $ZipPath) {
  Remove-Item -LiteralPath $ZipPath -Force
}
Compress-Archive -Path (Join-Path $AppDist "*") -DestinationPath $ZipPath -Force

Write-Host "EXE gerado em: $ExePath"
Write-Host "Pacote ZIP gerado em: $ZipPath"

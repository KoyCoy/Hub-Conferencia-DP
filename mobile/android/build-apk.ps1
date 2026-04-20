$ErrorActionPreference = "Stop"

$VersionName = "1.0.0"
$VersionCode = "1"
$PackageName = "br.com.koycoy.hubrh"

$SourceProjectDir = $PSScriptRoot
$RepoRoot = Split-Path -Parent (Split-Path -Parent $SourceProjectDir)
$StageRoot = Join-Path $env:TEMP "hubrh_android_build"
$ProjectDir = $StageRoot
$Sdk = Join-Path $env:LOCALAPPDATA "Android\Sdk"
$BuildTools = Join-Path $Sdk "build-tools\35.0.0"
$AndroidJar = Join-Path $Sdk "platforms\android-35\android.jar"
$JbrBin = "C:\Program Files\Android\Android Studio\jbr\bin"

$Aapt2 = Join-Path $BuildTools "aapt2.exe"
$D8 = Join-Path $BuildTools "d8.bat"
$Zipalign = Join-Path $BuildTools "zipalign.exe"
$ApkSigner = Join-Path $BuildTools "apksigner.bat"
$Javac = Join-Path $JbrBin "javac.exe"
$Jar = Join-Path $JbrBin "jar.exe"
$Keytool = Join-Path $JbrBin "keytool.exe"

foreach ($Tool in @($Aapt2, $D8, $Zipalign, $ApkSigner, $Javac, $Jar, $Keytool, $AndroidJar)) {
  if (-not (Test-Path $Tool)) {
    throw "Ferramenta Android/JDK nao encontrada: $Tool"
  }
}

$env:JAVA_HOME = "C:\Program Files\Android\Android Studio\jbr"
$env:PATH = "$JbrBin;$env:PATH"

function Invoke-Tool {
  param(
    [string]$FilePath,
    [string[]]$Arguments
  )
  & $FilePath @Arguments
  if ($LASTEXITCODE -ne 0) {
    throw "Falha ao executar: $FilePath $($Arguments -join ' ')"
  }
}

if (Test-Path $StageRoot) {
  Remove-Item -LiteralPath $StageRoot -Recurse -Force
}
New-Item -ItemType Directory -Force -Path $StageRoot | Out-Null
Copy-Item -LiteralPath (Join-Path $SourceProjectDir "AndroidManifest.xml") -Destination $StageRoot -Force
Copy-Item -LiteralPath (Join-Path $SourceProjectDir "res") -Destination $StageRoot -Recurse -Force
Copy-Item -LiteralPath (Join-Path $SourceProjectDir "src") -Destination $StageRoot -Recurse -Force

$AssetsDir = Join-Path $ProjectDir "assets"
$BuildDir = Join-Path $ProjectDir "build"
$DistDir = Join-Path $SourceProjectDir "dist"
$SourceKeystoreDir = Join-Path $SourceProjectDir "keystore"
$SourceKeystore = Join-Path $SourceKeystoreDir "hub-rh-internal.jks"
$StageKeystoreDir = Join-Path $ProjectDir "keystore"
$Keystore = Join-Path $StageKeystoreDir "hub-rh-internal.jks"
$StorePass = "hubrh-internal-2026"
$Alias = "hubrh"

New-Item -ItemType Directory -Force -Path $AssetsDir, $BuildDir, $DistDir, $SourceKeystoreDir, $StageKeystoreDir | Out-Null
Copy-Item -LiteralPath (Join-Path $RepoRoot "hub_rh_v7.html") -Destination (Join-Path $AssetsDir "hub_rh_v7.html") -Force
if (Test-Path $SourceKeystore) {
  Copy-Item -LiteralPath $SourceKeystore -Destination $Keystore -Force
}

if (Test-Path $BuildDir) {
  Remove-Item -LiteralPath $BuildDir -Recurse -Force
}
New-Item -ItemType Directory -Force -Path $BuildDir | Out-Null

$Compiled = Join-Path $BuildDir "compiled.zip"
$Gen = Join-Path $BuildDir "gen"
$Classes = Join-Path $BuildDir "classes"
$Dex = Join-Path $BuildDir "dex"
$ClassesJar = Join-Path $BuildDir "classes.jar"
$UnsignedApk = Join-Path $BuildDir "hub-rh-unsigned.apk"
$AlignedApk = Join-Path $BuildDir "hub-rh-aligned.apk"
$FinalApk = Join-Path $DistDir "hub-rh-$VersionName.apk"

New-Item -ItemType Directory -Force -Path $Gen, $Classes, $Dex | Out-Null

Invoke-Tool $Aapt2 @("compile", "--dir", (Join-Path $ProjectDir "res"), "-o", $Compiled)
Invoke-Tool $Aapt2 @(
  "link",
  "-o", $UnsignedApk,
  "-I", $AndroidJar,
  "--manifest", (Join-Path $ProjectDir "AndroidManifest.xml"),
  "-R", $Compiled,
  "--java", $Gen,
  "--auto-add-overlay",
  "--min-sdk-version", "23",
  "--target-sdk-version", "35",
  "--version-code", $VersionCode,
  "--version-name", $VersionName,
  "-A", $AssetsDir
)

$JavaFiles = @(
  (Join-Path $ProjectDir "src\br\com\koycoy\hubrh\MainActivity.java"),
  (Join-Path $Gen "br\com\koycoy\hubrh\R.java")
)

$JavacArgs = @("-encoding", "UTF-8", "-source", "8", "-target", "8", "-classpath", $AndroidJar, "-d", $Classes) + $JavaFiles
Invoke-Tool $Javac $JavacArgs
Invoke-Tool $Jar @("cf", $ClassesJar, "-C", $Classes, ".")
Invoke-Tool $D8 @("--release", "--lib", $AndroidJar, "--output", $Dex, $ClassesJar)
Invoke-Tool $Jar @("uf", $UnsignedApk, "-C", $Dex, "classes.dex")
Invoke-Tool $Zipalign @("-f", "-p", "4", $UnsignedApk, $AlignedApk)

if (-not (Test-Path $Keystore)) {
  Invoke-Tool $Keytool @(
    "-genkeypair",
    "-v",
    "-keystore", $Keystore,
    "-storepass", $StorePass,
    "-keypass", $StorePass,
    "-alias", $Alias,
    "-keyalg", "RSA",
    "-keysize", "2048",
    "-validity", "10000",
    "-dname", "CN=Hub RH Internal, OU=DP, O=KoyCoy, L=Sao Paulo, ST=SP, C=BR"
  )
  Copy-Item -LiteralPath $Keystore -Destination $SourceKeystore -Force
}

Invoke-Tool $ApkSigner @(
  "sign",
  "--ks", $Keystore,
  "--ks-key-alias", $Alias,
  "--ks-pass", "pass:$StorePass",
  "--key-pass", "pass:$StorePass",
  "--out", $FinalApk,
  $AlignedApk
)

Invoke-Tool $ApkSigner @("verify", "--verbose", $FinalApk)

Write-Host "APK gerado em: $FinalApk"

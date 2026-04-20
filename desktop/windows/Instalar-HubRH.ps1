$ErrorActionPreference = "Stop"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$Launcher = Join-Path $ScriptDir "HubRH-Launcher.ps1"

if (-not (Test-Path -LiteralPath $Launcher)) {
  throw "Launcher nao encontrado: $Launcher"
}

$PowerShellExe = Join-Path $env:WINDIR "System32\WindowsPowerShell\v1.0\powershell.exe"
$ShortcutTarget = $PowerShellExe
$ShortcutArgs = "-NoProfile -ExecutionPolicy Bypass -File `"$Launcher`""

$EdgeIcon = @(
  "${env:ProgramFiles(x86)}\Microsoft\Edge\Application\msedge.exe",
  "$env:ProgramFiles\Microsoft\Edge\Application\msedge.exe",
  "$env:LOCALAPPDATA\Microsoft\Edge\Application\msedge.exe"
) | Where-Object { $_ -and (Test-Path -LiteralPath $_) } | Select-Object -First 1

function New-HubShortcut {
  param(
    [string]$Path
  )

  $Shell = New-Object -ComObject WScript.Shell
  $Shortcut = $Shell.CreateShortcut($Path)
  $Shortcut.TargetPath = $ShortcutTarget
  $Shortcut.Arguments = $ShortcutArgs
  $Shortcut.WorkingDirectory = $ScriptDir
  $Shortcut.Description = "Hub RH - Validador de Lancamentos Manuais"
  if ($EdgeIcon) {
    $Shortcut.IconLocation = "$EdgeIcon,0"
  }
  $Shortcut.Save()
}

$Desktop = [Environment]::GetFolderPath("Desktop")
$StartMenu = Join-Path ([Environment]::GetFolderPath("Programs")) "Hub RH"
New-Item -ItemType Directory -Force -Path $StartMenu | Out-Null

New-HubShortcut -Path (Join-Path $Desktop "Hub RH.lnk")
New-HubShortcut -Path (Join-Path $StartMenu "Hub RH.lnk")

Write-Host "Hub RH instalado com sucesso."
Write-Host "Atalhos criados no Desktop e no Menu Iniciar."

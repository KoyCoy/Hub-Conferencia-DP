$ErrorActionPreference = "Stop"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$Launcher = Join-Path $ScriptDir "CheckDaFolhaIA-Launcher.ps1"

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
  $Shortcut.Description = "Check da Folha IA - Check da Folha IA"
  if ($EdgeIcon) {
    $Shortcut.IconLocation = "$EdgeIcon,0"
  }
  $Shortcut.Save()
}

$Desktop = [Environment]::GetFolderPath("Desktop")
$StartMenu = Join-Path ([Environment]::GetFolderPath("Programs")) "Check da Folha IA"
New-Item -ItemType Directory -Force -Path $StartMenu | Out-Null

New-HubShortcut -Path (Join-Path $Desktop "Check da Folha IA.lnk")
New-HubShortcut -Path (Join-Path $StartMenu "Check da Folha IA.lnk")

Write-Host "Check da Folha IA instalado com sucesso."
Write-Host "Atalhos criados no Desktop e no Menu Iniciar."

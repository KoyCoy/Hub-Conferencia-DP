$ErrorActionPreference = "Stop"

$ScriptDir = $PSScriptRoot
$RepoRoot = Split-Path -Parent $ScriptDir
$IconDir = Join-Path $RepoRoot "assets\icons"
$IcoPath = Join-Path $IconDir "check-folha.ico"

New-Item -ItemType Directory -Force -Path $IconDir | Out-Null
Add-Type -AssemblyName System.Drawing

$Size = 256
$bmp = New-Object System.Drawing.Bitmap $Size, $Size
$g = [System.Drawing.Graphics]::FromImage($bmp)
$g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias

$bg = [System.Drawing.ColorTranslator]::FromHtml('#0f172a')
$blue = [System.Drawing.ColorTranslator]::FromHtml('#38bdf8')
$white = [System.Drawing.ColorTranslator]::FromHtml('#f8fafc')

$g.Clear([System.Drawing.Color]::Transparent)

$rect = New-Object System.Drawing.RectangleF (0.08*$Size), (0.08*$Size), (0.84*$Size), (0.84*$Size)
$path = New-Object System.Drawing.Drawing2D.GraphicsPath
$radius = 0.18*$Size
$diameter = 2*$radius
$path.AddArc($rect.X, $rect.Y, $diameter, $diameter, 180, 90)
$path.AddArc($rect.Right-$diameter, $rect.Y, $diameter, $diameter, 270, 90)
$path.AddArc($rect.Right-$diameter, $rect.Bottom-$diameter, $diameter, $diameter, 0, 90)
$path.AddArc($rect.X, $rect.Bottom-$diameter, $diameter, $diameter, 90, 90)
$path.CloseFigure()
$g.FillPath((New-Object System.Drawing.SolidBrush $bg), $path)

$pen = New-Object System.Drawing.Pen $blue, (0.045*$Size)
$pen.StartCap = [System.Drawing.Drawing2D.LineCap]::Round
$pen.EndCap = [System.Drawing.Drawing2D.LineCap]::Round
$pen.LineJoin = [System.Drawing.Drawing2D.LineJoin]::Round
$points = @(
  (New-Object System.Drawing.PointF (0.29*$Size), (0.52*$Size)),
  (New-Object System.Drawing.PointF (0.43*$Size), (0.66*$Size)),
  (New-Object System.Drawing.PointF (0.72*$Size), (0.36*$Size))
)
$g.DrawLines($pen, $points)

$font = New-Object System.Drawing.Font 'Arial', (0.16*$Size), ([System.Drawing.FontStyle]::Bold), ([System.Drawing.GraphicsUnit]::Pixel)
$format = New-Object System.Drawing.StringFormat
$format.Alignment = [System.Drawing.StringAlignment]::Center
$format.LineAlignment = [System.Drawing.StringAlignment]::Center
$textRect = New-Object System.Drawing.RectangleF 0, (0.62*$Size), $Size, (0.22*$Size)
$g.DrawString('RH', $font, (New-Object System.Drawing.SolidBrush $white), $textRect, $format)

$icon = [System.Drawing.Icon]::FromHandle($bmp.GetHicon())
$fs = [System.IO.File]::Create($IcoPath)
$icon.Save($fs)
$fs.Dispose()

$icon.Dispose()
$format.Dispose()
$font.Dispose()
$pen.Dispose()
$path.Dispose()
$g.Dispose()
$bmp.Dispose()

Write-Host "Icone gerado em: $IcoPath"

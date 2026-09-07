Add-Type -AssemblyName System.Drawing

$srcPath = "C:\Users\yuang\.gemini\antigravity-ide\brain\1b92af03-44a1-44d1-b9a5-75c8b6e5cfa5\nexus_app_icon_1788789264326.jpg"
$img = [System.Drawing.Image]::FromFile($srcPath)
Write-Host "Source image size: $($img.Width) x $($img.Height)"

$targets = @{
    'mipmap-mdpi' = 48
    'mipmap-hdpi' = 72
    'mipmap-xhdpi' = 96
    'mipmap-xxhdpi' = 144
    'mipmap-xxxhdpi' = 192
}

foreach ($folder in $targets.Keys) {
    $size = $targets[$folder]
    $destDir = "c:\Users\yuang\Projects\NEXUS Study\flutter_app\android\app\src\main\res\$folder"
    $destPath = Join-Path $destDir "ic_launcher.png"
    $destBitmap = New-Object System.Drawing.Bitmap($size, $size)
    $graphics = [System.Drawing.Graphics]::FromImage($destBitmap)
    $graphics.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
    $graphics.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
    $graphics.DrawImage($img, 0, 0, $size, $size)
    $graphics.Dispose()
    $destBitmap.Save($destPath, [System.Drawing.Imaging.ImageFormat]::Png)
    $destBitmap.Dispose()
    Write-Host "Saved $destPath ($size x $size)"
}

$img.Dispose()
Write-Host "All launcher icons generated successfully!"

# 本地预览（无需全局安装 Hugo）
$Hugo = Join-Path $PSScriptRoot ".tools\hugo\hugo.exe"
if (-not (Test-Path $Hugo)) {
    Write-Host "未找到 Hugo，正在下载..."
    $dest = Join-Path $PSScriptRoot ".tools\hugo"
    New-Item -ItemType Directory -Force -Path $dest | Out-Null
    $zip = Join-Path $dest "hugo.zip"
    $url = "https://github.com/gohugoio/hugo/releases/download/v0.139.4/hugo_0.139.4_windows-amd64.zip"
    Invoke-WebRequest -Uri $url -OutFile $zip -UseBasicParsing
    Expand-Archive -Path $zip -DestinationPath $dest -Force
}
Set-Location $PSScriptRoot
& $Hugo server -D @args

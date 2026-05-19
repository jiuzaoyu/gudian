# 构建并上传到阿里云 OSS
# 用法:
#   .\scripts\deploy-oss.ps1 -Bucket "your-bucket" -Endpoint "oss-cn-hangzhou.aliyuncs.com"
#   .\scripts\deploy-oss.ps1 -Bucket "your-bucket" -Endpoint "oss-cn-hangzhou.aliyuncs.com" -BaseUrl "https://gudian.example.com/"

param(
    [Parameter(Mandatory = $true)]
    [string]$Bucket,
    [Parameter(Mandatory = $true)]
    [string]$Endpoint,
    [string]$BaseUrl = "",
    [switch]$SkipBuild
)

$ErrorActionPreference = "Stop"
$Root = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
Set-Location $Root

$Hugo = Join-Path $Root ".tools\hugo\hugo.exe"
if (-not (Test-Path $Hugo)) {
    $HugoCmd = Get-Command hugo -ErrorAction SilentlyContinue
    if ($HugoCmd) { $Hugo = $HugoCmd.Source } else {
        Write-Error "未找到 Hugo。请先运行 .\serve.ps1 或安装 Hugo。"
    }
}

if (-not $SkipBuild) {
    $buildArgs = @("--minify")
    if ($BaseUrl) {
        $buildArgs += "--baseURL", $BaseUrl
        Write-Host "构建 baseURL: $BaseUrl"
    } else {
        Write-Host "未指定 -BaseUrl，使用 hugo.toml 中的 baseURL"
    }
    & $Hugo @buildArgs
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
}

$ossutil = Get-Command ossutil -ErrorAction SilentlyContinue
if (-not $ossutil) {
    Write-Error "未找到 ossutil。请安装: https://help.aliyun.com/document_detail/120075.html"
}

$target = "oss://$Bucket/"
Write-Host "上传到 $target (endpoint: $Endpoint)"
ossutil cp -r "$Root\public\" $target --update --force --endpoint $Endpoint

if ($LASTEXITCODE -eq 0) {
    Write-Host "上传完成。请在 CDN 控制台刷新缓存（若已绑定 CDN）。"
} else {
    exit $LASTEXITCODE
}

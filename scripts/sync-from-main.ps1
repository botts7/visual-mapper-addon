#
# Sync Visual Mapper from main repo to addon repo
# Usage: .\sync-from-main.ps1 [-Target stable|beta]
#
# This script copies the latest code from the main visual-mapper repo
# to either the stable (visual-mapper/) or beta (visual-mapper-beta/) folder.
#

param(
    [ValidateSet("stable", "beta")]
    [string]$Target = "beta",

    [string]$MainRepo = "..\visual-mapper"
)

$ErrorActionPreference = "Stop"

# Get addon repo root
$AddonRepo = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
if (-not $AddonRepo) {
    $AddonRepo = Split-Path -Parent $PSScriptRoot
}

# Set target directory
if ($Target -eq "stable") {
    $TargetDir = Join-Path $AddonRepo "visual-mapper"
    Write-Host "Syncing to STABLE: $TargetDir" -ForegroundColor Green
} else {
    $TargetDir = Join-Path $AddonRepo "visual-mapper-beta"
    Write-Host "Syncing to BETA: $TargetDir" -ForegroundColor Yellow
}

# Resolve main repo path
$MainRepoPath = Resolve-Path $MainRepo -ErrorAction SilentlyContinue
if (-not $MainRepoPath) {
    Write-Host "Error: Main repo not found at $MainRepo" -ForegroundColor Red
    Write-Host "Use -MainRepo parameter to specify the correct path"
    exit 1
}

Write-Host ""
Write-Host "Syncing from: $MainRepoPath"
Write-Host "Syncing to: $TargetDir"
Write-Host ""

# Sync directories
Write-Host "Syncing backend..."
Remove-Item -Path (Join-Path $TargetDir "backend") -Recurse -Force -ErrorAction SilentlyContinue
Copy-Item -Path (Join-Path $MainRepoPath "backend") -Destination $TargetDir -Recurse

Write-Host "Syncing frontend..."
Remove-Item -Path (Join-Path $TargetDir "frontend") -Recurse -Force -ErrorAction SilentlyContinue
Copy-Item -Path (Join-Path $MainRepoPath "frontend") -Destination $TargetDir -Recurse

Write-Host "Syncing config..."
Remove-Item -Path (Join-Path $TargetDir "config") -Recurse -Force -ErrorAction SilentlyContinue
$configSrc = Join-Path $MainRepoPath "config"
if (Test-Path $configSrc) {
    Copy-Item -Path $configSrc -Destination $TargetDir -Recurse
} else {
    New-Item -Path (Join-Path $TargetDir "config") -ItemType Directory -Force | Out-Null
}

Write-Host "Syncing version files..."
Copy-Item -Path (Join-Path $MainRepoPath ".build-version") -Destination $TargetDir -Force

$reqSrc = Join-Path $MainRepoPath "requirements.txt"
if (Test-Path $reqSrc) {
    Copy-Item -Path $reqSrc -Destination $TargetDir -Force
}

# Update cache bust in Dockerfile
$CacheBust = Get-Date -Format "yyyyMMddHHmm"
Write-Host "Updating CACHE_BUST to $CacheBust..."
$dockerfilePath = Join-Path $TargetDir "Dockerfile"
$content = Get-Content $dockerfilePath -Raw
$content = $content -replace "CACHE_BUST=\d+", "CACHE_BUST=$CacheBust"
Set-Content -Path $dockerfilePath -Value $content -NoNewline

Write-Host ""
Write-Host "Sync complete!" -ForegroundColor Green
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host "  1. Update version in $TargetDir\config.yaml if needed"
Write-Host "  2. git add -A && git commit -m 'Sync from main repo'"
Write-Host "  3. git push origin master"

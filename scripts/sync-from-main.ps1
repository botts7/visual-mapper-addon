#
# Sync Visual Mapper from main repo to addon repo
# Usage: .\sync-from-main.ps1 [stable|beta]
#
# This script:
# 1. Checks out the appropriate branch from main repo (main for stable, beta for beta)
# 2. Copies the latest code to the addon folder
#
# Branch mapping:
#   stable → visual-mapper:main   → visual-mapper/
#   beta   → visual-mapper:beta   → visual-mapper-beta/
#

param(
    [Parameter(Position=0)]
    [ValidateSet("stable", "beta")]
    [string]$Target = "beta",

    [string]$MainRepo = "..\Visual Mapper"
)

$ErrorActionPreference = "Stop"

# Get addon repo root
$AddonRepo = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
if (-not $AddonRepo) {
    $AddonRepo = Split-Path -Parent $PSScriptRoot
}

# Set target directory and source branch
if ($Target -eq "stable") {
    $TargetDir = Join-Path $AddonRepo "visual-mapper"
    $SourceBranch = "main"
    Write-Host "╔════════════════════════════════════════════╗" -ForegroundColor Cyan
    Write-Host "║  Syncing STABLE from branch: main          ║" -ForegroundColor Cyan
    Write-Host "╚════════════════════════════════════════════╝" -ForegroundColor Cyan
} else {
    $TargetDir = Join-Path $AddonRepo "visual-mapper-beta"
    $SourceBranch = "beta"
    Write-Host "╔════════════════════════════════════════════╗" -ForegroundColor Yellow
    Write-Host "║  Syncing BETA from branch: beta            ║" -ForegroundColor Yellow
    Write-Host "╚════════════════════════════════════════════╝" -ForegroundColor Yellow
}

# Resolve main repo path
$MainRepoPath = Resolve-Path $MainRepo -ErrorAction SilentlyContinue
if (-not $MainRepoPath) {
    Write-Host "Error: Main repo not found at $MainRepo" -ForegroundColor Red
    Write-Host "Use -MainRepo parameter to specify the correct path"
    exit 1
}

# Save current directory
$OriginalDir = Get-Location

# Checkout the correct branch in main repo
Write-Host ""
Write-Host "→ Switching main repo to branch: $SourceBranch" -ForegroundColor Green
Set-Location $MainRepoPath
git fetch origin
git checkout $SourceBranch
git pull origin $SourceBranch

# Get version from the branch
$Version = (Get-Content ".build-version" -Raw).Trim()
Write-Host "→ Version: $Version" -ForegroundColor Green

# Return to original directory
Set-Location $OriginalDir

Write-Host ""
Write-Host "Syncing from: $MainRepoPath (branch: $SourceBranch)"
Write-Host "Syncing to: $TargetDir"
Write-Host ""

# Sync directories
Write-Host "→ Syncing backend..." -ForegroundColor Green
Remove-Item -Path (Join-Path $TargetDir "backend") -Recurse -Force -ErrorAction SilentlyContinue
Copy-Item -Path (Join-Path $MainRepoPath "backend") -Destination $TargetDir -Recurse

Write-Host "→ Syncing frontend..." -ForegroundColor Green
Remove-Item -Path (Join-Path $TargetDir "frontend") -Recurse -Force -ErrorAction SilentlyContinue
Copy-Item -Path (Join-Path $MainRepoPath "frontend") -Destination $TargetDir -Recurse

Write-Host "→ Syncing config..." -ForegroundColor Green
Remove-Item -Path (Join-Path $TargetDir "config") -Recurse -Force -ErrorAction SilentlyContinue
$configSrc = Join-Path $MainRepoPath "config"
if (Test-Path $configSrc) {
    Copy-Item -Path $configSrc -Destination $TargetDir -Recurse
} else {
    New-Item -Path (Join-Path $TargetDir "config") -ItemType Directory -Force | Out-Null
}

Write-Host "→ Syncing version files..." -ForegroundColor Green
$buildVersionSrc = Join-Path $MainRepoPath ".build-version"
if (Test-Path $buildVersionSrc) {
    Copy-Item -Path $buildVersionSrc -Destination $TargetDir -Force
} else {
    Set-Content -Path (Join-Path $TargetDir ".build-version") -Value $Version
}

$reqSrc = Join-Path $MainRepoPath "requirements.txt"
if (Test-Path $reqSrc) {
    Copy-Item -Path $reqSrc -Destination $TargetDir -Force
}

# Update version in config.yaml
Write-Host "→ Updating config.yaml version to $Version..." -ForegroundColor Green
$configYamlPath = Join-Path $TargetDir "config.yaml"
if (Test-Path $configYamlPath) {
    $configContent = Get-Content $configYamlPath -Raw
    $configContent = $configContent -replace "version: .*", "version: $Version"
    Set-Content -Path $configYamlPath -Value $configContent -NoNewline
}

# Update cache bust in Dockerfile
$CacheBust = Get-Date -Format "yyyyMMddHHmm"
Write-Host "→ Updating CACHE_BUST to $CacheBust..." -ForegroundColor Green
$dockerfilePath = Join-Path $TargetDir "Dockerfile"
if (Test-Path $dockerfilePath) {
    $content = Get-Content $dockerfilePath -Raw
    $content = $content -replace "CACHE_BUST=\d+", "CACHE_BUST=$CacheBust"
    Set-Content -Path $dockerfilePath -Value $content -NoNewline
}

Write-Host ""
Write-Host "════════════════════════════════════════════════" -ForegroundColor Green
Write-Host "✓ Sync complete!" -ForegroundColor Green
Write-Host ""
Write-Host "  Target:  $TargetDir"
Write-Host "  Branch:  $SourceBranch"
Write-Host "  Version: $Version"
Write-Host "════════════════════════════════════════════════" -ForegroundColor Green
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host "  1. Review changes: git diff"
Write-Host "  2. Commit: git add -A && git commit -m 'chore: Sync $Target from $SourceBranch ($Version)'"
Write-Host "  3. Push: git push origin master"
Write-Host ""

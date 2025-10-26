#!/usr/bin/env pwsh

$ErrorActionPreference = "Stop"

Write-Host "🔍 Running pre-commit checks..." -ForegroundColor Cyan

$stagedDartFiles = git diff --cached --name-only --diff-filter=ACMR | Where-Object { $_ -match "\.dart$" }

if (-not $stagedDartFiles) {
    Write-Host "✅ No Dart files staged for commit" -ForegroundColor Green
    exit 0
}

Write-Host "📝 Staged Dart files:" -ForegroundColor Cyan
$stagedDartFiles | ForEach-Object { Write-Host "  $_" }
Write-Host ""

Write-Host "🎨 Formatting Dart files..." -ForegroundColor Cyan
foreach ($file in $stagedDartFiles) {
    if (Test-Path $file) {
        dart format $file
        git add $file
    }
}
Write-Host "✓ Formatting complete" -ForegroundColor Green
Write-Host ""

Write-Host "🔬 Running dart analyze..." -ForegroundColor Cyan
$analyzeResult = dart analyze --fatal-infos 2>&1
$analyzeExitCode = $LASTEXITCODE

if ($analyzeExitCode -eq 0) {
    Write-Host "✓ Analysis passed" -ForegroundColor Green
} else {
    Write-Host "✗ Analysis failed" -ForegroundColor Red
    Write-Host $analyzeResult
    Write-Host "Please fix the issues above before committing" -ForegroundColor Yellow
    exit 1
}
Write-Host ""

Write-Host "🔧 Checking for available fixes..." -ForegroundColor Cyan
$fixOutput = dart fix --dry-run 2>&1
if ($fixOutput -match "Nothing to fix") {
    Write-Host "✓ No fixable issues found" -ForegroundColor Green
} else {
    Write-Host "⚠  Some issues can be auto-fixed with 'dart fix --apply'" -ForegroundColor Yellow
    Write-Host $fixOutput
}
Write-Host ""

Write-Host "✅ All pre-commit checks passed!" -ForegroundColor Green
exit 0

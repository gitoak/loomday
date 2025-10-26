$hooksDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$gitHooksDir = Join-Path (git rev-parse --git-dir) "hooks"

Write-Host "📦 Installing git hooks..." -ForegroundColor Cyan

Copy-Item "$hooksDir/pre-commit" "$gitHooksDir/pre-commit" -Force
Copy-Item "$hooksDir/pre-commit.ps1" "$gitHooksDir/pre-commit.ps1" -Force

Write-Host "✅ Git hooks installed successfully!" -ForegroundColor Green
Write-Host ""
Write-Host "The pre-commit hook will now:"
Write-Host "  🎨 Format Dart files automatically"
Write-Host "  🔬 Run dart analyze"
Write-Host "  🔧 Check for available fixes"
Write-Host ""
Write-Host "To bypass the hook when needed, use: git commit --no-verify"

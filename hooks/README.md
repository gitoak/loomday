# Git Hooks

This directory contains git hooks that should be installed by contributors to maintain code quality.

## Installation

Run the installation script after cloning the repository:

**Linux/macOS:**

```bash
./hooks/install.sh
```

**Windows PowerShell:**

```powershell
.\hooks\install.ps1
```

**Windows Git Bash:**

```bash
bash hooks/install.sh
```

## Available Hooks

### pre-commit

Runs automatically before each commit to:

- Format all staged Dart files with `dart format`
- Run static analysis with `dart analyze --fatal-infos`
- Check for available auto-fixes with `dart fix --dry-run`

The commit will be blocked if analysis fails.

## Bypassing Hooks

If you need to bypass the hooks temporarily:

```bash
git commit --no-verify
```

⚠️ Use sparingly - hooks are there to maintain code quality!

## Files

- `pre-commit` - Bash version of the pre-commit hook (cross-platform wrapper)
- `pre-commit.ps1` - PowerShell version for Windows
- `install.sh` - Installation script for Unix-like systems
- `install.ps1` - Installation script for Windows PowerShell

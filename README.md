# loomday

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

### Setting Up Git Hooks

After cloning this repository, install the git hooks to enable automatic code formatting and linting:

**On Linux/macOS:**

```bash
./hooks/install.sh
```

**On Windows (PowerShell):**

```powershell
.\hooks\install.ps1
```

**On Windows (Git Bash):**

```bash
bash hooks/install.sh
```

The pre-commit hook will automatically:

- 🎨 Format your Dart code with `dart format`
- 🔬 Run static analysis with `dart analyze`
- 🔧 Check for auto-fixable issues

To bypass the hook when needed: `git commit --no-verify`

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

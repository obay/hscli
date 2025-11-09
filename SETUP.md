# Setup Guide for Publishing HSCTL

This guide will help you set up the infrastructure needed to publish HSCTL using GoReleaser, GitHub Actions, Scoop, and Homebrew.

## Quick Start Checklist

- [ ] Repository is on GitHub (`obay/hsctl`)
- [ ] GitHub Actions are enabled
- [ ] Create Scoop bucket repository (optional, for Windows)
- [ ] Create Homebrew tap repository (optional, for macOS)
- [ ] Configure GitHub secrets (if using automated Scoop updates)

## Step-by-Step Setup

### 1. GitHub Repository Setup

1. **Push your code to GitHub**:
   ```bash
   git remote add origin https://github.com/obay/hsctl.git
   git push -u origin main
   ```

2. **Enable GitHub Actions**:
   - Go to repository Settings → Actions → General
   - Ensure "Allow all actions and reusable workflows" is selected
   - Save changes

### 2. Scoop Bucket Setup (Windows)

Scoop requires a separate repository for the bucket.

1. **Create the bucket repository**:
   - Go to GitHub and create a new repository: `hsctl-scoop`
   - Make it public
   - Initialize with a README

2. **Update GoReleaser config** (if you want automatic updates):
   - Edit `.goreleaser.yml`
   - Set `skip_upload: false` in the `scoop` section
   - Create a GitHub token with repo access
   - Add it as `SCOOP_BUCKET_TOKEN` in repository secrets

3. **Manual alternative**:
   - After each release, GoReleaser generates a manifest
   - Manually copy it to your `hsctl-scoop` repository
   - Users install with: `scoop bucket add hsctl https://github.com/obay/hsctl-scoop`

### 3. Homebrew Tap Setup (macOS)

You have two options:

#### Option A: Separate Tap Repository (Recommended)

1. **Create tap repository**:
   - Create: `homebrew-hsctl`
   - Make it public
   - Structure: `Formula/hsctl.rb`

2. **After each release**:
   - GoReleaser generates a formula
   - Copy it to your tap repository
   - Users install with: `brew install obay/hsctl/hsctl`

#### Option B: Main Repository

1. **Keep formulas in main repo**:
   - Formulas are in `Formula/hsctl.rb`
   - Users install with: `brew install obay/hsctl/hsctl`

2. **Update `.goreleaser.yml`**:
   - The `brews` section is already configured
   - GoReleaser will update the formula automatically

### 4. First Release

1. **Update version information**:
   ```bash
   # Update CHANGELOG.md
   # Update any version references
   ```

2. **Commit and tag**:
   ```bash
   git add .
   git commit -m "chore: prepare release v0.1.0"
   git tag -a v0.1.0 -m "Release v0.1.0"
   git push origin main
   git push origin v0.1.0
   ```

3. **GitHub Actions will automatically**:
   - Build binaries for all platforms
   - Create GitHub release
   - Upload artifacts
   - Generate package manifests

4. **Verify release**:
   - Check: `https://github.com/obay/hsctl/releases`
   - Download and test binaries
   - Update package repositories if needed

## Configuration Files Overview

### `.goreleaser.yml`
- Main configuration for GoReleaser
- Defines build targets, archives, and package managers
- Update `owner` and repository names if different

### `.github/workflows/release.yml`
- Triggers on version tags (`v*`)
- Runs GoReleaser to create releases
- No configuration needed (uses `.goreleaser.yml`)

### `.github/workflows/test.yml`
- Runs on pushes and PRs
- Tests and builds the project
- Ensures code quality

### `.github/workflows/scoop-update.yml`
- Optional: Updates Scoop bucket automatically
- Requires `SCOOP_BUCKET_TOKEN` secret
- Can be disabled if doing manual updates

## Package Manager Installation Commands

After setup, users can install with:

### macOS (Homebrew)
```bash
brew install obay/hsctl/hsctl
# or if using separate tap:
brew tap obay/hsctl
brew install hsctl
```

### Windows (Scoop)
```powershell
scoop bucket add hsctl https://github.com/obay/hsctl-scoop
scoop install hsctl
```

### Linux
```bash
# Download .deb or .rpm from releases page
# Or use manual installation
```

## Testing Before Release

1. **Test locally with GoReleaser**:
   ```bash
   # Install GoReleaser
   brew install goreleaser/tap/goreleaser
   
   # Dry run
   goreleaser release --snapshot --skip-publish
   ```

2. **Test GitHub Actions**:
   - Create a test tag: `git tag -a v0.0.1-test -m "Test"`
   - Push: `git push origin v0.0.1-test`
   - Check Actions tab for results
   - Delete test tag after verification

## Troubleshooting

### GitHub Actions Not Running
- Check repository Settings → Actions
- Ensure workflows are enabled
- Verify tag format starts with `v`

### Build Failures
- Check Go version in workflow
- Verify all dependencies in `go.mod`
- Test local build: `go build -o hsctl .`

### Package Manager Issues
- Verify repository names match
- Check file permissions
- Ensure manifests are valid JSON/YAML

## Next Steps

1. Complete the checklist above
2. Make your first release
3. Update package repositories
4. Share with users!

For detailed release instructions, see [RELEASE.md](RELEASE.md).


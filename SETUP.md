# Setup Guide for Publishing HSCTL

This guide will help you set up the infrastructure needed to publish HSCTL using GoReleaser, GitHub Actions, Scoop, and Homebrew.

## Quick Start Checklist

- [ ] Repository is on GitHub (`obay/hsctl`)
- [ ] GitHub Actions are enabled
- [x] Scoop bucket repository exists: `obay/scoop-bucket`
- [x] Homebrew tap repository exists: `obay/homebrew-tap`
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

Your Scoop bucket repository is already set up at `obay/scoop-bucket`.

1. **GoReleaser is configured** to automatically update the bucket:
   - The `.goreleaser.yml` is configured with `skip_upload: false`
   - GoReleaser will automatically create/update the manifest in your bucket

2. **Users install with**:
   ```powershell
   scoop bucket add obay https://github.com/obay/scoop-bucket
   scoop install hsctl
   ```

3. **For automatic updates** (optional):
   - Create a GitHub token with repo access to `obay/scoop-bucket`
   - Add it as `SCOOP_BUCKET_TOKEN` in repository secrets
   - The workflow will automatically update the bucket on each release

### 3. Homebrew Tap Setup (macOS)

Your Homebrew tap repository is already set up at `obay/homebrew-tap`.

1. **GoReleaser is configured** to automatically update the tap:
   - The `.goreleaser.yml` is configured with your tap repository
   - GoReleaser will automatically create/update the formula in your tap

2. **Users install with**:
   ```bash
   brew tap obay/homebrew-tap
   brew install hsctl
   ```

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
brew tap obay/homebrew-tap
brew install hsctl
```

### Windows (Scoop)
```powershell
scoop bucket add obay https://github.com/obay/scoop-bucket
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


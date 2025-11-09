# Release Guide

This guide explains how to release a new version of HSCTL using GoReleaser and GitHub Actions.

## Prerequisites

1. **GoReleaser** installed locally (optional, for testing):
   ```bash
   brew install goreleaser/tap/goreleaser
   # or
   go install github.com/goreleaser/goreleaser@latest
   ```

2. **GitHub Token** with appropriate permissions:
   - `repo` scope for creating releases
   - `write:packages` if publishing packages

3. **Scoop Bucket Repository** (for Windows):
   - Create a repository named `hsctl-scoop` under your GitHub account
   - This will store the Scoop manifest files

4. **Homebrew Tap** (for macOS):
   - Create a repository named `homebrew-hsctl` under your GitHub account
   - Or use the main repository with a `Formula` directory

## Release Process

### 1. Prepare the Release

1. Update version numbers and changelog:
   ```bash
   # Update CHANGELOG.md with new version
   # Update any version references in code
   ```

2. Commit your changes:
   ```bash
   git add .
   git commit -m "chore: prepare release v0.1.0"
   git push
   ```

### 2. Create a Git Tag

Create and push a tag (this triggers the release workflow):

```bash
# Create annotated tag
git tag -a v0.1.0 -m "Release v0.1.0"

# Push tag to GitHub
git push origin v0.1.0
```

**Note**: Tag names must start with `v` (e.g., `v0.1.0`, `v1.0.0`)

### 3. GitHub Actions Workflow

The release workflow (`.github/workflows/release.yml`) will automatically:

1. Build binaries for all platforms (Linux, macOS, Windows)
2. Create archives (tar.gz for Unix, zip for Windows)
3. Generate checksums
4. Create a GitHub release
5. Upload all artifacts
6. Generate Scoop manifest (if configured)
7. Generate Homebrew formula (if configured)

### 4. Verify the Release

1. Check GitHub Releases page: `https://github.com/obay/hsctl/releases`
2. Verify all artifacts are uploaded
3. Test installation on different platforms

### 5. Update Package Managers

#### Scoop (Windows)

If you have a separate Scoop bucket repository:

1. The GoReleaser will generate a manifest file
2. Manually copy it to your `hsctl-scoop` repository
3. Or set up the automated workflow (see `.github/workflows/scoop-update.yml`)

To enable automatic Scoop updates:
1. Create a GitHub token with repo access
2. Add it as `SCOOP_BUCKET_TOKEN` secret
3. Update `.goreleaser.yml` to set `skip_upload: false` for scoop

#### Homebrew (macOS)

For Homebrew, you have two options:

**Option 1: Homebrew Tap (Recommended)**
1. Create a repository: `homebrew-hsctl`
2. GoReleaser will generate the formula
3. Manually commit it to your tap repository

**Option 2: Main Repository**
1. Keep formulas in the `Formula/` directory
2. Users install with: `brew install obay/hsctl/hsctl`

## Testing Releases Locally

Test the release process locally before pushing:

```bash
# Dry run (doesn't publish)
goreleaser release --snapshot --skip-publish

# Full test (creates a snapshot release)
goreleaser release --snapshot
```

## Version Numbering

Follow [Semantic Versioning](https://semver.org/):
- **MAJOR**: Breaking changes
- **MINOR**: New features (backward compatible)
- **PATCH**: Bug fixes (backward compatible)

Examples:
- `v1.0.0` - Initial stable release
- `v1.1.0` - New features added
- `v1.1.1` - Bug fixes
- `v2.0.0` - Breaking changes

## Troubleshooting

### Release Fails

1. Check GitHub Actions logs
2. Verify GitHub token permissions
3. Ensure tag format is correct (`v*`)

### Binaries Not Building

1. Check Go version compatibility
2. Verify build flags in `.goreleaser.yml`
3. Test local build: `go build -o hsctl .`

### Package Manager Issues

1. **Scoop**: Verify bucket repository exists and is accessible
2. **Homebrew**: Check formula syntax and repository structure

## Automated Release (Optional)

You can automate releases using:
- **Semantic Release**: Automatically version and release based on commit messages
- **Release Drafter**: Draft release notes automatically
- **Dependabot**: Keep dependencies updated

## Next Steps After Release

1. Update documentation if needed
2. Announce the release (blog, social media, etc.)
3. Monitor for issues and feedback
4. Plan next release


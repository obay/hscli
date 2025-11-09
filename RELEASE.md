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
   - Already configured: `obay/scoop-bucket`
   - GoReleaser will automatically update the manifest

4. **Homebrew Tap** (for macOS):
   - Already configured: `obay/homebrew-tap`
   - GoReleaser will automatically update the formula

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

Your Scoop bucket is already configured at `obay/scoop-bucket`:

1. GoReleaser will automatically generate and upload the manifest
2. The manifest will be committed to your `scoop-bucket` repository
3. Users can install with: `scoop bucket add obay https://github.com/obay/scoop-bucket && scoop install hsctl`

**For automatic updates** (optional):
- Create a GitHub token with repo access to `obay/scoop-bucket`
- Add it as `SCOOP_BUCKET_TOKEN` secret in your repository
- The workflow will automatically update the bucket

#### Homebrew (macOS)

Your Homebrew tap is already configured at `obay/homebrew-tap`:

1. GoReleaser will automatically generate and upload the formula
2. The formula will be committed to your `homebrew-tap` repository
3. Users can install with: `brew tap obay/homebrew-tap && brew install hsctl`

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


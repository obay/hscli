# GitHub Repository Setup Guide

This guide will help you set up your GitHub repository with a proper description and ensure downloadable packages are available.

## Step 1: Add Repository Description

1. Go to your repository: `https://github.com/obay/hsctl`
2. Click the **⚙️ Settings** icon (or navigate to Settings)
3. Scroll down to the **"About"** section
4. Click the **✏️ Edit** icon
5. Paste this description:

```
A powerful CLI tool written in Go for managing HubSpot contacts. Perform CRUD operations, search, and automate contact management directly from your terminal.
```

6. Add the following **Topics** (tags):
   - `hubspot`
   - `cli`
   - `go`
   - `golang`
   - `contact-management`
   - `crm`
   - `command-line`
   - `automation`
   - `hubspot-api`
   - `contacts`

7. Click **Save changes**

## Step 2: Verify Release Assets

After your first release, GoReleaser will automatically create downloadable packages. Verify that these are available:

### What Gets Created

For each release, GoReleaser creates:

1. **Versioned Archives** (with version number):
   - `hsctl_darwin_amd64_v1.0.0.tar.gz`
   - `hsctl_darwin_arm64_v1.0.0.tar.gz`
   - `hsctl_linux_amd64_v1.0.0.tar.gz`
   - `hsctl_linux_arm64_v1.0.0.tar.gz`
   - `hsctl_windows_amd64_v1.0.0.zip`

2. **Version-less Archives** (for `/latest/download/` URLs):
   - `hsctl_darwin_amd64.tar.gz`
   - `hsctl_darwin_arm64.tar.gz`
   - `hsctl_linux_amd64.tar.gz`
   - `hsctl_linux_arm64.tar.gz`
   - `hsctl_windows_amd64.zip`

3. **Package Files**:
   - `hsctl_linux_amd64.deb` (Debian/Ubuntu)
   - `hsctl_linux_amd64.rpm` (Red Hat/CentOS/Fedora)

4. **Checksums**:
   - `checksums.txt` (for verifying downloads)

### Testing Direct Downloads

After creating a release, test these URLs:

```bash
# macOS Intel
curl -LO https://github.com/obay/hsctl/releases/latest/download/hsctl_darwin_amd64.tar.gz

# macOS Apple Silicon
curl -LO https://github.com/obay/hsctl/releases/latest/download/hsctl_darwin_arm64.tar.gz

# Linux
curl -LO https://github.com/obay/hsctl/releases/latest/download/hsctl_linux_amd64.tar.gz

# Windows
curl -LO https://github.com/obay/hsctl/releases/latest/download/hsctl_windows_amd64.zip
```

## Step 3: Create Your First Release

1. **Tag your release**:
   ```bash
   git tag -a v0.1.0 -m "Initial release"
   git push origin v0.1.0
   ```

2. **GitHub Actions will automatically**:
   - Build binaries for all platforms
   - Create archives (tar.gz and zip)
   - Generate package files (.deb, .rpm)
   - Create a GitHub release
   - Upload all assets

3. **Verify the release**:
   - Go to: `https://github.com/obay/hsctl/releases`
   - Check that all assets are listed
   - Test downloading one of the assets

## Step 4: Update README Links (if needed)

The README already includes direct download links. After your first release, verify that the links work:

- All `/latest/download/` URLs should redirect to the latest release
- Versioned URLs will point to specific releases
- Checksums file should be available

## Troubleshooting

### No Assets in Release

If assets aren't appearing:
1. Check GitHub Actions logs for errors
2. Verify GoReleaser configuration (`.goreleaser.yml`)
3. Ensure the workflow has proper permissions

### Download Links Don't Work

If `/latest/download/` URLs don't work:
1. Verify the asset filenames match exactly
2. Check that the release is marked as "Latest"
3. Ensure the release is published (not draft)

### Missing Package Files

If .deb or .rpm files are missing:
1. Check the `nfpms` section in `.goreleaser.yml`
2. Verify Linux builds are successful
3. Check GitHub Actions logs

## Next Steps

- ✅ Repository description added
- ✅ Topics/tags added
- ✅ First release created
- ✅ Download links verified
- ✅ Package managers set up (Scoop, Homebrew)

Your repository is now ready for users to download and install HSCTL!


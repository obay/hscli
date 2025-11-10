# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

hscli is a command-line interface (CLI) tool written in Go for managing HubSpot contacts. It provides CRUD operations on HubSpot contacts via the HubSpot API v3, eliminating the need to navigate through the HubSpot web interface.

## Development Commands

### Building
```bash
# Build the binary
go build -o hscli .

# Build with version information (as done by GoReleaser)
go build -ldflags "-s -w -X github.com/obay/hscli/cmd.version=dev -X github.com/obay/hscli/cmd.commit=$(git rev-parse HEAD) -X github.com/obay/hscli/cmd.buildDate=$(date -u +%Y-%m-%dT%H:%M:%SZ)" -o hscli .
```

### Testing
```bash
# Run all tests
go test -v ./...

# Run tests with coverage
go test -v -cover ./...

# Run tests for a specific package
go test -v ./internal/hubspot/...
```

### Running
```bash
# Run without building
go run . contacts list --api-key YOUR_API_KEY

# Run after building
./hscli contacts list --api-key YOUR_API_KEY
```

### Dependencies
```bash
# Download dependencies
go mod download

# Clean up dependencies
go mod tidy
```

## Architecture

### Project Structure

- **[main.go](main.go)**: Entry point that calls `cmd.Execute()`
- **[cmd/](cmd/)**: Cobra command definitions
  - **[root.go](cmd/root.go)**: Root command setup, configuration initialization (Viper), and API key management
  - **[contacts.go](cmd/contacts.go)**: All contact-related subcommands (list, create, update, delete, query, properties)
  - **[version.go](cmd/version.go)**: Version command with build metadata
- **[internal/hubspot/](internal/hubspot/)**: HubSpot API client implementation
  - **[client.go](internal/hubspot/client.go)**: HTTP client wrapper, data structures (Contact, Property), and all API operations
  - **[client_test.go](internal/hubspot/client_test.go)**: Unit tests for the client

### Key Design Patterns

**Command Pattern (Cobra)**
- Each operation is a separate Cobra command
- Commands are registered in `init()` functions
- All commands share the root command's persistent flags (api-key, config)

**Client Wrapper**
- The `hubspot.Client` struct encapsulates all API interactions
- `doRequest()` method handles common HTTP logic (authentication, error handling, JSON marshaling)
- Each API operation (ListContacts, CreateContact, etc.) is a separate method

**Configuration Priority (Viper)**
1. Command-line flags (--api-key)
2. Environment variables (HUBSPOT_API_KEY)
3. Config file (~/.hscli.yaml)

**Output Formatting**
- Two output modes: `table` (human-readable) and `json` (machine-readable)
- Implemented in `printContacts()` and `printProperties()` functions in [cmd/contacts.go](cmd/contacts.go)

### API Integration

All HubSpot API calls use v3 endpoints:
- Base URL: `https://api.hubapi.com`
- Authentication: Bearer token in Authorization header
- Standard properties retrieved: `email`, `firstname`, `lastname`, `hs_lead_status`, `lifecyclestage`

Search functionality supports two query formats:
- Property-based: `property=value` (e.g., `email=john@example.com`)
- Text search: searches in email field using CONTAINS_TOKEN operator

### Release Process

The project uses GoReleaser for automated releases:
- **Triggered by**: Git tags matching `v*` pattern
- **Builds for**: Linux, macOS, Windows (amd64, arm64)
- **Outputs**:
  - Versioned archives (e.g., `hscli_v1.0.0_darwin_amd64.tar.gz`)
  - Versionless archives (e.g., `hscli_darwin_amd64.tar.gz`) for package managers
  - Debian (.deb) and RPM (.rpm) packages
  - Homebrew cask formula (pushed to obay/homebrew-tap)
  - Scoop manifest (pushed to obay/scoop-bucket)

Configuration: [.goreleaser.yml](.goreleaser.yml)

### Testing Strategy

Tests are minimal but cover core functionality:
- Client initialization
- HTTP request/response handling with mock servers
- Data structure validation

When adding new API operations, follow the pattern in [internal/hubspot/client_test.go](internal/hubspot/client_test.go).

## Common Development Tasks

### Adding a New Contact Property to Default Retrieval

Update the `properties` query parameter in:
- `ListContacts()` method ([internal/hubspot/client.go:123](internal/hubspot/client.go#L123))
- `GetContact()` method ([internal/hubspot/client.go:146](internal/hubspot/client.go#L146))
- `SearchContacts()` method ([internal/hubspot/client.go:258](internal/hubspot/client.go#L258))

### Adding a New Command

1. Create a new `cobra.Command` in the appropriate file under [cmd/](cmd/)
2. Register it in the `init()` function
3. Implement the command logic in the `RunE` function
4. Add any necessary API methods to [internal/hubspot/client.go](internal/hubspot/client.go)

### Extending to Support Other HubSpot Objects

The current architecture is ready for extension:
1. Add new object types (Deal, Company, etc.) to [internal/hubspot/client.go](internal/hubspot/client.go)
2. Create new command files under [cmd/](cmd/) (e.g., `deals.go`, `companies.go`)
3. Follow the same pattern as [cmd/contacts.go](cmd/contacts.go)

## Configuration Management

The project uses Viper for unified configuration management, eliminating the need to pass the API key with every command.

### Configuration Priority

Viper checks for the API key in the following order (highest to lowest priority):
1. **Command-line flag**: `--api-key YOUR_KEY`
2. **Environment variable**: `HUBSPOT_API_KEY`
3. **Config file**: `~/.hscli.yaml`

### Configuration File Format

Create `~/.hscli.yaml` with:
```yaml
api-key: your-hubspot-api-key-here
```

### Implementation Details

Configuration is initialized in [cmd/root.go](cmd/root.go):
- `viper.BindPFlag("api-key", ...)` binds the CLI flag
- `viper.BindEnv("api-key", "HUBSPOT_API_KEY")` binds the environment variable
- `viper.SetConfigName(".hscli")` sets the config file name
- `viper.ReadInConfig()` reads the config file from `$HOME/.hscli.yaml`

All commands use `viper.GetString("api-key")` to retrieve the API key from any source (see `getAPIKey()` in [cmd/contacts.go:315](cmd/contacts.go#L315)).

### Required HubSpot Scopes

When creating a HubSpot private app, ensure it has these scopes:
- `crm.objects.contacts.read`
- `crm.objects.contacts.write`

## Release Process

### Creating a New Release

The project uses GoReleaser with GitHub Actions for automated releases. Releases are triggered by pushing a git tag with the format `v*`.

#### Step 1: Prepare the Release

```bash
# Ensure all changes are committed
git add .
git commit -m "chore: prepare release vX.Y.Z"
git push origin main
```

#### Step 2: Create and Push a Tag

Follow [Semantic Versioning](https://semver.org/):
- **MAJOR** (v2.0.0): Breaking changes
- **MINOR** (v1.1.0): New features (backward compatible)
- **PATCH** (v1.0.1): Bug fixes (backward compatible)

```bash
# Create annotated tag
git tag -a v0.2.0 -m "Release v0.2.0 - Description of changes"

# Push tag to trigger release workflow
git push origin v0.2.0
```

#### Step 3: Automated Release Workflow

The `.github/workflows/release.yml` workflow will automatically:

1. **Build binaries** for all platforms:
   - Linux (amd64, arm64)
   - macOS/Darwin (amd64, arm64)
   - Windows (amd64)

2. **Create release artifacts**:
   - Versioned archives: `hscli_v0.2.0_darwin_amd64.tar.gz`
   - Versionless archives: `hscli_darwin_amd64.tar.gz` (for package managers)
   - Debian packages: `hscli_linux_amd64.deb`
   - RPM packages: `hscli_linux_amd64.rpm`
   - Windows ZIP: `hscli_windows_amd64.zip`
   - Checksums file: `checksums.txt`

3. **Update package managers**:
   - Homebrew: Commits cask formula to `obay/homebrew-tap`
   - Scoop: Commits manifest to `obay/scoop-bucket`

4. **Create GitHub release** with:
   - Auto-generated changelog
   - All build artifacts attached
   - Release notes

#### Step 4: Verify the Release

1. Check GitHub Actions: https://github.com/obay/hscli/actions
2. Verify release page: https://github.com/obay/hscli/releases/tag/v0.2.0
3. Test installation via package managers:
   ```bash
   # Homebrew (macOS)
   brew update && brew upgrade hscli

   # Scoop (Windows)
   scoop update && scoop update hscli
   ```

### Testing Releases Locally

Before pushing a tag, test the release process locally:

```bash
# Install GoReleaser (if not already installed)
brew install goreleaser/tap/goreleaser

# Test without publishing (dry run)
goreleaser release --snapshot --skip-publish --clean

# Check generated artifacts in ./dist/
ls -la dist/

# Verify generated package manager configs
cat dist/*.rb  # Homebrew formula
cat dist/*.json  # Scoop manifest
```

### First-Time Release Setup

The first release automatically sets up package manager repositories:

#### Homebrew Tap Setup
- **Repository**: `obay/homebrew-tap`
- GoReleaser creates/updates: `Casks/hscli.rb`
- Users install with: `brew tap obay/homebrew-tap && brew install hscli`
- The cask includes an `unquarantine` hook for unsigned binaries

#### Scoop Bucket Setup
- **Repository**: `obay/scoop-bucket`
- GoReleaser creates/updates: `hscli.json`
- Users install with: `scoop bucket add obay https://github.com/obay/scoop-bucket && scoop install hscli`

#### GitHub Token Requirements
- The release workflow uses `HOMEBREW_TAP_TOKEN` secret
- Token needs `repo` scope for both main repository and tap/bucket repositories
- Set in: Repository Settings → Secrets and Variables → Actions

### Troubleshooting Releases

#### Release Workflow Fails
1. Check GitHub Actions logs for errors
2. Verify `HOMEBREW_TAP_TOKEN` is set and valid
3. Ensure tag format matches `v*` pattern
4. Verify Go version in workflow matches project requirements

#### Build Failures
1. Test local build: `go build -o hscli .`
2. Check `.goreleaser.yml` configuration
3. Verify all platforms are buildable: `GOOS=windows GOARCH=amd64 go build`

#### Package Manager Issues
1. **Homebrew**: Check tap repository for committed formula
2. **Scoop**: Verify bucket repository has updated manifest
3. **Checksums**: Ensure checksums.txt is generated correctly

#### Binaries Don't Work on macOS
- The homebrew cask includes an unquarantine hook
- Users may need to run: `xattr -dr com.apple.quarantine /path/to/hscli`
- Consider code signing for future releases

### Release Checklist

Before creating a release:
- [ ] All tests pass: `go test -v ./...`
- [ ] Build succeeds: `go build -o hscli .`
- [ ] CHANGELOG.md is updated (if exists)
- [ ] Version number follows semantic versioning
- [ ] All changes are committed and pushed
- [ ] Local GoReleaser test passes: `goreleaser release --snapshot --skip-publish --clean`

After creating a release:
- [ ] GitHub Actions workflow completed successfully
- [ ] Release appears on GitHub releases page
- [ ] All artifacts are present (binaries, packages, checksums)
- [ ] Homebrew tap is updated
- [ ] Scoop bucket is updated
- [ ] Installation via package managers works

## Installation for Development

### For Contributors

```bash
# Clone the repository
git clone https://github.com/obay/hscli.git
cd hscli

# Install dependencies
go mod download

# Build
go build -o hscli .

# Run tests
go test -v ./...

# Install locally (optional)
sudo mv hscli /usr/local/bin/
```

### For End Users

See the [README.md](README.md) for user-facing installation instructions via:
- Homebrew (macOS)
- Scoop (Windows)
- Direct downloads for all platforms

# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

HSCTL is a command-line interface (CLI) tool written in Go for managing HubSpot contacts. It provides CRUD operations on HubSpot contacts via the HubSpot API v3, eliminating the need to navigate through the HubSpot web interface.

## Development Commands

### Building
```bash
# Build the binary
go build -o hsctl .

# Build with version information (as done by GoReleaser)
go build -ldflags "-s -w -X github.com/obay/hsctl/cmd.version=dev -X github.com/obay/hsctl/cmd.commit=$(git rev-parse HEAD) -X github.com/obay/hsctl/cmd.buildDate=$(date -u +%Y-%m-%dT%H:%M:%SZ)" -o hsctl .
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
./hsctl contacts list --api-key YOUR_API_KEY
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
3. Config file (~/.hsctl.yaml)

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
  - Versioned archives (e.g., `hsctl_v1.0.0_darwin_amd64.tar.gz`)
  - Versionless archives (e.g., `hsctl_darwin_amd64.tar.gz`) for package managers
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
3. **Config file**: `~/.hsctl.yaml`

### Configuration File Format

Create `~/.hsctl.yaml` with:
```yaml
api-key: your-hubspot-api-key-here
```

### Implementation Details

Configuration is initialized in [cmd/root.go](cmd/root.go):
- `viper.BindPFlag("api-key", ...)` binds the CLI flag
- `viper.BindEnv("api-key", "HUBSPOT_API_KEY")` binds the environment variable
- `viper.SetConfigName(".hsctl")` sets the config file name
- `viper.ReadInConfig()` reads the config file from `$HOME/.hsctl.yaml`

All commands use `viper.GetString("api-key")` to retrieve the API key from any source (see `getAPIKey()` in [cmd/contacts.go:315](cmd/contacts.go#L315)).

### Required HubSpot Scopes

When creating a HubSpot private app, ensure it has these scopes:
- `crm.objects.contacts.read`
- `crm.objects.contacts.write`

# Installation Guide

This guide provides detailed installation instructions for HSCTL on different platforms.

## Prerequisites

- A HubSpot account with API access
- A HubSpot Private App API key (starts with `pat-`)

## Platform-Specific Installation

### macOS

#### Option 1: Homebrew (Recommended)

1. Add the tap:
   ```bash
   brew tap obay/hsctl
   ```

2. Install:
   ```bash
   brew install hsctl
   ```

3. Verify:
   ```bash
   hsctl --version
   ```

#### Option 2: Manual Installation

1. Download the latest macOS release:
   ```bash
   curl -LO https://github.com/obay/hsctl/releases/latest/download/hsctl_darwin_amd64.tar.gz
   ```

2. Extract:
   ```bash
   tar -xzf hsctl_darwin_amd64.tar.gz
   ```

3. Move to PATH:
   ```bash
   sudo mv hsctl /usr/local/bin/
   ```

4. Make executable:
   ```bash
   chmod +x /usr/local/bin/hsctl
   ```

### Windows

#### Option 1: Scoop (Recommended)

1. Install Scoop (if not already installed):
   ```powershell
   Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
   iwr -useb get.scoop.sh | iex
   ```

2. Add the bucket:
   ```powershell
   scoop bucket add hsctl https://github.com/obay/hsctl-scoop
   ```

3. Install:
   ```powershell
   scoop install hsctl
   ```

4. Verify:
   ```powershell
   hsctl --version
   ```

#### Option 2: Manual Installation

1. Download the latest Windows release:
   ```powershell
   Invoke-WebRequest -Uri "https://github.com/obay/hsctl/releases/latest/download/hsctl_windows_amd64.zip" -OutFile "hsctl.zip"
   ```

2. Extract the ZIP file

3. Add to PATH:
   - Open System Properties → Environment Variables
   - Add the extracted directory to your PATH
   - Or move `hsctl.exe` to a directory already in your PATH

4. Verify:
   ```powershell
   hsctl --version
   ```

### Linux

#### Option 1: Debian/Ubuntu (.deb package)

1. Download the .deb package:
   ```bash
   wget https://github.com/obay/hsctl/releases/latest/download/hsctl_linux_amd64.deb
   ```

2. Install:
   ```bash
   sudo dpkg -i hsctl_linux_amd64.deb
   ```

3. Verify:
   ```bash
   hsctl --version
   ```

#### Option 2: Red Hat/CentOS (.rpm package)

1. Download the .rpm package:
   ```bash
   wget https://github.com/obay/hsctl/releases/latest/download/hsctl_linux_amd64.rpm
   ```

2. Install:
   ```bash
   sudo rpm -i hsctl_linux_amd64.rpm
   ```

3. Verify:
   ```bash
   hsctl --version
   ```

#### Option 3: Manual Installation (Any Linux Distribution)

1. Download the tarball:
   ```bash
   wget https://github.com/obay/hsctl/releases/latest/download/hsctl_linux_amd64.tar.gz
   ```

2. Extract:
   ```bash
   tar -xzf hsctl_linux_amd64.tar.gz
   ```

3. Move to PATH:
   ```bash
   sudo mv hsctl /usr/local/bin/
   ```

4. Make executable:
   ```bash
   chmod +x /usr/local/bin/hsctl
   ```

## Build from Source

If you prefer to build from source:

```bash
# Clone the repository
git clone https://github.com/obay/hsctl.git
cd hsctl

# Build
go build -o hsctl .

# Install (optional)
sudo mv hsctl /usr/local/bin/
```

## Verification

After installation, verify that HSCTL is working:

```bash
hsctl --help
hsctl version
```

## Next Steps

1. Get your HubSpot API key (see [README.md](README.md#getting-your-hubspot-api-key))
2. Set up authentication:
   ```bash
   export HUBSPOT_API_KEY=your-api-key-here
   ```
3. Test the connection:
   ```bash
   hsctl contacts list
   ```

## Troubleshooting

### Command Not Found

If you get a "command not found" error:

1. **macOS/Linux**: Ensure `/usr/local/bin` is in your PATH:
   ```bash
   echo $PATH | grep /usr/local/bin
   ```
   If not, add it to your shell profile (`~/.zshrc`, `~/.bashrc`, etc.)

2. **Windows**: Ensure the directory containing `hsctl.exe` is in your system PATH

### Permission Denied

If you get a permission error:

```bash
# macOS/Linux
chmod +x /usr/local/bin/hsctl

# Or use sudo
sudo chmod +x /usr/local/bin/hsctl
```

### API Key Issues

If you encounter authentication errors:

1. Verify your API key is correct
2. Check that your private app has the required scopes
3. Ensure the API key hasn't expired

For more help, see the [README.md](README.md) or open an issue on GitHub.


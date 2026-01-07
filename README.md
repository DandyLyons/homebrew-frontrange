# homebrew-frontrange

Homebrew tap for [FrontRange](https://github.com/DandyLyons/FrontRange) - Swift tools for parsing and managing YAML front matter in text files.

## Installation

```bash
# Add this tap
brew tap dandylyons/frontrange

# Install FrontRange
brew install frontrange

# Verify installation
fr --version
```

## What Gets Installed

This tap installs two executables:

- **`fr`** - CLI tool for managing front matter in text files
- **`frontrange-mcp`** - Model Context Protocol (MCP) server for AI-powered front matter operations

## How It Works

This formula builds FrontRange from source during installation:

- **Requirements**: macOS with Command Line Tools installed (`xcode-select --install`)
- **Build time**: ~30 seconds on first install
- **No Xcode required**: Command Line Tools are sufficient

The source-based approach prioritizes simplicity in the release process over installation speed.

## Updating the Formula

When a new version of FrontRange is released:

1. Update the `url` and `sha256` in [Formula/frontrange.rb](Formula/frontrange.rb)
2. Update version assertions in the `test` block
3. Commit and push changes
4. Users can update with `brew upgrade frontrange`

## Documentation

For FrontRange usage and features, see the [main repository](https://github.com/DandyLyons/FrontRange).

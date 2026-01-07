# CLAUDE.md - Developer Guide for homebrew-frontrange

This is a Homebrew tap repository for distributing [FrontRange](https://github.com/DandyLyons/FrontRange), a Swift package for managing YAML front matter in text files.

## Repository Structure

```
homebrew-frontrange/
├── Formula/
│   └── frontrange.rb    # Homebrew formula for FrontRange
└── README.md            # User-facing documentation
```

## How This Tap Works

### Installation Process

When users run `brew install frontrange` after tapping this repository:

1. Homebrew downloads the source tarball from the GitHub release specified in `url`
2. Verifies the download using the `sha256` checksum
3. Runs `swift build -c release --disable-sandbox` to compile the Swift package
4. Installs the resulting binaries (`fr` and `frontrange-mcp`) to Homebrew's bin directory
5. Runs tests to verify the installation

### Build-from-Source Philosophy

This tap builds FrontRange from source rather than distributing pre-built binaries.

**Rationale:**
- Simpler release workflow for maintainer
- No need for GitHub Actions or CI/CD
- No binary asset management or architecture concerns
- No build automation required

**Trade-offs:**
- Users need Swift Command Line Tools installed
- Installation takes ~30 seconds (compile time)
- Better for maintainability than user convenience

## Release Workflow

When releasing a new version of FrontRange:

1. **Create release in main repo** (`DandyLyons/FrontRange`):
   ```bash
   git tag v0.3.0-beta
   git push origin v0.3.0-beta
   # Create GitHub release (source tarball auto-generated)
   ```

2. **Update this tap's formula**:
   - Update `url` to point to new release tarball
   - Update `sha256` checksum (get from release or compute locally)
   - Update version in test block (e.g., `assert_match "0.3.0-beta"`)

3. **Commit and push**:
   ```bash
   git add Formula/frontrange.rb
   git commit -m "Update FrontRange to v0.3.0-beta"
   git push
   ```

4. **Users update**:
   ```bash
   brew update
   brew upgrade frontrange
   ```

## Formula Maintenance

### Getting SHA256 for New Release

```bash
# Download the tarball
curl -LO https://github.com/DandyLyons/FrontRange/archive/refs/tags/v0.3.0-beta.tar.gz

# Compute SHA256
shasum -a 256 v0.3.0-beta.tar.gz
```

Or use Homebrew's built-in tool:
```bash
brew fetch --force --build-from-source frontrange
```

### Testing the Formula Locally

```bash
# Install from local formula
brew install --build-from-source Formula/frontrange.rb

# Run formula tests
brew test frontrange

# Audit formula for issues
brew audit --strict frontrange
```

### Formula Structure

The formula ([Formula/frontrange.rb](Formula/frontrange.rb)) contains:

- **Metadata**: `desc`, `homepage`, `url`, `sha256`, `license`
- **Dependencies**: `depends_on :macos` (Swift toolchain implied)
- **Installation**: Compiles Swift package and installs binaries
- **Tests**: Verifies version output and basic functionality

## Dependencies

### Build Requirements
- macOS (any recent version with Command Line Tools)
- Swift toolchain (comes with Command Line Tools)
- No Xcode required

### Runtime Requirements
- macOS only (Swift packages are platform-specific)

## History and Evolution

### v0.1.0-beta (December 2025)
- Initial release with build-from-source approach
- Required Xcode (later relaxed to Command Line Tools)

### v0.2.0-beta Attempt (December 2025)
- Attempted to switch to pre-built binaries
- Failed because releases didn't include compiled binaries
- Only source tarballs were available

### v0.2.0-beta Final (January 2026)
- Reverted to build-from-source approach
- Prioritized development simplicity over installation speed
- Added clarifying comments about Command Line Tools

## Common Tasks

### Update to New Version
1. Edit `Formula/frontrange.rb`
2. Change `url` line to new version tag
3. Update `sha256` with new checksum
4. Update version string in test assertions
5. Commit with message: "Update FrontRange to vX.Y.Z"

### Fix Formula Issues
- Use `brew audit --strict frontrange` to check for problems
- Use `brew style frontrange` to check Ruby style
- Test installation: `brew reinstall --build-from-source frontrange`

### Debug Installation Problems
```bash
# Verbose installation
brew install --build-from-source --verbose --debug frontrange

# Check build logs
cat ~/Library/Logs/Homebrew/frontrange/
```

## Related Repositories

- **Main Project**: [DandyLyons/FrontRange](https://github.com/DandyLyons/FrontRange)
- **This Tap**: [DandyLyons/homebrew-frontrange](https://github.com/DandyLyons/homebrew-frontrange)

## Design Decisions

### Why Not Submit to Homebrew Core?

This is a custom tap (`dandylyons/frontrange`) rather than being in Homebrew's main repository because:

- FrontRange is still in beta (pre-1.0)
- Homebrew core prefers stable, widely-used software
- Custom tap gives us flexibility during development
- May submit to core after 1.0 stable release

### Why Build from Source Instead of Binaries?

See [commit ec1f7fa](https://github.com/DandyLyons/homebrew-frontrange/commit/ec1f7fa) for detailed rationale. Summary:

- **Development simplicity** > User convenience
- No CI/CD complexity
- No binary upload/management overhead
- Easier to maintain long-term

## Contributing

This is a simple tap with a single formula. If you need to make changes:

1. Fork the repository
2. Make changes to `Formula/frontrange.rb`
3. Test locally with `brew install --build-from-source`
4. Submit a pull request

For issues with FrontRange itself (not the Homebrew formula), report them in the [main repository](https://github.com/DandyLyons/FrontRange/issues).

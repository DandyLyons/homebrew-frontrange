class Frontrange < Formula
  desc "Swift package for parsing and managing YAML front matter in text files"
  homepage "https://github.com/DandyLyons/FrontRange"
  url "https://github.com/DandyLyons/FrontRange/archive/refs/tags/v0.5.0-beta.tar.gz"
  sha256 "b9a7b9c2c326e5cb85648c367e967ab90a7084a65abaf6a3850907500815f393"
  license "MIT" # Update if different
  head "https://github.com/DandyLyons/FrontRange.git", branch: "main"

  # Requires Xcode for complete Swift toolchain (Command Line Tools lacks PackageDescription framework)
  depends_on xcode: [">= 14.0", :build]
  depends_on :macos

  def install
    system "swift", "build", "-c", "release", "--disable-sandbox"

    # Install the CLI tool
    bin.install ".build/release/fr"

    # Install the MCP server
    bin.install ".build/release/frontrange-mcp"
  end

  test do
    # Test fr CLI
    assert_match "0.5.0-beta", shell_output("#{bin}/fr --version")

    # Test frontrange-mcp (basic check that it exists)
    assert_predicate bin/"frontrange-mcp", :exist?

    # Test basic fr functionality
    (testpath/"test.md").write <<~EOS
      ---
      title: Test Document
      draft: true
      ---
      # Test Content
    EOS

    output = shell_output("#{bin}/fr get --key title --path #{testpath}/test.md")
    assert_match "Test Document", output
  end
end

class Frontrange < Formula
  desc "Swift package for parsing and managing YAML front matter in text files"
  homepage "https://github.com/DandyLyons/FrontRange"
  url "https://github.com/DandyLyons/FrontRange/archive/refs/tags/v0.3.0-beta.tar.gz"
  sha256 "0019dfc4b32d63c1392aa264aed2253c1e0c2fb09216f8e2cc269bbfb8bb49b5"
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
    assert_match "0.3.0-beta", shell_output("#{bin}/fr --version")

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

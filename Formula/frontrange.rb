class Frontrange < Formula
  desc "Swift package for parsing and managing YAML front matter in text files"
  homepage "https://github.com/DandyLyons/FrontRange"
  url "https://github.com/DandyLyons/FrontRange/archive/refs/tags/v0.2.0-beta.tar.gz"
  sha256 "c2ce2d54a54868e18783feadadff9de0b78bd873b72ebca1ba1fba35e7516cc5"
  license "MIT" # Update if different
  head "https://github.com/DandyLyons/FrontRange.git", branch: "main"

  # Only requires Command Line Tools, not full Xcode
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
    assert_match "0.2.0-beta", shell_output("#{bin}/fr --version")

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

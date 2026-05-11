class McpOmni < Formula
  desc "MCP server for Omni Talos cluster management — native gRPC, no omnictl dependency"
  homepage "https://github.com/qjoly/mcp-omni"
  version "0.1.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/qjoly/mcp-omni/archive/refs/tags/v0.1.3.tar.gz"
      sha256 "dd082c5f303836057468cd091a91e7a9f7b10f2b3b29e485e4f5fc946b065712"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/qjoly/mcp-omni/archive/refs/tags/v0.1.3.tar.gz"
      sha256 "dd082c5f303836057468cd091a91e7a9f7b10f2b3b29e485e4f5fc946b065712"
    end
  end

  def install
    if OS.mac? && Hardware::CPU.arm?
      bin.install "mcp-omni-darwin-arm64" => "mcp-omni"
    elsif OS.linux? && Hardware::CPU.intel?
      bin.install "mcp-omni-linux-amd64" => "mcp-omni"
    end
  end

  test do
    # mcp-omni is a stdio MCP server; just verify it starts and fails gracefully without env vars
    output = shell_output("#{bin}/mcp-omni 2>&1", 1)
    assert_match(/OMNI_ENDPOINT|mcp|error/i, output)
  end
end

class McpOmni < Formula
  desc "MCP server for Omni Talos cluster management — native gRPC, no omnictl dependency"
  homepage "https://github.com/qjoly/mcp-omni"
  version "0.1.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/qjoly/mcp-omni/archive/refs/tags/v0.1.1.tar.gz"
      sha256 "143cd40ce0fb09ca4607bfe5d505d7a7ae3aa930f9f4761c83ca7d1436071704"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/qjoly/mcp-omni/archive/refs/tags/v0.1.1.tar.gz"
      sha256 "143cd40ce0fb09ca4607bfe5d505d7a7ae3aa930f9f4761c83ca7d1436071704"
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

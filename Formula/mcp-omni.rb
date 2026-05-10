class McpOmni < Formula
  desc "MCP server for Omni Talos cluster management — native gRPC, no omnictl dependency"
  homepage "https://github.com/qjoly/mcp-omni"
  version "0.1.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/qjoly/mcp-omni/releases/download/v#{version}/mcp-omni-darwin-arm64"
      sha256 "f6400d9a3d90088846f4d78a4485af81359a74d6e4248de94179a025aa10f4b8"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/qjoly/mcp-omni/releases/download/v#{version}/mcp-omni-linux-amd64"
      sha256 "6000259fb2da88ca6c9db471acb929a00504d5120b4b1bf45e7f5f6ab3553540"
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

require "time"

class TalosctlOidc < Formula
  desc "OIDC certificate exchange server and client for Talos Linux"
  homepage "https://github.com/qjoly/talosctl-oidc"
  url "https://github.com/qjoly/talosctl-oidc/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "480cbdef0b1a0fcb79752d6d62a71e232b8fbea39f48e44da48ca1ba6b48b2d2"
  license "MIT"
  head "https://github.com/qjoly/talosctl-oidc.git", branch: "main"

  depends_on "go" => :build

  def install
    commit = build.head? ? Utils.git_head : version
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{commit}
      -X main.date=#{Time.now.utc.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    system "#{bin}/talosctl-oidc", "--help"
  end
end

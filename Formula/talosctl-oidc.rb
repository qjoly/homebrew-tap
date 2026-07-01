require "time"

class TalosctlOidc < Formula
  desc "OIDC certificate exchange server and client for Talos Linux"
  homepage "https://github.com/qjoly/talosctl-oidc"
  url "https://github.com/qjoly/talosctl-oidc/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "2768a7a82358afd6683246b471c6046dca4759ac760dd92a42fc3fbe2b497c02"
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

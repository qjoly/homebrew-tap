require "time"

class TalosctlOidc < Formula
  desc "OIDC certificate exchange server and client for Talos Linux"
  homepage "https://github.com/qjoly/talosctl-oidc"
  url "https://github.com/qjoly/talosctl-oidc/archive/refs/tags/v0.0.4.tar.gz"
  sha256 "4562f9e55fc8cb1cbe3d59825084822c53184164a5333db5ba890637dddd6d4b"
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

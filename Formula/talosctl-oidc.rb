require "time"

class TalosctlOidc < Formula
  desc "OIDC certificate exchange server and client for Talos Linux"
  homepage "https://github.com/qjoly/talosctl-oidc"
  url "https://github.com/qjoly/talosctl-oidc/archive/refs/tags/v0.0.2.tar.gz"
  sha256 "397c54805bbe739b7e47ffc6c71d328ef0e130d1b349d4c1c11b23a26fe3727f"
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

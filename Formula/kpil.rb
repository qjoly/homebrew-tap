class Kpil < Formula
  desc "Spin up a GitHub Copilot CLI container with a read-only (no-secrets) kubeconfig"
  homepage "https://github.com/qjoly/kpil"
  version "0.0.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/qjoly/kpil/archive/refs/tags/v0.1.1.tar.gz"
      sha256 "a21739632d5a8df734d15393dbeb5d8d44094aa11267100f78eec1bb76ab9e7f"
    end

    on_intel do
      url "https://github.com/qjoly/kpil/archive/refs/tags/v0.1.1.tar.gz"
      sha256 "a21739632d5a8df734d15393dbeb5d8d44094aa11267100f78eec1bb76ab9e7f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/qjoly/kpil/archive/refs/tags/v0.1.1.tar.gz"
      sha256 "a21739632d5a8df734d15393dbeb5d8d44094aa11267100f78eec1bb76ab9e7f"
    end

    on_intel do
      url "https://github.com/qjoly/kpil/archive/refs/tags/v0.1.1.tar.gz"
      sha256 "a21739632d5a8df734d15393dbeb5d8d44094aa11267100f78eec1bb76ab9e7f"
    end
  end

  def install
    bin.install "kpil"
  end

  test do
    assert_match "kpil", shell_output("#{bin}/kpil --help 2>&1")
  end
end

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
      url "https://github.com/qjoly/kpil/releases/download/v0.0.1/kpil_0.0.1_darwin_amd64.tar.gz"
      sha256 "f770b3bd093ff85868650c407390bafda283fa7589bedbad91f41742ca07a90b"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/qjoly/kpil/releases/download/v0.0.1/kpil_0.0.1_linux_arm64.tar.gz"
      sha256 "6c41caf491efcb96a35cbf58ea2c1dd7830a1081d74c6efd6ae17dc126efb7a5"
    end

    on_intel do
      url "https://github.com/qjoly/kpil/releases/download/v0.0.1/kpil_0.0.1_linux_amd64.tar.gz"
      sha256 "2fc3ccd99327ccf6dee7e31176d169597a614d17ba3019d669785ac9c069da04"
    end
  end

  def install
    bin.install "kpil"
  end

  test do
    assert_match "kpil", shell_output("#{bin}/kpil --help 2>&1")
  end
end

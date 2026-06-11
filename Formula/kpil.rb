class Kpil < Formula
  desc "Spin up a GitHub Copilot CLI container with a read-only (no-secrets) kubeconfig"
  homepage "https://github.com/qjoly/kpil"
  version "0.0.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/qjoly/kpil/archive/refs/tags/v0.2.0.tar.gz"
      sha256 "7ccfe1d7554263a7511ce67a33a2f0faa2280c7ea43f2f3c9701521fe04c8a1c"
    end

    on_intel do
      url "https://github.com/qjoly/kpil/archive/refs/tags/v0.2.0.tar.gz"
      sha256 "7ccfe1d7554263a7511ce67a33a2f0faa2280c7ea43f2f3c9701521fe04c8a1c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/qjoly/kpil/archive/refs/tags/v0.2.0.tar.gz"
      sha256 "7ccfe1d7554263a7511ce67a33a2f0faa2280c7ea43f2f3c9701521fe04c8a1c"
    end

    on_intel do
      url "https://github.com/qjoly/kpil/archive/refs/tags/v0.2.0.tar.gz"
      sha256 "7ccfe1d7554263a7511ce67a33a2f0faa2280c7ea43f2f3c9701521fe04c8a1c"
    end
  end

  def install
    bin.install "kpil"
  end

  test do
    assert_match "kpil", shell_output("#{bin}/kpil --help 2>&1")
  end
end

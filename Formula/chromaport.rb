class Chromaport < Formula
  desc "Migrate VS Code / Cursor themes to Superset, Warp, and more"
  homepage "https://github.com/hamsurang/chromaport"
  version "0.4.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/hamsurang/chromaport/releases/download/v0.4.0/chromaport-aarch64-apple-darwin.tar.xz"
      sha256 "d2df09d45f55921546e1432144abe6c138767776d980cd6b2fbb6da5f9762b35"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hamsurang/chromaport/releases/download/v0.4.0/chromaport-x86_64-apple-darwin.tar.xz"
      sha256 "dbdb5a7ab0ea7d129059bc7c89888369a78686750f3ce35bb4e55706ac1f9eb0"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
      url "https://github.com/hamsurang/chromaport/releases/download/v0.4.0/chromaport-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "db4c9523fe4de8805eeb5b84801a3967a7b89de9b4b52bf6160ad7493f86f7ae"
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":     {},
    "x86_64-apple-darwin":      {},
    "x86_64-unknown-linux-gnu": {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "chromaport" if OS.mac? && Hardware::CPU.arm?
    bin.install "chromaport" if OS.mac? && Hardware::CPU.intel?
    bin.install "chromaport" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end

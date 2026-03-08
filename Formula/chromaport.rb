class Chromaport < Formula
  desc "Migrate VS Code / Cursor themes to Superset, Warp, and more"
  homepage "https://github.com/hamsurang/chromaport"
  version "0.3.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/hamsurang/chromaport/releases/download/v0.3.0/chromaport-aarch64-apple-darwin.tar.xz"
      sha256 "f93d2742f5f6ceba1464d5c707e659a2014774ca1127e70c86fca0334e30e351"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hamsurang/chromaport/releases/download/v0.3.0/chromaport-x86_64-apple-darwin.tar.xz"
      sha256 "9ddbc068b7bb2ed0da6cbd0f662945daa6577531753f27fd1b00dd38043ad0e1"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
      url "https://github.com/hamsurang/chromaport/releases/download/v0.3.0/chromaport-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "5505d0a41f18dae46941514126c455a12ad2aace178c791b2c50404a3b4b0892"
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

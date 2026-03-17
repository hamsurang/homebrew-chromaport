class Chromaport < Formula
  desc "Migrate VS Code / Cursor / OpenCode / iTerm2 themes to Superset, Warp, Ghostty, OpenCode, Obsidian, iTerm2, and more"
  homepage "https://github.com/hamsurang/chromaport"
  version "0.10.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/hamsurang/chromaport/releases/download/v0.10.0/chromaport-aarch64-apple-darwin.tar.xz"
      sha256 "37e087fe96e14105da9c0d1810852cfdea8c39378c8ffbf42e1faef77e5d64a5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hamsurang/chromaport/releases/download/v0.10.0/chromaport-x86_64-apple-darwin.tar.xz"
      sha256 "da5e32029afbaa8fc98cb151202db63b56f0de2ee057fd7840d91a7cafabb0c0"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
      url "https://github.com/hamsurang/chromaport/releases/download/v0.10.0/chromaport-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "e8f6b9bc4b5c91526eb45a511f76543424c2c217149a2d53782744e338f85dd8"
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

class Chromaport < Formula
  desc "Migrate VS Code / Cursor / OpenCode / iTerm2 themes to Superset, Warp, Ghostty, OpenCode, Obsidian, iTerm2, WezTerm, and more"
  homepage "https://github.com/hamsurang/chromaport"
  version "0.12.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/hamsurang/chromaport/releases/download/v0.12.0/chromaport-aarch64-apple-darwin.tar.xz"
      sha256 "2967b31b546ba7b39b85ca91c0a94b3b2fac408d42b4a3107a373f70b38100bf"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hamsurang/chromaport/releases/download/v0.12.0/chromaport-x86_64-apple-darwin.tar.xz"
      sha256 "647df06c8c61a43e8f5eefddd4f1ff08d222e5d0cd6e2c2efe538d58db33207d"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/hamsurang/chromaport/releases/download/v0.12.0/chromaport-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "3879c280f04149cd103919ae6fbd0630b623faff8a1c01f5125ee1071a8cfe92"
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

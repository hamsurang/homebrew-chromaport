class Chromaport < Formula
  desc "Migrate VS Code / Cursor / OpenCode / iTerm2 themes to Superset, Warp, Ghostty, OpenCode, Obsidian, iTerm2, WezTerm, and more"
  homepage "https://github.com/hamsurang/chromaport"
  version "0.11.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/hamsurang/chromaport/releases/download/v0.11.0/chromaport-aarch64-apple-darwin.tar.xz"
      sha256 "617df86a9377b2cc8166a55e1f6dc1c6efbfc00df30aebeb70aaaac67317f5cc"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hamsurang/chromaport/releases/download/v0.11.0/chromaport-x86_64-apple-darwin.tar.xz"
      sha256 "6bd3d4ccd3e06cc97a2ad33651c71b6883de1b62e7d94f91834e6c9ff961430a"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
      url "https://github.com/hamsurang/chromaport/releases/download/v0.11.0/chromaport-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "57ab8749df3a592793924bc452b1de557c3a95ed514a2263104f463fa211651b"
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

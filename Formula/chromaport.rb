class Chromaport < Formula
  desc "Migrate VS Code / Cursor themes to Superset, Warp, and more"
  homepage "https://github.com/hamsurang/chromaport"
  version "0.3.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/hamsurang/chromaport/releases/download/v0.3.1/chromaport-aarch64-apple-darwin.tar.xz"
      sha256 "cf7947a74a5d4465bbfab552b4da336642fb7dbc64725205f6e927d03451ddac"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hamsurang/chromaport/releases/download/v0.3.1/chromaport-x86_64-apple-darwin.tar.xz"
      sha256 "59d6bc5229a4cf992020f905cc07a2a5740020ece1e32f42eb00f7da758e31fa"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
      url "https://github.com/hamsurang/chromaport/releases/download/v0.3.1/chromaport-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "6a8d97f2bc82a1bc648140f2bc72b19c9dea7fce0bcdf66dd171d8775c2f673d"
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

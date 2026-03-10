class Chromaport < Formula
  desc "Migrate VS Code / Cursor themes to Superset, Warp, and more"
  homepage "https://github.com/hamsurang/chromaport"
  version "0.5.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/hamsurang/chromaport/releases/download/v0.5.1/chromaport-aarch64-apple-darwin.tar.xz"
      sha256 "ae391dc9e9b0760a539b6a680e25dbc5ca932b52355867a69cbaf327be9f01a8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hamsurang/chromaport/releases/download/v0.5.1/chromaport-x86_64-apple-darwin.tar.xz"
      sha256 "a569eb52799340bafac9d246fb30ddb4f8bd574ff9e2d476a79b55be5c6cce81"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
      url "https://github.com/hamsurang/chromaport/releases/download/v0.5.1/chromaport-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "1d3312cc484786c80f7ace67af82c87fb625daae9e378bd7fd74a6a7dfec9cd0"
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

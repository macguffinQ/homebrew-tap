class TiffanyLoop < Formula
  desc "Lightweight multi-agent orchestration shell for LLM CLIs"
  homepage "https://github.com/macguffinQ/Tiffany"
  version "0.1.26"

  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/macguffinQ/Tiffany/releases/download/v0.1.26/tiffany-loop-v0.1.26-aarch64-apple-darwin.tar.gz"
    sha256 "7dfea83ba487ed738bdaa83a0aa54fcc95b38e86fe836ab12f15da6747ce1a67"
  else
    url "https://github.com/macguffinQ/Tiffany/archive/refs/tags/v0.1.26.tar.gz"
    sha256 "171714fb825d5eb26063fa89876845839a40be655a896465ae97afa2bd23bc23"
    depends_on "rust" => :build
  end

  def install
    if OS.mac? && Hardware::CPU.arm?
      bin.install "orchestrator", "tiffany-loop", "tiffany"
    else
      system "cargo", "install", *std_cargo_args, "--profile", "tiffany-dist"
      system "cargo", "install", *std_cargo_args(path: "tiffany-ui/codex-rs/tiffany-cli"), "--profile", "tiffany-dist"
    end

    system "strip", bin/"orchestrator", bin/"tiffany-loop", bin/"tiffany" if OS.mac? || OS.linux?
  end

  def caveats
    <<~EOS
      Start Tiffany Loop with:
        tiffany-loop

      If Homebrew still reports an old tiffany-loop version after a release:
        brew update
        brew upgrade macguffinQ/tap/tiffany-loop
        brew untap macguffinQ/tap
        brew tap macguffinQ/tap
        brew reinstall macguffinQ/tap/tiffany-loop

      The tiffany command is a compatibility alias; tiffany-loop is the primary command.
    EOS
  end

  test do
    assert_match "orchestrator", shell_output("#{bin}/orchestrator --help")
    assert_match "orchestrator", shell_output("#{bin}/tiffany-loop orchestrator --help 2>/dev/null")
    assert_match "orchestrator status", shell_output("#{bin}/tiffany-loop status --help 2>/dev/null")
  end
end

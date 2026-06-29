class TiffanyLoop < Formula
  desc "Lightweight multi-agent orchestration shell for LLM CLIs"
  homepage "https://github.com/macguffinQ/Tiffany"
  version "0.2.2"

  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/macguffinQ/Tiffany/releases/download/v0.2.2/tiffany-loop-v0.2.2-aarch64-apple-darwin.tar.gz"
    sha256 "46c85e78f58e9f36df5861ae952a93c78ee01eb142b3bf6379abfb98827661cf"
  elsif OS.linux? && Hardware::CPU.intel?
    url "https://github.com/macguffinQ/Tiffany/releases/download/v0.2.2/tiffany-loop-v0.2.2-x86_64-unknown-linux-gnu.tar.gz"
    sha256 "ff8d4674ca4f10f1455959c009891272d674ca900bf4f35c468247c82f401e5e"
  elsif OS.linux? && Hardware::CPU.arm?
    url "https://github.com/macguffinQ/Tiffany/releases/download/v0.2.2/tiffany-loop-v0.2.2-aarch64-unknown-linux-gnu.tar.gz"
    sha256 "99de5cfb56a7656f5eae898fd1eb9b76c8afe863d704f97f5936de8190c6b688"
  else
    url "https://github.com/macguffinQ/Tiffany/archive/refs/tags/v0.2.2.tar.gz"
    sha256 "c9acbacf0b1d10a5511350d88dfa13b874043b670e7496d0076c5d01b57fcafa"
    depends_on "rust" => :build
  end

  def install
    if (OS.mac? && Hardware::CPU.arm?) || (OS.linux? && (Hardware::CPU.arm? || Hardware::CPU.intel?))
      bin.install "tiffany-loop"
      bin.install_symlink "tiffany-loop" => "orchestrator"
      bin.install_symlink "tiffany-loop" => "tiffany"
    else
      system "cargo", "install", *std_cargo_args(path: "tiffany-ui/codex-rs/tiffany-cli"), "--profile", "tiffany-dist"
      bin.install_symlink "tiffany-loop" => "orchestrator"
      bin.install_symlink "tiffany-loop" => "tiffany"
    end

    system "strip", bin/"tiffany-loop" if OS.mac? || OS.linux?
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
    assert_match "Tiffany Loop", shell_output("#{bin}/tiffany --help 2>/dev/null")
    assert_match "orchestrator", shell_output("#{bin}/tiffany-loop orchestrator --help 2>/dev/null")
    assert_match "orchestrator", shell_output("#{bin}/tiffany orchestrator --help 2>/dev/null")
    assert_match "orchestrator status", shell_output("#{bin}/tiffany-loop status --help 2>/dev/null")
  end
end

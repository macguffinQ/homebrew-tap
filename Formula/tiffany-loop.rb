class TiffanyLoop < Formula
  desc "Lightweight multi-agent orchestration shell for LLM CLIs"
  homepage "https://github.com/macguffinQ/Tiffany"

  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/macguffinQ/Tiffany/releases/download/v0.1.12/tiffany-loop-v0.1.12-aarch64-apple-darwin.tar.gz"
    sha256 "1369a7efda1416e80a0b2b9b58ffa8695ea49e85b4148640235eecf5ebd2127f"
  else
    url "https://github.com/macguffinQ/Tiffany/archive/refs/tags/v0.1.12.tar.gz"
    sha256 "5e94a2632b98649bc4cc9dcb09b5e57ff40b27f65ff7f6734dabadb391b6468f"
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

  test do
    assert_match "orchestrator", shell_output("#{bin}/orchestrator --help")
    assert_match "orchestrator", shell_output("#{bin}/tiffany-loop orchestrator --help 2>/dev/null")
  end
end

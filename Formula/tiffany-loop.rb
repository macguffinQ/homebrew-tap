class TiffanyLoop < Formula
  desc "Lightweight multi-agent orchestration shell for LLM CLIs"
  homepage "https://github.com/macguffinQ/Tiffany"

  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/macguffinQ/Tiffany/releases/download/v0.1.20/tiffany-loop-v0.1.20-aarch64-apple-darwin.tar.gz"
    sha256 "2514a1642ceec3a2efa091a57017800afed730b6eb86a64743af5974631c76a1"
  else
    url "https://github.com/macguffinQ/Tiffany/archive/refs/tags/v0.1.20.tar.gz"
    sha256 "8bfbe9ddb3329816ec0befce4d3804ea0721ad0834e8f49c1583f98a3dba4ae1"
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
    assert_match "orchestrator status", shell_output("#{bin}/tiffany-loop status --help 2>/dev/null")
  end
end

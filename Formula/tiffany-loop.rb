class TiffanyLoop < Formula
  desc "Lightweight multi-agent orchestration shell for LLM CLIs"
  homepage "https://github.com/macguffinQ/Tiffany"

  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/macguffinQ/Tiffany/releases/download/v0.1.14/tiffany-loop-v0.1.14-aarch64-apple-darwin.tar.gz"
    sha256 "480253ae9c75971af7ba9eea6ca253bee1eeb63e3d4c4294a753ef155d127f00"
  else
    url "https://github.com/macguffinQ/Tiffany/archive/refs/tags/v0.1.14.tar.gz"
    sha256 "4938055d1b4db02004ea8c2cc487a62ac40f5fc2a1e093097adbaf560713ad06"
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

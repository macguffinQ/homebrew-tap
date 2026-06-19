class TiffanyLoop < Formula
  desc "Lightweight multi-agent orchestration shell for LLM CLIs"
  homepage "https://github.com/macguffinQ/Tiffany"

  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/macguffinQ/Tiffany/releases/download/v0.1.11/tiffany-loop-v0.1.11-aarch64-apple-darwin.tar.gz"
    sha256 "1ec4f07735ab0e1542ffc8eeaee36f8ebfc25413d3809d9071f8c3d8727a2575"
  else
    url "https://github.com/macguffinQ/Tiffany/archive/refs/tags/v0.1.11.tar.gz"
    sha256 "1690ef222dc7604d361277fef810c8589af36fb792d6e3b3d0bef77d4667c8ff"
    depends_on "rust" => :build
  end

  def install
    if OS.mac? && Hardware::CPU.arm?
      bin.install "orchestrator", "tiffany"
    else
      system "cargo", "install", *std_cargo_args, "--profile", "tiffany-dist"
      system "cargo", "install", *std_cargo_args(path: "tiffany-ui/codex-rs/tiffany-cli"), "--profile", "tiffany-dist"
      system "strip", bin/"orchestrator", bin/"tiffany" if OS.mac? || OS.linux?
    end
  end

  test do
    assert_match "orchestrator", shell_output("#{bin}/orchestrator --help")
    assert_match "orchestrator", shell_output("#{bin}/tiffany orchestrator --help 2>/dev/null")
  end
end

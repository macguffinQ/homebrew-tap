class TiffanyLoop < Formula
  desc "Lightweight multi-agent orchestration shell for LLM CLIs"
  homepage "https://github.com/macguffinQ/Tiffany"

  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/macguffinQ/Tiffany/releases/download/v0.1.10/tiffany-loop-v0.1.10-aarch64-apple-darwin.tar.gz"
    sha256 "76a439b83078ab69a6c9c1be4234ee3862d9b1c3db035622c35644e2e9c273a1"
  else
    url "https://github.com/macguffinQ/Tiffany/archive/refs/tags/v0.1.10.tar.gz"
    sha256 "7bc5886ff5c54ce2a899ca0f619090f72d2e6c2d8e1d4d8988fe8b0650aaee83"
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

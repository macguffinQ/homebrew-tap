class TiffanyLoop < Formula
  desc "Lightweight multi-agent orchestration shell for LLM CLIs"
  homepage "https://github.com/macguffinQ/Tiffany"

  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/macguffinQ/Tiffany/releases/download/v0.1.19/tiffany-loop-v0.1.19-aarch64-apple-darwin.tar.gz"
    sha256 "224d06dadfd30ae78959c2ea9f2e1fc6f0061d9117cc5ed4d9b0b42495d0a3c4"
  else
    url "https://github.com/macguffinQ/Tiffany/archive/refs/tags/v0.1.19.tar.gz"
    sha256 "c02fbe468a0bf49aa1f6ed428431b6d092f2ccec3d8e78388d28ee58d4fe8737"
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

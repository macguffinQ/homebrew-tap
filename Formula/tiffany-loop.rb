class TiffanyLoop < Formula
  desc "Lightweight multi-agent orchestration shell for Claude Code, Codex CLI, and LLM agents"
  homepage "https://github.com/macguffinQ/Tiffany"
  version "0.1.9"

  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/macguffinQ/Tiffany/releases/download/v0.1.9/tiffany-loop-v0.1.9-aarch64-apple-darwin.tar.gz"
    sha256 "418c6899fd7307573090fe626583b6bf5eb162aff7ba5404836a111dfea967d4"
  else
    url "https://github.com/macguffinQ/Tiffany/archive/refs/tags/v0.1.9.tar.gz"
    sha256 "9b38837032923530f8c4c24d224250c6c3090c4b5144f001a75858eb2e5eb839"
    depends_on "rust" => :build
  end

  def install
    if OS.mac? && Hardware::CPU.arm?
      bin.install "orchestrator", "tiffany"
    else
      system "cargo", "install", *std_cargo_args, "--profile", "tiffany-dist"
      system "cargo", "install", *std_cargo_args(path: "tiffany-ui/codex-rs/cli"), "--profile", "tiffany-dist"
      system "strip", bin/"orchestrator", bin/"tiffany" if OS.mac?
    end
  end

  test do
    assert_match "orchestrator", shell_output("#{bin}/orchestrator --help")
    assert_match "orchestrator", shell_output("#{bin}/tiffany orchestrator --help")
  end
end

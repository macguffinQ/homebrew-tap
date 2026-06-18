class TiffanyLoop < Formula
  desc "Lightweight multi-agent orchestration shell for Claude Code, Codex CLI, and LLM agents"
  homepage "https://github.com/macguffinQ/Tiffany"
  version "0.0.4"

  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/macguffinQ/Tiffany/releases/download/v0.0.4/tiffany-loop-v0.0.4-aarch64-apple-darwin.tar.gz"
    sha256 "29d193f2a9196d22d438f7d029bd059ce272c7e0359f65e2417fc70c9a394cf8"
  else
    url "https://github.com/macguffinQ/Tiffany/archive/refs/tags/v0.0.4.tar.gz"
    sha256 "aedc6bf67d7e8cf0d1b29709e1621fa4b984224965448320df7cdc97cd5044e7"
    depends_on "rust" => :build
  end

  def install
    if OS.mac? && Hardware::CPU.arm?
      bin.install "orchestrator", "tiffany"
    else
      system "cargo", "install", *std_cargo_args, "--profile", "tiffany-dist"
      system "cargo", "install", *std_cargo_args(path: "tiffany-ui/codex-rs/cli"), "--profile", "tiffany-dist"
    end
  end

  test do
    assert_match "orchestrator", shell_output("#{bin}/orchestrator --help")
    assert_match "orchestrator", shell_output("#{bin}/tiffany orchestrator --help")
  end
end

class TiffanyLoop < Formula
  desc "Lightweight multi-agent orchestration shell for Claude Code, Codex CLI, and LLM agents"
  homepage "https://github.com/macguffinQ/Tiffany"
  version "0.0.3"

  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/macguffinQ/Tiffany/releases/download/v0.0.3/tiffany-loop-v0.0.3-aarch64-apple-darwin.tar.gz"
    sha256 "9b4bd882259211fcfc16c3365b9c50f5a7dee534ac673a9490f1d99ba9260c89"
  else
    url "https://github.com/macguffinQ/Tiffany/archive/refs/tags/v0.0.3.tar.gz"
    sha256 "65adfa1f42ef38cb3f957c8802e13fbc3aee88af0a38ceece341747858edf56a"
    depends_on "rust" => :build
  end

  def install
    if OS.mac? && Hardware::CPU.arm?
      bin.install "orchestrator", "tiffany"
    else
      system "cargo", "install", *std_cargo_args
      system "cargo", "install", *std_cargo_args(path: "tiffany-ui/codex-rs/cli")
    end
  end

  test do
    assert_match "orchestrator", shell_output("#{bin}/orchestrator --help")
    assert_match "orchestrator", shell_output("#{bin}/tiffany orchestrator --help")
  end
end

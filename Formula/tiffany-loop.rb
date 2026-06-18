class TiffanyLoop < Formula
  desc "Lightweight multi-agent orchestration shell for Claude Code, Codex CLI, and LLM agents"
  homepage "https://github.com/macguffinQ/Tiffany"
  version "0.1.6"

  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/macguffinQ/Tiffany/releases/download/v0.1.6/tiffany-loop-v0.1.6-aarch64-apple-darwin.tar.gz"
    sha256 "5c038a10479ea0de2c9aba7990c548564363a4ff928ab3ac6aefcf015aec68c9"
  else
    url "https://github.com/macguffinQ/Tiffany/archive/refs/tags/v0.1.6.tar.gz"
    sha256 "c517f431a1ea1d6310a92abf30a1c1b6b60f1ac1a1a111860e39f8763f92f41c"
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

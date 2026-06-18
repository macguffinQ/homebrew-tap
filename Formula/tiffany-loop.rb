class TiffanyLoop < Formula
  desc "Lightweight multi-agent orchestration shell for Claude Code, Codex CLI, and LLM agents"
  homepage "https://github.com/macguffinQ/Tiffany"
  version "0.1.7"

  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/macguffinQ/Tiffany/releases/download/v0.1.7/tiffany-loop-v0.1.7-aarch64-apple-darwin.tar.gz"
    sha256 "c0a95cc54f53d200cf13bca87386593dbbae7deeeb994edb6d5ea28ca105a6d1"
  else
    url "https://github.com/macguffinQ/Tiffany/archive/refs/tags/v0.1.7.tar.gz"
    sha256 "e4ee25b203abebaf594029c3b18c05ea7afe2e57743de595cc66f4c0cfc32ef0"
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

class TiffanyLoop < Formula
  desc "Lightweight multi-agent orchestration shell for Claude Code, Codex CLI, and LLM agents"
  homepage "https://github.com/macguffinQ/Tiffany"
  version "0.0.1"

  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/macguffinQ/Tiffany/releases/download/v0.0.1/tiffany-loop-v0.0.1-aarch64-apple-darwin.tar.gz"
    sha256 "c892ab9a024d35aecf503e0b66a3b9452d873276a06f35f8491d0f981464a33c"
  else
    url "https://github.com/macguffinQ/Tiffany/archive/refs/tags/v0.0.1.tar.gz"
    sha256 "bf19f39578a5cbbdd35ec7f52a247f9f76a7afa9c2e48c6cfafe40db17de444c"
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

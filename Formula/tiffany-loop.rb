class TiffanyLoop < Formula
  desc "Lightweight multi-agent orchestration shell for Claude Code, Codex CLI, and LLM agents"
  homepage "https://github.com/macguffinQ/Tiffany"
  version "0.0.6"

  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/macguffinQ/Tiffany/releases/download/v0.0.6/tiffany-loop-v0.0.6-aarch64-apple-darwin.tar.gz"
    sha256 "c72eea80e8e76ddaeb1096ef37beb452f2a8a181baf3e9e9874e4a40ea4b75e5"
  else
    url "https://github.com/macguffinQ/Tiffany/archive/refs/tags/v0.0.6.tar.gz"
    sha256 "fcc1f524cabd34de6dd68765f624b2895f0158819840f49e7ad6b94e711c8202"
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

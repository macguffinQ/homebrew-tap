class TiffanyLoop < Formula
  desc "Lightweight multi-agent orchestration shell for Claude Code, Codex CLI, and LLM agents"
  homepage "https://github.com/macguffinQ/Tiffany"
  version "0.1.8"

  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/macguffinQ/Tiffany/releases/download/v0.1.8/tiffany-loop-v0.1.8-aarch64-apple-darwin.tar.gz"
    sha256 "067bd44dddd81fabac27d68d6a0d7eab2d7a35cc824a87e120043c6d3d690a06"
  else
    url "https://github.com/macguffinQ/Tiffany/archive/refs/tags/v0.1.8.tar.gz"
    sha256 "9e0b646dce37fe6fab744a6694c8e6f997f4d178b4701454872e11882d687628"
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

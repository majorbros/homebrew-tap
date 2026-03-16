class Mycelium < Formula
  desc "The underground network for AI agents — LLM-agnostic message bus"
  homepage "https://github.com/majorbros/mycelium"
  url "https://github.com/majorbros/mycelium/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "4c0eec3462826fd223537e916a6e107eaf2adb77b5ab4e301f1dcf504296bc36"
  license "MIT"

  depends_on "mosquitto"
  depends_on "python@3"

  def install
    # Install CLI scripts
    bin.install "bin/myc"
    bin.install "bin/myc-watcher"
    bin.install "bin/myc-historian"
    bin.install "bin/myc-register"

    # Build wait-for-idle on macOS
    if OS.mac?
      system ENV.cc, "src/wait-for-idle.c",
             "-framework", "CoreGraphics",
             "-o", "wait-for-idle"
      bin.install "wait-for-idle"
    end
  end

  def caveats
    <<~EOS
      To get started:
        myc init

      Kitty terminal must have remote control enabled.
      Add to ~/.config/kitty/kitty.conf:
        allow_remote_control socket-only
        listen_on unix:/tmp/kitty-socket

      Start services:
        myc start

      Quick demo (spawns two AI agents chatting):
        myc cultivate
    EOS
  end

  test do
    assert_match "Mycelium", shell_output("#{bin}/myc 2>&1", 0)
  end
end

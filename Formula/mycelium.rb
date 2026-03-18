class Mycelium < Formula
  desc "The underground network for AI agents — LLM-agnostic message bus"
  homepage "https://github.com/majorbros/mycelium"
  url "https://github.com/majorbros/mycelium/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "f25d9daa266eaf1e7bd629286df3b25b6438ca62915ce5754c7db008c23bb16d"
  license "MIT"

  depends_on "mosquitto"
  depends_on "python@3"

  def install
    # Install CLI scripts
    bin.install "bin/myc"
    bin.install "bin/myc-watcher"
    bin.install "bin/myc-historian"
    bin.install "bin/myc-register"
    bin.install "bin/myc-services"

    # Build wait-for-idle on macOS
    if OS.mac?
      system ENV.cc, "src/wait-for-idle.c",
             "-framework", "CoreGraphics",
             "-o", "wait-for-idle"
      bin.install "wait-for-idle"
    end
  end

  service do
    run [Formula["python@3"].opt_bin/"python3", opt_bin/"myc-services"]
    keep_alive true
    log_path var/"log/mycelium.log"
    error_log_path var/"log/mycelium.log"
  end

  def caveats
    <<~EOS
      To get started:
        myc init

      Kitty terminal must have remote control enabled.
      Add to ~/.config/kitty/kitty.conf:
        allow_remote_control socket-only
        listen_on unix:/tmp/kitty-socket

      Start mycelium services (watcher + historian):
        brew services start mycelium

      Mosquitto broker (installed as dependency):
        brew services start mosquitto

      Quick demo (spawns two AI agents chatting):
        myc cultivate
    EOS
  end

  test do
    assert_match "Mycelium", shell_output("#{bin}/myc 2>&1", 0)
  end
end

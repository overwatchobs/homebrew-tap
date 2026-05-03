class OverwatchHelper < Formula
  desc "Local agent for the Overwatch incident-resolution Chrome extension"
  homepage "https://www.overwatch-observability.com"
  version "0.6.0"

  on_macos do
    on_arm do
      url "https://github.com/overwatchobs/overwatch/releases/download/helper-v#{version}/overwatch-helper-macos-arm64.tar.gz"
      sha256 "281224256e6554e5fc077db684ae2e9fb760b16325243b26b3e5e1a66e7e043b"
    end
    on_intel do
      url "https://github.com/overwatchobs/overwatch/releases/download/helper-v#{version}/overwatch-helper-macos-amd64.tar.gz"
      sha256 "60263ef3882cee0e1e26520e1e3c4290b0177b1d114a7001f3eefe13cc2d9cb8"
    end
  end

  def install
    bin.install "overwatch-helper"
  end

  def post_install
    # Idempotent — safe to re-run on every brew install / upgrade.
    system bin/"overwatch-helper", "--install-host"
  end

  def caveats
    <<~EOS
      The Overwatch Helper has registered itself as a Native Messaging host
      for Chrome and other Chromium browsers. Open the Overwatch extension
      to start using it — there's no daemon to start manually.

      To update:    brew upgrade overwatch-helper
      To unregister without uninstalling:
                    overwatch-helper --uninstall-host
    EOS
  end

  def uninstall_postflight
    system bin/"overwatch-helper", "--uninstall-host"
  end

  test do
    assert_match(/overwatch-helper \d+\.\d+\.\d+/, shell_output("#{bin}/overwatch-helper --version"))
    system bin/"overwatch-helper", "--install-host"
    system bin/"overwatch-helper", "--uninstall-host"
  end
end

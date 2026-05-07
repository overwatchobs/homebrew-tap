class OverwatchHelper < Formula
  desc "Local agent for the Overwatch incident-resolution Chrome extension"
  homepage "https://www.overwatch-observability.com"
  version "0.8.1"

  on_macos do
    on_arm do
      url "https://packages.buildkite.com/overwatchobs/overwatch-files/files/overwatch-helper-macos-arm64-#{version}.tar.gz"
      sha256 "b2dfac9a58c2fd71c3e931aa901f7c15e1e0768e32d7f65d2319ebf83f4818cc"
    end
    on_intel do
      url "https://packages.buildkite.com/overwatchobs/overwatch-files/files/overwatch-helper-macos-amd64-#{version}.tar.gz"
      sha256 "ffff53eec30a4d46847889e3a6374949c0ff6ee37f826557ee9b518a5cbb85ce"
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

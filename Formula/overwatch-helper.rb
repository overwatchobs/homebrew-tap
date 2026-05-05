class OverwatchHelper < Formula
  desc "Local agent for the Overwatch incident-resolution Chrome extension"
  homepage "https://www.overwatch-observability.com"
  version "0.6.5"

  on_macos do
    on_arm do
      url "https://packages.buildkite.com/overwatchobs/overwatch-files/files/overwatch-helper-macos-arm64-#{version}.tar.gz"
      sha256 "7456a9884423dd0d0809e8a2dddad6d33b9c5d6e3dcdbaecdd40f4a2a8165587"
    end
    on_intel do
      url "https://packages.buildkite.com/overwatchobs/overwatch-files/files/overwatch-helper-macos-amd64-#{version}.tar.gz"
      sha256 "04085f26d8c28d5e06bf0b879f68bbd55efb7579b68b58d486af754301433e40"
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

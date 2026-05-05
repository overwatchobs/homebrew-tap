class OverwatchHelper < Formula
  desc "Local agent for the Overwatch incident-resolution Chrome extension"
  homepage "https://www.overwatch-observability.com"
  version "0.6.3"

  on_macos do
    on_arm do
      url "https://packages.buildkite.com/overwatchobs/overwatch-files/files/overwatch-helper-macos-arm64-#{version}.tar.gz"
      sha256 "f33c0c376c45d2e9fe14c9a939a3a853697c9b13ee2b7ab33e0d1518b6c9f611"
    end
    on_intel do
      url "https://packages.buildkite.com/overwatchobs/overwatch-files/files/overwatch-helper-macos-amd64-#{version}.tar.gz"
      sha256 "eafa99649c7c174d869731ef7d7d6ee8263f5ff8008d9a2af1bc9a47c7dc8811"
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

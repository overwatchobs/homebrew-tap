class OverwatchHelper < Formula
  desc "Local agent for the Overwatch incident-resolution Chrome extension"
  homepage "https://www.overwatch-observability.com"
  version "0.8.7"

  on_macos do
    on_arm do
      url "https://packages.buildkite.com/overwatchobs/overwatch-files/files/overwatch-helper-macos-arm64-#{version}.tar.gz"
      sha256 "30541364beb08ca55634d910766ab8822de7f152dba4afa69e1f3317e3a5cc1d"
    end
    on_intel do
      url "https://packages.buildkite.com/overwatchobs/overwatch-files/files/overwatch-helper-macos-amd64-#{version}.tar.gz"
      sha256 "580cef4609706ebe9b3aa9d7f215683f0c9bef1929144fb48213facca069c178"
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

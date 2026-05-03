# Overwatch Homebrew tap

Auto-maintained tap for the Overwatch helper agent. Formulae here
are rewritten in full by `helper-release.yml` in
[overwatchobs/overwatch](https://github.com/overwatchobs/overwatch)
on each `helper-v*` tag — do not edit by hand; manual edits will
be overwritten on the next release.

## Install

    brew install overwatchobs/tap/overwatch-helper

The post-install hook registers the Chrome Native Messaging host
for the current user. Run `overwatch-helper --uninstall-host`
to deregister without uninstalling the binary.

cask "cockpit-tools" do
  version "1.3.10"
  sha256 "0cdc78eb16482bfa62d26419f97a18910353b2b0b16cddea2a15497a6f6f7901"

  url "https://github.com/suoak/cockpit-tools/releases/download/v#{version}/SC-Cockpit.Tools_#{version}_universal.dmg",
      verified: "github.com/suoak/cockpit-tools/"
  name "SC-Cockpit Tools"
  desc "Account manager for AI IDEs (Antigravity and Codex)"
  homepage "https://github.com/suoak/cockpit-tools"

  auto_updates true

  postflight do
    system_command "/usr/bin/xattr",
                   args: ["-cr", "#{appdir}/SC-Cockpit Tools.app"],
                   sudo: true
  end

  app "SC-Cockpit Tools.app"

  zap trash: [
    "~/Library/Application Support/com.suoak.cockpit-tools",
    "~/Library/Caches/com.suoak.cockpit-tools",
    "~/Library/Preferences/com.suoak.cockpit-tools.plist",
    "~/Library/Saved Application State/com.suoak.cockpit-tools.savedState",
    "~/Library/Application Support/com.jlcodes.cockpit-tools",
    "~/Library/Caches/com.jlcodes.cockpit-tools",
    "~/Library/Preferences/com.jlcodes.cockpit-tools.plist",
    "~/Library/Saved Application State/com.jlcodes.cockpit-tools.savedState",
  ]

  caveats <<~EOS
    The app is automatically quarantined by macOS. A postflight hook has been added to remove this quarantine.
    If you still encounter the "App is damaged" error, please run:
      sudo xattr -rd com.apple.quarantine "/Applications/SC-Cockpit Tools.app"
  EOS
end

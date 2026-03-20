cask "cockpit-tools" do
  version "0.16.3"
  sha256 "95fcf1b5c730ef6d5361051b46cc61b15d9151b736b8af49ce8f104e422a2761"

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
  ]

  caveats <<~EOS
    The app is automatically quarantined by macOS. A postflight hook has been added to remove this quarantine.
    If you still encounter the "App is damaged" error, please run:
      sudo xattr -rd com.apple.quarantine "/Applications/SC-Cockpit Tools.app"
  EOS
end

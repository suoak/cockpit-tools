cask "cockpit-tools" do
  version "0.16.0"
  sha256 "4f48d9f2f1ba5ab518319bc1a7366cd6e74f3e2f5f3ce8b629f11385a6bf924b"

  url "https://github.com/suoak/cockpit-tools/releases/download/v#{version}/Cockpit.Tools_#{version}_universal.dmg",
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
    "~/Library/Application Support/com.jlcodes.sc-cockpit-tools",
    "~/Library/Caches/com.jlcodes.sc-cockpit-tools",
    "~/Library/Preferences/com.jlcodes.sc-cockpit-tools.plist",
    "~/Library/Saved Application State/com.jlcodes.sc-cockpit-tools.savedState",
  ]

  caveats <<~EOS
    The app is automatically quarantined by macOS. A postflight hook has been added to remove this quarantine.
    If you still encounter the "App is damaged" error, please run:
      sudo xattr -rd com.apple.quarantine "/Applications/SC-Cockpit Tools.app"
  EOS
end

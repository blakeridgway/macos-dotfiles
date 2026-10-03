#!/usr/bin/env bash
# ---------------------------------------------------------------------------
# macos/defaults.sh - sensible macOS defaults, applied with `defaults write`.
#
#   ./macos/defaults.sh --dry-run   # print what would change, change nothing
#   ./macos/defaults.sh             # apply
#
# Safe to re-run. Some changes only take effect after the affected app or
# Finder/Dock restarts; logout/login makes everything stick. This is
# optional - install.sh never runs it unless you pass --macos.
# ---------------------------------------------------------------------------
set -euo pipefail

DRY_RUN=0
[[ "${1:-}" == "--dry-run" ]] && DRY_RUN=1
[[ "${1:-}" == "--help" || "${1:-}" == "-h" ]] && { grep '^#' "$0" | sed 's/^# \{0,1\}//'; exit 0; }

write() {
  # write <domain> <key> <type> <value>
  local domain="$1" key="$2" type="$3" value="$4"
  if [[ $DRY_RUN -eq 1 ]]; then
    printf 'defaults write %s %s -%s %s\n' "$domain" "$key" "$type" "$value"
  else
    defaults write "$domain" "$key" "-$type" "$value"
  fi
}

echo "==> Finder"
write NSGlobalDomain  AppleShowAllExtensions        bool  true
write NSGlobalDomain  NSNavPanelExpandedStateForSaveMode bool true   # expanded save dialogs
write NSGlobalDomain  NSNavPanelExpandedStateForSaveMode2 bool true  # expanded open dialogs
write com.apple.finder AppleShowAllFiles             bool  true
write com.apple.finder ShowPathbar                   bool  true
write com.apple.finder ShowStatusBar                 bool  true
write com.apple.finder _FXSortFoldersFirst           bool  true
write com.apple.finder FXPreferredViewStyle          string clmv      # column view; Nlsv=list, icnv=icons
write com.apple.finder FXDefaultSearchScope          string SCcf      # search the current folder
write com.apple.finder FXEnableExtensionChangeWarning bool false
write com.apple.finder ShowExternalHardDrivesOnDesktop bool true

echo "==> Dock"
write com.apple.dock autohide                    bool  true
write com.apple.dock autohide-delay              float 0.1
write com.apple.dock autohide-time-modifier      float 0.2
write com.apple.dock show-recents                bool  false
write com.apple.dock minimize-to-application     bool  true
write com.apple.dock mineffect                   string scale
write com.apple.dock mru-spaces                  bool  false       # don't reorder Spaces by use
write com.apple.dock tilesize                    int   48

echo "==> Screenshots"
SCREENSHOT_DIR="$HOME/Pictures/Screenshots"
if [[ $DRY_RUN -eq 0 ]]; then mkdir -p "$SCREENSHOT_DIR"; fi
write com.apple.screencapture location          string "$SCREENSHOT_DIR"
write com.apple.screencapture disable-shadow    bool   true
write com.apple.screencapture type              string png

echo "==> Keyboard"
write NSGlobalDomain KeyRepeat                  int  2            # fast key repeat
write NSGlobalDomain InitialKeyRepeat           int  15
write NSGlobalDomain ApplePressAndHoldEnabled   bool false        # hold a key = repeat, not accent menu
write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled bool false
write NSGlobalDomain NSAutomaticCapitalizationEnabled     bool false

echo "==> Trackpad (tap to click)"
write com.apple.AppleMultitouchTrackpad Clicking bool true
write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking bool true

echo "==> Menu bar clock"
write com.apple.menuextra.clock DateFormat string "EEE d MMM  HH:mm"

echo "==> TextEdit"
write com.apple.TextEdit RichText bool false    # plain text by default

echo "==> Misc"
write com.apple.desktopservices DSDontWriteNetworkStores bool true   # no .DS_Store on network shares
write com.apple.desktopservices DSDontWriteUSBStores     bool true

if [[ $DRY_RUN -eq 0 ]]; then
  echo "==> Restarting Finder and Dock so changes take effect..."
  killall Finder 2>/dev/null || true
  killall Dock   2>/dev/null || true
  echo "Done. Log out and back in if anything still looks stale."
else
  echo "(dry run - nothing changed)"
fi

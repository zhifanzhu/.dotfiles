#!/bin/bash
# Set up "Cmd+click a remote file link in iTerm2 → fetch it and show it in Finder".
# Run once on each Mac:   ~/dotfiles/iterm2-open-file-link/install.sh
#
# 1. links ~/bin/iterm2-open-file-link → this folder's script
# 2. sets iTerm2 → Settings → Advanced → "Command to run when opening a clicked URL"
# Undo:  defaults delete com.googlecode.iterm2 UrlHandlerCommand
set -euo pipefail

here="$(cd "$(dirname "$0")" && pwd)"
script="$HOME/bin/iterm2-open-file-link"

mkdir -p "$HOME/bin"
ln -sfn "$here/iterm2-open-file-link" "$script"
echo "linked $script → $here/iterm2-open-file-link"

# The clicked URL is passed through a quoted heredoc so it can never run as shell code.
# \(background), \(jobPid) and \(url) are filled in by iTerm2.
setting=$(printf '%s \\(background) \\(jobPid) <<%s\n\\(url)\n%s' \
          "$script" "'ITERM2_URL_END'" "ITERM2_URL_END")
defaults write com.googlecode.iterm2 UrlHandlerCommand -string "$setting"
echo "iTerm2 setting written:"
echo "$setting" | sed 's/^/    /'

# Checks
for host in u6xd-vultr u6xd-seis vultr; do
    if grep -qE "^Host .*\b$host\b" "$HOME/.ssh/config" 2>/dev/null; then
        echo "ok: ssh host '$host' found"
    else
        echo "note: ssh host '$host' not in ~/.ssh/config (only needed if you use that route)"
    fi
done
echo "Needs iTerm2 3.7.6 or newer. If Cmd+click doesn't fetch yet, restart iTerm2 once."

#!/bin/bash
set -e


# Run dotfile linking once
$HOME/dotfiles/symlinks.sh || echo "Dotfiles linking failed, skipping..."

# Keep the container alive with a shell
exec "$@"


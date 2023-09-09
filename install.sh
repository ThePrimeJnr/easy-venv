#!/bin/bash

# Check if 'pip' is installed
if ! command -v pip &> /dev/null; then
  echo "❌ Error: 'pip' is not installed. Please install pip to continue."
  exit 1
fi

# Uninstall 'venv' package if it's installed, but ignore errors if it's not found
pip uninstall -y venv &> /dev/null || true

# Prompt the user to install virtualenv
echo "🔧 Installing virtualenv..."
pip install virtualenv &> /dev/null

# Check if installation was successful
if [ $? -eq 0 ]; then
  echo "✅ virtualenv installation successful!"
else
  echo "❌ Error: Failed to install virtualenv. Please check your internet connection or try installing it manually."
  exit 1
fi

# Check if 'source venv.sh' is already aliased to 'venv'
if ! alias venv 2>/dev/null; then
  # Move 'venv.sh' to ~/usr/bin/venv
  cp venv.sh ~/.local/bin/venv

  # Create an alias for 'venv' command
  alias venv="source ~/.local/bin/venv"

  echo "✅ Installation successful! 🚀"
  echo "You can now use the 'venv' command to activate your virtual environments."
else
  echo "❌ Error: 'venv' alias already exists. Please choose a different name for the alias."
  exit 1
fi


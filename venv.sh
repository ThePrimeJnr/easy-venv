#!/bin/bash

# Define the directory where you want to store your virtual environments (relative to the current directory)
VENVS_DIR=".venvs"

# Check for the correct number of arguments
if [ $# -lt 1 ]; then
  operation="help"  # Default to "help" if no arguments are provided
else
  operation="$1"
fi

# Parse the command and arguments
envname="$2"

# Determine the absolute path to the current working directory
cwd=$(pwd)

case "$operation" in
  "create")
    # Check for the correct number of arguments
    if [ -n "$envname" ]; then
      # Create the .venvs directory if it doesn't exist
      mkdir -p "$cwd/$VENVS_DIR"
      # Create a new virtual environment in the current directory
      if virtualenv "$cwd/$VENVS_DIR/$envname" > /dev/null 2>&1; then
        echo "✅ Virtual environment '$envname' created successfully!"
      else
        echo "❌ Error: Failed to create virtual environment '$envname'."
      fi
    else
      echo "❌ Error: Missing virtual environment name for creation."
    fi
    ;;
  "activate")
    # Activate a virtual environment
    if [ -n "$envname" ]; then
      if [ -d "$cwd/$VENVS_DIR/$envname" ]; then
        if source "$cwd/$VENVS_DIR/$envname/bin/activate"; then
          echo "✅ Activated virtual environment '$envname'."
        else
          echo "❌ Error: Failed to activate virtual environment '$envname'."
        fi
      else
        echo "❌ Error: Virtual environment '$envname' does not exist."
      fi
    else
      echo "❌ Error: Missing virtual environment name for activation."
    fi
    ;;
  "deactivate")
    # Check if we are currently in a virtual environment
    if [ -n "$VIRTUAL_ENV" ]; then
      deactivate
      echo "✅ Deactivated the currently active virtual environment."
    else
      echo "❌ Error: You are not currently in a virtual environment. Nothing to deactivate."
    fi
    ;;
  "list")
    # List all available virtual environments in the current directory
    if [ -d "$cwd/$VENVS_DIR" ]; then
      venv_list=$(ls -1 "$cwd/$VENVS_DIR/")
      if [ -n "$venv_list" ]; then
        echo "📋 Available virtual environments:"
        echo "$venv_list"
      else
        echo "❌ No virtual environments found in '$VENVS_DIR'."
      fi
    else
      echo "❌ Error: Directory '$VENVS_DIR' does not exist."
    fi
    ;;
  "remove")
    # Remove a virtual environment
    if [ -n "$envname" ]; then
      if [ -d "$cwd/$VENVS_DIR/$envname" ]; then
        rm -rf "$cwd/$VENVS_DIR/$envname"
        echo "✅ Removed virtual environment '$envname'."
      else
        echo "❌ Error: Virtual environment '$envname' does not exist."
      fi
    else
      echo "❌ Error: Missing virtual environment name for removal."
    fi
    ;;
  "help")
    # Display usage information
    echo "Usage: $0 <operation> [envname]"
    echo "Operations:"
    echo "  create <envname> - Create a virtual environment with the specified name."
    echo "  activate <envname> - Activate a virtual environment."
    echo "  deactivate - Deactivate the currently active virtual environment."
    echo "  list - List all available virtual environments."
    echo "  remove <envname> - Remove a virtual environment."
    ;;
  *)
    echo "❌ Error: Invalid operation: $operation"
    echo "Use '$0 help' for usage information."
    ;;
esac


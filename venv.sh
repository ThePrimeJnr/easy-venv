#!/bin/bash
# List all av#!/bin/bash

# Define the directory where you want to store your virtual environments (relative to the current directory)
VENVS_DIR=".venvs"

# Define usage function to display error messages
usage() {
  echo "Usage: $0 <operation> [envname]"
  echo "Operations:"
  echo "  create <envname> - Create a virtual environment with the specified name."
  echo "  activate <envname> - Activate a virtual environment."
  echo "  deactivate - Deactivate the currently active virtual environment."
  echo "  list - List all available virtual environments."
  echo "  remove <envname> - Remove a virtual environment."
  exit 1
}

deactivate () {
        unset -f pydoc > /dev/null 2>&1 || true
        if ! [ -z "${_OLD_VIRTUAL_PATH:+_}" ]
        then
                PATH="$_OLD_VIRTUAL_PATH" 
                export PATH
                unset _OLD_VIRTUAL_PATH
        fi
        if ! [ -z "${_OLD_VIRTUAL_PYTHONHOME+_}" ]
        then
                PYTHONHOME="$_OLD_VIRTUAL_PYTHONHOME" 
                export PYTHONHOME
                unset _OLD_VIRTUAL_PYTHONHOME
        fi
        hash -r 2> /dev/null
        if ! [ -z "${_OLD_VIRTUAL_PS1+_}" ]
        then
                PS1="$_OLD_VIRTUAL_PS1" 
                export PS1
                unset _OLD_VIRTUAL_PS1
        fi
        unset VIRTUAL_ENV
        unset VIRTUAL_ENV_PROMPT
        if [ ! "${1-}" = "nondestructive" ]
        then
                unset -f deactivate
        fi
}

# Check for the correct number of arguments
if [ $# -lt 1 ]; then
  usage
fi

# Parse the command and arguments
operation="$1"
envname="$2"

# Determine the absolute path to the current working directory
cwd=$(pwd)

case "$operation" in
  "create")
    # Check for the correct number of arguments
    if [ -n "$envname" ]; then
      # Create the .venvs directory if it doesn't exist
      mkdir -p "$cwd/$VENS_DIR"
      # Create a new virtual environment in the current directory
      virtualenv "$cwd/$VENVS_DIR/$envname"
    else
      echo "Missing virtual environment name for creation."
      exit 1
    fi

    ;;
  "activate")
    # Activate a virtual environment
    if [ -n "$envname" ]; then
      if [ -d "$cwd/$VENVS_DIR/$envname" ]; then
        source "./$VENVS_DIR/$envname/bin/activate"
      else
        echo "Virtual environment '$envname' does not exist."
        exit 1
      fi
    else
      echo "Missing virtual environment name for activation."
      exit 1
    fi
    ;;
  "deactivate")
    # Check if we are currently in a virtual environment
    if [ -n "$VIRTUAL_ENV" ]; then
      deactivate
    else
      echo "You are not currently in a virtual environment. Nothing to deactivate."
    fi
    ;;
  "list")
    # List all available virtual environments in the current directory
    if [ -d "$cwd/$VENVS_DIR" ]; then
      ls -1 "$cwd/$VENVS_DIR/"
    else
      exit 1
    fi
    ;;
  "remove")
    # Remove a virtual environment
    if [ -n "$envname" ]; then
      if [ -d "$cwd/$VENVS_DIR/$envname" ]; then
        rm -rf "$cwd/$VENVS_DIR/$envname"
      else
        echo "Virtual environment '$envname' does not exist."
        exit 1
      fi
    else
      echo "Missing virtual environment name for removal."
      exit 1
    fi
    ;;
  *)
    echo "Invalid operation: $operation"
    usage
    ;;
esac


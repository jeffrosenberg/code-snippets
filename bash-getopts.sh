#!/usr/bin/env bash

##
# This file is an example of how to use Bash getopts for parsing CLI options
# Not to be confused with GNU getopt!
# See https://sookocheff.com/post/bash/parsing-bash-script-arguments-with-shopts/ for a good overview
#
# Advantages of getopts:
# - Cleaner parsing
# - Built-in, no separate install
# Disadvantages of getopts:
# - No long arguments
##

# Display usage on the command line
usage() {
cat <<EOF
Usage:
  helm-guard.sh {client_name} {env_name} [-a {install/uninstall}] [-f]"

  Execution options:
  -a [action]    Helm action (install/uninstall)
  -f             Bypass validation and automatically return success

  -h             Display this message
EOF
}

# Display errors
error() {
  printf '%s\n\n' "$1"
  usage
  exit 1
} >&2

# Display help
help() {
  printf "Double-check Helm actions against their environment before running\n\n"
  usage
}

client=
action=install
env=local

# extract options and their arguments into variables.
while getopts ":a:fh" opt; do
  case ${opt} in
    h)
      help 
      exit 0
      ;;
    f)
      echo "Validation skipped"
      exit 0
      ;;
    a)
      action="${OPTARG,,}" # to lowercase
      ;;
    \? )
      error "Invalid option: ${opt}"
      ;;
    : )
      error "Invalid option: ${opt} requires an argument"
      ;;
  esac
done

# Parse positional arguments
shift $((OPTIND -1))
if [[ "$#" -lt 2 ]]; then
  error "Incorrect number of arguments"
fi
client="$1"
env="$2"
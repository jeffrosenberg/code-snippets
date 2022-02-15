#!/usr/bin/env bash

##
# This file is an example of how to use gnu-getopt for parsing CLI options
# brew install gnu-getopt
# Not to be confused with Bash built-in getopts!
#
# Advantages of getopt:
# - Accepts both short and long arguments
# Disadvantages of getopt:
# - Requires separate installation on macOS, so much less portable
##

# Display usage on the command line
usage() {
cat <<EOF
Usage:
  docker-retag.sh {from_tag} {to_tag} [--tag] [--push]"

  from_sha                The existing tag on your computer
  to_sha                  The new tag to apply to the image

  Execution options:
  -c --client [name]      Client whose images should be targeted

  -t --tag                Retag {from_tag} to {to_tag}
  -p --push               Push {to_tag} to the origin
  NOTE: If neither --tag or --push is specified, nothing will happen

  -h --help               Display this message
EOF
}

# Display errors
error() {
  printf "$1\n\n"
  usage
  exit 1
} >&2

# Display help
help() {
  printf "Utility to re-tag already-built Docker images\n\n"
  usage
}

tag=0
push=0
client=

# read command-line options
ARGS=$(getopt -o tpc:h --long tag,push,client:,help -n 'docker-retag.sh' -- "$@")
eval set -- "$ARGS"

# extract options and their arguments into variables.
while true ; do
  case "$1" in
    -h|--help)
      help 
      exit 0
      ;;
    -t|--tag)
      tag=1
      shift 
      ;;
    -p|--push)
      push=1
      shift 
      ;;
    -c|--client)
      client="${2,,}" # to lowercase
      [[ "${client}" = "hotel-reference" ]] && client="hotel"
      shift 2
      ;;
    --) # End of option arguments
      shift
      break;
      ;;
    *)
      break
      ;;
  esac
done

# Parse positional arguments
if [[ "$#" -lt 2 ]]; then
  error "Incorrect number of arguments"
fi
from="$1"
to="$2"

if [[ $tag -eq 0 ]] && [[ $push -eq 0 ]]; then
  echo "No action specified"
  echo
  usage
fi
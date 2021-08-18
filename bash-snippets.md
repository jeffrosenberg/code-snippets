# Bash

## Common script functionality
```bash
# Get the directory of the script
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# Check number of arguments
if [[ "$#" -lt 2 ]]; then
  error "Incorrect number of arguments"
fi

# Echo to stderr
echo "Invalid input detected!" >&2
>&2 echo "Invalid input detected!"

# Get a field from stdin using `cut`
# cut -d "delimiter" -f (field number) file.txt
# default delimiter is tab
cut -d ' ' -f 2 file.txt
# Combine multiple delimiters into one
tr -s ' ' file.txt | cut -d ' ' -f 2
```

## Redirect file descriptor streams
```bash
# Echo to stderr
echo "Invalid input detected!" >&2
>&2 echo "Invalid input detected!"

# Echo stderr to stdout
echo "This input should be on stderr" 2>&1

## Echo all to /dev/null
my_prog.sh &>/dev/null
```

## Comparisons

> For more, see:
> https://tldp.org/LDP/abs/html/testconstructs.html
> https://tldp.org/LDP/abs/html/fto.html
> https://tldp.org/LDP/abs/html/comparison-ops.html

```bash
# String comparison
[[ $a == z* ]]   # True if $a starts with an "z" (pattern matching).
[[ $a == "z*" ]] # True if $a is equal to z* (literal matching).

[ $a == z* ]     # File globbing and word splitting take place.
[ "$a" == "z*" ] # True if $a is equal to z* (literal matching).

[ -z "$String" ] # String is null
[ -n "$String" ] # String is not null
```

## Variables
```bash
# Use indirection to reference a dynamic variable name
function openshift_login() {
  client=${1:-TAL}
  oc_env=OPENSHIFT_${client^^}
  oc login "${!oc_env}"
}

# Change variable casing
# More examples here: https://linuxhint.com/bash_lowercase_uppercase_strings/
ucase="${STRING^^}"
lcase="${STRING,,}"
```

## Arrays
```bash
# Counting array size
echo ${#images[@]}
if [[ ${#images[@]} -gt 1 ]]; then
  echo "Yup"
fi

# Splitting strings on a delimiter
# Single var
IFS=':' read -r out1 out2 <<< "$input_variable"
# Pipeline
while IFS=':' read -r out1 out2 out3; do
  # ... 
done <<< "$input_variable"
```

## Loops
```bash
# For loop over monotonic integers
for (( i=0; i<3; i++)); do HASH="$HASH#"; done
```

## Here docs

A helpful heredoc resource: https://linuxize.com/post/bash-heredoc/

```bash
cat <<EOF
Usage:
  docker-retag.sh {from_tag} {to_tag}

  from_sha                The existing tag on your computer
  to_sha                  The new tag to apply to the image
EOF

# Piping to another file
cat <<EOF > /path/to/my.file
Usage:
  docker-retag.sh {from_tag} {to_tag}

  from_sha                The existing tag on your computer
  to_sha                  The new tag to apply to the image
EOF
```


## Formatting
```bash
# Regular Colors
black="\033[0;30m"
red="\033[0;31m"
green="\033[0;32m"
yellow="\033[0;33m"
blue="\033[0;34m"
magenta="\033[0;35m"
cyan="\033[0;36m"
white="\033[0;37m"

# bright
bBlack="\033[1;30m"
bRed="\033[1;31m"
bGreen="\033[1;32m"
bYellow="\033[1;33m"
bBlue="\033[1;34m"
bMagenta="\033[1;35m"
bCyan="\033[1;36m"
bWhite="\033[1;37m"

# Underline
uBlack="\033[4;30m"
uRed="\033[4;31m"
uGreen="\033[4;32m"
uYellow="\033[4;33m"
uBlue="\033[4;34m"
uMagenta="\033[4;35m"
uCyan="\033[4;36m"
uWhite="\033[4;37m"

# Background
bgBlack="\033[40m"
bgRed="\033[41m"
bgGreen="\033[42m"
bgYellow="\033[43m"
bgBlue="\033[44m"
bgMagenta="\033[45m"
bgCyan="\033[46m"
bgWhite="\033[47m"

reset="\033[0m"
```
#!/bin/bash
# First argument is the directory to be searched
# Second is the directory to create hardlinks in

find "$1" -type f -exec ./link.sh "$2" {} \;

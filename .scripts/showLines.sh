#!/bin/bash

lines=${3:-10}
sed ''"$(expr $2 - $lines)"','"$(expr $2 + $lines)"'!d' "$1"

#!/bin/bash

vim `find . -type f -iname "$*" -print -quit`

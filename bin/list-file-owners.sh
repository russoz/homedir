#!/bin/ksh

dir="$1"

find $dir -print0 | xargs -0 ls -ld | awk '{ print $3 }' | sort | uniq

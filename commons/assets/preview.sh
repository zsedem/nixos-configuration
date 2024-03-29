#!/usr/bin/env bash
#Source: https://github.com/junegunn/fzf.vim/blob/0452b71830b1a219b8cdc68141ee58ec288ea711/bin/preview.sh
# For local changes just follow the git history
#MIT License
#
#Copyright (c) 2021 Junegunn Choi
#
#Permission is hereby granted, free of charge, to any person obtaining a copy
#of this software and associated documentation files (the "Software"), to deal
#in the Software without restriction, including without limitation the rights
#to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#copies of the Software, and to permit persons to whom the Software is
#furnished to do so, subject to the following conditions:
#
#The above copyright notice and this permission notice shall be included in all
#copies or substantial portions of the Software.
#
#THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
#SOFTWARE.


REVERSE="\x1b[7m"
RESET="\x1b[m"

if [ -z "$1" ]; then
  echo "usage: $0 FILENAME[:LINENO][:IGNORED]"
  exit 1
fi

IFS=':' read -r -a INPUT <<< "$1"
FILE=${INPUT[0]}
CENTER=${INPUT[1]}

if [[ "$1" =~ ^[A-Za-z]:\\ ]]; then
  FILE=$FILE:${INPUT[1]}
  CENTER=${INPUT[2]}
fi

if [[ -n "$CENTER" && ! "$CENTER" =~ ^[0-9] ]]; then
  exit 1
fi
CENTER=${CENTER/[^0-9]*/}

FILE="${FILE/#\~\//$HOME/}"
if [ ! -r "$FILE" ]; then
  echo "File not found ${FILE}"
  exit 1
fi

if [ -z "$CENTER" ]; then
  CENTER=0
fi

BATNAME="bat"

LINE_RANGE_FROM=$(( $CENTER - $(tput lines) / 2 ))
LINE_RANGE_FROM=$(( $LINE_RANGE_FROM < 0 ? 0 : $LINE_RANGE_FROM ))
LINE_RANGE_TO=$(( $LINE_RANGE_FROM + $(tput lines)))

${BATNAME} --style="numbers" \
    --line-range "$LINE_RANGE_FROM:$LINE_RANGE_TO" \
    --color=always --pager=never \
    --highlight-line=$CENTER -- "$FILE"


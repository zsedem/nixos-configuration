#!/usr/bin/env bash

IFS=':'; arrIN=($1); unset IFS;
FILE=${arrIN[0]}
LINE_NUMBER=${arrIN[1]}
nvim "+$LINE_NUMBER" "$FILE"

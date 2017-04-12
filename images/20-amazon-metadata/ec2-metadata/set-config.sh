#!/bin/bash

[ -f "$1" ] || exit 1

ros config merge < "${1}"

#!/usr/bin/env bash 
# Absolute path this script is in, thus /home/user/bin
SCRIPTPATH=$(dirname "$0")

PYTHON="python3"
if ! [ -x "$(command -v $PYTHON)" ]; then
	PYTHON="python"
fi

$PYTHON $SCRIPTPATH/proto_gen.py

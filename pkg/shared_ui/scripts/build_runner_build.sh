#!/bin/bash

cd "$(dirname "$0")" || exit

cd .. && dart run build_runner build -d

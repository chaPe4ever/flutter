#!/bin/bash

cd "$(dirname "$0")" || exit

cd .. && dart pub global run index_generator
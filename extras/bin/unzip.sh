#!/bin/bash
ZIP="$1"
unzip "$ZIP" -d "$(echo $ZIP | rev | cut -c5- | rev)"

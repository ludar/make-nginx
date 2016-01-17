#!/bin/bash

# Build from sources fetched with bin/sources.sh using etc/configure.opt configuration
# Install into /usr/local/nginx

APP_PATH=$(dirname "$0" | xargs -I{} readlink -m {}/..)
. $APP_PATH/share/lib.sh

function usage() {
	bye Usage: $(basename "$0") nginx_sources_dir
}

[[ -n "$1" ]] || usage

root_only

nginx_dir=$(readlink -m "$1")

# Check for dir name ending with /nginx-X.Y.Z
[[ "$nginx_dir" =~ /nginx-([0-9]+\.){2}[0-9]+$ ]] || bye_no the dir doesnt look like a one of nginx sources

# Check for dir existence
[[ -d "$nginx_dir" ]] || bye_no the dir doesnt exist

q cd "$nginx_dir" || bye_no cant chdir to the dir

# Prepare configure options
options=$(sed -r 's/^\s+//' "$APP_PATH"/etc/configure.opt | grep -v ^# | tr '\n' ' ')

# Configure sources
echo $options | xargs ./configure

[[ $? -eq 0 ]] || bye_no error on configure stage

# Compile
make -j4 || bye_no error on make stage

# Install
make install || bye_no error on install stage

#!/bin/bash

# Fetch nginx+modules sources based on etc/versions

APP_PATH=$(dirname "$0" | xargs -I{} readlink -m {}/..)
. $APP_PATH/share/lib.sh

function usage() {
	bye Usage: $(basename "$0") sources_dir
}

[[ -n "$1" ]] || usage

# Important here to ensure all read/write in the set of tools is done by the same user
root_only

sources_dir=$(readlink -m "$1")

# Check for dir existence
[[ -d "$sources_dir" ]] || bye_no the dir doesnt exist

q cd "$sources_dir" || bye_no cant chdir to the dir

. $APP_PATH/etc/versions.sh
ng_name=nginx-$ng_version

# Get nginx sources
download http://nginx.org/download/$ng_name.tar.gz $ng_name.tar.gz || exit
tar xf $ng_name.tar.gz || exit
mkdir -p $ng_name/extra || exit

for module in ${!ng_modules[@]}; do
	version=${ng_modules["$module"]}
	name=$module-$version
	source=${ng_sources["$module"]}
	
	download ${source/\{\}/$version} $name.tar.gz || exit
	tar xf $name.tar.gz || exit
	# Overwrite existing symlink if any
	ln -sfn ../../$name $ng_name/extra/$module || exit
done

echo nginx: $ng_version
for module in ${!ng_modules[@]}; do
	echo $module: ${ng_modules["$module"]}
done

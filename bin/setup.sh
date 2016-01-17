#!/bin/bash

# Install/uninstall customized nginx binary built with bin/make.sh
# The customized binary uses /etc/nginx stock conf

APP_PATH=$(dirname "$0" | xargs -I{} readlink -m {}/..)
. $APP_PATH/share/lib.sh

function usage() {
	bye Usage: $(basename "$0") --install\|--uninstall
}

root_only

. $APP_PATH/etc/pathes.sh

# Check if both binaries exist
[[ -f $nginx_stock_bin ]] || bye_no $nginx_stock_bin not found
[[ -f $nginx_custom_bin ]] || bye_no $nginx_custom_bin not found

[[ $(readlink -n $nginx_stock_bin) == $nginx_custom_bin ]] && installed=yes

case $1 in
	--install)
		[[ -z $installed ]] || bye_no custom binary is already is use

		nginx_stop

		# Hold nginx packages
		pkg_hold hold nginx

		# Install custom binary
		override_set $nginx_stock_bin $nginx_custom_bin

		# Reuse stock conf
		override_set $nginx_custom_conf $nginx_stock_conf
		
		nginx_start || exit
	;;
	--uninstall)
		[[ $installed ]] || bye_no stock binary is already in use
		nginx_stop

		# Unhold nginx packages
		pkg_hold unhold nginx

		# Restore stock binary
		override_unset $nginx_stock_bin

		# Restore custom conf
		override_unset $nginx_custom_conf

		nginx_start || exit
	;;
	*)
		usage
	;;
esac

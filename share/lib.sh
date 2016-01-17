function bye() {
	echo "$@"
	exit
}
function bye_no() {
	bye -- "$@"
}
function q() {
	"$@" >/dev/null 2>&1
}

function root_only() {
	[[ $EUID -eq 0 ]] || bye_no this script should be run by root
}

# pkg_list install nginx
# pkg_list hold nginx
function pkg_list() {
	dpkg --get-selections | grep $1 | grep $2 | cut -f1
}
# pkg_hold hold nginx
# pkg_hold unhold nginx
function pkg_hold() {
	local match
	[[ $1 == "hold" ]] && match=install || match=hold

	echo .. $1 $2 packages
	pkg_list $match $2 | xargs -r apt-mark $1
	echo .. done
}

# download http://abc.com/something downloads/somefilename
function download() {
	local url=$1
	local file=$2
	local opt

	[[ -f $file ]] && opt="-z $file"

	curl -RL -o $file $opt $url
}

function override_set() {
	# Just a precaution
	[[ -e $2 ]] || bye_no target doesnt exist in override_set

	mv -T $1 $1-org
	ln -s $2 $1
}
function override_unset() {
	# Just a precaution
	[[ -e $1-org ]] || bye_no target doesnt exist in override_unset

	rm $1
	mv -T $1-org $1
}

function nginx_stop() {
	service nginx stop
}
function nginx_start() {
	service nginx start
}

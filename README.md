# make-nginx

Tools to build and deploy a customised nginx quickly on ubuntu.

*STOCK NGINX MUST BE INSTALLED FIRST!!*

*CUSTOMIZED BINARY IS RUNNING ON THE SAME /etc/nginx/nginx.conf*

```bin/sources.sh DIR``` fetch nginx and modules sources according to ```etc/versions.sh```.
Sources are stored to DIR under corresponding subdirs.
```extra``` subdir is created under nginx sources dir and symlinks to all modules are created in it.

```bin/make.sh NGINX_SRC_DIR``` build nginx from sources (downloaded with ```bin/sources.sh```) using configuration in ```etc/configure.opt```.
The configuration file is plain text with ```^\s*#.*$``` comments. After built it is installed into ```/usr/local/nginx```

```bin/setup.sh --install|--uninstall``` install/uninstall the customized binary.

```--install``` works as:
- stop nginx
- hold all nginx packages
- rename /usr/sbin/nginx into nginx-org and symlink /usr/sbin/nginx to /usr/local/nginx/sbin/nginx
- start nginx

```--uninstall``` words as:
- stop nginx
- unhold all nginx packages
- remove /usr/sbin/nginx and rename /usr/sbin/nginx-org to nginx
- start nginx

There are checks so you cant install/uninstall twice.

Sample use
---------------------
```
cd /root
git clone git@github.com:ludar/make-nginx.git
mkdir tmp
make-nginx/bin/sources.sh tmp
make-nginx/bin/make.sh tmp/nginx-1.8.0
make-nginx/bin/setup.sh --install
```

You're running the customized binary now
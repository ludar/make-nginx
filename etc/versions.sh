ng_version=1.8.0

declare -A ng_modules=(\
	["nginx-vod-module"]="1.5.2"\
)

# Use {} as a version placeholder.
# tar.gz only
declare -A ng_sources=(\
	["nginx-vod-module"]="https://github.com/kaltura/nginx-vod-module/archive/{}.tar.gz"\
)

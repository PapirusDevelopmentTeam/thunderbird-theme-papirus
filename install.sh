#!/bin/sh

set -e

gh_repo="thunderbird-theme-papirus"
gh_desc="Papirus icons for Thunderbird"

cat <<- EOF



      ppppp                         ii
      pp   pp     aaaaa   ppppp          rr  rrr   uu   uu     sssss
      ppppp     aa   aa   pp   pp   ii   rrrr      uu   uu   ssss
      pp        aa   aa   pp   pp   ii   rr        uu   uu      ssss
      pp          aaaaa   ppppp     ii   rr          uuuuu   sssss
                          pp
                          pp


  $gh_desc
  https://github.com/PapirusDevelopmentTeam/$gh_repo


EOF

: "${DESTDIR:=$HOME/.thunderbird}"
: "${TAG:=master}"

_msg() {
    echo "=>" "$@" >&2
}

_rm() {
    # removes parent directories if empty
    rm -rf "$1"
    rmdir -p "$(dirname "$1")" 2>/dev/null || true
}

_download() {
    _msg "Getting the latest version from GitHub ..."
    wget -O "$temp_file" \
        "https://github.com/PapirusDevelopmentTeam/$gh_repo/archive/$TAG.tar.gz"
    _msg "Unpacking archive ..."
    tar -xzf "$temp_file" -C "$temp_dir"
}

_uninstall() {
    for theme in "$@"; do
        test -d "$DESTDIR/$theme" || continue
        _msg "Deleting '$theme' ..."
        _rm "$DESTDIR/$theme"
    done
}

_install() {
    chrome_dir="$1/chrome"

    _msg "Installing Papirus Icons to '$chrome_dir' ..."
    rm -rf "${chrome_dir?}/papirus-icons"

    mkdir -p "$chrome_dir"
    cp --backup="t" \
        "$temp_dir/$gh_repo-$TAG/chrome/userChrome.css" \
        "$chrome_dir"/
    cp -R "$temp_dir/$gh_repo-$TAG/chrome/papirus-icons" \
        "$chrome_dir"/
}

_cleanup() {
    _msg "Clearing cache ..."
    rm -rf "$temp_file" "$temp_dir"
    _msg "Done!"
}

trap _cleanup EXIT HUP INT TERM

temp_file="$(mktemp -u)"
temp_dir="$(mktemp -d)"

if [ ! -f "$DESTDIR/profiles.ini" ]; then
    _msg "Unable to find '$DESTDIR/profiles.ini' file."
    exit 1
fi

_download

sed -n '/^Path/ s/Path=//p' "$DESTDIR/profiles.ini" | \
    while read -r profile_path; do
        if [ -d "$profile_path" ]; then
            # it's the absolute path to profile
            _install "$profile_path"
        elif [ -d "$DESTDIR/$profile_path" ]; then
            # it's the relative path to profile
            _install "$DESTDIR/$profile_path"
        else
            _msg "'$profile_path' is not exists. Skipping ..."
            continue
        fi
    done

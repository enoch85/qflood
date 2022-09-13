#!/bin/bash

flood_version=$(curl -u "${GITHUB_ACTOR}:${GITHUB_TOKEN}" -fsSL "https://api.github.com/repos/jesec/flood/releases/latest" | jq -r .tag_name | sed s/v//g)
[[ -z ${flood_version} ]] && exit 0
qbittorrent_full_version=$(curl -u "${GITHUB_ACTOR}:${GITHUB_TOKEN}" -fsSL "https://github.com/userdocs/qbittorrent-nox-static/releases/latest/download/dependency-version.json" | jq -r '. | "release-\(.qbittorrent)_v\(.libtorrent_1_2)"')
qbittorrent_version=$(echo "${qbittorrent_full_version}" | sed -e "s/release-//g" -e "s/_.*//g")
[[ -z ${qbittorrent_version} ]] && exit 0
version="${qbittorrent_version}--${flood_version}"
version_json=$(cat ./VERSION.json)
jq '.version = "'"${version}"'" | .qbittorrent_version = "'"${qbittorrent_version}"'" | .qbittorrent_full_version = "'"${qbittorrent_full_version}"'" | .flood_version = "'"${flood_version}"'"' <<< "${version_json}" > VERSION.json

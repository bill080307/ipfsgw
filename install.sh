#!/usr/bin/env bash
set -x
mkdir -p /etc/nginx/sites-enabled
cp ipfsgw.conf /etc/nginx/sites-enabled/
cp -r lua/ /etc/nginx/
systemctl restart openresty.service
echo Please edit set_ipns.lua to modify token.

#!/usr/bin/env bash

branches=$(./get-lts-kernels.py)

for branch in ${branches[@]}; do
	branch=${branch} ./spice-up-ebuild.sh
done

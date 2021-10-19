#!/usr/bin/env bash
set -euo pipefail
branches=($(./get-lts-kernels.py))

echo '['
for((counter=0; counter < ${#branches[@]}; counter++)); do
	branch=${branches[${counter}]} ./spice-up-ebuild.sh
	if [ $((${counter} + 1)) -ne ${#branches[@]} ]; then
		echo -e '\t,'
	fi
done
echo ']'

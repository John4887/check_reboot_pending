#!/bin/bash

script="check_reboot_pending.sh"
version="1.1.0"
author="John Gonzalez"

while getopts ":v" opt; do
  case $opt in
    v)
      echo "$script - $author - $version"
      exit 0
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
  esac
done

reboot_required_file="/var/run/reboot-required"
reboot_pkgs_file="/var/run/reboot-required.pkgs"
current_kernel=$(uname -r)
latest_kernel=$(ls /boot | grep vmlinuz | sort -V | tail -n 1 | cut -d'-' -f2-)

if [ -f "$reboot_required_file" ]; then
  pkgs=$(cat "$reboot_pkgs_file")
  reboot_pkgs_list=$(echo "$pkgs" | tr '\n' ',' | sed 's/,$//;s/,/, /g')
  echo "A reboot is pending - Packages asking for this reboot: $reboot_pkgs_list."
  exit 1 # WARNING
elif [ "$current_kernel" != "$latest_kernel" ]; then
  echo "A new kernel is installed. A reboot is pending to use the new kernel."
  exit 1 # WARNING
else
  echo "No reboot is required."
  exit 0 # OK
fi

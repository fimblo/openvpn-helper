#!/bin/bash
# --------------------------------------------------
[[ "$DEBUG" ]] && set -x
# --------------------------------------------------
# ovpn.sh - Starts openvpn
#
# I use this with NordVPN, and their openvpn configurations.
# Currently it only supports TCP.
# --------------------------------------------------
# If you don't have the configurations, do the following:
# mkdir ~/.openvpn; cd ~/.openvpn
# wget https://downloads.nordcdn.com/configs/archives/servers/ovpn.zip
# unzip ovpn.zip
# --------------------------------------------------
#
# Another thing - this script assumes gnu versions of ls, grep, shuf, etc.
#
# --------------------------------------------------
# ToDos etc
# - handle tty-less startup nicely
# - let user see what regions exist if they don't know
# - usage would be nice
# - use getopt
# - option to redirect openvpn output elsewhere, with summary presented in stdout instead
# --------------------------------------------------

# --------------------------------------------------
# Some variables
OPENVPN_DIR=$HOME/.openvpn
configdir=$OPENVPN_DIR/ovpn_tcp
selected_region='default'


# --------------------------------------------------
# Functions
usage () {
  cat<<-EOF
	blah blah
	EOF
  [[ "$1" ]] && echo $1
}

# simple error function
croak () {
  echo "$1"
  exit ${2:-255}
}

# --------------------------------------------------
# Catch all CLI options

while getopts 'h' tag ; do
  case $tag in
    h) usage; exit 0                          ;;
    \?) usage "Invalid cmdline parm."; exit 1 ;;
  esac
done

[[ ! -d $OPENVPN_DIR ]] && croak "Can't find config dir: $OPENVPN_DIR"        1
[[ ! -d $configdir   ]] && croak "Can't find openvpn config dir: $configdir." 1


if [[ $selected_region == "default" ]] ; then
  echo "Missing cmdline arg for region (us,se,jp,etc)."
  echo "Hit [enter] to default to se. Ctrl-c to abort."
  read check_for_permission
  selected_region='se'
fi


# --------------------------------------------------
# check if region exists, exit if not
tmpfile=$(mktemp) ; trap 'rm -f $tmpfile' 0
ls -1 $configdir | cut -c-2 | sort -u > $tmpfile
if ! grep -q "$selected_region" $tmpfile ; then
  croak "Illegal region: $selected_region" 2
fi

# --------------------------------------------------
# find all files with that region, select one at random
config=$(find $configdir/${selected_region}* | shuf -n 1)

# --------------------------------------------------
# start openvpn with that file
echo sudo openvpn $config


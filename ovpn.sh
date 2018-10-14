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
# - option to redirect openvpn output elsewhere, with summary presented in stdout instead
# --------------------------------------------------

# --------------------------------------------------
# Some variables
configdir=$HOME/.openvpn/ovpn_tcp
selected_region='default'


# --------------------------------------------------
# Functions
usage () {
  cat<<-EOF
	ovpn.sh - Start openvpn with random server in given region
	
	Usage: ovpn.sh [-h] [-l] [-r <region>]
	  -h          This usage text
	  -l          List possible regions and exit
	  -r <region> Select a server in this region and connect
	
	*Warning: this script needs sudo credentials to run openvpn.*
	EOF
  [[ "$1" ]] && echo $1
}

list_regions () {
  tmpfile=$(mktemp) ; trap 'rm -f $tmpfile' 0
  ls -1 $configdir | cut -c-2 | sort -u 
}

region_check () {
  list_regions | grep -q "$1"
  return $?
}

# simple error function
croak () {
  echo -e "$1"
  exit ${2:-255}
}

# --------------------------------------------------
# Catch all CLI options

while getopts 'hlr:f:' tag ; do
  case $tag in
    h) usage; exit 0                          ;;
    r) selected_region="$OPTARG"              ;;
    l) list_regions; exit 0                   ;;
    \?) usage "Invalid cmdline parm."; exit 1 ;;
  esac
done

[[ ! -d $configdir   ]] && croak "Can't find openvpn config dir: $configdir." 1


# select which region to select the openvpn server from
if [[ $selected_region == "default" ]] ; then
  echo "Missing cmdline arg for region (us,se,jp,etc)."
  echo "Hit [enter] to default to se. Ctrl-c to abort."
  read check_for_permission
  selected_region='se'
fi

# check if region exists, exit if not
if ! region_check $selected_region ; then
  croak "Illegal region: $selected_region\nTry the -l param to list regions" 2
fi

# --------------------------------------------------
# find all files with that region, select one at random
config=$(find $configdir/${selected_region}* | shuf -n 1)

# --------------------------------------------------
# start openvpn with that file
 sudo openvpn --writepid /var/run/ovpn.pid  --config $config


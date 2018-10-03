#!/bin/bash
# readme - intended for use with nordvpn
# are the openvpn configurations available?
# are the credentials in place?

# wget https://downloads.nordcdn.com/configs/archives/servers/ovpn.zip

croak () {
  echo "$1"
  exit ${2:-255}
}

# --------------------------------------------------
# HELPER VARS
OPENVPN_DIR=$HOME/.openvpn
tcp_configdir=$OPENVPN_DIR/ovpn_tcp
udp_configdir=$OPENVPN_DIR/ovpn_udp
selected_region=${1:-default}

# --------------------------------------------------
# sanity check
[ ! -d $OPENVPN_DIR   ] && croak "Cannot find config dir: $OPENVPN_DIR"          1
[ ! -d $tcp_configdir ] && croak "Cannot find config dir for TCP openvpn: $tcp_configdir." 1
[ ! -d $udp_configdir ] && croak "Cannot find config dir for UDP openvpn: $udp_configdir." 1

if [ $selected_region == "default" ] ; then
  echo "Missing cmdline arg for region (us,se,jp,etc)."
  echo "Defaulting to se."
  selected_region='se'
fi

# --------------------------------------------------
# check if region exists, exit if not
tmpfile=$(mktemp) ; trap 'rm -f $tmpfile' 0
ls -1 $tcp_configdir | cut -c-2 | sort -u > $tmpfile
if ! grep -q "$selected_region" $tmpfile ; then
  croak "Illegal region: $selected_region" 2
fi

# --------------------------------------------------
# find all files with that region, select one at random
config=$(find $tcp_configdir/${selected_region}* | shuf -n 1)

# --------------------------------------------------
# start openvpn with that file
sudo openvpn $config




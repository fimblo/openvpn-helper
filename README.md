# openvpn-helper
A simple commandline tool to set up my nordvpn connection.

You probably don't need to be a Nordvpn subscriber to use this script,
but the script _does_ assume a few things:

- That you have a directory with openvpn configurations prefixed with
  country-codes. For example, there are over four hundred
  configurations prefixed with 'de', and almost two thousand with a
  'us' prefix.
- All of these regional configurations exist in the same directory.

If you have just one configuration you want to use, then this script
is pretty useless. Just start your connection using the command

	openvpn <configfile>

If you want to use this script the way I do, you should consider subscribing to NordVPN or some other fine VPN service, then, if you use NordVPN, run the following commands:

	mkdir ~/.openvpn; cd ~/.openvpn
	wget https://downloads.nordcdn.com/configs/archives/servers/ovpn.zip
	unzip ovpn.zip

Another thing - this script assumes gnu versions of ls, grep, shuf, etc.

# openvpn-helper
simple commandline tool to set up my nordvpn connection.

I use this with NordVPN, and their openvpn configurations. Currently it only supports TCP.

If you don't have the configurations, do the following:

	mkdir ~/.openvpn; cd ~/.openvpn
	wget https://downloads.nordcdn.com/configs/archives/servers/ovpn.zip
	unzip ovpn.zip

Another thing - this script assumes gnu versions of ls, grep, shuf, etc.

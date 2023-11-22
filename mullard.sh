#!/bin/bash

function cleanup()
{
    ls -1 configs|shuf|xargs -P10 -I{} wg-quick down configs/{} |& grep -vF 'is not'
}

display_usage() {
    cat << EOF
Usage: $0 [MullvadID]

Description:
Here be very functional dragons. Give it a Mullvad ID and you'll end up with a nice proxy pool.
It will download all the WireGuard configs, make a few tweaks, find the fastest one based on ping,
connect (requires wg-quick) but without using AllowedIPs 0/0 so your internet will continue to function.
It'll then run a rotating proxy server that makes use of Mullvad's unique and rather wonderful SOCKS5 facility.

WARNING: This script contains binaries, lions, tigers, and bears. For sure it's packed with malware.

Arguments:
  MullvadID: Your Mullvad account ID.

EOF
}

if [ $# -ne 1 ]; then
    display_usage
    exit 1
fi

# check whether user had supplied -h or --help. If yes, display usage
if [[ $1 == "--help" || $1 == "-h" ]]; then
    display_usage
    exit 0
fi

# display usage if the script is not run as root user
if [[ "$EUID" -ne 0 ]]; then
	echo "This script must be run as root!"
	exit 1
fi

./bin/download_config.sh $1
#CFG=`ls -1 configs|shuf|head -n1`
echo Finding fastest server
IP=$(./bin/servers.sh | ./bin/speedtest | egrep -v '\s0s'| tee /dev/stderr | tail -n1| awk '{print $1}')
echo $IP
CFG=$(grep -r $IP configs/ | awk -F: '{print $1}')
echo $CFG
wg-quick up $CFG

trap cleanup EXIT

echo Start proxy pool.
curl -LskS https://api.mullvad.net/www/relays/wireguard/ | jq -r '.[].socks_name' | xargs -I{} -P10 -n1 dig -t a {} @10.8.0.1 +short | awk '{print $1":1080"}' > socks5.txt
./bin/gost -L=:36061 -F=socks5://localhost:1080?ip=socks5.txt


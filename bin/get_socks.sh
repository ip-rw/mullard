#!/bin/bash
curl -LskS https://api.mullvad.net/www/relays/wireguard/ | jq -r '.[].socks_name' | xargs -I{} -P10 -n1 dig -t a {} @10.8.0.1 +short | awk '{print $1":1080"}' > socks5.txt
#./laundry5 -v --proxy-list socks5.txt
#wget https://github.com/ginuerzh/gost/releases/download/v2.11.1/gost-linux-amd64-2.11.1.gz -O - | gzip -d - > gost
#chmod +x gost
./gost -L=:$1 -F=socks5://localhost:1080?ip=socks5.txt
#./gost  -L=:8081 -F=:1080?ip=socks5.txt

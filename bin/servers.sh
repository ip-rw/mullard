#!/bin/bash

RESPONSE="$(curl -LksS https://api.mullvad.net/public/relays/wireguard/v1/)" || die "Unable to connect to Mullvad API."
FIELDS="$(jq -r 'foreach .countries[] as $country (.; .; foreach $country.cities[] as $city (.; .; foreach $city.relays[] as $relay (.; .; $relay.ipv4_addr_in)))' <<<"$RESPONSE")" || die "Unable to parse response."
while read -r COUNTRY && read -r CITY && read -r HOSTNAME && read -r PUBKEY && read -r IPADDR; do
	echo $IPADDR
done <<<"$FIELDS"


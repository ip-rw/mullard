mullard
=======
Here be very functional dragons. Give it a Mullvad ID and you'll end up with a nice proxy pool.
It will download all the WireGuard configs, make a few tweaks, find the fastest one based on ping,
connect (requires wg-quick) but without using AllowedIPs 0/0 so your internet will continue to function.
It'll then run a rotating proxy server that makes use of Mullvad's unique and rather wonderful SOCKS5 facility.

WARNING: This script contains binaries, lions, tigers, and bears. For sure it's packed with malware.

Arguments:
  MullvadID: Your Mullvad account ID.


You're gonna want jq, wireguard, curl, bash, new/working gost and maybe some day the source for the speed measurement thing.

ulimit -SHn 999999

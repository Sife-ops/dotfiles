#!/bin/sh
# convert bw identities to abook database

. bwvault.sh

bw_sync 1>/dev/null

idents=$(vault | jq -c '[ .[] | select(.type == 4) ]')
len=$(echo "$idents" | jq 'length')

echo "# abook addressbook file

[format]
program=abook
version=$(abook -h | head -n 1 | cut -d ' ' -f 2 | tr -d 'v')

"
for index in $(seq 0 $((len - 1))); do
    echo "[$index]"
    echo "name=$(echo "$idents" | jq -r ".[$index].name")"
    echo "email=$(echo "$idents" | jq -r ".[$index].identity.email")"
    echo
done

# vim: fdm=marker fmr=#^,#$

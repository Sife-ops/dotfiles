#!/bin/sh
# bspc desktop menu

checkdeps.sh bspc dmenu jq bc

dmenucmd="${DMENU_CMD:-dmenu -b -i -l 20}"
alias dmenucmd="$dmenucmd"

msg_help() { echo \
"Usage:
    dmenudesk.sh [OPTIONS]

Options:
    -f          display focused desktop first (default: last)
    -k          kill 0 on no selection
    -h          print this message"
}

while getopts "fhk" o; do case "${o}" in
	f) focused="focused" ;;
	k) killzero=t ;;
    h) msg_help ;;
	*) printf "Invalid option: -%s\\n" "$o" && msg_help && exit 1 ;;
esac done

first_item=$(echo "ibase=16; $(bspc query -D -d "${focused:-last}" |
    cut -d 'x' -f 2)" | bc)

desktop_list(){
    bspc wm -d |
        jq -r \
            '.monitors[] |
            {
                monitor: .name,
                desktop: .desktops[] |
                {
                    name: .name,
                    id: .id
                }
            } |
            .monitor,
            .desktop.name,
            .desktop.id' |
    paste - - - -d':' |
    tac |
    awk "/$first_item/ { first = \$0 } { print \$0 } END { print first }" |
    tac
}

chosen="$(desktop_list | dmenucmd -p "desktop")"
case "$chosen" in
    "") [ -n "$killzero" ] && kill 0 ;;
    *) echo "$chosen" | cut -d ':' -f 3 ;;
esac

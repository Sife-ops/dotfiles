#!/bin/sh
# dmenu bspc wrapper

checkdeps.sh bspc dmenu

dmenucmd="${DMENU_CMD:-dmenu -b -i -l 20}"
alias dmenucmd="$dmenucmd"

choose(){ #^
    chosen="$(printf '%s' "$1" | eval "dmenucmd ${2:+-p \"$2\"}")"
} #$

# menus #^
domains='node
desktop
monitor
wm
config'

node_options_list='-f, --focus [NODE_SEL]
-a, --activate [NODE_SEL]
-d, --to-desktop DESKTOP_SEL [--follow]
-m, --to-monitor MONITOR_SEL [--follow]
-n, --to-node NODE_SEL [--follow]
-s, --swap NODE_SEL [--follow]
-p, --presel-dir [~]DIR|cancel
-o, --presel-ratio RATIO
-v, --move dx dy
-z, --resize top|left|bottom|right|top_left|top_right|bottom_right|bottom_left dx dy
-r, --ratio RATIO|(+|-)(PIXELS|FRACTION)
-R, --rotate 90|270|180
-F, --flip horizontal|vertical
-E, --equalize
-B, --balance
-C, --circulate forward|backward
-t, --state [~](tiled|pseudo_tiled|floating|fullscreen)
-g, --flag hidden|sticky|private|locked|marked[=on|off]
-l, --layer below|normal|above
-i, --insert-receptacle
-c, --close
-k, --kill'

desktop_options_list='-f, --focus [DESKTOP_SEL]
-a, --activate [DESKTOP_SEL]
-m, --to-monitor MONITOR_SEL [--follow]
-s, --swap DESKTOP_SEL [--follow]
-l, --layout CYCLE_DIR|monocle|tiled
-n, --rename <new_name>
-b, --bubble CYCLE_DIR
-r, --remove'

monitor_options_list='-f, --focus [MONITOR_SEL]
-s, --swap MONITOR_SEL
-a, --add-desktops <name>...
-o, --reorder-desktops <name>...
-d, --reset-desktops <name>...
-g, --rectangle WxH+X+Y
-n, --rename <new_name>
-r, --remove'

wm_options_list='-d, --dump-state
-l, --load-state <file_path>
-a, --add-monitor <name> WxH+X+Y
-O, --reorder-monitors <name>...
-o, --adopt-orphans
-h, --record-history on|off
-g, --get-status
-r, --restart'

dir='north
west
south
east'

ratio='0.25
0.33
0.50
0.75'

degrees='90
270
180'

orientation='horizontal
vertical'

direction='forward
backward'

state='tiled
pseudo_tiled
floating
fullscreen'

flag='hidden
sticky
private
locked
marked'

layer='below
normal
above'

dxdy='50 50
25 25'

edge='top
left
bottom
right
top_left
top_right
bottom_right
bottom_left'

cycle='next
prev'

settings_list='normal_border_color, Color of the border of an unfocused window.
active_border_color, Color of the border of a focused window of an unfocused monitor.
focused_border_color, Color of the border of a focused window of a focused monitor.
presel_feedback_color, Color of the node --presel-{dir,ratio} message feedback area.
split_ratio, Default split ratio.
status_prefix, Prefix prepended to each of the status lines.
external_rules_command, Absolute path to the command used to retrieve rule consequences. The command will receive the following arguments: window ID, class name, instance name, and intermediate consequences. The output of that command must have the following format: key1=value1 key2=value2 ...  (the valid key/value pairs are given in the description of the rule command).
automatic_scheme, The insertion scheme used when the insertion point is in automatic mode. Accept the following values: longest_side, alternate, spiral.
initial_polarity, On which child should a new window be attached when adding a window on a single window tree in automatic mode. Accept the following values: first_child, second_child.
directional_focus_tightness, The tightness of the algorithm used to decide whether a window is on the DIR side of another window. Accept the following values: high, low.
removal_adjustment, Adjust the brother when unlinking a node from the tree in accordance with the automatic insertion scheme.
presel_feedback, Draw the preselection feedback area. Defaults to true.
borderless_monocle, Remove borders of tiled windows for the monocle desktop layout.
gapless_monocle, Remove gaps of tiled windows for the monocle desktop layout.
top_monocle_padding, Padding space added at the sides of the screen for the monocle desktop layout.
right_monocle_padding, Padding space added at the sides of the screen for the monocle desktop layout.
bottom_monocle_padding, Padding space added at the sides of the screen for the monocle desktop layout.
left_monocle_padding, Padding space added at the sides of the screen for the monocle desktop layout.
single_monocle, Set the desktop layout to monocle if there???s only one tiled window in the tree.
pointer_motion_interval, The minimum interval, in milliseconds, between two motion notify events.
pointer_modifier, Keyboard modifier used for moving or resizing windows. Accept the following values: shift, control, lock, mod1, mod2, mod3, mod4, mod5.
pointer_action1, pointer_action2, pointer_action3, Action performed when pressing pointer_modifier + button<n>.  Accept the following values: move, resize_side, resize_corner, focus, none.
click_to_focus, Button used for focusing a window (or a monitor). The possible values are: button1, button2, button3, any, none. Defaults to button1.
swallow_first_click, Don???t replay the click that makes a window focused if click_to_focus isn???t none.
focus_follows_pointer, Focus the window under the pointer.
top_padding, Padding space added at the sides of the monitor or desktop.
right_padding, Padding space added at the sides of the monitor or desktop.
bottom_padding, Padding space added at the sides of the monitor or desktop.
left_padding, Padding space added at the sides of the monitor or desktop.
window_gap, Size of the gap that separates windows.
border_width, Window border width.'
#$

# domain="$(choose "$domains" "domain")"
choose "$domains" "domain"
domain="$chosen"
cmd="bspc $domain"

case "$domain" in #^
    node) domain_sel="$(dmenunode.sh -f)" ;;
    desktop) domain_sel="$(dmenudesk.sh -f)" ;;
    monitor) domain_sel="$(dmenumon.sh -f)" ;;
    wm) domain_sel="" ;;
    config) choose "$(printf 'node\ndesktop\nmonitor')" "domain"
        case "$chosen" in
            node) domain_sel="-n $(dmenunode.sh -f -k)" ;;
            desktop) domain_sel="-d $(dmenudesk.sh -f -k)" ;;
            monitor) domain_sel="-m $(dmenumon.sh -f -k)" ;;
            "") domain_sel="" ;;
            *) exit 1 ;;
        esac ;;
    "") exit 1 ;;
    *) exit 1 ;;
esac
cmd="$cmd $domain_sel" #$

case "$domain" in #^
    node) choose "$node_options_list" "node options" ;;
    desktop) choose "$desktop_options_list" "desktop options" ;;
    monitor) choose "$monitor_options_list" "monitor options" ;;
    wm) choose "$wm_options_list" "wm options" ;;
    config) choose "$settings_list" "settings" ;;
    "") exit 1 ;;
    *) exit 1 ;;
esac
option="$(echo "$chosen" | cut -d ',' -f 1)"
cmd="$cmd $option" #$

case $domain in #^
    node) case $option in #^
        -f|-a|-n|-s) chosen=$(dmenunode.sh -f) ;;
        -d) chosen=$(dmenudesk.sh -f) ;;
        -m) chosen=$(dmenumon.sh -f) ;;
        -p) choose "$dir" "direction" ;; # [~]DIR|cancel
        -o) choose "$ratio" "ratio" ;; # RATIO
        -r) choose "$ratio" "ratio" ;; # RATIO|(+|-(PIXELS|FRACTION)
        -R) choose "$degrees" "degrees" ;; # 90|270|180
        -F) choose "$orientation" "orientation" ;; # horizontal|vertical
        -C) choose "$direction" "direction" ;; # forward|backward
        -t) choose "$state" "state" ;; # [~](tiled|pseudo_tiled|floating|fullscreen)
        -g) choose "$flag" "flag" ;; # hidden|sticky|private|locked|marked[=on|off]
        -l) choose "$layer" "layer" ;; # below|normal|above
        -v) choose "$dxdy" "dx dy" ;; # dx dy
        -z) choose "$edge" "edge"
            cmd="$cmd $chosen"
            choose "$dxdy" "dx dy" ;; # top|left|bottom|right|top_left|top_right|bottom_right|bottom_left dx dy
        # -E|-B|-i|-c|-k) echo "$cmd" && exit 0 ;;
        # -E|-B|-i|-c|-k) eval "$cmd"; exit ;;
        -E|-B|-i|-c|-k) chosen="" ;;
        "") exit 1 ;;
        *) exit 1 ;;
    esac ;; #$

    desktop) case $option in #^
        -f|-a|-s) chosen=$(dmenudesk.sh -f) ;; # , --focus [DESKTOP_SEL]
        -l|-b) choose "$cycle" "cycle" ;; # , --layout CYCLE_DIR|monocle|tiled
        -m) chosen=$(dmenumon.sh -f) ;; # , --to-monitor MONITOR_SEL [--follow]
        -n) choose "" "name" ;; # , --rename <new_name>
        -r) chosen="" ;;
        "") exit 1 ;;
        *) exit 1 ;;
    esac ;; #$

    monitor) case $option in #^
        -f|-s) chosen=$(dmenumon.sh -f) ;; # , --focus [MONITOR_SEL]
        -a) choose "" "name" ;; # , --add-desktops <name>...
        -n) choose "" "name" ;; # , --rename <new_name>
        -o) choose "" "name" ;; # , --reorder-desktops <name>...
        -d) choose "" "name" ;; # , --reset-desktops <name>...
        -g) choose "" "WxH+X+Y" ;; # , --rectangle WxH+X+Y
        -r) chosen="" ;;
        "") exit 1 ;;
        *) exit 1 ;;
    esac ;; #$

    wm) case $option in #^
        -r) chosen="" ;;
        # -d) : ;; # , --dump-state # open in buffer?
        # -l) : ;; # , --load-state <file_path>
        # -a) : ;; # , --add-monitor <name> WxH+X+Y
        # -O) : ;; # , --reorder-monitors <name>...
        # -o) : ;; # , --adopt-orphans
        # -h) : ;; # , --record-history on|off
        # -g) : ;; # , --get-status
        "") exit 1 ;;
        *) exit 1 ;;
    esac ;; #$

    config) choose "" "value" ;;
esac
option_arguments="$chosen"
cmd="$cmd $option_arguments" #$

eval "$cmd"

# vim: fdm=marker fmr=#^,#$

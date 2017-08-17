#!/bin/bash

hc()
{
	"${herbstclient_command[@]:-herbstclient}" "$@" ;
}

monitor=${1:-0}
geometry=( $(herbstclient monitor_rect "$monitor") )
if [ -z "$geometry" ] ;then
	echo "Invalid monitor $monitor"
	exit 1
fi

# geometry has the format W H X Y
x=${geometry[0]}
y=${geometry[1]}
panel_width=${geometry[2]}
panel_height=16
#font="-*-fixed-*-10-*-*-*-*-*-*-*"
font="Liberation Mono:pixelsize=12"
bgcolor="#242424"
selbg=$(hc get window_border_active_color)
selfg='#eeeeee'

# get colors
color_fg="#eeeeee"
color_bg=$(hc get window_border_normal_color)
color_bg_bar="#242424"
color_urgent="#ff0000"

block_start=" ^bg($color_bg) "
block_end="^bg($color_bg) "
separator="^bg(${color_bg}) ^bg(${color_bg_bar}) ^bg(${color_bg}) "

####
# Try to find textwidth binary.
# In e.g. Ubuntu, this is named dzen2-textwidth.
#if which textwidth &> /dev/null ; then
#	textwidth="textwidth";
#elif which dzen2-textwidth &> /dev/null ; then
#	textwidth="dzen2-textwidth";
#else
#	echo "This script requires the textwidth tool of the dzen2 project."
#	exit 1
#fi
textwidth="xftwidth"

####
# true if we are using the svn version of dzen2
# depending on version/distribution, this seems to have version strings like
# "dzen-" or "dzen-x.x.x-svn"
if dzen2 -v 2>&1 | head -n 1 | grep -q '^dzen-\([^,]*-svn\|\),'; then
	dzen2_svn="true"
else
	dzen2_svn=""
fi

if awk -Wv 2>/dev/null | head -1 | grep -q '^mawk'; then
	# mawk needs "-W interactive" to line-buffer stdout correctly
	# http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=593504
	uniq_linebuffered() {
		awk -W interactive '$0 != l { print ; l=$0 ; fflush(); }' "$@"
	}
else
	# other awk versions (e.g. gawk) issue a warning with "-W interactive", so
	# we don't want to use it there.
	uniq_linebuffered() {
		awk '$0 != l { print ; l=$0 ; fflush(); }' "$@"
	}
fi

hc pad $monitor $panel_height

{
    ### Event generator ###
    # based on different input data (mpc, date, hlwm hooks, ...) this generates events, formed like this:
    #   <eventname>\t<data> [...]
    # e.g.
    #   date    ^fg(#efefef)18:33^fg(#909090), 2013-10-^fg(#efefef)29

    #mpc idleloop player &
    while true ; do
        # "date" output is checked once a second, but an event is only
        # generated if the output changed compared to the previous run.
		date +$'date\t^fg(#909090)%Y-%m-%d ^fg(#eeeeee)%H:%M^fg(#909090):%S'
        sleep 1 || break
    done > >(uniq_linebuffered) &
    childpid=$!
    hc --idle
    kill $childpid
} 2> /dev/null | {
    IFS=$'\t' read -ra tags <<< "$(hc tag_status $monitor)"
    visible=true
    date=""
    windowtitle=""
    while true ; do

        ### Output ###
        # This part prints dzen data based on the _previous_ data handling run,
        # and then waits for the next event to happen.

        bordercolor="#26221C"

		echo -n "${block_start}"

        # draw tags
		for i in "${tags[@]}" ; do
			case ${i:0:1} in
				# focused monitor
				'#') # active, focused
					echo -n "^bg($selbg)^fg(${color_fg})"
				;;
				':') # active, unfocused
					echo -n "^fg(#eeeeee)"
				;;
				'-') # active, unfocused, focus on other monitor
					echo -n "^bg(#93c955)^fg(${color_bg})"
				;;

				# unfocused monitor
				'+') # active, focused
					echo -n "^bg(#93c955)^fg(${color_bg})"
				;;
				'%') # active, unfocused
					echo -n "^fg(#eeeeee)"
				;;

				# other
				'!') # urgent
					echo -n "^fg(#ff6000)"
				;;
				*)
					echo -n "^fg(#ababab)"
				;;
			esac

			if [ ! -z "$dzen2_svn" ] ; then
				# clickable tags if using SVN dzen
				echo -n "^ca(1,\"${herbstclient_command[@]:-herbstclient}\" "
				echo -n "focus_monitor \"$monitor\" && "
				echo -n "\"${herbstclient_command[@]:-herbstclient}\" "
				echo -n "use \"${i:1}\") ${i:1} ^ca()"
			else
				# non-clickable tags if using older dzen
				echo -n " ${i:1} "
			fi

			# reset the background color
			echo -n "^bg($color_bg)"
		done

		echo -n "${separator}"

		echo -n "^bg(${color_bg})^fg(${color_fg})${windowtitle//^/^^}"

		echo -n "${block_end}"

		# right side
        right="${block_start}${date}${block_end}"

        right_text_only=$(echo -n "$right" | sed 's.\^[^(]*([^)]*)..g')
        # get width of right aligned text.. and add some space..
        width=$($textwidth "$font" "$right_text_only  ") # 2 extra spaces for the border
        echo -n "^pa($(($panel_width - $width)))$right"
        echo

        ### Data handling ###
        # This part handles the events generated in the event loop, and sets
        # internal variables based on them. The event and its arguments are
        # read into the array cmd, then action is taken depending on the event
        # name.
        # "Special" events (quit_panel/togglehidepanel/reload) are also handled
        # here.

        # wait for next event
        IFS=$'\t' read -ra cmd || break
        # find out event origin
        case "${cmd[0]}" in
            tag*)
                #echo "resetting tags" >&2
                IFS=$'\t' read -ra tags <<< "$(hc tag_status $monitor)"
                ;;
            date)
                #echo "resetting date" >&2
                date="${cmd[@]:1}"
                ;;
            quit_panel)
                exit
                ;;
            togglehidepanel)
                currentmonidx=$(hc list_monitors | sed -n '/\[FOCUS\]$/s/:.*//p')
                if [ "${cmd[1]}" -ne "$monitor" ] ; then
                    continue
                fi
                if [ "${cmd[1]}" = "current" ] && [ "$currentmonidx" -ne "$monitor" ] ; then
                    continue
                fi
                echo "^togglehide()"
                if $visible ; then
                    visible=false
                    hc pad $monitor 0
                else
                    visible=true
                    hc pad $monitor $panel_height
                fi
                ;;
            reload)
                exit
                ;;
            focus_changed|window_title_changed)
                windowtitle="${cmd[@]:2}"
                ;;
            #player)
            #    ;;
        esac
    done

    ### dzen2 ###
    # After the data is gathered and processed, the output of the previous block
    # gets piped to dzen2.

} 2> /dev/null | dzen2 -w $panel_width -x $x -y $y -fn "$font" -h $panel_height \
    -e 'button3=' \
    -ta l -bg "$color_bg_bar" -fg "${color_fg}"

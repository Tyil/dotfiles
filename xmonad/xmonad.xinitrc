# start some required stuff
pulseaudio --start

dunst &

# finally, run the wm of choice
exec xmonad

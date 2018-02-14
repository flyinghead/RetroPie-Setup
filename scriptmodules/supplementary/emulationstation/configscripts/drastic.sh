#!/usr/bin/env bash

function check_drastic() {
    [[ ! -d "$configdir/nds/drastic/config" ]] && return 1
    return 0
}

function onstart_drastic_joystick() {
    iniConfig " = " "" "$configdir/nds/drastic/config/drastic.cfg"
}

function map_drastic_joystick() {
    local input_name="$1"	# up, a, lefttrigger, etc.
    local input_type="$2"	# axis, hat, 
    local input_id="$3"
    local input_value="$4"

    local keys
    case "$input_name" in
    	up)
	    keys=("UP" "UI_UP")
	    ;;
    	down)
	    keys=("DOWN" "UI_DOWN")
	    ;;
    	left)
	    keys=("LEFT" "UI_LEFT")
	    ;;
    	right)
	    keys=("RIGHT" "UI_RIGHT")
	    ;;
	a)
	    keys=("A" "UI_SELECT")
	    ;;
	b)
	    keys=("B" "UI_BACK")
	    ;;
	x)
	    keys=("X")
	    ;;
	y)
	    keys=("Y")
	    ;;
	leftshoulder)
	    keys=("L")
	    ;;
	rightshoulder)
	    keys=("R")
	    ;;
	lefttrigger)
	    keys=("MENU")
	    ;;
	righttrigger)
	    keys=("SWAP_SCREENS")
	    ;;
	leftthumb)
	    keys=("SWAP_ORIENTATION_B")
	    ;;
	rightthumb)
	    keys=("QUIT")
	    ;;
	start)
	    keys=("START")
	    ;;
	"select")
	    keys=("SELECT")
	    ;;
	leftanalogup)
	    keys=("TOUCH_CURSOR_UP")
	    ;;
	leftanalogdown)
	    keys=("TOUCH_CURSOR_DOWN")
	    ;;
	leftanalogleft)
	    keys=("TOUCH_CURSOR_LEFT")
	    ;;
	leftanalogright)
	    keys=("TOUCH_CURSOR_RIGHT")
	    ;;
	*)
	    return
	    ;;
    esac

    local value
    case "$input_type" in
        axis)
	    let value=1024+128+$input_id
	    [[ "$input_value" != "1" ]] && let value=$value+64
	    ;;
	button)
	    let value=1024+input_id
	    ;;
	*)
	    return
	    ;;
    esac

    for key in "${keys[@]}"; do
	# Workaround the issue with square brackets in key names
	iniDel "controls_b.CONTROL_INDEX_${key}."
	key="controls_b[CONTROL_INDEX_${key}]"
	iniSet "$key" "$value"
    done
    
}

#function map_drastic_keyboard() {
#    local input_name="$1"	# up, a, lefttrigger, etc.
#    local input_type="$2"	# button, axis, hat, key
#    local input_id="$3"		# button id or SDL2 keycode
#    local input_value="$4"	# joystick input value (or 1 for keyboard)
#}

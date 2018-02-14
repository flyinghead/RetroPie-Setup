#!/usr/bin/env bash

rp_module_id="custom"
rp_module_desc="Additional stuff not part of RetroPie"
rp_module_section="main"

function depends_custom() {
    getDepends triggerhappy
}

function install_bin_custom() {
    if [[ -f "$md_inst/profile.sh" ]] ; then
	. "$md_inst/profile.sh"
    else
	echo "PROFILE=$PROFILE" > "$md_inst/profile.sh"
    fi
    if [[ "$PROFILE" == "gamepod" ]]; then
	cp "$md_data/poweroff.conf" "/etc/triggerhappy/triggers.d/"
	cp "$md_data/audio.conf" "/etc/triggerhappy/triggers.d/"
	cp "$md_data/scroll.wav" "$md_inst/"
	cp "$md_data/set-volume.sh" "$md_inst/"
	chmod a+x "$md_inst/set-volume.sh"
	md_ret_require="/etc/triggerhappy/triggers.d/poweroff.conf"
    fi
    if isPlatform "x86" ; then
	cp "$md_data/dolphin-emu.conf" "/etc/triggerhappy/triggers.d/"
	md_ret_require="/etc/triggerhappy/triggers.d/dolphin-emu.conf"
    fi
    service triggerhappy restart

}

function configure_custom() {
    if isPlatform "rpi" ; then
	#
	# /boot/config.txt settings
	#
        iniConfig "=" "" /boot/config.txt
	iniSet "hdmi_force_hotplug" 1
	if [[ "$PROFILE" == "gamepod" ]]; then
	    # 800x480 LCD
	    iniSet "framebuffer_width" 800
	    iniSet "framebuffer_height" 480
	    iniSet "hdmi_group" 2
	    iniSet "hdmi_mode" 87
	    iniSet "hdmi_cvt" 800  480  60  6  0  0  0
	    iniSet "device_tree" bcm2710-rpi-3-b.dtb
	    # flip screen upside down
	    display_rotate=2
	    # Experimental audio driver
	    iniSet "audio_pwm_mode" 2
	else
	    # Full HD
	    iniSet "disable_overscan" 1
	    iniSet "config_hdmi_boost" 6
	fi
	# Overclocking
	iniSet "total_mem" 1024
	iniSet "arm_freq" 1300
	iniSet "gpu_freq" 500
	iniSet "core_freq" 500
	iniSet "sdram_freq" 500
	iniSet "sdram_schmoo" 0x02000020
	iniSet "over_voltage" 4 
	iniSet "sdram_over_voltage" 2
	v3d_freq=525

	# TODO disable boot log on console
	# s/tty1/tty3/ in /boot/cmdline.txt
    fi
    #
    # /opt/retropie/configs/all/retroarch.cfg
    #
    iniConfig " = " '"' /opt/retropie/configs/all/retroarch.cfg
    iniSet "menu_driver" xmb
    iniSet "user_language" 2
    if [[ "$PROFILE" == "gamepod" ]]; then
	# 800x480 LCD
	iniSet "xmb_scale_factor" 120
    fi

    rp_isInstalled "ps3controller" || rp_callModule "ps3controller"
    rp_isInstalled "reicast" || rp_callModule "reicast"
    rp_isInstalled "ppsspp" || rp_callModule "ppsspp"
    if isPlatform "rpi" ; then
	rp_isInstalled "drastic" || rp_callModule "drastic"
	if [[ "$PROFILE" == "gamepod" ]]; then
	    rp_isInstalled "kodi" || rp_callModule "kodi"
	fi
    fi
    if isPlatform "x86" ; then
	rp_isInstalled "lr-desmume" || rp_callModule "lr-desmume"
	rp_isInstalled "dolphin" || rp_callModule "dolphin"
    fi
}

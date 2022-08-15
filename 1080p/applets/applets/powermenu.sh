#!/usr/bin/env bash

## Author  : Aditya Shakya
## Mail    : adi1090x@gmail.com
## Github  : @adi1090x
## Twitter : @adi1090x

style="$($HOME/.config/rofi/applets/applets/style.sh)"

dir="$HOME/.config/rofi/applets/applets/configs/$style"
rofi_command="rofi -theme $dir/powermenu.rasi"

uptime=$(uptime -p | sed -e 's/up //g')
cpu=$($HOME/.config/rofi/bin/usedcpu)
memory=$($HOME/.config/rofi/bin/usedram)

# Options
shutdown=""
reboot=""
lock=""
suspend=""
exit=""
logout=""

# Confirmation
confirm_exit() {
	rofi -dmenu\
		-i\
		-no-fixed-num-lines\
    -p "Are You Sure? (Y/n) : "\
		-theme $HOME/.config/rofi/applets/styles/confirm.rasi
}

# Message
msg() {
	rofi -theme "$HOME/.config/rofi/applets/styles/message.rasi" -e "Available Options  -  y / n"
}

# Variable passed to rofi
options="$shutdown\n$reboot\n$lock\n$suspend\n$exit\n$logout"

chosen="$(echo -e "$options" | $rofi_command -p "UP - $uptime" -dmenu -selected-row 2)"
case $chosen in
    $shutdown)
		ans=$(confirm_exit &)
		if [[ $ans == "y" || $ans == "Y" || $ans == "" ]]; then
			loginctl poweroff
		elif [[ $ans == "n" || $ans == "N" ]]; then
			exit 0
        else
			msg
        fi
        ;;
    $reboot)
		ans=$(confirm_exit &)
		if [[ $ans == "y" || $ans == "Y" || $ans == "" ]]; then
			loginctl reboot
		elif [[ $ans == "n" || $ans == "N" ]]; then
			exit 0
        else
			msg
        fi
        ;;
    $lock)
    loginctl lock-session ${XDG_SESSION_ID-}
        ;;
    $suspend)
		ans=$(confirm_exit &)
		if [[ $ans == "y" || $ans == "Y" || $ans == "" ]]; then
			mpc -q pause
			loginctl suspend
		elif [[ $ans == "n" || $ans == "N" ]]; then
			exit 0
        else
			msg
        fi
        ;;
    $exit)
		ans=$(confirm_exit &)
		if [[ $ans == "y" || $ans == "Y" || $ans == "" ]]; then
			if [[ "$XDG_CURRENT_SESSION" == "Openbox" ]]; then
				openbox --exit
			elif [[ "$XDG_CURRENT_SESSION" == "bspwm" ]]; then
				bspc quit
			elif [[ "$XDG_CURRENT_SESSION" == "i3" ]]; then
				i3-msg exit
      elif [[ "$XDG_CURRENT_SESSION" == "qtile" ]]; then
        qtile cmd-obj -o cmd -f shutdown
			fi
		elif [[ $ans == "n" || $ans == "N" ]]; then
			exit 0
        else
			msg
        fi
        ;;
    $logout)
		ans=$(confirm_exit &)
		if [[ $ans == "y" || $ans == "Y" || $ans == "" ]]; then
      loginctl terminate-session ${XDG_SESSION_ID-}
		elif [[ $ans == "n" || $ans == "N" ]]; then
			exit 0
        else
			msg
        fi
        ;;
esac

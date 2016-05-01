#! /bin/bash

tone () {
  local note="$1" #primo parametro
  local duration="$2" #secondo parametro
  if test "$note" -eq 0; then
    gpio -g mode 18 in
  else
    local period="$(perl -e"printf'%.0f',600000/440/2**(( $note-69)/12 )")"
    echo $period
    gpio -g mode 18 pwm
    gpio pwmr "$(( period ))"
    gpio -g pwm 18 "$(( period/2 ))"
    gpio pwm-ms
    sleep $duration
    tone 0 #resetta la porta. Se lo tolgo rimane in output all'infinito
  fi
}

duration=0.1
while :
do
    read -r -n 1 key
    case "$key" in
      # TAB ) note=54;;   #not working!
        q) note=55;;
        2) note=56;;
        w) note=57;;
        3) note=58;;
        e) note=59;;
        r) note=60;;
        5) note=61;;
        t) note=62;;
        6) note=63;;
        y) note=64;;
        u) note=65;;
        8) note=66;;
        i) note=67;;
        9) note=68;;
        o) note=69;;
        0) note=70;;
        p) note=71;;
        "[") note=72;;
        "-") note=73;;
        "]") note=74;;
        "=") note=75;;
	    z) duration=0.1;;
 	    x) duration=0.5;;
	    c) duration=1.0;;

    esac
    tone $note $duration
done

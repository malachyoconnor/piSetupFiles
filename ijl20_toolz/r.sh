#!/bin/bash
# * Save / Restore your window positions
# * Reset all your window positions to cascade from top left of screen
# For usage, call script with --help
#
# This script was prompted by an Ubuntu/Linux screen driver bug that hides
# your windows when waking up in a multi-monitor desktop.
#
# REQUIRES: wmctrl (install with sudo apt install wmctrl)
#
# author Ian Lewis ijl20
# 2016-11-14
#

# 'save' file name, used to save window postitions if you use option -s|--save
WMCTRL_SAVE_FILE=$HOME/.wmctrl_save
EXCLUDE_TITLES="Desktop XdndCollectionWindowImp unity-launcher unity-panel unity-dash Hud"

ARGSTEP=1
while [[ $ARGSTEP -eq 1 ]]
do
    key="$1"

    case $key in
        -h|--help)
            printf '%s\n' 'r.sh Window location reset script - requires wmctrl'
            printf '%s\n' 'Basic usage:'
            printf '%s\n' '  r.sh [options] [filter pattern]'
            printf '%s\n' 'Usage:'
            printf '%s\n' '  r.sh [-x|--xstart XSTART]    # 100 move first window to this X position'
            printf '%s\n' '       [-y|--ystart YSTART]    # 100 move first window to this Y position'
            printf '%s\n' '       [-xo|--xoffset XOFFSET] # 50  increment X position by XOFFSET for each window'
            printf '%s\n' '       [-yo|--yoffset YOFFSET] # 50  increment Y position by YOFFSET for each window'
            printf '%s\n' '       [-xl|--xlimit XLIMIT]   # 0   only move windows with current xpos > XLIMIT'
            printf '%s\n' '       [-yl|--ylimit YLIMIT]   # 0   only move windows with current ypos > YLIMIT'
            printf '%s\n' '       [-s|--save]             # save window positions matching window filter'
            printf '%s\n' '       [-r|--restore]          # restore window positions'
            printf '%s\n' '       <window filter>         # hex window id | window title string'
            printf '\n%s\n' 'r.sh will move the windows containing the <window filter> string in their title to'
            printf '%s\n' 'new locations starting at position XSTART,YSTART and incrementing the position coordinates'
            printf '%s\n' 'to XSTART+XOFFSET, YSTART+YOFFSET.'
            printf '%s\n' 'So with the defaults, the first moved window will be moved to position 100,100'
            printf '%s\n' 'and the second to 150,150, the next to 200,200 and so on.'
            printf '%s\n' ''
            exit 0
            ;;
        -l|--list)
            LIST=1
            ARGSTEP=0
            ;;
        -s|--save)
            SAVE=1
            shift
            ARGSTEP=0
            ;;
        -r|--restore)
            RESTORE=1
            shift
            ARGSTEP=0
            ;;
        -x|--xstart)
            XSTART="$2"
            shift
            shift # past argument
            ;;
        -y|--ystart)
            YSTART="$2"
            shift
            shift # past argument
            ;;
        -xl|--xlimit)
            XLIMIT="$2"
            shift
            shift # past argument
            ;;
        -yl|--ylimit)
            YLIMIT="$2"
            shift
            shift # past argument
            ;;
        -xo|--xoffset)
            XOFFSET="$2"
            shift
            shift # past argument
            ;;
        -yo|--yoffset)
            YOFFSET="$2"
            shift
            shift # past argument
            ;;
        --default)
            echo DEFAULT
            DEFAULT=YES
            shift
            ;;
        *)
            ARGSTEP=0
            # unknown option
            ;;
    esac
done

if [[ $LIST -eq 1 ]]
then
    wmctrl -plG
    exit 0
fi

# *************************************************************
# -s|--save ASCII STRING then save those and exit
# *************************************************************

if [[ $SAVE -eq 1 ]]
then
    echo Saving windows containing \"$1\"
    rm -f $WMCTRL_SAVE_FILE
    if [ -z "$1" ]
    then
        wmctrl -lG | while read -r window
        do
            skip=0
            title=$(set -- $window ; echo ${@: 8})
            for ex in $EXCLUDE_TITLES
            do
                if [[ $title == $ex ]]
                then
                  echo SKIPPING \(contains $ex\) $key $x \"$title\"
                  skip=1
                  break;
                fi
            done

            if [[ $skip == 1 ]]
            then
              continue
            fi
            echo $window >>$WMCTRL_SAVE_FILE
        done
    else
        wmctrl -lG | grep $1 | while read -r window
        do
            skip=0
            title=$(set -- $window ; echo ${@: 8})
            for ex in $EXCLUDE_TITLES
            do
                if [[ $title == $ex ]]
                then
                  echo SKIPPING \(contains $ex\) $key $x \"$title\"
                  skip=1
                  break;
                fi
            done

            if [[ $skip == 1 ]]
            then
              continue
            fi
            echo $window >>$WMCTRL_SAVE_FILE
        done
    fi
    exit 0
fi

# **************************************************************
# -r|--restore then read WMCTRL_SAVE_FILE and move those windows
# **************************************************************

if [[ $RESTORE -eq 1 ]]
then
    echo Restoring window positions from $WMCTRL_SAVE_FILE
    cat $WMCTRL_SAVE_FILE | while read -r line
    do
      IFS=" "
      key=$(set -- $line ; echo $1)
      x=$(set -- $line ; echo $3)
      y=$(set -- $line ; echo $4)
      width=$(set -- $line ; echo $5)
      height=$(set -- $line ; echo $6)
  
      echo Restoring $line
      wmctrl -i -r $key -e 0,$x,$y,$width,$height

    done
    exit 0
fi

# **************************************************************
# If we're going to do a window 'cascade' then set coordinates
# **************************************************************

# x,y screen coordinates of start of window cascade
if [ -z "$XSTART" ]
then
  XSTART=100
  printf '%s\n' 'using default XSTART value of '$XSTART
fi

if [ -z "$YSTART" ]
then
  YSTART=100
  printf '%s\n' 'using default YSTART value of '$YSTART
fi

# shift right and down of each successive window
if [ -z "$XOFFSET" ]
then
  XOFFSET=50
  printf '%s\n' 'using default XOFFSET value of '$XOFFSET
fi

if [ -z "$YOFFSET" ]
then
  YOFFSET=50
  printf '%s\n' 'using default YOFFSET value of '$YOFFSET
fi

# new window x,y size, -1 means keep current size
XSIZE=-1
YSIZE=-1

# window will be moved to XPOS,YPOS
XPOS=$XSTART
YPOS=$YSTART

# ************************************************************************
# DEBUG stuff, generally commented out
# ************************************************************************

# echo DEBUG XLIMIT is $XLIMIT

# ************************************************************************
# <window filter> is list of HEX WINDOW IDs then just move those and exit
# ************************************************************************

if [[ "$1" == "0x"* ]]
then
    echo Moving window keys
    for key in "$@"
    do
        echo Moving window $key
        wmctrl -i -r $key -e 0,$XPOS,$YPOS,$XSIZE,$YSIZE
        ((XPOS+=XOFFSET))
        ((YPOS+=YOFFSET))
    done
    exit 0
fi


# *************************************************************
# <window filter> is ASCII STRING then just move those and exit
# *************************************************************

if [[ "$1" != "" && $1 > 99999 ]]
then
    echo Moving windows containing \"$1\"
    wmctrl -lG | grep $1 | awk '{print $1}' | while read -r line
    do
        echo Moving window $line
        wmctrl -i -r $line -e 0,$XPOS,$YPOS,$XSIZE,$YSIZE
        ((XPOS+=XOFFSET))
        ((YPOS+=YOFFSET))
    done
    exit 0
fi

# *************************************************************
# <window filter> is EMPTY or
# <window filter> is a NUMBER
# *************************************************************

IFS=" "

IFS=$'\n'

for window in $(wmctrl -lG)
do
  IFS=" "
  key=$(set -- $window ; echo $1)
  x=$(set -- $window ; echo $3)
  y=$(set -- $window ; echo $4)
  title=$(set -- $window ; echo ${@: 8})
  
  skip=0

  # if window is inside (i.e. less than) xlimit then skip
  if [[ $XLIMIT -gt $x ]]
  then
    echo SKIPPING \(x position\) $key $x \"$title\"
    continue
  fi

  # if window is below (i.e. less than) ylimit then skip
  if [[ $YLIMIT -gt $y ]]
  then
    echo SKIPPING \(y position\) $key $y \"$title\"
    continue
  fi

  for ex in $EXCLUDE_TITLES
  do
    if [[ $title == $ex ]]
    then
      echo SKIPPING \(contains $ex\) $key $x \"$title\"
      skip=1
      break;
    fi
  done

  if [[ $skip == 1 ]]
  then
      continue
  fi

  echo MOVING window $key $x \"$title\" to \($XPOS, $YPOS\)

  wmctrl -i -r $key -e 0,$XPOS,$YPOS,$XSIZE,$YSIZE
  ((XPOS+=XOFFSET))
  ((YPOS+=YOFFSET))

done
exit 0

#!/bin/bash

files="xinitrc Xresources"
PS3="(Non-number skips) #? "

for file in $files;
do
    #echo "Type a non-number to skip (yes, it's a hack, whatever)"
    select guh in $file*;
    do
        if [ -n "$guh" ]; then
            echo "You picked $guh ($REPLY)"
            #ln -s $guh ../.$file
        else
            echo "Skipped"
        fi
        break
    done
done

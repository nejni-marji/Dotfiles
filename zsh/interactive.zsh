#!/bin/zsh -i

# This file is for handling the rare cases where I need to use aliases or other
# interactive shell elements inside of a function or other kind of script.

ydl-retry() {
        for ((i=0;i<10;i++)) ; ydl $@ && break
}

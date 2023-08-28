#!/bin/zsh

# THIS FUNCTION IS EXPERIMENTAL AND JANKY.
# Watch out! This function might break your custom functions and aliases!
# Also, do not run this for a given $1 more than once!
# If you really want to have several possible awiases for one command, make a
# cannonical one, and do the rest using the regular 'alias' builtin.
# I could theoretically boost this to incorporate multiple awiases, but for now,
# it works well enough.



awias() {
	# save existing alias, if it exists
	if data="$(alias $1)" ; then
		# alias $2="\\${(Q)${(j:=:)${${(s:=:)data}[2,-1]}}}"
		alias $2="\\${(Q)data#*=}"
	# if it doesn't, just do this instead
	else
		alias $2="\\$1"
	fi
	# alias the original to an error message. hopefully this doesn't cause
	# trouble in scripts.
	# alias $1="\\printf \"uwuify: $1 -> $2 [from: \$0]\n\""
	# disabling this feature because it breaks EVERYTHING -2022-11-17 17:36:12
}



awias sudo suwudo
awias doas dowoas   # if you use doas
awias clear cweaw
awias reset weset
awias print pwint
awias printf pwintf
awias echo echowo
awias ls wist
awias cd cdiw
awias dir diw
awias mkdir mkdiw
# awias man myan
alias myan='\man'
awias man nyan
awias chmod chmowod
# awias chown chowon
alias chowon='\chown'
awias chown chowown
awias chgrp chgruwup
awias yes nya   # nya nya
awias cat neko   # what about head and tail?
awias tac oken   # haha lol
awias rev wev

awias pacman pacnyan

awias git gwit
awias perl pewl
awias grep gwep

awias firefox furryfox
# awias firefox fwiorfowox
alias fwiorfowox='\firefox'
# awias firefox fuwwyfox
alias fuwwyfox='\firefox'





# This is the original version of this file, preserved mostly for reference.



#alias awias=alias
#awias suwudo=sudo
#awias dowoas=doas   # if you're into that
#awias pwint=print
#awias pwintf=printf
#awias echowo=echo
#awias wist=ls
#awias cdiw=cd
#awias diw=dir
#awias mkdiw=mkdir
#awias myan=man
#awias nyan=man
#awias chmowod=chmod
##awias chowon=chown
#awias chowown=chown
#awias chgruwup=chgrp
#awias nya=yes   # nya nya
#awias neko=cat   # what about head and tail?
#awias oken=tac   # haha lol
#awias wev=rev

#awias gwit=git
#awias pewl=perl
#awias gwep=grep

#awias fwiorfowox=firefox
#awias fuwwyfox=firefox   # bc ofc
#awias furryfox=firefox   # also this

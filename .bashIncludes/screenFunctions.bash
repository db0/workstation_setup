############################################################################
#     GNU screen functions
############################################################################

function scr() {
wd=`pwd`
cmd=$1
shift

# We can tell if we are running inside screen by looking
# for the STY environment variable.  If it is not set we
# only need to run the command, but if it is set then
# we need to use screen.


if [ -z "$STY" ]; then
   $cmd $*
else
   # Screen needs to change directory so that
   # relative file names are resolved correctly.
   screen -X chdir $wd
   # Ask screen to run the command
   if [ $cmd == "ssh" ]; then
      screen -t ""${1##*@}"" ${SCRIPTS}/screen_ssh.sh $*
   elif [ $cmd == "console" ]; then
      screen -t ""${1##*@}-CONS"" ${SCRIPTS}/screen_ssh.sh -tt ${SERV_ACC}@${CONSOLE_SRV} console $* 
   else
      screen -t "$cmd $*" $cmd $*
   fi
fi

} # End scr() function


function screentitle() { echo -ne "\033k${1}\033\\" ; } # legacy support 

function s() {
   if [ `echo $@ | grep -v '\-sc'` ]; then
      scr ssh "$@" -ttl ${SERV_ACC} exec bash --rcfile /tmp/bash_profile.tmp -i 
   else
      scr ssh "${SERV_ACC}@$@"
   fi
}

function z() {
   echo -e "\033]2;ssh $@  \007"
   [ $TERM == screen ] && screentitle "$@"
   zlogin "$@" 
   [ $TERM == screen ] && screentitle `hostname`
}

[ $TERM == screen ] && screentitle `hostname` # To make sure I get the hostname after connecting to a LH

function vi() {
   if [ `hostname` == $PRIV_DESKTOP ]
   then  
      scr vim $*
   else
      /bin/vi $*
   fi
}

function man() {
   scr /usr/bin/man $*
}

function watch() {
   scr /usr/bin/watch $*
}

function c() {
   scr console $*
}

function top() {
   scr htop
}

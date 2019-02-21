# We only load our bashrc for a local session
[[ -r ~/.bashrc ]] && shopt -q login_shell && . ~/.bashrc

### Fix to load the ${SERV_ACC} profile on other systems with some setup
if [ $(hostname) != $PRIV_DESKTOP ]
then
   [ $(uname | grep SunOS) ] && [[ -r .profile ]] && source .profile
   [[ -r /tmp/corpVars.bash.tmp ]] && source /tmp/corpVars.bash.tmp 
   PATH=${PATH}:/bin:${CORPPATHS}
   [ $(uname | grep Linux) ] && [[ -r .bash_profile ]] && source .bash_profile 
fi


case $OSTYPE in
        FreBSD*)
          SU=/usr/bin/su
          P_ID=/usr/bin/id
          BASHPATH=/usr/local/bin/bash
          E_GREP=/usr/bin/egrep
          ;;
        solaris*)
          SU=/bin/su
          P_ID=/usr/xpg4/bin/id
          BASHPATH=/usr/bin/bash
          E_GREP=/usr/xpg4/bin/egrep
          alias id='/usr/xpg4/bin/id'
          ;;
        linux*)
          SU=/bin/su
          P_ID=/usr/bin/id
          BASHPATH=/bin/bash
          E_GREP=/bin/egrep
          ;;
        darwin*)
          SU=/usr/bin/su
          P_ID=/usr/bin/id
          BASHPATH=/bin/bash
          E_GREP=/bin/egrep
          ;;
esac

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

############################################################################
#      Common vars
############################################################################

export PAGER=less
export EDITOR=vim
export MANPATH=/usr/man:/usr/openwin/share/man:/usr/dt/man:/usr/opt/SUNWmd/man:/opt/SUNWatm/man:/usr/local/man:/usr/local/teTeX/man:/usr/local/ecb-doc/man:/usr/sfw/share/man:/usr/local/rrdtool/man:/usr/cluster/man:/opt/SUNWcluster/man:/usr/share/man:
export TMP=~/tmp/

############################################################################
#      Aliases
############################################################################

alias vt=' TERM vt100 ; stty rows 24'
alias dy='date +%Y%m%d'
alias cd="pushd >/dev/null"
alias memfree='free -m | grep Mem |  awk '\''{print $4}'\'''
alias swapfree='free -m | grep Swap |  awk '\''{print $4}'i\'''
alias pz="ps -ef|${E_GREP} -v '/usr/lib/saf/sac|/usr/lib/saf/ttymon|/usr/lib/utmpd|/usr/sbin/syslogd|/usr/cluster/lib/sc/failfastd|/usr/sbin/cron|zsched|/usr/lib/nfs/nfsmapid|/usr/lib/nfs/nfs4cbd|/usr/lib/inet/inetd|/sbin/init|/usr/lib/ldap/ldap_cachemgr|/usr/sbin/rpcbind|/usr/lib/ssh/sshd|/usr/lib/sendmail|/usr/lib/saf/ttymon|/usr/lib/autofs/automountd|/usr/sbin/nscd|/usr/lib/nfs/lockd|/usr/lib/crypto/kcfd|/usr/lib/nfs/statd|/usr/lib/krb5/ktkt_warnd|/usr/lib/autofs/automountd|/usr/cluster/lib/sc/pmmd|/lib/svc/bin/svc.startd|/lib/svc/bin/svc.configd|/usr/cluster/lib/sc/rpc.pmfd|/usr/bin/login|ps -ef|-bash|0:00 -sh|/usr/cluster/lib/|/usr/cluster/bin/cl|/usr/bin/bash|/usr/local/ecbmon/|[.*]|grep '"
alias lsf='compgen -A function'
alias vib='vi ~/.bash_profile'
alias lsopen='lsof +aL1'
#Local aliases for myself.
alias pycharm='~/Tools/pycharm/latest/bin/pycharm.sh &'
alias t='task +READY' # Taskwarrior
if [ `hostname` == $PRIV_DESKTOP ]; then
   alias ls='exa --git'
   alias ll='exa --git -larsold'
   alias ping='prettyping'
   alias diff='vimdiff'
   alias top='htop'
   alias rsync='rsync --info=progress2'
   alias cat='bat'
else
   alias ll='ls -lart'
fi

function calcspace() {
echo "scale=1; $(df -k | egrep -e '(/dev/|rpool)' | grep -v /fd | grep -v cdrom | grep -v /global/.devices | grep -v /global/mgmt | awk '{s+=$3} END {print s}') / 1014^2" | bc
}

############################################################################
#      Personal sourcing
############################################################################
if [ $(hostname) == "${PRIV_DESKTOP}" ]; then
   if [ -r ~/.privIncludes/*.bash ]; then
      for FILE in ~/.privIncludes/*.bash; do
         source $FILE
      done
   fi
   for FILE in ~/.bashIncludes/*.bash; do
      source $FILE
   done
fi

############################################################################
#      Portable Solaris functions and aliases
############################################################################

function clsvc() ( # This function shows the status of all resources whose resource group matches the command line regex
	 clrg list | ${E_GREP} -i $1 | xargs -i clrs status -g {} | grep -v Resource | grep -v '^$'
)

function clrestart() ( # This function restarts one resource 
         clrs disable $1 && clrs enable $1
)

if [ -x /usr/cluster/bin/clnode ]; then
   alias clzpools="for node in $(clnode list); do echo zpools in $node; ssh $node zpool list; done"
fi

alias clrsnaps='zfs list -t snapshot -o name -H | while read a; do echo Destroying $a; zfs destroy $a; done'
############################################################################
#      PROMPT 
############################################################################

RED="\[\033[0;31m\]";GREEN="\[\033[0;32m\]";LIGHT_GREEN="\[\033[1;32m\]";LIGHT_RED="\[\033[1;31m\]";WHITE="\[\033[1;37m\]";NO_COLOUR="\[\033[0m\]";CYAN="\[\033[0;36m\]";YELLOW="\[\033[0;33m\]";LIGHT_CYAN="\[\033[1;36m\]";LIGHT_YELLOW="\[\033[1;33m\]";PURPLE="\[\033[0;35m\]";LIGHT_PURPLE="\[\033[1;35m\]"

if [ $($P_ID -u) -eq 0 ];
then
   if [ $(hostname) == "${PRIV_DESKTOP}" ]
   then
      STR_COLOUR=$LIGHT_GREEN
   else
      if [ `uname | grep Linux` ]
      then
         STR_COLOUR=$LIGHT_RED
      else
         STR_COLOUR=$LIGHT_PURPLE
	   fi
   fi
	ID_COLOUR=$LIGHT_CYAN
else
   if [ $(hostname) == "${PRIV_DESKTOP}" ]
   then
      STR_COLOUR=$GREEN
   else
      if [ $(uname | grep Linux) ]
      then
         STR_COLOUR=$RED
      else
         STR_COLOUR=$PURPLE
      fi
   fi
   ID_COLOUR=$CYAN
fi

[ `zone-where 2>/dev/null` ] && GLOBAL_ZONE=":`zone-where`" # bit of Solaris prompt magic
PS1="${TITLEBAR}[${ID_COLOUR}\u${NO_COLOUR}@${STR_COLOUR}\h${PURPLE}$GLOBAL_ZONE${NO_COLOUR}]\w${NO_COLOUR}\$ "
if [ $(hostname) == "${PRIV_DESKTOP}" ]
then
   if [ -z "$BASH" ]; then bash
   else
      #PS1="${TITLEBAR}[${ID_COLOUR}\u${NO_COLOUR}@${STR_COLOUR}\h${NO_COLOUR}]\w${NO_COLOUR}\$ "
      shopt -s histappend
      shopt -s histreedit
      shopt -s cmdhist
      shopt -s checkwinsize
      export HISTCONTROL=ignorespace:ignoredups
      export HISTIGNORE="ls:ll:pwd:clear"
      export HISTSIZE=500000
      export HISTSIZE=5000000
   fi
else # Your Business Command History setup should be hidden
   [[ -r /tmp/corpHistory.bash.tmp ]] && source /tmp/corpHistory.bash.tmp
fi

export PS1

############################################################################
#    Cleanup of my profile of business hosts I'm connecting to 
############################################################################

if [ $(hostname) != "$PRIV_DESKTOP" ]
then
	rm -f /tmp/bash_profile.tmp /tmp/*.bash.tmp 
fi

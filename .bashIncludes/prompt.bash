############################################################################
#      Task Warrior in the Prompt 
############################################################################

## Nice Command to grab unicode 
## var="$(echo -n '✅' | od -An -tx1)"; printf '\\x%s' ${var^^}; echo

URGENT=$'[\xE2\x9D\x97]' # ❗
OVERDUE=$'[\xE2\x98\xA0\xEF\xB8\x8F ]' # ☠️
DUETODAY=$'[\xF0\x9F\x98\xB1]' # 😱
DUETOMORROW=$'[\xF0\x9F\x93\x85]' # 📅

[ ! -r ~/.taskrc ] && yes | task > /dev/null 2>&1 # We need to check if the task has been started at least once to prevent bashrc getting stuck    

function task_indicator {
    if [ `task +READY +OVERDUE count` -gt "0" ]; then
        echo "$OVERDUE"
    elif [ `task +READY +DUETODAY count` -gt "0" ]; then
        echo "$DUETODAY"
    elif [ `task +READY +TOMORROW count` -gt "0" ]; then
        echo "$DUETOMORROW"
    elif [ `task +READY urgency \> 10 count` -gt "0" ]; then
        echo "$URGENT"
    fi
}

############################################################################
#      Git Status in the Prompt 
############################################################################


BRed='\e[1;31m'        # Red
BGreen='\e[1;32m'      # Green
RemColour="\033[0m" 

GIT_OK=$'[\xE2\x9C\x85]' # ✅
GIT_NOK=$'[\xE2\x9D\x8C]' # ❌

function git_indicator {
   BRANCH=$(git rev-parse --abbrev-ref HEAD 2> /dev/null)
   if [ -n "$BRANCH" ]; then
      DIRTY=$(git status --porcelain --untracked-files=no 2> /dev/null); 
      if [ -n "$DIRTY" ]; then 
         echo -e "${GIT_NOK}"
      else 
         echo -e "${GIT_OK}"
      fi; 
   fi;
}

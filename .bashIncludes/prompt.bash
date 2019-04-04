############################################################################
#      Task Warrior in the Prompt 
############################################################################

URGENT=$'[\xe2\x9d\x97]' # ❗
OVERDUE=$'[\xe2\x98\xa0\xef\xb8\x8f]' # ☠️
DUETODAY=$'[\xf0\x9f\x98\xb1]' # 😱
DUETOMORROW=$'[\xf0\x9f\x93\x85]' # 📅

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

TICK="✓"
CROSS="✗"

PROMPT_CROSS="'${NO_COLOUR}'['${BRed}'${CROSS}'${NO_COLOUR}']"
PROMPT_TICK="'${NO_COLOUR}'['${BGreen}'${TICK}'${NO_COLOUR}']"

function git_indicator {
   BRANCH=$(git rev-parse --abbrev-ref HEAD 2> /dev/null)
   if [ -n "$BRANCH" ]; then
      DIRTY=$(git status --porcelain --untracked-files=no 2> /dev/null); 
      if [ -n "$DIRTY" ]; then 
         echo -e "${RemColour}[${BRed}${CROSS}${RemColour}]"
      else 
         echo -e "${RemColour}[${BGreen}${TICK}${RemColour}]"
      fi; 
   fi;
}

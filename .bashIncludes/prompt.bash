############################################################################
#      Task Warrior in the Prompt 
############################################################################

URGENT=$'[\xE2\x9D\x97]' # ❗
OVERDUE=$'[\xE2\x98\xA0\xEF\xB8\x8F ]' # ☠️
DUETODAY=$'[\xF0\x9F\x98\xB1]' # 😱
DUETOMORROW=$'[\xF0\x9F\x93\x85]' # 📅

[ ! -r ~/.taskrc ] && yes | task > /dev/null 2>&1 # We need to check if the task has been started at least once to prevent bashrc getting stuck    

function task_indicator {
    exit 0 # Prompt moved to GNU Screen. Comment this line if you prefer it to be in your bash prompt (as well)
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
GIT_DIRTY=$'[\xF0\x9F\x9A\xA7]' # 🚧

function git_indicator {
   BRANCH=$(git rev-parse --abbrev-ref HEAD 2> /dev/null)
   if [ -n "$BRANCH" ]; then
      DIRTY=$(git status --porcelain --untracked-files=no 2> /dev/null); 
      if [ -n "$DIRTY" ]; then 
         echo -e "${GIT_DIRTY}"
      elif [ $(git rev-parse HEAD) != $(git rev-parse @{u}) ]; then
         echo -e "${GIT_NOK}"
      else 
         echo -e "${GIT_OK}"
      fi; 
   fi;
}

############################################################################
#      Other relevant stuff
############################################################################

hexFromGlyph(){ 
## Nice Function to grab unicode codes
## Source: https://stackoverflow.com/questions/602912/how-do-you-echo-a-4-digit-unicode-character-in-bash#comment53918435_5760420
   if [ "$1" == "-n" ]; then 
      outputSeparator=' '
      shift
   else 
      outputSeparator='\n'
   fi 
   for glyph in "$@"; do 
      printf "\\\x%s" $(printf "$glyph"|xxd -p -c1 -u)
      echo -n -e "$outputSeparator"
   done 
}


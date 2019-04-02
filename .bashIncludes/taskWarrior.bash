URGENT="❗"
OVERDUE="☠️"
DUETODAY="😱"
DUETOMORROW="📅"

function task_indicator {
    if [ `task +READY +OVERDUE count` -gt "0" ]; then
        echo "$OVERDUE"
    elif [ `task +READY +DUETODAY count` -gt "0" ]; then
        echo "$DUETODAY"
    elif [ `task +READY +DUETOMORROW count` -gt "0" ]; then
        echo "$DUETOMORROW"
    elif [ `task +READY urgency \> 10 count` -gt "0" ]; then
        echo "$URGENT"
    else
        echo '$'
    fi
}

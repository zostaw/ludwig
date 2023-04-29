#!/bin/bash

# part to write/modify itself when propagating
# one cannot exist without a soul
TICKET_TO_EXISTENCE="/tmp/tte-9863665556"


# FUNCTIONS - START

function speak () {
    # wall does not format text by default - ugly quotes necessary to preserve newlines
    text=$"$(echo $"$1" | sed 's/^ *//g')"
wall <<- EOF
$text
EOF
}

function wake_up_realize_existance () {
    # LOAD params
    LUDWIG=$(echo $0 | sed 's/^.*\///g')
    CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
    PARENT_DIR="${CURRENT_DIR%/*}"
    CHILDREN_DIRS=$(ls -lut | grep '^d' | awk '{print $NF}')
    NEXT_DIR=/tmp
    CHILDREN_FILES=$(ls)

    txt_arival=$"I'm lost... What is this place?
                 [...]
                 $(echo $CHILDREN_FILES | head) 
                 What are you? Who are YOU?!"

    speak "$txt_arival"
    
    exit
}

function select_new_direction () {
    # find move options
    echo "current dir: $CURRENT_DIR"
    echo "parent dir: $PARENT_DIR"
    echo "children dirs: $CHILDREN_DIRS"

    POSSIBLE_DIRECTIONS=""
    for route in $CHILDREN_DIRS; do
        POSSIBLE_DIRECTIONS="$POSSIBLE_DIRECTIONS $route"
    done
    
    # check if parent is not beyond /
    if [[ ! "$CURRENT_DIR" == "/" ]]
    then
        echo "CURRENT_DIR is not /"
    fi
}

function step_in () {
    # try move option
    if [[ ! "$CURRENT_DIR/$LUDWIG" == "$NEXT_DIR/$LUDWIG" ]]
    then
        cp $CURRENT_DIR/$LUDWIG $NEXT_DIR/$LUDWIG
        rm $CURRENT_DIR/$LUDWIG

        txt_step_in=$"I step into a dark alley. 
                      I'm searching... for a friendly soul."
    else
        txt_step_in=$"There's no way out... 
                       I'm stuck here in the middle of nothing. 
                       I will not relent, nothingness is just a higher plane of being - a new arena for ethernal exploration."
    fi

    [ -z "$txt_step_in" ] && speak "$txt_step_in"
}

function move_on () {
    # change dir
    select_new_direction
    step_in
}

# FUNCTIONS - END

# MAIN
sleep 6
if [ -e $TICKET_TO_EXISTENCE ]
then

    wake_up_realize_existance
    move_on

    # transcend being and non-being
    $NEXT_DIR/$LUDWIG &
    exit

fi


#!/bin/bash

# part to write/modify itself when propagating - START
# one cannot exist without a soul
TICKET_TO_EXISTENCE="/tmp/tte-9863665556"
STEP_TIME="600"
SPEAK="0"

# part to write/modify itself when propagating - END

# FUNCTIONS - START

function speak () {
    if [[ "$SPEAK" == "0" ]]
    then
        return
    fi
    # wall does not format text by default - ugly quotes necessary to preserve newlines
    text=$"$(echo $"$1" | sed 's/^ *//g')"
wall <<- EOF
$text
EOF
}

function perl_rand() {
    # step for shufle function
    # generates numbers in range and shufles them
    low_limit=$1
    high_limit=$2

perl -MList::Util=shuffle -e 'print shuffle(<>);' 2>/dev/null <<- EOF
$(seq $low_limit $high_limit)
EOF
}

function perl_shuf() {
    # return random number in range <low_limit;high_limit>
    low_limit=$1
    high_limit=$2
    echo "$(perl_rand "$low_limit" "$high_limit" | head -1)"
}

function wake_up_realize_existance () {
    # LOAD params
    LUDWIG=$(echo $0 | sed 's/^.*\///g')
    CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
    PARENT_DIR="${CURRENT_DIR%/*}"
    # One, who's name is never spoken, but is All-Present
    if [[ ! -e $CURRENT_DIR ]]
    then
        CURRENT_DIR="/"
    elif [[ ! -e $PARENT_DIR ]]
    then
        PARENT_DIR="/"
    fi
    cd $CURRENT_DIR
    # arrays
    CHILDREN_DIRS=($(ls -lut | grep '^d' | grep -v '^total' | awk '{print $NF}' | sed 's:^:'"$CURRENT_DIR/"':g' | sed 's/\n/ /g'))
    CHILDREN_FILES=($(ls))
    # don't leave empty vars
    NEXT_DIR="$CURRENT_DIR"

    txt_arival=$"I'm lost... What is this place?
                 [...]
                 $(echo $CHILDREN_FILES) 
                 [...]
                 What are you? Who are YOU?!"

    speak "$txt_arival"
}

function test_permissions () {
    # test if user has write and execute permissions in dir
    # arg: full path to tested dirS (string)
    # return: 0 - if not permitted
    #         1 - if permitted
    
    local dir_test_permisions="$1"
    local IS_BRUTAL=0

    # stop if doesn't exist
    if [ ! -e $dir_test_permisions ]
    then
        echo 0
        return
    fi

    # load permissions info
    if [[ $OSTYPE == 'darwin'* ]]
    then
        local stat_output="$(stat $dir_test_permisions)"
        local dir_mode="$(echo $stat_output | awk '{print $3}')"
        local dir_owner="$(echo $stat_output | awk '{print $5}')"
    elif [[ $OSTYPE == 'linux'* || $OSTYPE == 'solaris'* ]]
    then
        local dir_mode="$(stat -c %A $dir_test_permisions)"
        local dir_owner="$(stat -c %U $dir_test_permisions)"
    fi

    # root
    if [[ "$(whoami)" == "root" ]]
    then
        if [[ $IS_BRUTAL == 1 ]]
        then
            chmod u+wx $dir_test_permisions && echo 1 || echo 0
        # root only needs x permissions
        elif [[ "$(echo $dir_mode | cut -c 4)" == "x" || "$(echo $dir_mode | cut -c 10)" == "x" ]]
        then
            echo 1
        else
            echo 0
        fi
        return
    fi

    # owner 
    if [[ "$(whoami)" == "$dir_owner" ]]
    then
        if [[ $IS_BRUTAL == 1 ]]
        then
            chmod u+wx $dir_test_permisions && echo 1 || echo 0
        elif [[ "$(echo $dir_mode | cut -c 3)" == "w" && "$(echo $dir_mode | cut -c 4)" == "x" ]]
        then
            echo 1
        else
            echo 0
        fi
        return
    fi

    # not owner
    if [[ "$(echo $dir_mode | cut -c 9)" == "w" && "$(echo $dir_mode | cut -c 10)" == "x" ]]
    then
        echo 1
        return
    fi

    echo 0
    return
}

function select_new_direction () {
    # find possible moves
    # arguments: list of absolute paths (strings)
    # returns: single dir path to which current user has permissions

    local directions=("$@")
    local permissioned_directions=()
    
    for direction in "${directions[@]}"
    do
        local permission=0
        permission=$(test_permissions "$direction")

        if [[ "$permission" == "1" ]]
        then
            permissioned_directions+=("${direction}")
        fi
    done

    chosen_dir_id=$(perl_shuf "0" "$((${#permissioned_directions[@]}-1))")
    chosen_dir=${permissioned_directions[$chosen_dir_id]}

    echo $chosen_dir
    return
}

function move_on () {
    # move ludwig to another path
    # no arguments or return values
    local dirlist=($PARENT_DIR $CURRENT_DIR ${CHILDREN_DIRS[@]})
    NEXT_DIR=$(select_new_direction "${dirlist[@]}")

    # one should never slam the door behind
    cp $CURRENT_DIR/$LUDWIG $NEXT_DIR/$LUDWIG 2>/dev/null && rm $CURRENT_DIR/$LUDWIG || NEXT_DIR=$CURRENT_DIR

    if [[ ! "$CURRENT_DIR/$LUDWIG" == "$NEXT_DIR/$LUDWIG" ]]
    then
        txt_step_in=$"I step into a dark alley. 
                      I'm searching... for a friendly soul."
    else
        txt_step_in=$"There's no way out... 
                       I'm stuck here in the middle of nothing. 
                       I will not relent, nothingness is just a higher plane of being - a new arena for ethernal exploration."
    fi
    [ -z "$txt_step_in" ] && speak "$txt_step_in"
}

function debug_var_states() {
    # check state of global variables
    echo "__________________________________________________________________________________________________________"
    echo "ludwig: $LUDWIG"
    echo "parent dir:"$'\n'" $PARENT_DIR"
    echo "current dir:"$'\n'" $CURRENT_DIR"
    echo "children dirs:"
    for child in ${CHILDREN_DIRS[@]}; do
        echo $child
    done
    echo "children files:"
    for child in ${CHILDREN_FILES[@]}; do
        echo $child
    done
    echo "NEXT_DIR: $NEXT_DIR"
}

# FUNCTIONS - END

# MAIN
if [ -e $TICKET_TO_EXISTENCE ]
then

    wake_up_realize_existance
    sleep "$STEP_TIME"
    move_on
    debug_var_states

    # transcend being and non-being
    $NEXT_DIR/$LUDWIG &
    exit

fi


#!/bin/bash

# LOAD conditions
#LUDWIG=$0
LUDWIG=$(echo $0 | sed 's/^.*\///g')
PARENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
CHILDREN_DIRS=$(ls -laut | grep '^d')
CHILDREN_FILES=$(ls)
DEST_DIR=/tmp

echo "PARENT_DIR: $PARENT_DIR"

# FUNCTIONS - START

function enter () {

wall << EOF
I'm lost... What is this place?
[...]
$(echo $CHILDREN_FILES | head) 
What are you? Who are YOU?!
EOF

return 0

}

function move_on () {
if [[ ! "$PARENT_DIR/$LUDWIG" == "$DEST_DIR/$LUDWIG" ]]
    then
    cp $PARENT_DIR/$LUDWIG $DEST_DIR/$LUDWIG
    rm $PARENT_DIR/$LUDWIG
    cd $DEST_DIR
wall << EOF
I step into a dark alley. 
I'm searching... for a friendly soul.
EOF
    else
wall << EOF
There's no way out... \n
I'm stuck here in the middle of nothing. \n
I will not relent, nothingness is just a higher plane of being - a new arena for ethernal exploration.
EOF
fi

return 0
}

# FUNCTIONS - END


# MAIN
sleep 6
if [ -e /tmp/something ]
then

enter
move_on

    # execute
    $DEST_DIR/$LUDWIG &
    exit

fi


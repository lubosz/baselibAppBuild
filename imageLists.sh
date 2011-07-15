#!/bin/sh

# baseLibApp Build
# Lubosz Sarnecki 2011

EXTENSION_LIST="jpg png"

cd images/
IMAGE_PATH=$PWD
TEMP_LIST="$IMAGE_PATH/temp.list"
DIR_LIST=`find . -type d`

for IMAGEDIR in $DIR_LIST; do
  if [ "$IMAGEDIR" != "." ]; then
    cd $IMAGE_PATH/$IMAGEDIR
    for EXT in $EXTENSION_LIST; do 
      IMAGE_LIST=`find . -type f | grep -i "\.$EXT$"`
      if ((${#IMAGE_LIST} != 0)); then
        LIST_NAME=`echo $IMAGEDIR | cut -c 3-`
        echo "Found Images in $LIST_NAME"
        LIST_PATH="$IMAGE_PATH/$LIST_NAME-$EXT.list"
        #echo $LIST_PATH
        touch $TEMP_LIST
        for IMAGE in $IMAGE_LIST; do
          echo "$PWD/`echo $IMAGE | cut -c 3-`" >> $TEMP_LIST
        done
        sort $TEMP_LIST > $LIST_PATH
        rm $TEMP_LIST
      fi
    done
  fi
done



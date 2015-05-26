#!/bin/bash

#!/bin/bash

OLDFILE=$1

usage() {
    echo "Usage: $0 oldfile"
    exit 1
}

if [ -z "$OLDFILE" ]
  then 
    usage
    exit 1
fi

OLDFILE=$1
NEWFILE=x$1

col -bp < $OLDFILE >> $NEWFILE
chmod +x $NEWFILE
rm $OLDFILE
mv $NEWFILE $OLDFILE

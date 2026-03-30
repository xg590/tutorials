#!/bin/bash

# Assign the Env_var
FILE=$1
FILENAME=${FILE%.*} 
SCRATCH_DIR=/tmp/scratch
CHK=$FILENAME.chk 

export g09root=/home/share/app/g09d01
source ${g09root}/g09/bsd/g09.profile
export GAUSS_SCRDIR=${SCRATCH_DIR}
export GAUSS_EXEDIR=$g09root/g09  

# Tmp
if [ ! -d ${SCRATCH_DIR} ]; then
        mkdir ${SCRATCH_DIR}
fi

rm -f ${SCRATCH_DIR}/Gau-* 2>/dev/null

if [ -s $PWD/$CHK ]; then
        cp --update $PWD/$CHK ${SCRATCH_DIR} 
fi

# Run

ulimit -S -c 0

g09 < $FILENAME.gjf >> $FILENAME.log
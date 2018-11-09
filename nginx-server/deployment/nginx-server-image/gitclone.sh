#!/bin/sh
DIR="/mnt/azurefile"
LOG="/var/log/gitclone.log"
REPO="https://github.com/andyzhangx/k8s-demo.git"

if [ $# -eq 1 ]; then
	REPO=$1
fi

if [ -d "$DIR" ]; then
	if [ "$(ls -A $DIR)" ]; then
		echo "$DIR is not empty" >> $LOG
	else
		git clone $REPO $DIR 2>&1 >> $LOG
	fi
else
	echo "$DIR does not exist" >> $LOG
fi

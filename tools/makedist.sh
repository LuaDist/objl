#!/bin/sh

if [ "$1" == "-h" ] || [ "$1" == "-help" ] || [ "$1" == "--help" ] ; then
	echo -e "$0 -- Makes an ObjL distribution.\tUsage: $0 PACKAGENAME"
	exit 0
fi

cd ../..
tar -cz objective-lua > ${1}.tgz
cd objective-lua/tools


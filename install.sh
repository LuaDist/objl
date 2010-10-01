#!/bin/sh

INSTDIR="/usr/local/ObjL/"
DOCSDIR="/usr/share/doc/ObjL"
INCDIR="/usr/include/ObjL"
BINDIR="/usr/bin"

echo "Installing ObjL..."
echo -e "\tCreating library directory... \c"
mkdir $INSTDIR && echo -e "\t[OK]" || echo -e "\t[FAILED]"
echo -e "\tCopying library files.. \c"
cp ./lib/* $INSTDIR && echo -e "\t[OK]" || echo -e "\t[FAILED]"
echo -e "\tCreating docs directory... \c"
mkdir $DOCSDIR && echo -e "\t[OK]" || echo -e "\t[FAILED]"
echo -e "\tCopying docs... \c"
cp ./doc/* $DOCSDIR && echo -e "\t[OK]" || echo -e "\t[FAILED]"
#echo "Installing experimental ObjL standalone interpreter..."
#cd src
#./build.sh
#./install.sh
#cd ..
echo -e "\tCreating ObjL C include directory... \c"
mkdir $INCDIR && echo -e "\t[OK]" || echo -e "\t[FAILED]"
echo -e "\tCopying ObjL C headers over... \c"
cp ./src/*.h $INCDIR && echo -e "\t[OK]" || echo -e "\t[FAILED]"
echo -e "\tBuilding ObjL standalone wrapper... \c"
cd src
./build.sh && echo -e "\t[OK]" || echo -e "\t[FAILED]"
cd ..
echo -e "\tCopying ObjL standalone wrapper... \c"
cp ./src/ObjL $BINDIR && echo -e "\t[OK]" || echo -e "\t[FAILED]"
echo -e "\tTesting ObjL..."
for item in ./test/*.lua ; do 
ObjL $item && echo -e "\t[OK]" || echo -e "\t[FAILED]"
done
echo -e "Done installing ObjL."
echo -e "Docs are in $DOCSDIR and library files are in $INSTDIR.\n\n"


#!/bin/sh

# mkipk.sh
# generates an ipkg for embedded Mad Bomber

# Bill Kendrick
# bill@newbreedsoftware.com
# http://www.newbreedsoftware.com/madbomber/

# 2002.Apr.13 - 2003.Mar.16


VER=0.2.5


PACKAGE=madbomber
TMPDIR=tmp
CONTROL=$TMPDIR/CONTROL/control
ARCH=arm
RM=rm

echo "SETTING UP"
mkdir $TMPDIR
mkdir $TMPDIR/CONTROL


echo
echo "MAKING SURE BINARY EXISTS"
make clean
make embedded

echo 
echo "CREATING CONTROL FILE"

echo "Package: $PACKAGE" > $CONTROL
echo "Priority: optional" >> $CONTROL
echo "Version: $VER" >> $CONTROL
echo "Section: games" >> $CONTROL
echo "Architecture: $ARCH" >> $CONTROL
echo "Maintainer: Bill Kendrick (bill@newbreedsoftware.com)" >> $CONTROL
echo "Description: A Kaboom! clone" >> $CONTROL

echo
echo "COPYING DATA FILES"

mkdir -p $TMPDIR/opt/QtPalmtop/share/madbomber
cp -R data/sounds $TMPDIR/opt/QtPalmtop/share/madbomber
mkdir $TMPDIR/opt/QtPalmtop/share/madbomber/images
cp -R data/embedded/images/* $TMPDIR/opt/QtPalmtop/share/madbomber/images
mkdir $TMPDIR/opt/QtPalmtop/share/madbomber/music
cp -R data/embedded/music/* $TMPDIR/opt/QtPalmtop/share/madbomber/music

echo
echo "CREATING BINARIES"

mkdir -p $TMPDIR/opt/QtPalmtop/bin/
echo "madbomber" > $TMPDIR/opt/QtPalmtop/bin/madbomber.sh
cp madbomber $TMPDIR/opt/QtPalmtop/bin/
chmod 755 TMPDIR/opt/QtPalmtop/bin/madbomber.sh


echo "CREATING ICON AND DESKTOP FILE"

mkdir -p $TMPDIR/opt/QtPalmtop/pics/
cp data/images/game/bomb/bomb2.png $TMPDIR/opt/QtPalmtop/pics/madbomber.png

mkdir -p $TMPDIR/opt/QtPalmtop/apps/Games/
DESKTOP=$TMPDIR/opt/QtPalmtop/apps/Games/madbomber.desktop
echo "[Desktop Entry]" > $DESKTOP
echo "Comment=Kaboom! clone" >> $DESKTOP
echo "Exec=madbomber.sh" >> $DESKTOP
echo "Icon=madbomber" >> $DESKTOP
echo "Type=Application" >> $DESKTOP
echo "Name=Madbomber" >> $DESKTOP


echo
echo "CREATING IPK..."

ipkg-build $TMPDIR

echo
echo "CLEANING UP"

$RM -r $TMPDIR

echo


#!/bin/sh
#
# Copyright (c) 2005 Matteo Riondato
#
# See COPYING for licence terms.
#
#
# $Id: sound.sh,v 1.4 2007/01/08 18:31:01 rionda Exp $

set -e -u

if [ -z "${LOGFILE:-}" ]; then
	echo "This script can't run standalone."
	echo "Please use launch.sh to execute it."
	exit 1
fi

mkdir -p $BASEDIR/usr/local/share/sound $BASEDIR/etc/rc.d

cp extra/sound/sound_detect.sh $BASEDIR/etc/rc.d/sound_detect
chmod 555 $BASEDIR/etc/rc.d/sound_detect
cp extra/sound/snd_card_ids.txt $BASEDIR/usr/local/share/sound/


#!/bin/sh
#
# Copyright (c) 2005 Dario Freni
#
# See COPYING for licence terms.
#
# $FreeBSD$
# $Id: installworld.sh,v 1.8 2006/06/11 18:29:50 saturnero Exp $

set -e -u

if [ -z "${LOGFILE:-}" ]; then
    echo "This script can't run standalone."
    echo "Please use launch.sh to execute it."
    exit 1
fi

echo "#### Installing world for ${ARCH} architecture ####"

# Set MAKE_CONF variable if it's not already set.
if [ -z "${MAKE_CONF:-}" ]; then
    if [ -n "${MINIMAL:-}" ]; then
	MAKE_CONF=${LOCALDIR}/conf/make.conf.minimal
    else
	MAKE_CONF=${LOCALDIR}/conf/make.conf
    fi
fi

mkdir -p ${BASEDIR}

cd ${SRCDIR}

makeargs="${MAKEOPT:-} ${MAKEJ_WORLD:-} __MAKE_CONF=${MAKE_CONF} TARGET_ARCH=${ARCH} DESTDIR=${BASEDIR} SRCCONF=${SRC_CONF}"
(env $MAKE_ENV script -aq $LOGFILE make ${makeargs:-} installworld || print_error;) | grep '^>>>'

makeargs="${MAKEOPT:-} __MAKE_CONF=${MAKE_CONF} TARGET_ARCH=${ARCH} DESTDIR=${BASEDIR} SRCCONF=${SRC_CONF}"
set +e
(env $MAKE_ENV script -aq $LOGFILE make ${makeargs:-} distribution || print_error;) | grep '^>>>'
set -e
cd $LOCALDIR

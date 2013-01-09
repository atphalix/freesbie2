#!/bin/sh
#
# Copyright (c) 2005 Dario Freni
#
# See COPYING for licence terms.
#
# $FreeBSD$
# $Id: buildkernel.sh,v 1.8 2006/06/11 18:29:50 saturnero Exp $

set -e -u

if [ -z "${LOGFILE:-}" ]; then
    echo "This script can't run standalone."
    echo "Please use launch.sh to execute it."
    exit 1
fi

echo "#### Building kernel for ${ARCH} architecture ####"

if [ -n "${NO_BUILDKERNEL:-}" ]; then
    echo "NO_BUILDKERNEL set, skipping build" | tee -a ${LOGFILE}
    return
fi

# Set MAKE_CONF variable if it's not already set.
if [ -z "${MAKE_CONF:-}" ]; then
    if [ -n "${MINIMAL:-}" ]; then
	MAKE_CONF=${LOCALDIR}/conf/make.conf.minimal
    else
	MAKE_CONF=${LOCALDIR}/conf/make.conf
    fi
fi

if [ -n "${KERNELCONF:-}" ]; then
    export KERNCONFDIR=$(dirname ${KERNELCONF})
    export KERNCONF=$(basename ${KERNELCONF})
elif [ -z "${KERNCONF:-}" ]; then
    export KERNCONFDIR=${LOCALDIR}/conf/${ARCH}
    export KERNCONF="FREESBIE"
fi

cd $SRCDIR

unset EXTRA

makeargs="${MAKEOPT:-} ${MAKEJ_KERNEL:-} __MAKE_CONF=${MAKE_CONF} TARGET_ARCH=${ARCH} SRCCONF=${SRC_CONF}"
(env $MAKE_ENV script -aq $LOGFILE make $makeargs buildkernel || print_error;) | grep '^>>>'

cd $LOCALDIR

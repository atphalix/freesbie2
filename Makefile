#
# Copyright (c) 2005 Dario Freni
#
# See COPYING for licence terms.
#
# $FreeBSD$
# $Id: Makefile,v 1.5 2006/05/29 19:26:42 saturnero Exp $
#
# FreeSBIE makefile. Main targets are:
#
# iso:		build an iso image
# img:		build a loopback image 
# flash:	copy the built system on a device (interactive)
# freesbie:	same of `iso'
#
# pkgselect:	choose packages to include in the built system (interactive)

.if defined(MAKEOBJDIRPREFIX)
CANONICALOBJDIR:=${MAKEOBJDIRPREFIX}${.CURDIR}
.else
CANONICALOBJDIR:=/usr/obj${.CURDIR}
.endif

all: freesbie

freesbie: iso

pkgselect: obj
	@sh ${.CURDIR}/scripts/launch.sh ${.CURDIR} pkgselect

obj: .done_objdir
.done_objdir:
	@if ! test -d ${CANONICALOBJDIR}/; then \
		mkdir -p ${CANONICALOBJDIR}; \
		if ! test -d ${CANONICALOBJDIR}/; then \
			${ECHO} "Unable to create ${CANONICALOBJDIR}."; \
			exit 1; \
		fi; \
	fi
	@if ! test -f .done_objdir; then \
		touch ${CANONICALOBJDIR}/.done_objdir; \
	fi

buildworld: .done_buildworld
.done_buildworld: .done_objdir
	@-rm -f ${CANONICALOBJDIR}/.tmp_buildworld
	@touch ${CANONICALOBJDIR}/.tmp_buildworld
	@sh ${.CURDIR}/scripts/launch.sh ${.CURDIR} buildworld ${CANONICALOBJDIR}/.tmp_buildworld
	@mv ${CANONICALOBJDIR}/.tmp_buildworld ${CANONICALOBJDIR}/.done_buildworld

installworld: .done_installworld
.done_installworld: .done_buildworld
	@-rm -f ${CANONICALOBJDIR}/.tmp_installworld
	@touch ${CANONICALOBJDIR}/.tmp_installworld
	@sh ${.CURDIR}/scripts/launch.sh ${.CURDIR} installworld ${CANONICALOBJDIR}/.tmp_installworld
	@mv ${CANONICALOBJDIR}/.tmp_installworld ${CANONICALOBJDIR}/.done_installworld

buildkernel: .done_buildkernel
.done_buildkernel: .done_buildworld
	@-rm -f ${CANONICALOBJDIR}/.tmp_buildkernel
	@touch ${CANONICALOBJDIR}/.tmp_buildkernel
	@sh ${.CURDIR}/scripts/launch.sh ${.CURDIR} buildkernel ${CANONICALOBJDIR}/.tmp_buildkernel
	@mv ${CANONICALOBJDIR}/.tmp_buildkernel ${CANONICALOBJDIR}/.done_buildkernel

installkernel: .done_installkernel
.done_installkernel: .done_buildkernel .done_installworld
	@-rm -f ${CANONICALOBJDIR}/.tmp_installkernel
	@touch ${CANONICALOBJDIR}/.tmp_installkernel
	@sh ${.CURDIR}/scripts/launch.sh ${.CURDIR} installkernel ${CANONICALOBJDIR}/.tmp_installkernel
	@mv ${CANONICALOBJDIR}/.tmp_installkernel ${CANONICALOBJDIR}/.done_installkernel

pkginstall: .done_pkginstall
.done_pkginstall: .done_installworld
	@-rm -f ${CANONICALOBJDIR}/.tmp_pkginstall
	@touch ${CANONICALOBJDIR}/.tmp_pkginstall
	@sh ${.CURDIR}/scripts/launch.sh ${.CURDIR} pkginstall ${CANONICALOBJDIR}/.tmp_pkginstall
	@mv ${CANONICALOBJDIR}/.tmp_pkginstall ${CANONICALOBJDIR}/.done_pkginstall

extra:	.done_extra
.done_extra: .done_installworld
	@-rm -f ${CANONICALOBJDIR}/.tmp_extra
	@touch ${CANONICALOBJDIR}/.tmp_extra
	@sh ${.CURDIR}/scripts/launch.sh ${.CURDIR} extra ${CANONICALOBJDIR}/.tmp_extra
	@mv ${CANONICALOBJDIR}/.tmp_extra ${CANONICALOBJDIR}/.done_extra

clonefs: .done_clonefs
.done_clonefs: .done_installkernel .done_pkginstall .done_extra
	@-rm -f ${CANONICALOBJDIR}/.tmp_clonefs
	@touch ${CANONICALOBJDIR}/.tmp_clonefs
	@sh ${.CURDIR}/scripts/launch.sh ${.CURDIR} clonefs ${CANONICALOBJDIR}/.tmp_clonefs
	@mv ${CANONICALOBJDIR}/.tmp_clonefs ${CANONICALOBJDIR}/.done_clonefs

iso: .done_iso
.done_iso: .done_clonefs
	@-rm -f ${CANONICALOBJDIR}/.tmp_iso
	@touch ${CANONICALOBJDIR}/.tmp_iso
	@sh ${.CURDIR}/scripts/launch.sh ${.CURDIR} iso ${CANONICALOBJDIR}/.tmp_iso
	@mv ${CANONICALOBJDIR}/.tmp_iso ${CANONICALOBJDIR}/.done_iso

img: .done_img
.done_img: .done_clonefs
	@-rm -f ${CANONICALOBJDIR}/.tmp_img
	@touch ${CANONICALOBJDIR}/.tmp_img
	@sh ${.CURDIR}/scripts/launch.sh ${.CURDIR} img ${CANONICALOBJDIR}/.tmp_img
	@mv ${CANONICALOBJDIR}/.tmp_img ${CANONICALOBJDIR}/.done_img

flash: .done_flash
.done_flash: .done_clonefs
	@-rm -f ${CANONICALOBJDIR}/.tmp_flash
	@touch ${CANONICALOBJDIR}/.tmp_flash
	@sh ${.CURDIR}/scripts/launch.sh ${.CURDIR} flash ${CANONICALOBJDIR}/.tmp_flash
	@mv ${CANONICALOBJDIR}/.tmp_flash ${CANONICALOBJDIR}/.done_flash

clean:
	@-rm -f .tmp* .done* > /dev/null 2>&1

cleandir: clean
	@sh ${.CURDIR}/scripts/launch.sh ${.CURDIR} cleandir

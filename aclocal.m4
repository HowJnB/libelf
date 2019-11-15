# Local additions to Autoconf macros.
# Copyright (C) 1995 Michael Riepe <riepe@ifwsn4.ifw.uni-hannover.de>

dnl mr_ACTION(VARIABLE [, ACTION-IF-YES [, ACTION-IF-NO ]])
define([mr_ACTION], [
  ifelse([$2$3], , , [
    if test "$1" = yes; then
      ifelse([$2], , :, [$2])
    ifelse([$3], , , [else
      $3])
    fi
  ])
])

dnl mr_SYS_ELFHOST([ ACTION-IF-TRUE [, ACTION-IF-FALSE ]])
AC_DEFUN(mr_SYS_ELFHOST, [
  AC_MSG_CHECKING([for ELF host system])
  AC_CACHE_VAL(mr_cv_sys_elfhost, [
    mr_cv_sys_elfhost=`sed -ne 's/^.ELF.*/yes/p' -e 'q' /bin/sh`
    if test "$mr_cv_sys_elfhost" != 'yes'; then
      mr_cv_sys_elfhost=no
    fi
  ])
  AC_MSG_RESULT($mr_cv_sys_elfhost)
  mr_ACTION([$mr_cv_sys_elfhost], [$1], [$2])
])

dnl mr_SYS_ELFTARGET([ ACTION-IF-TRUE [, ACTION-IF-FALSE ]])
AC_DEFUN(mr_SYS_ELFTARGET, [
  AC_MSG_CHECKING([for ELF target system])
  AC_CACHE_VAL(mr_cv_sys_elftarget, [
    rm -f conftest*
    echo 'int main(){return 0;}' >conftest.c
    if ! eval $ac_compile; then
      AC_MSG_ERROR([cannot create object file])
    fi
    mr_cv_sys_elftarget=`sed -ne 's/^.ELF.*/yes/p' -e 'q' conftest.o`
    if test "$mr_cv_sys_elftarget" != 'yes'; then
      mr_cv_sys_elftarget=no
    fi
    rm -f conftest*
  ])
  AC_MSG_RESULT($mr_cv_sys_elftarget)
  mr_ACTION([$mr_cv_sys_elftarget], [$1], [$2])
])

dnl mr_SYS_NLS_CATGETS([ ACTION-IF-TRUE [, ACTION-IF-FALSE ]])
AC_DEFUN(mr_SYS_NLS_CATGETS, [
  AC_MSG_CHECKING(for catgets)
  AC_CACHE_VAL(mr_cv_sys_nls_catgets, [
    AC_TRY_LINK(
      [#include <nl_types.h>],
      [catgets(catopen("",0),0,0,"");return 0;],
      mr_cv_sys_nls_catgets=yes,
      mr_cv_sys_nls_catgets=no)
  ])
  AC_MSG_RESULT($mr_cv_sys_nls_catgets)
  mr_ACTION([$mr_cv_sys_nls_catgets], [$1], [$2])
])

dnl mr_SYS_NLS_GETTEXT([ ACTION-IF-TRUE [, ACTION-IF-FALSE ]])
AC_DEFUN(mr_SYS_NLS_GETTEXT, [
  AC_MSG_CHECKING(for gettext)
  AC_CACHE_VAL(mr_cv_sys_nls_gettext, [
    mr_save_libs="$LIBS"
    LIBS="-lintl $LIBS"
    AC_TRY_LINK(
      [#include <libintl.h>],
      [gettext("");return 0;],
      mr_cv_sys_nls_gettext=yes,
      mr_cv_sys_nls_gettext=no LIBS="$mr_save_libs")
  ])
  AC_MSG_RESULT($mr_cv_sys_nls_gettext)
  mr_ACTION([$mr_cv_sys_nls_gettext], [$1], [$2])
])

dnl mr_SYS_NLS([ ACTION-IF-TRUE [, ACTION-IF-FALSE ]])
AC_DEFUN(mr_SYS_NLS, [
  AC_MSG_CHECKING(for NLS support)
  AC_MSG_RESULT()
  mr_sys_nls=no
  mr_SYS_NLS_CATGETS(mr_sys_nls=yes)
  mr_SYS_NLS_GETTEXT(mr_sys_nls=yes)
  mr_ACTION([$mr_sys_nls], [$1], [$2])
])

dnl mr_ENABLE_NLS([ ACTION-IF-TRUE [, ACTION-IF-FALSE ]])
AC_DEFUN(mr_ENABLE_NLS, [
  AC_MSG_CHECKING(whether NLS is requested)
  AC_ARG_ENABLE(nls,
    [  --disable-nls           disable native language support],
    [mr_enable_nls="$enableval"],
    [mr_enable_nls=yes])
  AC_MSG_RESULT($mr_enable_nls)
  mr_ACTION([$mr_enable_nls], [$1], [$2])
])

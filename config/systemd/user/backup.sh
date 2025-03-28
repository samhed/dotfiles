#!/bin/bash
set -e
if [ $USER != 'samuel' ]; then
    echo "This script must be run as user 'samuel'"
    exit 1
fi

if [ $HOSTNAME != 'samuel.lkpg.cendio.se' ]; then
    echo "This script must be run on host 'samuel.lkpg.cendio.se'"
    exit 1
fi

if [ ! -d /home/samuel/backup ]; then
    mkdir -p /home/samuel/backup
fi
/usr/bin/rsync \
    --archive \
    --update \
    --delete \
    --exclude=ctc/buildarea \
    --exclude=ctc/*.zip \
    --exclude=ctc/*-bundle \
    --exclude=ctc/*-debug \
    --exclude=ctc-git/buildarea \
    --exclude=ctc-git/*.zip \
    --exclude=ctc-git/*-bundle \
    --exclude=ctc-git/*-debug \
    --exclude=tigervnc/build/output_* \
    --exclude=cenbuild/repo/result \
    --exclude=cenbuild/repo/rpmbuild \
    --exclude=cenbuild/repo/cache \
    --exclude=cenbuild/repo/staging \
    --exclude=svn/cenbuild/repo/result \
    --exclude=svn/cenbuild/repo/rpmbuild \
    --exclude=svn/cenbuild/repo/cache \
    --exclude=svn/cenbuild/repo/staging \
    /local/home/samuel/* /home/samuel/backup/

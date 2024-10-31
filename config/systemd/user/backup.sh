#!/bin/bash
set -e
/usr/bin/rsync --archive --update --delete /local/home/samuel/* /home/samuel/backup/

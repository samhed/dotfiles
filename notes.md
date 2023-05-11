## Other packages:

 * google chrome
 * gnome console
 * gnome extensions
   - vertical overview
   - launch new instance
 * gnome tweaks
 * epiphany
 * microsoft edge
 * cronie
 * slack
 * screenruler

## crontab

```
$ crontab -l
15 3 * * * /home/samuel/bin/gettlserver
20 3 * * * /home/samuel/bin/gettlclient
1 * * * * /usr/bin/rsync -r -u --delete /local/home/samuel/.vim/ /home/samuel/backup/.vim/
2 * * * * /usr/bin/rsync -r -u --delete /local/home/samuel/.config-nvim/ /home/samuel/backup/.config-nvim/
3 * * * * /usr/bin/rsync -r -u --delete /local/home/samuel/* /home/samuel/backup/
```

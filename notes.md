## Other packages:

 * google chrome
 * gnome console
 * gnome extensions
   - vertical overview
   - launch new instance
 * gnome tweaks
 * color picker
 * epiphany
 * microsoft edge
 * cronie
 * slack
 * screenruler

### Gnome settings

 * Keybindings
   - Change Alt+Tab from "Switch applications" to "Switch windows"
   - Start terminal with Ctrl+Alt+T (flatpak run com.raggesilver.BlackBox)
 * Multitasking
   - Workspaces on primary display only
 * Tweaks
   - Fonts, Monospace Text, set "Source Code Pro Regular"
   - Top Bar, Clock, enable "Weekday", "Date", and "Seconds"
   - Top Bar, Calendar, enable "Week Numbers"
   - Windows, Window Focus, "Focus on hover"
   - Window Titlebars, Titlebar Buttons, disable "Maximize"

## crontab

```
$ crontab -l
15 3 * * * /home/samuel/bin/gettlserver
20 3 * * * /home/samuel/bin/gettlclient
1 * * * * /usr/bin/rsync -r -u --delete /local/home/samuel/.vim/ /home/samuel/backup/.vim/
2 * * * * /usr/bin/rsync -r -u --delete /local/home/samuel/.config-nvim/ /home/samuel/backup/.config-nvim/
3 * * * * /usr/bin/rsync -r -u --delete /local/home/samuel/* /home/samuel/backup/
```

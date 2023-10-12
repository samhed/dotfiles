## Other packages:

 * google chrome
 * epiphany
 * microsoft edge
 * gnome extensions
   - vertical overview
   - launch new instance
 * gnome tweaks
 * Black Box
 * cronie
 * slack
 * openssh-askpass
 * color picker
 * screenruler

### Better out of memory handling
Replace systemd-oomd with earlyoom
```
sudo systemctl disable systemd-oomd
sudo systemctl stop systemd-oomd

sudo dnf install
sudo systemctl enable earlyoom
sudo systemctl start earlyoom
```

### Gnome settings

 * Keybindings
   - Change Alt+Tab from "Switch applications" to "Switch windows"
   - Start terminal with Ctrl+Alt+T (flatpak run com.raggesilver.BlackBox)
 * Multitasking
   - Workspaces on primary display only
 * Nautilus
   - Performance, Show Thumbnails, set "All locations"
   - Performance, Search in Subfolders, set "All files"
   - Performance, Count Number of Files in Folders, set "All folders"
 * Tweaks
   - Fonts, Monospace Text, set "Source Code Pro Regular"
   - Top Bar, Clock, enable "Weekday", "Date", and "Seconds"
   - Top Bar, Calendar, enable "Week Numbers"
   - Windows, Window Focus, "Focus on hover"
   - Window Titlebars, Titlebar Buttons, disable "Maximize"

### BlackBox

See `BlackBox.gsettings`.

## crontab

```
$ crontab -l
15 3 * * * /home/samuel/bin/gettlserver
20 3 * * * /home/samuel/bin/gettlclient
3 * * * * /usr/bin/rsync --archive --update --delete /local/home/samuel/* /home/samuel/backup/
```

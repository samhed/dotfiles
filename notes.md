## Other packages:

 * google chrome
 * epiphany
 * microsoft edge
 * gnome extensions
   - Launch new instance
   - Rounded Window Corners Reborn
 * gnome tweaks
 * Kitty
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
   - Resize window with Super+R
   - Start terminal with Ctrl+Alt+T (kitty)
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

### Black Box terminal emulator

(Replaced by Kitty)

See `BlackBox.gsettings`.

<p align="center">
  <img src="https://raw.githubusercontent.com/PapirusDevelopmentTeam/thunderbird-theme-papirus/master/preview.png" alt="Preview Papirus Dark"/>
</p>

## Description

This repository contained only icons for Thunderbird and used with your current GTK Theme.
Recommend use with Materia [GTK](https://github.com/nana-4/materia-theme)/[KDE](https://github.com/PapirusDevelopmentTeam/materia-kde).

## Installation

**NOTE:** In Thunderbird 78+ is now set by default to ignore `userChrome.css`. Needs to manually set `toolkit.legacyUserProfileCustomizations.stylesheets` to **true** in the config editor (Tools → Options → General → <kbd>Config Editor...</kbd>) and then restart Thunderbird. See [details](http://forums.mozillazine.org/viewtopic.php?p=14873328#p14873328).

#### Install Papirus icons

```
wget -qO- https://raw.githubusercontent.com/PapirusDevelopmentTeam/thunderbird-theme-papirus/master/install.sh | env CUSTOM_COLOR=444444 sh
```

#### Install Papirus-Dark icons

```
wget -qO- https://raw.githubusercontent.com/PapirusDevelopmentTeam/thunderbird-theme-papirus/master/install.sh | sh
```

#### Install ePapirus icons

```
wget -qO- https://raw.githubusercontent.com/PapirusDevelopmentTeam/thunderbird-theme-papirus/master/install.sh | env CUSTOM_COLOR=6e6e6e sh
```

#### Uninstall

```
wget -qO- https://raw.githubusercontent.com/PapirusDevelopmentTeam/thunderbird-theme-papirus/master/install.sh | env uninstall=true sh
```

## Recommendations

We recommend use [FireTray](https://github.com/Ximi1970/FireTray) extension for better looking. Open **FireTray-Settings-Mail** set flag on **display custom icon** and write name `thunderbird-attention-panel`.


## License

GNU GPL v3

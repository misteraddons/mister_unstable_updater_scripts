# MiSTer Unstable and Test Core Updater Scripts
These scripts are useful for quickly getting the latest work in progress cores.

## Instructions
Place these scripts within the `Scripts` folder of your micro sd card
- update_unstable_n64.sh: downloads the latest N64 test cores, which aren't yet part of the MiSTer `unstable` repository
- update_unstable.sh: downloads all `unstable` cores into an `_Unstable` folder on your micro SD card
- update_unstable+main.sh: downloads all `unstable` cores into an `_Unstable` folder on your micro SD card, and also downloads and replaces the MiSTer binary with the latest unstable

## Alternative
If you would rather run these within the downloader or update_all scripts, add this to your `downloader.ini` file on your micro SD card:
```
[unstable_nightlies_folder]
db_url = https://raw.githubusercontent.com/MiSTer-unstable-nightlies/Unstable_Folder_MiSTer/main/db_unstable_nightlies_folder.json```

## Credit
Thanks to VampierMSX for the original Playstation Update script that these are based upon

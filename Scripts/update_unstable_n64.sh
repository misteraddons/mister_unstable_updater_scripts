#!/bin/sh

# Run this script at your own risk - this script is intended to test the latest N64 core build by FPGAZumSpass
#
# This Script will update to MiSTer Unstable and the N64 Unstable Core - if you do not understand what this is then do not use this script!
#
# Special thanks to wpo and revoice for suggestions and code snippets


#URLs
url="https://vampier.net/N64/getlast.php"
urlmain="https://api.github.com/repos/MiSTer-unstable-nightlies/Main_MiSTer/releases"
n64softwaredb="https://vampier.net/N64/N64-database.txt"

#Directories
tmp="/tmp"
rootDir="/media/fat"
tmp2="$rootDir/Scripts"
dest="$rootDir/_Unstable"
N64Dir="$rootDir/games/N64"
#CheatDir="$rootDir/cheats/N64"


#check if we're connected to the internet
if ping -q -c 1 -W 1 google.com >/dev/null; then
	clear
	echo "[Ok] Internet Connection Found"
else
	echo "[Warning] MiSTer not connected to the internet - script cannot continue"
	sleep 5 
	exit
fi

echo "[ATTENTION] !!! Run update_all or downloader as well !!!"

function CreateDir() {
	echo "[Action] checking for directory '$1'"
	if [ -d "$1" ]; then
		echo "[Ok] Directory '$1' found, nothing to do here"
	else
		echo "[Action] Creating Directory '$1'" 
		mkdir $1
	fi
}

function CheckFileExist() {
	retval="False"
	if [ -f "$1" ]; then 
		echo "[Ok] The file '$1' already exists"
		retval="True"
	else
		echo "[Info] The File '$1' does not exists"
	fi
}

#create Directories if they don't exist yet
CreateDir "$N64Dir"
#CreateDir "$CheatDir"

#Check if BIOS Exists
CheckFileExist "$N64Dir/boot.rom"; if  [ $retval == "False" ]; then echo "[Warning] BIOS file boot.rom not found - please put a PIF file in $N64Dir and rename it to boot.rom";fi

#Check if N64 SoftwareDB
CheckFileExist "$N64Dir/N64-database.txt"

if [ $retval == "False" ]; then
    echo "[Action] Downloading N64-database.txt"
		if wget -q -P $N64Dir $n64softwaredb; then
                echo "[Ok] N64 Database File Download"
	else
    		echo "[Warning] Unable to download N64-database.txt file"
	fi
fi


# Process JSON
f=`wget -q -O- $url | jq -r '.files[] | .url | select(contains("N64"))'`

# Get basename of the download file
fn=`basename $f`

# Check if newest core version already exists
CheckFileExist "$dest/$fn"

if [ $retval == "True"  ]; then
	echo "[Ok] N64 core '$fn' already the Latest version, nothing to do here"
else
	echo "[Action] Update Found Downloading '$fn' now"
	# Attempt to download the file and organize
	if wget -q -P $tmp $f; then
			echo "[Action] Latest File Downloaded"
			echo "[Action] Removing previous version"
			rm $dest/N64_*
			echo "[Action] Adding New version '$fn' to $dest"
			mv $tmp/$fn $dest
	else
		echo "[Warning] Download Failed - Please Try Again Later"
	fi
fi

echo "[Ok] N64 Core all updated! Have fun"

exit

####################################################################################################
##### !!! REMOVE THE EXIT ABOVE THIS SECTION IF YOU WANT TO UPDATE TO MISTER MAIN UNSTABLE !!! #####
####################################################################################################

#Get latest unstable core link
main=$(wget -q -O- $urlmain | jq -r '[.[0].assets[] | select(.name|startswith("MiSTer_unstable_202"))] | sort_by(.created_at)[-1:][] | .browser_download_url')

#get corename
mainbase=`basename $main`


# Check if newest version already exists

CheckFileExist "$tmp2/$mainbase" 

if [ $retval == "True"  ]; then
                echo "[Ok] Mister Main Unstable Core $mainbase Already the Latest version, nothing to do here"
else
		echo "[Info] New Main Unstable Found - Downloading new version"
        # Attempt to download the file and organize
        rm $tmp2/MiSTer_unstable_202*

        if wget -q -P $tmp2 $main; then
                echo "[Info] Latest Main MiSTer Core ($mainbase) File Downloaded"

                echo "[Action] Remove Old MiSTer Main backup file"
                rm $rootDir/unstable_MiSTer.old

                echo "[Action] Backing Up Current MiSter Core to unstable_MiSTer.old"
                mv $rootDir/MiSTer $rootDir/unstable_MiSTer.old

                echo "[Action] Putting New Mister Unstable Core into Place"
                cp $tmp2/$mainbase $rootDir/MiSTer

		reboot
        else
                   echo "[Warning] Download Failed - Please Try Again Later"
        fi
fi

echo "All done! Have fun"

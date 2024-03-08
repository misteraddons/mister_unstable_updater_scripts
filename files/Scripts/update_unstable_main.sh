#!/bin/sh

# Run this script at your own risk
#
# This Script will update to MiSTer unstable and the unstable cores - if you do not understand what this is then do not use this script!
#
# Special thanks to wpo and revoice for suggestions and code snippets

# URLs
urlmain="https://api.github.com/repos/MiSTer-unstable-nightlies/Main_MiSTer/releases"

# Directories
tmp=$(mktemp -d)
rootDir="/media/fat"
tmp2="$rootDir/Scripts"

# Function Definitions
check_err(){ error_state=$(echo $?)
  if [[ "$error_state" != "0" ]];then
    echo "$1"
    sleep 5
    exit
  fi
}

function test_internet_connection(){
  ping -q -c 1 -4 -W 1 google.com >/dev/null 2>&1
  check_err "[No Internet Connection Found] MiSTer not connected to the internet - script cannot continue"
}

# Start
test_internet_connection

#Get latest unstable core link
main=$(wget -q -O- $urlmain | jq -r '[.[0].assets[] | select(.name|startswith("MiSTer_unstable_202"))] | sort_by(.created_at)[-1:][] | .browser_download_url')

#get corename
mainbase=`basename $main`

# Check if newest version already exists

if [ -f  "$tmp2/$mainbase" ]; then
  echo "[Ok] Mister Main Unstable Core $mainbase Already the Latest version, nothing to do here"
else
  echo "[Info] New Main Unstable Found - Downloading new version"

  # Attempt to download the file and organize
  rm $tmp2/MiSTer_unstable_202*

  if wget -q -P $tmp2 $main; then
    echo "[Info] Latest Main MiSTer Core ($mainbase) File Downloaded"

    echo "[Action] Remove Old MiSTer Main backup file"
    rm $rootDir/unstable_MiSTer.old

    echo "[Action] Backing Up Current MiSter Core to MiSTer.old"
    mv $rootDir/MiSTer $rootDir/unstable_MiSTer.old

    echo "[Action] Putting New Mister Unstable Core into Place"
    cp $tmp2/$mainbase $rootDir/MiSTer

    reboot
   else
     echo "[Warning] Download Failed - Please Try Again Later"
   fi
fi

echo "All done! Have fun"
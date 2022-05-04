#!/bin/bash
#setting up dock with apps.
dock_util=/usr/local/bin/dockutil
fullOSVersion=$(/usr/bin/sw_vers -productVersion)
majorOSVersion=$(/usr/bin/sw_vers -productVersion | awk -F. {'print $2'})
minorOSVersion=$(/usr/bin/sw_vers -productVersion | awk -F. {'print $3'})

if [ "$3" != "" ] && [ "$loggedInUser" == "" ]; then
    loggedInUser=$3
else
    loggedInUser=$(/bin/ls -l /dev/console | /usr/bin/awk '{ print $3 }')
fi
echo "Creating $loggedInUser's dock."


sudo -u $loggedInUser $dock_util --remove all --no-restart '/Users/'"$loggedInUser"
sudo -u $loggedInUser $dock_util --add '/Applications/Cedar Self Service.app' --no-restart '/Users/'"$loggedInUser"
sudo -u $loggedInUser $dock_util --add '/Applications/Google Chrome.app' --no-restart  '/Users/'"$loggedInUser"
sudo -u $loggedInUser $dock_util --add '/Applications/Slack.app' --no-restart  '/Users/'"$loggedInUser"
sudo -u $loggedInUser $dock_util --add '/Applications/zoom.us.app' --no-restart  '/Users/'"$loggedInUser"
sudo -u $loggedInUser $dock_util --add '/Applications/Google Drive.app' --no-restart  '/Users/'"$loggedInUser"
sudo -u $loggedInUser $dock_util --add '/System/Applications/Launchpad.app' --no-restart  '/Users/'"$loggedInUser"
sudo -u $loggedInUser $dock_util --add '/Users/'"$loggedInUser"'/Downloads' '/Users/'"$loggedInUser"
sudo -u $loggedInUser $dock_util --add '/Users/'"$loggedInUser"'/Documents' '/Users/'"$loggedInUser"

sudo -u $loggedInUser defaults write com.apple.dock show-recents -bool FALSE


killall -KILL Dock

exit 0
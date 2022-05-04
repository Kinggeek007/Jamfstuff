#!/bin/bash

killSlack="$4"

currentSlackVersion=$(/usr/bin/curl -sL 'https://slack.com/release-notes/mac/rss' | grep -o "Slack-[0-9]\.[0-9]\.[0-9]"  | cut -c 7-11 | head -n 1)

install_slack() {

slackDownloadUrl=$(curl "https://slack.com/ssb/download-osx" -s -L -I -o /dev/null -w '%{url_effective}')
dmgName=$(printf "%s" "${slackDownloadUrl[@]}" | sed 's@.*/@@')
slackDmgPath="/tmp/$dmgName"


if [ "$killSlack" = "kill" ];
then
pkill Slack*
fi

curl -L -o "$slackDmgPath" "$slackDownloadUrl"

hdiutil attach -nobrowse $slackDmgPath

if pgrep '[S]lack' && [ "$killSlack" != "kill" ]; then
    printf "Error: Slack is currently running!\n"

elif pgrep '[S]lack' && [ "$killSlack" = "kill" ]; then
    pkill Slack*
    sleep 10
    if pgrep '[S]lack' && [ "$killSlack" != "kill" ]; then
        printf "Error: Slack is still running!  Please try again later.\n"
        exit 409
    fi
fi

    rm -rf /Applications/Slack.app

    ditto -rsrc /Volumes/Slack*/Slack.app /Applications/Slack.app

    mountName=$(diskutil list | grep Slack | awk '{ print $3 }')
    umount -f /Volumes/Slack*/
    diskutil eject $mountName

    rm -rf "$slackDmgPath"
}

assimilate_ownership() {
    echo "=> Assimilate ownership on '/Applications/Slack.app'"
    chown -R $(scutil <<< "show State:/Users/ConsoleUser" | awk -F': ' '/[[:space:]]+Name[[:space:]]:/ { if ( $2 != "loginwindow" ) { print $2 }}'):staff "/Applications/Slack.app"
}

if [ ! -d "/Applications/Slack.app" ]; then
    echo "=> Slack.app is not installed"
    install_slack
    assimilate_ownership

elif [ "$currentSlackVersion" != `defaults read "/Applications/Slack.app/Contents/Info.plist" "CFBundleShortVersionString"` ]; then
    install_slack
    assimilate_ownership

elif [ -d "/Applications/Slack.app" ]; then
        localSlackVersion=$(defaults read "/Applications/Slack.app/Contents/Info.plist" "CFBundleShortVersionString")
        if [ "$currentSlackVersion" = "$localSlackVersion" ]; then
            printf "Slack is already up-to-date. Version: %s" "$localSlackVersion"      
assimilate_ownership            
            exit 0
    fi
fi
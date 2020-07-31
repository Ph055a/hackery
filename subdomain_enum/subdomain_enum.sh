#!/bin/bash

echo "[*] Enter domain to start brute forcing"
echo "[*] Example: hackerone.com"
echo
read TARGET

DIRTY_SUBDOMAINS="$HOME/BugBounty/$TARGET/dirty_subdomains.txt"
SUBDOMAINS="$HOME/BugBounty/$TARGET/complete_subdomains.txt"
LIVE_TARGETS="$HOME/BugBounty/$TARGET/live_targets.txt"
URLS="$HOME/BugBounty/$TARGET/urls.txt"
INCOMPLETE_WORDLIST="$HOME/BugBounty/$TARGET/wordlist.txt"
COMPLETE_WORDLIST="$HOME/BugBounty/$TARGET/complete_wordlist.txt"
SCRAPED_WORDLIST="$HOME/BugBounty/$TARGET/scraped_wordlist.txt"
KEYS_WORDLIST="$HOME/BugBounty/$TARGET/keys_wordlist.txt"
PATHS_WORDLIST="$HOME/BugBounty/$TARGET/paths_wordlist.txt"

if [ -f $HOME/BugBounty/$TARGET  ]; then
    echo "$TARGET directory already exists" 
else
    echo "Creating $TARGET directory"
    mkdir -p $HOME/BugBounty/$TARGET
fi

assetfinder(){
    echo "[*] Running assetfinder on $TARGET"
    assetfinder --subs-only $TARGET >> $DIRTY_SUBDOMAINS
}

subfinder(){
    echo "[*] Running Subfinder on $TARGET"
    subfinder -d $TARGET >> $DIRTY_SUBDOMAINS
}

amass(){
    echo "[*] Running Amass on $TARGET"
    amass enum -brute -d $TARGET >> $DIRTY_SUBDOMAINS
}

subdomains(){
    subdomains $TARGET >> $DIRTY_SUBDOMAINS
}

gau(){
    echo "[*] Running Gua on $TARGET"
    gau -subs $TARGET >> $URLS
}

clean_domains(){
    echo "[*] Removing email addresses from domains"
    egrep -v "@" $DIRTY_SUBDOMAINS > $SUBDOMAINS
}

live_targets(){
    cat $DIRTY_SUBDOMAINS | httprobe | unfurl --unique domains >> $LIVE_TARGETS
}

custom_wordlist(){
    gocewl $TARGET -d 3 -w $INCOMPLETE_WORDLIST
    cat $INCOMPLETE_WORDLIST | tr '[:upper:]' '[:lower:]' | sort -u > $COMPLETE_WORDLIST
    cat $URLS | unfurl keys | sed 's#/#\n#g' | sort -u > $KEYS_WORDLIST
    cat $URLS | unfurl paths | sed 's#/#\n#g' | sort -u > $PATHS_WORDLIST
}

clean_up(){
    echo "[*] Cleaning up temp files"
    sudo rm -rf $INCOMPLETE_WORDLIST $DIRTY_SUBDOMAINS
}

assetfinder
subfinder
amass
subdomains
gau
clean_domains
live_targets
custom_wordlist
clean_up
echo "[*] Enumeration Completed!!!"
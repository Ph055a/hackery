#!/bin/bash

echo "[*] Enter domain to start brute forcing"
echo "[*] Example: hackerone.com"
echo
read TARGET

DIRTY_SUBDOMAINS="$HOME/BugBounty/$TARGET/dirty_DIRTY_Ds.txt"
SUBDOMAINS="$HOME/BugBounty/$TARGET/DIRTY_Ds.txt"
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

gospider(){
    echo "[*] Running GoSpider on $TARGET"
    gospider -s https://$TARGET -w -a -k 10 -t 10 -r --sitemap --robots --other-source -u web >> $URLS
    gospider -s $TARGET --other-source --include-subs -u web >> $URLS
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
    cat $URLS | unfurl keys | sed 's#/#\n#g' | sort -u >> $KEYS_WORDLIST
    cat $URLS | unfurl paths | sed 's#/#\n#g' | sort -u >> $PATHS_WORDLIST
}

clean_up(){
    echo "[*] Almost done, just some cleaning up to do. I need to be sudo"
    sudo rm -rf $INCOMPLETE_WORDLIST
}

assetfinder
subfinder
amass
subdomains
gospider
gau
clean_domains
live_targets
custom_wordlist
clean_up
echo "[*] Enumeration Completed, Happy Hacking"
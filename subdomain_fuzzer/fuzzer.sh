#!/bin/bash

echo "[*] Enter domain to start subdomain brute forcing"
echo "[*] Example: hackerone.com"
read TARGET

SCRAPED_WORDLIST="$HOME/BugBounty/$TARGET/scraped_wordlist.txt"
KEYS_WORDLIST="$HOME/BugBounty/$TARGET/keys_wordlist.txt"
PATHS_WORDLIST="$HOME/BugBounty/$TARGET/paths_wordlist.txt"
PATHS="$HOME/BugBounty/$TARGET/paths.txt"
FORBIDDEN_URLS="$HOME/BugBounty/$TARGET/forbidden_urls.txt"
UP_URLS="$HOME/BugBounty/$TARGET/up_urls.txt"


file_check(){
    if [ -f $HOME/BugBounty/$TARGET  ]; then
        echo "$TARGET directory already exists" 
    else
        echo "Creating $TARGET directory"
        mkdir -p $HOME/BugBounty/$TARGET
    fi

    if [ ! -f $LIVE_TARGETS ]; then
        echo "You need to run the enumerate.sh script first"
        # exit code
    fi
    
}

pause(){
    echo "Sleep for a 15 minutes"
    sleep 15m
}

custom_wordlist(){
    gobuster dns -d $TARGET -w $SCRAPED_WORDLIST -o $HOME/BugBounty/$TARGET/subdomains.txt
}

dns_commonspeak(){
    echo "Brute forcing domains"
    gobuster dns -d $TARGET -w ~/Lists/commonspeak2-wordlists/subdomains/subdomains.txt -o $HOME/BugBounty/$TARGET/subdomains.txt
    echo "Completed Commonspeak"
}

dns_seclist(){
    gobuster dns -d $TARGET -w ~/Lists/SecLists/Discovery/Web-Content/directory-list-lowercase-2.3-big.txt -o $HOME/BugBounty/$TARGET/subdomains.txt
    echo "Completed directory-list-lowercase-2.3-big.txt"
    
    gobuster dns -d $TARGET -w ~/Lists/SecLists/Discovery/Web-Content/raft-large-directories.txt -o $HOME/BugBounty/$TARGET/subdomains.txt
    echo "Completed raft-large-directories.txt"

    gobuster dns -d $TARGET -w ~/Lists/SecLists/Discovery/Web-Content/common.txt -o $HOME/BugBounty/$TARGET/subdomains.txt
    echo "Complted common.txt"

    gobuster dns -d $TARGET -w ~/Lists/SecLists/Discovery/DNS/subdomains-top1million-110000.txt -o $HOME/BugBounty/$TARGET/subdomains.txt
    echo "Completed subdomains-top1million-110000.txt"

    gobuster dns -d $TARGET -w ~/Lists/SecLists/Discovery/DNS/namelist.txt -o $HOME/BugBounty/$TARGET/subdomains.txt
    echo "Completed namelist.txt"

    gobuster dns -d $TARGET -w ~/Lists/SecLists/Discovery/Miscellaneous/us-cities.txt -o $HOME/BugBounty/$TARGET/subdomains.txt
    echo "Completed us-cities.txt"

    gobuster dns -d $TARGET -w ~/Lists/SecLists/Discovery/Miscellaneous/ike-groupid.txt -o $HOME/BugBounty/$TARGET/subdomains.txt
    echo "Completed ike-groupid.txt"
}

dns_fuzzdb(){
    gobuster dns -d $TARGET -w ~/Lists/fuzzdb/discovery/dns/gTLD.txt -o $HOME/BugBounty/$TARGET/subdomains.txt
    echo "Completed gTLD.txt"

    gobuster dns -d $TARGET -w ~/Lists/fuzzdb/discovery/dns/dnsmapCommonSubdomains.txt -o $HOME/BugBounty/$TARGET/subdomains.txt
    echo "Completed dnsmapCommonSubdomains.txt"

    gobuster dns -d $TARGET -w ~/Lists/fuzzdb/discovery/dns/alexaTop1mAXFRcommonSubdomains.txt -o $HOME/BugBounty/$TARGET/subdomains.txt
    echo "Completed alexaTop1mAXFRcommonSubdomains.txt" 

    gobuster dns -d $TARGET -w ~/Lists/fuzzdb/discovery/Miscellaneous/common-methods.txt -o $HOME/BugBounty/$TARGET/subdomains.txt
    echo "Completed common-methods.txt"

    gobuster dns -d $TARGET -w ~/List/fuzzdb/wordlist-misc/wordlist-alphanumeric-case.txt -o $HOME/BugBounty/$TARGET/subdomains.txt
    echo "Completed wordlist-alphanumeric-case.txt"

    gobuster dns -d $TARGET -w ~/List/fuzzdb/wordlist-user-passwd/names/namelist.txt -o $HOME/BugBounty/$TARGET/subdomains.txt
    echo "Completed namelist.txt"

    gobuster dns -d $TARGET -w ~/List/fuzzdb/wordlist-user-passwd/unix-os/unix_users.txt -o $HOME/BugBounty/$TARGET/subdomains.txt
    echo "Completed unix_users.txt"
}

ffuf(){
    ffuf -w $PATHS_WORDLIST -u $TARGET/FUZZ >> $PATHS
    ffuf -w $KEYS_WORDLIST -u $TARGET/FUZZ >> $PATHS
}

burl(){
    cat $PATHS | burl | grep FORBIDDEN >> $FORBIDDEN_URLS
    cat $PATHS | burl | grep grep -v "Not\|Forbidden" >> $UP_URLS
}


live_targets(){
    cat $DIRTY_SUBDOMAINS | httprobe | unfurl --unique domains >> $LIVE_TARGETS
}

file_check
custom_wordlist
dns_commonspeak
pause
dns_seclist
pause
dns_fuzzdb
ffuf
live_targets
echo "Completed Brute Force"
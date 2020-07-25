#!/bin/bash

echo "[*] Enter domain to start subdomain brute forcing"
echo "[*] Example: hackerone.com"
read TARGET

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

dns_commonspeak(){
    echo "Brute forcing domains"
    gobuster dns -d $TARGET -w ~/Lists/commonspeak2-wordlists/subdomains/subdomains.txt -o $HOME/BugBounty/$TARGET/common_speak_results.txt
    echo "Completed Commonspeak"
}

dns_seclist(){
    gobuster dns -d $TARGET -w ~/Lists/SecLists/Discovery/Web-Content/directory-list-lowercase-2.3-big.txt -o $HOME/BugBounty/$TARGET/dir_lower_results.txt
    echo "Completed directory-list-lowercase-2.3-big.txt"
    
    gobuster dns -d $TARGET -w ~/Lists/SecLists/Discovery/Web-Content/raft-large-directories.txt -o $HOME/BugBounty/$TARGET/raft_large_results.txt
    echo "Completed raft-large-directories.txt"

    gobuster dns -d $TARGET -w ~/Lists/SecLists/Discovery/Web-Content/common.txt -o $HOME/BugBounty/$TARGET/web_content_results.txt
    echo "Complted common.txt"

    gobuster dns -d $TARGET -w ~/Lists/SecLists/Discovery/DNS/subdomains-top1million-110000.txt -o $HOME/BugBounty/$TARGET/top_million_results.txt
    echo "Completed subdomains-top1million-110000.txt"

    gobuster dns -d $TARGET -w ~/Lists/SecLists/Discovery/DNS/namelist.txt -o $HOME/BugBounty/$TARGET/namelist_results.txt
    echo "Completed namelist.txt"

    gobuster dns -d $TARGET -w ~/Lists/SecLists/Discovery/Miscellaneous/us-cities.txt -o $HOME/BugBounty/$TARGET/cities_results.txt
    echo "Completed us-cities.txt"

    gobuster dns -d $TARGET -w ~/Lists/SecLists/Discovery/Miscellaneous/ike-groupid.txt -o $HOME/BugBounty/$TARGET/ike_results.txt
    echo "Completed ike-groupid.txt"
}

dns_fuzzdb(){
    gobuster dns -d $TARGET -w ~/Lists/fuzzdb/discovery/dns/gTLD.txt -o $HOME/BugBounty/$TARGET/gtld_results.txt
    echo "Completed gTLD.txt"

    gobuster dns -d $TARGET -w ~/Lists/fuzzdb/discovery/dns/dnsmapCommonSubdomains.txt -o $HOME/BugBounty/$TARGET/dnsmap_results.txt
    echo "Completed dnsmapCommonSubdomains.txt"

    gobuster dns -d $TARGET -w ~/Lists/fuzzdb/discovery/dns/alexaTop1mAXFRcommonSubdomains.txt -o $HOME/BugBounty/$TARGET/alexa_top_results.txt
    echo "Completed alexaTop1mAXFRcommonSubdomains.txt" 

    gobuster dns -d $TARGET -w ~/Lists/fuzzdb/discovery/Miscellaneous/common-methods.txt -o $HOME/BugBounty/$TARGET/common_methods_results.txt
    echo "Completed common-methods.txt"

    gobuster dns -d $TARGET -w ~/List/fuzzdb/wordlist-misc/wordlist-alphanumeric-case.txt -o $HOME/BugBounty/$TARGET/alphanumeric_reults.txt
    echo "Completed wordlist-alphanumeric-case.txt"

    gobuster dns -d $TARGET -w ~/List/fuzzdb/wordlist-user-passwd/names/namelist.txt -o $HOME/BugBounty/$TARGET/namelist_results2.txt
    echo "Completed namelist.txt"

    gobuster dns -d $TARGET -w ~/List/fuzzdb/wordlist-user-passwd/unix-os/unix_users.txt -o $HOME/BugBounty/$TARGET/unix_users_results.txt
    echo "Completed unix_users.txt"
}

file_check
dns_commonspeak
dns_seclist
dns_fuzzdb
echo "Completed Brute Force"
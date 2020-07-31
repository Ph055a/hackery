echo "[*] Enter domain to start brute forcing"
echo "[*] Example: hackerone.com"
echo
read TARGET

SCRAPED_WORDLIST="$HOME/BugBounty/$TARGET/scraped_wordlist.txt"
KEYS_WORDLIST="$HOME/BugBounty/$TARGET/keys_wordlist.txt"
PATHS_WORDLIST="$HOME/BugBounty/$TARGET/paths_wordlist.txt"
PATHS="$HOME/BugBounty/$TARGET/paths.txt"
FORBIDDEN_URLS="$HOME/BugBounty/$TARGET/forbidden_urls.txt"
UP_URLS="$HOME/BugBounty/$TARGET/up_urls.txt"



spider(){
    echo "[*] Spidering $TARGET"
    gospider -s $TARGET -d 1 | grep -e "code-200" | awk '{print $5}' >> spider_results.txt
}

fuzz(){
    echo "[*] Fuzzing $TARGET"
    cat spider_results.txt | qsreplace -a  | httprobe >> possible.txt
}


ffuf(){
    ffuf -w $PATHS_WORDLIST -u $TARGET/FUZZ >> $PATHS
    ffuf -w $KEYS_WORDLIST -u $TARGET/FUZZ >> $PATHS
}

burl(){
    cat $PATHS | burl | grep FORBIDDEN >> $FORBIDDEN_URLS
    cat $PATHS | burl | grep grep -v "Not\|Forbidden" >> $UP_URLS
}





gospider
fuzz

# gau $TARGET | unfurl paths | qsreplace -a $REDIRECT
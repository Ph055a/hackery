#!/bin/bash

echo "[*] Enter domain to start brute forcing"
echo "[*] Example: hackerone.com"
echo
read -r TARGET

# Directories and Files
DIR="$HOME/BugBounty/$TARGET"
DIRTY_SUBDOMAINS="$DIR/dirty_subdomains.txt"
SUBDOMAINS="$DIR/complete_subdomains.txt"
LIVE_TARGETS="$DIR/live_targets.txt"
URLS="$DIR/urls.txt"
INCOMPLETE_WORDLIST="$DIR/wordlist.txt"
COMPLETE_WORDLIST="$DIR/complete_wordlist.txt"
SCRAPED_WORDLIST="$DIR/scraped_wordlist.txt"
KEYS_WORDLIST="$DIR/keys_wordlist.txt"
PATHS_WORDLIST="$DIR/paths_wordlist.txt"

# Create directory if it doesn't exist
if [ -d "$DIR" ]; then
    echo "$TARGET directory already exists"
else
    echo "Creating $TARGET directory"
    mkdir -p "$DIR"
fi

# Enumeration functions
assetfinder() {
    echo "[*] Running assetfinder on $TARGET"
    assetfinder --subs-only "$TARGET" >> "$DIRTY_SUBDOMAINS"
}

subfinder() {
    echo "[*] Running Subfinder on $TARGET"
    subfinder -d "$TARGET" >> "$DIRTY_SUBDOMAINS"
}

amass() {
    echo "[*] Running Amass on $TARGET"
    amass enum -brute -d "$TARGET" >> "$DIRTY_SUBDOMAINS"
}

subdomains() {
    subdomains "$TARGET" >> "$DIRTY_SUBDOMAINS"
}

gau() {
    echo "[*] Running Gua on $TARGET"
    gau -subs "$TARGET" >> "$URLS"
}

clean_domains() {
    echo "[*] Removing email addresses from domains"
    egrep -v "@" "$DIRTY_SUBDOMAINS" > "$SUBDOMAINS"
}

live_targets() {
    cat "$DIRTY_SUBDOMAINS" | httprobe | unfurl --unique domains >> "$LIVE_TARGETS"
}

custom_wordlist() {
    gocewl "$TARGET" -d 3 -w "$INCOMPLETE_WORDLIST"
    cat "$INCOMPLETE_WORDLIST" | tr '[:upper:]' '[:lower:]' | sort -u > "$COMPLETE_WORDLIST"
    cat "$URLS" | unfurl keys | sed 's#/#\n#g' | sort -u > "$KEYS_WORDLIST"
    cat "$URLS" | unfurl paths | sed 's#/#\n#g' | sort -u > "$PATHS_WORDLIST"
}

clean_up() {
    echo "[*] Cleaning up temp files"
    sudo rm -rf "$INCOMPLETE_WORDLIST" "$DIRTY_SUBDOMAINS"
}

# Call the enumeration functions
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

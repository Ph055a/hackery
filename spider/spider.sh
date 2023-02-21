TARGET="https://www.defense.gov/"


spider(){
    gospider -s $TARGET -w -a -k 3 -t 5 -r --sitemap --robots --other-source -u web -d 1 -q >> spider.txt
    cat spider.txt | grep -e "code-200" | awk '{print $5}' | unfurl -u paths >> navy_wordlist.txt
}

spider
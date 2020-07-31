# gospider -s "$TARGET" -c 10 -d 10 | grep -e "code-200" | awk '{print $5}' | unfurl paths

TARGET="https://www.tesla.com"

# gospider(){
#    echo "[*] Running GoSpider on $TARGET"
#    gospider -s https://$TARGET -w -a -k 10 -t 10 -r --sitemap --robots --other-source -u mobi >> $URLS
#    gospider -s $TARGET --other-source --include-subs -u web >> $URLS
#}


spider(){
    gospider -s $TARGET -w -a -k 3 -t 10 -r --sitemap --robots --other-source -u web -d 30 >> spider.txt
    cat spider.txt | grep -e "code-200" | awk '{print $5}' | qsreplace -a 'testing'
}

spider
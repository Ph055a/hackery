# TCP Connect Scan

print "enter target: "
target = gets
if target === ""
    puts "no target specified"
    exit
else 
    puts "Launching TCP Connect Scan on #{target}"
    system("nmap -sT #{target}")
end
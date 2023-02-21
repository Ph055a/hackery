# Ping Sweep

print "Enter Target or Range: "
print "Example: 192.168.1.45/24"
target = gets

if target == ""
	puts "You need to enter a target range to continue"
	exit
end

print "------------------------"
print "WARNING: A Ping Scan is VERY NOISY!!!"
print "------------------------"

print "Do you wish to continue?"
print "Y/N"
continue = gets

if continue == ""
	puts "You need to enter Y or N"
	exit
elsif continue == "y" || "Y"
	puts "Understood, launching scan"
	system("nmap -sn #{target}")
else
	puts "Understood, exiting"
	exit
end

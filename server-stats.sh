#!/bin/bash

echo "===== SYSTEM STATUS ====="
echo ""

echo "CPU usage:"
top -bn1 | grep "Cpu(s)" | \
awk '{print "  " $2 + $4 "% used."}'

echo ""

echo "Memory usage:"
free -h --si | grep "Mem" | \
awk '{print "  " $3 " used, " $4 " available. A total of " ($3 * 100) / $2 "% of memory used." }'

echo ""

echo "Disk usage:"
df -h --si / | tail -n 1 | awk '{print "  " $3 " used and " $4 " available, a total of " $5 " of disk usage."}'

echo ""

echo "5 processes with the most CPU usage:"
echo ""
ps aux --sort=-%cpu | head -n 6 | tail -n 5 | awk '{print " " $11}'

echo ""

echo "5 processes with the most memory usage:"
echo ""
ps aux --sort=-%mem | head -n 6 | tail -n 5 | awk '{print " " $11}'

echo ""

echo "Logged-in users:"
echo " $(who | awk '{print $1}' )"

echo ""

echo "OS version infos:"
cat /etc/os-release | head -n 6 | cut -d "=" -f 2 | awk '{print " " $1}' | tr -d '"'

echo ""

echo "Failed login attempts:"
if [ -f "/var/log/auth.log" ]; then
	cat /var/log/auth.log | grep failure | awk '{print " " $1 " " $2 " " $3 " " $5 " " $15 }' | tr -d ']'
elif [-f "/var/log/secure"]; then
	cat /var/log/auth.log | grep failure | awk '{print " " $1 " " $2 " " $3 " " $4 " " $6 " " $14}'
else
	echo "Authentication log not found !"
fi

echo ""
echo "System uptime: $(uptime -p | awk '{print $2 " " $3 " " $4 " " $5}')"


#!/bin/bash
#This is my script

pc=$(uname -a)
cpu=$(lscpu | grep -w 'CPU(s):' | tr -s ' ' | cut -d ' ' -f 2)
vcpu=$(nproc)
ram=$(free -m | awk 'NR==2{printf"%s/%sMB (%.2f%%)\n", $3,$2,$3*100/$2 }')
hdd=$(df -h | awk '$NF=="/"{printf"%d%dGB (%s)\n", $3, $2, $5}')
idle=$(mpstat | grep -w 'all' | awk '{print $12}')
cpuavg=$(mpstat | awk '$12 ~ /[0-9.]+/ {print 100 - $12"%" }')
last=$(who -b | tr -s ' ')
lvm=$(lsblk | grep 'lvm')
tcp=$(netstat -anp | grep ESTABLISHED | wc -l)
users=$(who | cut -d " " -f 1 | wc -l)
ip=$(ip addr show | grep 'inet' | awk '{print $2}' | grep '10')
mac=$(ip addr show | grep 'link/ether' | awk '{print $2}')
sudoers=$(cat /var/log/aantiloc/sudo | grep -c "COMMAND")

if [ -n "$lvm" ]
then text1="yes"
else text1="no"
fi

wall -n "
#Architecture: $pc
#CPU physical: $cpu
#vCPU: $vcpu
#RAM usage: $ram
#HDD usage: $hdd
#CPU  load: $cpuavg
#$last
#LVM: $text1
#TCP ESTABLISHED $tcp
#User log: $users
#Network: IP $ip ($mac)
#Sudo : $sudoers cmd
"

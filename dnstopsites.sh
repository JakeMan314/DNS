#!/usr/bin/env bash
# DNS Top Sites
# Using current DNS Settings, the bash script will take the top 1 million sites and display the time it takes for the dns server to respond back.

#Check for requirements
command -v bc > /dev/null || { echo "bc was not found. Please install bc."; exit 1; }
{ command -v drill > /dev/null && dig=drill; } || { command -v dig > /dev/null && dig=dig; } || { echo "dig was not found. Please install dnsutils."; exit 1; }

#Starting Arguments
#WORK ON ME
if [[ "$1" == "-a" ]]
then
      printf "Attempts: $2 (Argument Set)"
      count=$2
else
      printf "Attempts: 1 (Default)"
      count=1
fi

# Define Colours
blue=$(tput setaf 4)
red=$(tput setaf 1)
bold=$(tput bold)
normal=$(tput sgr0)

# Grabbing local DNS and Search
NAMESERVERS=`cat /etc/resolv.conf | grep ^nameserver | cut -d " " -f 2 | sed 's/\(.*\)/&#&/'`

# Domains to test. Duplicates are fine
DOMAINS2TEST=$(<./topsites.txt)

clear

printf "${bold}DNS Speed Testing Top 500 Sites${normal}\n"
printf "DNS: ${NAMESERVERS%%#*}\n"
printf "DNS Name: ${NAMESERVERS##*#}\n\n"

# Setting it to zero for the counter
totaldomains=0

totaldomains=0

for d in $DOMAINS2TEST; do
    # Simple counter
    totaldomains=$((totaldomains + 1))

done

# Just parsing it and removing post pound symbol
# Also setting some variables to start the script
for i in $(seq $count); do
    pip=${NAMESERVERS%%#*}
    pname=${NAMESERVERS##*#}
    ftime=0
    # Print Result Each time
    # printf "%-18s" "$pname"
    for d in $DOMAINS2TEST; do
        ttime=`$dig +tries=1 +time=2 +stats @$pip $d |grep "Query time:" | cut -d : -f 2- | cut -d " " -f 2`
        if [ -z "$ttime" ]; then
	        #let's have time out be 1s = 1000ms
          #Jake changes this to push timout limit
	        ttime=1000
          # This is just so that if it cant resolve it fails, except dig isnt allowing it to fails
          # This is a dig problem. it hangs if it cant reach. the timeout written is outside dig
        elif [ "x$ttime" = "x0" ]; then
	        ttime=1
	    fi
        # Print individual
        deadtime=1000
        if [[ "$ttime" == "$deadtime" ]]
        then
        printf "%-8s" "${red}ERR${normal}"
        printf "%-5s"
        #printf "%-8s" "ERR"
        else
          printf "%-8s" "$ttime ms"
        fi

        #Add each time
        ftime=$((ftime + ttime))
        # ftime=$((ftime + ttime))
    done
    # Average Calc
    avg=`bc -lq <<< "scale=2; $ftime/$totaldomains"`
    # Average Print
    printf "\n"
    printf "Average Time for DNS Request:  $avg"

done

#Exit Script
exit 0;

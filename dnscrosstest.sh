#!/usr/bin/env bash
# DNS Cross Test
#
clear
# Check for requirements
command -v bc >/dev/null || {
  echo "bc was not found. Please install bc."
  exit 1
}
{ command -v drill >/dev/null && dig=drill; } || { command -v dig >/dev/null && dig=dig; } || {
  echo "dig was not found. Please install dnsutils."
  exit 1
}

# Define Colours
red=$(tput setaf 1)
bold=$(tput bold)
normal=$(tput sgr0)
# File Requirements
nameservers=$(grep </etc/resolv.conf ^nameserver | cut -d " " -f 2 | sed 's/\(.*\)/&#&/') # Grabbing local DNS and Name
providers=$(<./dnsproviders.txt) # Grab top DNS Resolvers
domains=$(head -10 ./topsites.txt) # Domains to test. Duplicates are fine
timeouts=1000
printf "%sDNS Cross-Testing%s\n" "$bold" "$normal"
printf "DNS: %s\n" "${nameservers%%#*}"
printf "DNS Name: %s\n" "${nameservers##*#}"
printf "Timeout: %sms\n\n" "${timeouts}"

totaldomains=0
printf "%-18s" ""
for d in $domains; do
  totaldomains=$((totaldomains + 1))   # Simple counter
  printf "%-8s" "test$totaldomains"   # Whitespace
done
printf "%-8s" "Average"
printf "\n"

# Just parsing it and removing post pound symbol  Also setting some variables to start the script
for p in $nameservers $providers; do
  pip=${p%%#*}
  pname=${p##*#}
  ftime=0
  # Print Result Each time
  printf "%-18s" "$pname"
  for d in $domains; do
    ttime=$($dig +tries=1 +time=2 +stats @"$pip" "$d" | grep "Query time:" | cut -d : -f 2- | cut -d " " -f 2)
    if [ -z "$ttime" ]; then
      #let's have time out be 1s = 1000ms  Jake changes this to push timout limit
      ttime=${timeouts}
      # This is just so that if it cant resolve it fails, except dig isnt allowing it to fails.  This is a dig problem. it hangs if it cant reach. the timeout written is outside dig
    elif [ "$ttime" = "x0" ]; then
      ttime=1
    fi
    # Print individual
    if [[ "$ttime" == "$timeouts" ]]; then
      printf "%-8s" "${red}ERR${normal}"
      printf "%-5s"
    else
      printf "%-8s" "$ttime ms"
    fi
    #Add each time
    ftime=$((ftime + ttime))
    # ftime=$((ftime + ttime))
  done
  # Average Calc
  avg=$(bc -lq <<<"scale=2; $ftime/$totaldomains")
  # Average Print
  echo "  $avg"
done
#Exit Script
exit 0

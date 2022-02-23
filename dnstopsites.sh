#!/usr/bin/env bash
# DNS Top Sites
# Using current DNS Settings, the bash script will take the top 1 million sites and display the time it takes for the dns server to respond back.
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

NAMESERVERS=$(grep </etc/resolv.conf ^nameserver | cut -d " " -f 2 | sed 's/\(.*\)/&#&/') # Grabbing local DNS and Name
pip=${NAMESERVERS%%#*} # Parsing to just the ip)
domains=$(<./resources/topsites.txt)
domainnum=$(echo "$domains" | wc -l) # Number of domains by counting lines
timeouts=1000
printf "%sDNS Speed Testing Top 500 Sites%s\n" "$bold" "$normal"
printf "DNS: %s\n" "${NAMESERVERS%%#*}"
printf "DNS Name: %s\n" "${NAMESERVERS##*#}"
printf "Timeout: %sms\n\n" "${timeouts}"

# Testing
ftime=0
for d in $domains; do
  ttime=$($dig +tries=1 +time=2 +stats @"$pip" "$d" | grep "Query time:" | cut -d : -f 2- | cut -d " " -f 2)
  # Catch Any Failures
  if [ -z "$ttime" ]; then
    # If dig fails sets time to
    ttime=${timeouts}
    # different kind of failure. This is if it theoretically takes no time.
  elif [ "$ttime" = "x0" ]; then
    ttime=1 #ms
  fi
  if [[ "$ttime" == "$timeouts" ]]; then
    printf "%-8s" "${red}ERR${normal}" # Error printing if 1000ms
    printf "%-5s"
  else
    printf "%-8s" "$ttime ms"
  fi
  ftime=$((ftime + ttime))   #Add each time
done

avg=$(bc -lq <<<"scale=2; $ftime/$domainnum") # Average Calc
printf "\n\n\n%s" "$domainnum" # Average Print
printf " domains averaging %sms\n\n" "$avg"

exit 0 #Exit Script

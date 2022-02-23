#!/usr/bin/env bash
# DNS Brute Test
# The top 10 sites will be sent to resolve with the current DNS, and will repeat a certain amount of attempts.
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

# Argument
if [[ "$1" == "-a" ]]; then
  count=$2
  message="Attempts: $2 (Argument Set)"
else
  count=10
  message="Attempts: 10 (Default)"
fi

# Define Colours
red=$(tput setaf 1)
bold=$(tput bold)
normal=$(tput sgr0)

nameservers=$(grep </etc/resolv.conf ^nameserver | cut -d " " -f 2 | sed 's/\(.*\)/&#&/') # Grabbing local DNS and Name
pip=${nameservers%%#*}
pname=${nameservers##*#} # Parsing to just the ip)
domains=$(head -10 ./resources/topsites.txt)
timeouts=1000
printf "%sDNS Brute Testings%s\n" "$bold" "$normal"
printf "DNS: %s\n" "${nameservers%%#*}"
printf "DNS Name: %s\n" "${nameservers##*#}"
printf "%s\n" "$message"

totaldomains=0
printf "%-18s" ""
for d in $domains; do
  totaldomains=$((totaldomains + 1))   # Simple counter
  printf "%-8s" "test$totaldomains"   # Whitespace and Test#
done
printf "%-8s\n" # Last Whitespace and Avg

for i in $(seq $count); do
  ftime=0
  printf "%-18s" "$pname" # Print Result Each time
  for d in $domains; do
    ttime=$($dig +tries=1 +time=2 +stats @"$pip" "$d" | grep "Query time:" | cut -d : -f 2- | cut -d " " -f 2)
    if [ -z "$ttime" ]; then
      #let's have time out be 1s = 1000ms  Jake changes this to push timout limit
      ttime=${timeouts}
      # This is just so that if it cant resolve it fails, except dig isnt allowing it to fails  This is a dig problem. it hangs if it cant reach. the timeout written is outside dig
    elif [ "$ttime" = "x0" ]; then
      ttime=1
    fi
    # Print individual
    if [[ "$ttime" == "$timeouts" ]]; then
      printf "%-8s" "${red}ERR${normal}" # Error printing if 1000ms
      printf "%-5s"
    else
      printf "%-8s" "$ttime ms"
    fi
    ftime=$((ftime + ttime))     #Add each time
  done
  printf "\n"
done
exit 0 #Exit Script

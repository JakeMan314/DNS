# DNS-Testing

## About
A few short scripts written in Bash to test/benchmark local DNS settings and compare them among other DNS Servers.

## Requirements
- dig
   - preinstalled on most machines and bash terminals
   - run `apt install dnsutils` to install `dig` along with `nslookup` and `nsupdate`

### Compatibility
These scripts were built on a Mac, and run best on it. Regardless, it should work on any bash terminal.


## Files
### dnstopsites.sh
Using current DNS Settings, the bash script will take the top 1 million sites and display the time it takes for the dns server to respond back.
- Arguments
  - `timeout` measured in milliseconds is when the output results in a timeout error and will display `ERR` instead of hanging due to problems with the DNS.
  - default is 1000ms (1s)
### dnscrosstest.sh
This script take the top 10 sites, and compare your DNS against the top 10 free and open DNS Servers.
- Arguments
  - `timeout` measured in milliseconds is when the output results in a timeout error and will display `ERR` instead of hanging due to problems with the DNS.
  - default is 1000ms (1s)
  - `sitecount` is the number of sites used in this script taken from sitelist.txt
  - default is 10
### dnsbrutetest.sh
The top 10 sites will be sent to resolve with the current DNS, and will repeat a certain amount of attempts.
  - Arguments
  - `timeout` measured in milliseconds is when the output results in a timeout error and will display `ERR` instead of hanging due to problems with the DNS.
  - default is 1000ms (1s)
  - `sitecount` is the number of sites used in this script taken from sitelist.txt
  - default is 10
  -  `attemptcount` is the number of times the script will repeat
  - default is 10
### topsites.txt
Contains the top 1 million websites. Downloaded from (LINK HERE)
### README.md
contains this file that explains the project.

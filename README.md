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
Using current DNS Settings, the bash script will take the top 500 sites and display the time it takes for the dns server to respond back.
### dnscrosstest.sh
This script take the top 10 sites, and compare your DNS against the top 10 free and open DNS Servers.
### dnsbrutetest.sh
The top 10 sites will be sent to resolve with the current DNS, and will repeat a certain amount of attempts.
  - Arguments
  -  `-a` or attempt is the number of times the script will repeat
  - default is 10
### topsites.txt
Contains the top 500 million websites. Downloaded and parsed from [Alexa Top 1 Million](http://s3.amazonaws.com/alexa-static/top-1m.csv.zip)
### dnsproviders.txt
Contains the top 10 free DNS providers.
### README.md
contains this file that explains the project.

## Screenshots
![dnstopsites](/screenshots/dnstopsites.png)
![dnscrosstest](/screenshots/dnscrosstest.png)
![dnsbrutetest](/screenshots/dnsbrutetest.png)

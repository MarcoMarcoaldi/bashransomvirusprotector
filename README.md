### Important note and claim
This script is an pure Bash adaption and "conversion" of original idea by Giovanbattista Vieri and his RansomVirusProtector tool, developed in Python3 and located at (https://github.com/gvieri/ransomvirusprotector).

I look for a simple solution, using only bash scripting without the use of Python.

### Introduction (quote by the Author of original project)
We live in tragic times where war is returning in Europe. After that we had death and destructions in AF, YU, SY a lot of African places and in Asia. Now we have to front cyberwae and rogue cyber attack. I can't do anything to stop a cyber war but I really hope this script will become usefull to sme's owner and healthcare organizations. In brief: malware needs to "phone home" for both ativation and to esfiltrate stolen data. It will phone home to get the 'key' to encrypt all your data before ask for ransom.

What if it can't "phone home" ? nothing... It will wait and will try to communicate with its owner by using other means. But a firewall correctly configured can buy you some time to fix the thing.

So I have written and published this script that I use as a sort of "swiss knife" to block suspect ip coming from a given country or, a set of countries...

I'm using on linux but it can be used on windows too. You can try on wsl (linux on windows) and maybe from powershell.

The license ? AGPL. Look at it.

### Technologies
Only Bash scripting

### What this script does
The provided script is a shell script designed to download and process IP address allocations from the RIPE NCC (Réseaux IP Européens Network Coordination Centre), specifically focusing on IPv4 addresses allocated to certain countries. 

This script is useful for automating the download and processing of IP address allocation data from RIPE NCC, potentially for analysis, reporting, or integration into other tools or databases, or in this case, make an another script with all IPTables command to block country,

### Examples
Obtain the:
net blocks related to France: ./bashramsonvirusprotector.sh -c FR
net blocks related to Italy and France: ./bashransomvirusprotector.sh -c FR,IT
Do you want know the command to block:
All russian IP addresses: ./bashransomvirusprotector.sh -c RU -p "iptables -I INPUT -s " -P " -j REJECT"

Create script for block all Russian IP: ./bashransomvirusprotector.sh -c RU -p "iptables -I INPUT -s " -P " -j REJECT" > script.sh

You will obtain a simple script that blocks all the connection coming from Russian.

Now launch the script.sh

**Installation**

Download the script bashramsonvirusprotector.sh and make executable : chmod +x bashramsonvirusprotector.sh

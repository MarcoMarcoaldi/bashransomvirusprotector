#!/bin/bash

# -------------------------------------------------------------------------------------------
#
# BashRansomVirusProtector.sh
#
# by Marco Marcoaldi @ Managed Server S.r.l. info@managedserver.it
#
# This is a Pure Bash adaptation of the Original Idea and Python3 code
# by Giovanbattista Vieri titled "RansomVirusProtector".
#
# Source: https://github.com/gvieri/ransomvirusprotector
#
#
# Introduction Quoted by Giovanbattista:
#
# " We live in tragic times where war is returning in Europe. After experiencing
# death and destructions in various parts of the world, we now face the challenge
# of cyberwarfare and rogue cyber attacks. While I cannot stop a cyber war, I hope
# this script will become useful to SME's owners and healthcare organizations.
# In essence, malware needs to "phone home" for both activation and to exfiltrate
# stolen data. It phones home to get the 'key' to encrypt all your data before
# asking for ransom.
#
# What if it can't "phone home"? Nothing... It will wait and will try to communicate
# with its owner by using other means. But a correctly configured firewall can buy
# you some time to fix the thing.
#
# Therefore, I have written and published this script that I use as a sort of
# "Swiss knife" to block suspect IPs coming from a given country or, a set of countries...
#
# I'm using it on Linux, but it can be used on Windows too. You can try on WSL
# (Linux on Windows) and maybe from PowerShell.
#
# The license? AGPL. Look at it. "
#
# Examples of use and Syntax:
#
# Obtain net blocks related to France:
# ./bashransomvirusprotector.sh -c FR
#
# Net blocks related to Italy and France:
# ./bashransomvirusprotector.sh -c FR,IT
#
# To block all Russian IP addresses:
# ./bashransomvirusprotector.sh -c RU -p "iptables -I INPUT -s " -P " -j REJECT"
#
# Then, to block all connections coming from Germany and generate an iptables script:
# ./bashransomvirusprotector.sh -c RU -p "iptables -I INPUT -s " -P " -j REJECT" > script.sh
#
# This will produce a script to block all connections coming from Russia.
#
# --------------------------------------------------------------------------------------------

# Initial setup
fn='delegated-ripencc-latest'
md5fn='delegated-ripencc-latest.md5'
site="https://ftp.ripe.net/pub/stats/ripencc/"
verbose=0
headerfilename=""
prefix=""
postfix=""
countrieslist=""

# Show usage if no arguments
if [ $# -eq 0 ]; then
    echo "Usage: $0 [options]"
    echo "Options:"
    echo "  -H, --header       Header file name to prepend to output"
    echo "  -p, --prefix       Prefix for each line of output"
    echo "  -c, --countries    Country codes, comma-separated (e.g., 'RU,IT')"
    echo "  -P, --postfix      Postfix for each line of output"
    echo "  -v, --verbose      Enable verbose output"
    exit 1
fi

# Parse command-line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -H|--header)
            headerfilename="$2"
            shift; shift ;;
        -p|--prefix)
            prefix="$2"
            shift; shift ;;
        -c|--countries)
            countrieslist="$2"
            shift; shift ;;
        -P|--postfix)
            postfix="$2"
            shift; shift ;;
        -v|--verbose)
            verbose=1
            shift ;;
        *)
            echo "Unknown option: $1"
            exit 1 ;;
    esac
done

# Function to download files
download() {
    curl -s "$1$2" -o "$2"
}

# Function to verify MD5
verifyFileMd5() {
    original_md5=$(grep -oP 'MD5 \(.*\) = \K[a-f0-9]+' "$2")
    computed_md5=$(md5sum "$1" | awk '{print $1}')
    if [ "$original_md5" == "$computed_md5" ]; then
        [ $verbose -eq 1 ] && echo "MD5 verified successfully."
        return 0
    else
        echo "MD5 verification failed!"
        return 1
    fi
}

# Download and verify files
download "$site" "$fn"
download "$site" "$md5fn"
if ! verifyFileMd5 "$fn" "$md5fn"; then
    exit 1
fi

# Process and print addresses
processAddresses() {
    local country_codes=(${countrieslist//,/ })
    while IFS='|' read -ra line; do
        if [[ "ipv4" == "${line[2]}" && " ${country_codes[*]} " =~ " ${line[1]} " ]]; then
            local net="${line[3]}"
            local num_hosts="${line[4]}"
            local cidr_bits=$(awk "BEGIN {cidr=32-log($num_hosts)/log(2); print int(cidr+(cidr-int(cidr)<0.5?0:1))}")
            echo "${prefix}${net}/${cidr_bits}${postfix}"
        fi
    done < "$fn"
}

# Print header if specified
if [ -n "$headerfilename" ]; then
    cat "$headerfilename"
fi

processAddresses

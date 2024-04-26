#!/bin/bash

# Teal Dulcet, CS533
# Downloads and runs Prime95 to generate interference.
# wget https://raw.github.com/tdulcet/Testing-and-Benchmarking-Scripts/master/mprime.sh -qO - | bash -s --
# ./mprime.sh <Type of interference>
# ./mprime.sh 4

DIR="mprime"
FILE32=p95v3019b14.linux32.tar.gz
SUM32=17af605e06b050f93722d11f41b8e55e23ed148bc343288cdd2caa20e022d6f6
FILE64=p95v3019b14.linux64.tar.gz
SUM64=ccd48d2ceebfe583003dbf8ff1dca8d744e98bf7ed4124e482bd6a3a06eaf507
if [[ $# -ne 1 ]]; then
	echo "Usage: $0 <Type of interference>" >&2
	exit 1
fi
TYPE=$1
RE='^[0-9]+$'
if ! [[ $TYPE =~ $RE ]]; then
	echo "Usage: <Type of interference> must be a number" >&2
	exit 1
fi
if [[ $TYPE -lt 1 || $TYPE -gt 5 ]]; then
	echo "Usage: <Type of interference> is not valid" >&2
	exit 1
fi
echo -e "Type of interference:\t$TYPE\n"

ARCHITECTURE=$(getconf LONG_BIT)
echo -e "\nArchitecture:\t\t\t$HOSTTYPE (${ARCHITECTURE}-bit)\n"

if [[ -d $DIR && -x "$DIR/mprime" ]]; then
	echo -e "Prime95 is already downloaded\n"
	cd "$DIR"
else
	if ! command -v expect >/dev/null; then
		echo -e "Installing Expect"
		echo -e "Please enter your password if prompted.\n"
		sudo apt-get update -y
		sudo apt-get install -y expect
	fi
	if [[ $ARCHITECTURE -eq 32 ]]; then
		FILE=$FILE32
		SUM=$SUM32
	else
		FILE=$FILE64
		SUM=$SUM64
	fi
	if ! mkdir "$DIR"; then
		echo "Error: Failed to create directory $DIR" >&2
		exit 1
	fi
	cd "$DIR"
	echo -e "Downloading Prime95\n"
	wget https://www.mersenne.org/download/software/v30/30.19/$FILE
	if [[ "$(sha256sum $FILE | head -c 64)" != "$SUM" ]]; then
		echo "Error: sha256sum does not match" >&2
		echo "Please run \"rm -r ${DIR@Q}\" make sure you are using the latest version of this script and try running it again" >&2
		echo "If you still get this error, please create an issue: https://github.com/tdulcet/Testing-and-Benchmarking-Scripts/issues" >&2
		exit 1
	fi
	echo -e "\nDecompressing the files\n"
	tar -xzvf $FILE
	echo -e "\nSetting up Prime95\n"
	if [[ -e ../mprime.exp ]]; then
		expect ../mprime.exp -- "$TYPE"
	else
		expect <(wget https://raw.github.com/tdulcet/Testing-and-Benchmarking-Scripts/master/mprime.exp -qO -) -- "$TYPE"
	fi
fi
echo -e "\nStarting Prime95\n"
# nohup ./mprime -t &
exec ./mprime -t

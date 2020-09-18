#!/bin/bash

# Teal Dulcet, CS533
# Downloads and runs Prime95 to generate interference.
# wget https://raw.github.com/tdulcet/Testing-and-Benchmarking-Scripts/master/mprime.sh -qO - | bash -s --
# ./mprime.sh <Type of interference>
# ./mprime.sh 4

DIR="mprime"
FILE="p95v303b6.linux64.tar.gz"
SUM="EE54B56062FEB05C9F80963A4E3AE8555D0E59CA60DDBCBA65CE05225C9B9A79"
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
if [[ $TYPE -lt 1 || $TYPE -gt 4 ]]; then
	echo "Usage: <Type of interference> is not valid" >&2
	exit 1
fi
echo -e "Type of interference:\t$TYPE\n"
if [[ -d "$DIR" && -x "$DIR/mprime" ]]; then
	echo -e "Prime95 is already downloaded\n"
	cd "$DIR"
else
	if ! command -v expect >/dev/null; then
		echo -e "Installing Expect"
		echo -e "Please enter your password when prompted.\n"
		sudo apt-get update -y
		sudo apt-get install expect -y
	fi
	if ! mkdir "$DIR"; then
		echo "Error: Failed to create directory $DIR" >&2
		exit 1
	fi
	cd "$DIR"
	echo -e "Downloading Prime95\n"
	wget https://www.mersenne.org/ftp_root/gimps/$FILE
	if [[ ! "$(sha256sum $FILE | head -c 64 | tr 'a-z' 'A-Z')" == "$SUM" ]]; then
		echo "Error: sha256sum does not match" >&2
		echo "Please run \"rm -r $DIR\" and try running this script again" >&2
		exit 1
	fi
	echo -e "\nDecompressing the files\n"
	tar -xzvf $FILE
	echo -e "\nSetting up Prime95\n"
	expect <(wget https://raw.github.com/tdulcet/Testing-and-Benchmarking-Scripts/master/mprime.exp -qO -) -- "$TYPE"
fi
echo -e "\nStarting Prime95\n"
# nohup ./mprime -t &
./mprime -t

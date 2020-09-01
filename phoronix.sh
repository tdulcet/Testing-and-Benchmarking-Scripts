#!/bin/bash

# Teal Dulcet, CS533
# Downloads, installs and runs the Phoronix Test Suite benchmarks.
# wget https://raw.github.com/tdulcet/Testing-and-Benchmarking-Scripts/master/phoronix.sh -qO - | bash -s --
# ./phoronix.sh <Benchmark Test(s) or Suite(s)>
# ./phoronix.sh pts/cpu pts/kernel pts/memory pts/motherboard

# sudo dpkg -P phoronix-test-suite

DIR="phoronix"
FILE="phoronix-test-suite_9.8.0_all.deb"
if [[ $# -eq 0 ]]; then
	echo "Usage: $0 <Benchmark Test(s) or Suite(s)>" >&2
	exit 1
fi
echo -e "Benchmark Test(s) or Suite(s):\t$*\n"
if [[ -d "$DIR" ]] && command -v phoronix-test-suite >/dev/null; then
	echo -e "The Phoronix Test Suite is already downloaded and installed"
else
	if ! command -v expect >/dev/null; then
		echo -e "Installing Expect"
		echo -e "Please enter your password when prompted.\n"
		sudo apt-get update -y
		sudo apt-get install expect -y
	fi
	if ! command -v php >/dev/null; then
		echo -e "Installing PHP"
		echo -e "Please enter your password when prompted.\n"
		sudo apt-get update -y
		sudo apt-get install php5-cli -y
		# sudo apt-get install php-cli -y
	fi
	if ! mkdir "$DIR"; then
		echo "Error: Failed to create directory $DIR" >&2
		exit 1
	fi
	cd "$DIR"
	echo -e "Downloading the Phoronix Test Suite\n"
	wget https://phoronix-test-suite.com/releases/repo/pts.debian/files/$FILE
	echo -e "\nInstalling the Phoronix Test Suite"
	echo -e "Please enter your password when prompted.\n"
	sudo dpkg -i $FILE
	echo -e "\nSetting up the Phoronix Test Suite\n"
	expect <(wget https://raw.github.com/tdulcet/Testing-and-Benchmarking-Scripts/master/phoronix.exp -qO -) --
fi
echo -e "\nStarting the Phoronix Test Suite\n"
# nohup phoronix-test-suite batch-benchmark "$@" &
phoronix-test-suite batch-benchmark "$@"

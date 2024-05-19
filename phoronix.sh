#!/bin/bash

# Teal Dulcet, CS533
# Downloads, installs and runs the Phoronix Test Suite benchmarks.
# wget -qO - https://raw.github.com/tdulcet/Testing-and-Benchmarking-Scripts/master/phoronix.sh | bash -s --
# ./phoronix.sh <Benchmark Test(s) or Suite(s)>
# ./phoronix.sh pts/cpu pts/kernel pts/memory pts/motherboard

# sudo dpkg -P phoronix-test-suite

DIR="phoronix"
FILE="phoronix-test-suite_10.6.1_all.deb"
if [[ $# -eq 0 ]]; then
	echo "Usage: $0 <Benchmark Test(s) or Suite(s)>" >&2
	exit 1
fi
echo -e "Benchmark Test(s) or Suite(s):\t$*\n"
if [[ -d $DIR ]] && command -v phoronix-test-suite >/dev/null; then
	echo -e "The Phoronix Test Suite is already downloaded and installed"
else
	if ! command -v expect >/dev/null; then
		echo -e "Installing Expect"
		echo -e "Please enter your password if prompted.\n"
		sudo apt-get update -y
		sudo apt-get install -y expect
	fi
	if ! command -v php >/dev/null; then
		echo -e "Installing PHP"
		echo -e "Please enter your password if prompted.\n"
		sudo apt-get update -y
		sudo apt-get install -y php5-cli
		# sudo apt-get install -y php-cli
	fi
	if ! mkdir "$DIR"; then
		echo "Error: Failed to create directory $DIR" >&2
		exit 1
	fi
	cd "$DIR"
	echo -e "Downloading the Phoronix Test Suite\n"
	wget https://phoronix-test-suite.com/releases/repo/pts.debian/files/$FILE
	echo -e "\nInstalling the Phoronix Test Suite"
	echo -e "Please enter your password if prompted.\n"
	sudo dpkg -i $FILE
	echo -e "\nSetting up the Phoronix Test Suite\n"
	if [[ -e ../phoronix.exp ]]; then
		expect ../phoronix.exp --
	else
		expect <(wget -qO - https://raw.github.com/tdulcet/Testing-and-Benchmarking-Scripts/master/phoronix.exp) --
	fi
fi
echo -e "\nStarting the Phoronix Test Suite\n"
# nohup phoronix-test-suite batch-benchmark "$@" &
exec phoronix-test-suite batch-benchmark "$@"

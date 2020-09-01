# Testing and Benchmarking Scripts
Linux Stress/Torture Testing and Benchmarking Scripts

Copyright © 2018 Teal Dulcet

## Stress/Torture Testing

### Prime95/MPrime

Downloads, sets up and runs [Prime95](https://www.mersenne.org/download/#download).

```
wget https://raw.github.com/tdulcet/Testing-and-Benchmarking-Scripts/master/mprime.sh -qO - | bash -s -- <Type of torture test>
```

To run Prime95 for Distributed Computing, see the [Distributed Computing](https://github.com/tdulcet/Distributed-Computing-Scripts) scripts.

## Benchmarking

### The Phoronix Test Suite

Downloads, installs, sets up and runs the [Phoronix Test Suite](https://www.phoronix-test-suite.com/?k=downloads).

```
wget https://raw.github.com/tdulcet/Testing-and-Benchmarking-Scripts/master/phoronix.sh -qO - | bash -s -- <Benchmark Test(s) or Suite(s)>
```

These scripts should work on Ubuntu and any Linux distribution that can use the apt package manager.

## Contributing

Pull requests welcome!

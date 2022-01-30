# DaMastaCoda's C/C++ Build System

This is a quick and simple build system, along with some utility files which can be used to quickly create classes.

## Usage

```sh
# Build project into ./bin/main
dmccbs build
```

## Install

```sh
git clone https://github.com/DMCCBS/DMCCBS.git
cd DMCCBS
# Will wait 2 seconds then prompt for a password.
./dmccbs install-dmccbs
# If sudo is not available or to do it directly (run as root or with sudo)
ln -s $(pwd)/dmccbs /usr/local/bin/dmccbs
```

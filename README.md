# sec-project1
This project is being built using [NodeMCU firmware](https://github.com/nodemcu/nodemcu-firmware). Below are a few useful link mostly for our own use for quick access and documentation.


## NodeMCU documentation
*Applies if we decide to use Lua*
*Copied from the [NodeMCU Github repository documentation]
(https://github.com/nodemcu/nodemcu-firmware/blob/master/README.md)*

The entire [NodeMCU documentation](https://nodemcu.readthedocs.io) is maintained right in this repository at [/docs](docs). The fact that the API documentation is mainted in the same repository as the code that *provides* the API ensures consistency between the two. With every commit the documentation is rebuilt by Read the Docs and thus transformed from terse Markdown into a nicely browsable HTML site at [https://nodemcu.readthedocs.io](https://nodemcu.readthedocs.io). 

- How to [build the firmware](https://nodemcu.readthedocs.io/en/master/en/build/)
- How to [build the filesystem](https://nodemcu.readthedocs.io/en/master/en/spiffs/)
- How to [flash the firmware](https://nodemcu.readthedocs.io/en/master/en/flash/)
- How to [upload code and NodeMCU IDEs](https://nodemcu.readthedocs.io/en/master/en/upload/)
- API documentation for every module

##Custom firmware
Your custom NodeMCU firmware should include the following modules to support the project:

- crypto
- end user setup
- file
- GPIO
- HTTP
- net
- node
- timer
- UART
- WiFi


#Other possibilities
## Useful links

- [ESP-open-SDK toolchain](https://github.com/pfalcon/esp-open-sdk)
- [ESP8266 wiki](https://github.com/esp8266/esp8266-wiki/wiki/Toolchain)

## ESP-open-SDK 
ESP-open-SDK contains the complete toolchain.

### Dependencies (Debian / Ubuntu)
```
$ sudo apt-get install make unrar-free autoconf automake libtool gcc g++ gperf \
flex bison texinfo gawk ncurses-dev libexpat-dev python-dev python python-serial \
sed git unzip bash help2man wget bzip2
```

Esptool, python2 needed.
`pip install esptool`

### Building
You might need to use your own brain for this but generally it'll be something like;
```
$ cd /opt/
$ git clone --recursive https://github.com/pfalcon/esp-open-sdk.git
#Probably want to chown the folder to your user.
$ cd open-sdk
$ make
$ export PATH=/opt/esp-open-sdk/xtensa-lx106-elf/bin:$PATH 
```

This will give you the following structure:
- Compiler : `/opt/esp-open-sdk/xtensa-lx106-elf/bin`
- SDK base dir: `/opt/esp-open-sdk/sdk`

Depending on the makefile a project may search for different directories. Edit makefile accordingly.

## Code
Starting a project using esp-open-sdk we need to create a .c script containing our code. A Makefile containing things like the root sdk folder and the compiler and optionally a .h config file.

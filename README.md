# artesky_flat_box
ARM64 command line control app for the Artesky flat box. Svr goes on PC connected to Artesky panel, and Cmd sends commands to the server to control the panel

## Quick install for arm32 and arm64

This will install the artesky_flatbox.service for the user, and start it up.

1. Open terminal and go to the folder you wish to install
2. Git Clone this library: `git clone https://github.com/maudy2u/artesky_flat_box.git`
3. run `install-srv` specifying the IP and device to use
4. Can check with `systemctl --user status artesky_flatbox`

## Artesky files
The project directly uses the Artesky library file.

e.g. 

- The header files can be found here: https://github.com/Artesky/artesky-projects-devel/tree/master/libartesky_SDK/1.0.0/include

- the binaries can be found here: https://github.com/Artesky/artesky-flat-box/tree/master/1.2

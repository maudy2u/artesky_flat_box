#!/usr/bin/env bash
# could use this to get the IP address
# ifconfig eth0 | grep inet | grep -v inet6 | awk '{print $2}'
# need to specify the network interface to use, e.g: eth0

if [ $# -eq 0 ]
  then
    echo ""
    echo " *******************************"
    echo " Install Artesky_srv v2.0"
    echo " *******************************"
		echo ": "
		echo ": Requires one parameter - the IP of the host server"
    echo ": e.g."
    echo ": install_artesky_srv.sh 192.168.0.1"
		exit 1
fi

IP=${1}
SRVC_NAME=artesky_flat
SRVC=${SRVC_NAME}.service
SRVC_DIR=${HOME}'/.config/systemd/user'
SRVC_FILE=${SRVC_DIR}/${SRVC}
SRVC_AUTOSTART=${HOME}'/.config/autostart/'${SRVC}.desktop


install_dir=$(pwd)

install.autostart.file() {
	echo " *******************************"
  echo " Install autostart: "${SRVC_AUTOSTART}
  echo " *******************************"
	echo '' > ${SRVC_AUTOSTART}
  echo '[Desktop Entry]' >> ${SRVC_AUTOSTART}
	echo 'Type=Application' >> ${SRVC_AUTOSTART}
	echo 'Name='${SRVC_NAME} >> ${SRVC_AUTOSTART}
	echo 'Exec=systemctl --user start '${SRVC} >> ${SRVC_AUTOSTART}
	echo 'X-MATE-Autostart-enabled=true' >> ${SRVC_AUTOSTART}
	echo 'X-GNOME-Autostart-enabled=true' >> ${SRVC_AUTOSTART}
}

install.service.file() {
  echo ""
  echo " *******************************"
  echo " Install service: "${SRVC_FILE}
  echo " *******************************"
  echo '' > ${SRVC_FILE}
  echo '[Unit]' >> ${SRVC_FILE}
  echo 'Description=Artesky Flatbox server' >> ${SRVC_FILE}
  echo 'After=multi-user.target syslog.target network.target remote-fs.target' >> ${SRVC_FILE}
  echo '' >> ${SRVC_FILE}
  echo '[Service]' >> ${SRVC_FILE}
  echo 'Type=idle' >> ${SRVC_FILE}
  echo 'PIDFile=/var/run/artesky_srv.pid' >> ${SRVC_FILE}
  echo 'WorkingDirectory='${install_dir}'/bin' >> ${SRVC_FILE}
  # LD_LIBRARY_PATH
  # echo 'Environment="LD_LIBRARY_PATH='${install_dir}'/artesky_flatbox/lib"'    >> ${SRVC_FILE}
  # https://askubuntu.com/questions/1063153/systemd-service-working-directory-not-change-the-directory
  echo '' >> ${SRVC_FILE}
  echo 'ExecStartPre=/bin/rm -f /var/run/artesky_srv.pid' >> ${SRVC_FILE}
  echo 'ExecStart='${install_dir}'/bin/artesky_srv --ip '${IP}'' >> ${SRVC_FILE}
  echo '' >> ${SRVC_FILE}
  echo 'Restart=always' >> ${SRVC_FILE}
  echo 'RestartSec=10' >> ${SRVC_FILE}
  echo '' >> ${SRVC_FILE}
  echo 'ExecStop=/bin/kill -s QUIT $MAINPID' >> ${SRVC_FILE}
  echo 'KillSignal=SIGKILL' >> ${SRVC_FILE}
  echo '' >> ${SRVC_FILE}
  echo '[Install]' >> ${SRVC_FILE}
  echo 'WantedBy=multi-user.target' >> ${SRVC_FILE}
}

printf "\n[-] Get the BOOST Library\n\n"
sudo apt install -y libboost-dev
# https://github.com/Artesky/artesky-flat-box/blob/master/1.2/setup_artesky-flat_1.2.0.0_arm64_ubuntu.tar.xz
#printf "\n[-] Download the server code\n\n"
#mkdir -p ${install_dir}/artesky_flatbox
#cd ${install_dir}/artesky_flatbox
#git clone https://github.com/maudy2u/artesky_flat_box.git

printf "\n[-] Download and Install the header files\n\n"
mkdir -p ${install_dir}/libartesky_SDK/1.0.0/include
cd ${install_dir}/libartesky_SDK/1.0.0/include
curl -Ls -o "libartesky.h" "https://raw.githubusercontent.com/Artesky/artesky-projects-devel/master/libartesky_SDK/1.0.0/include/libartesky.h"
curl -Ls -o "libartesky_defs.h" "https://raw.githubusercontent.com/Artesky/artesky-projects-devel/master/libartesky_SDK/1.0.0/include/libartesky_defs.h"
curl -Ls -o "libartesky_errors.h" "https://raw.githubusercontent.com/Artesky/artesky-projects-devel/master/libartesky_SDK/1.0.0/include/libartesky_errors.h"
curl -Ls -o "libartesky_info.h" "https://raw.githubusercontent.com/Artesky/artesky-projects-devel/master/libartesky_SDK/1.0.0/include/libartesky_info.h"
curl -Ls -o "libartlibarteskycesky.h" "https://raw.githubusercontent.com/Artesky/artesky-projects-devel/master/libartesky_SDK/1.0.0/include/libarteskyc.h"
curl -Ls -o "serial.h" "https://raw.githubusercontent.com/Artesky/artesky-projects-devel/master/libartesky_SDK/1.0.0/include/serial.h"

printf "\n[-] Download and Install the binary libraries\n\n"
cd ${install_dir}
curl -Ls -o "artesky_binaries.tar.xz" "https://github.com/Artesky/artesky-flat-box/raw/master/1.2/setup_artesky-flat_1.2.0.0_arm64_ubuntu.tar.xz"
tar -xf artesky_binaries.tar.xz

printf "\n[-] Make artesky_srv\n\n"
cd ${install_dir}/src
#export LD_LIBRARY_PATH=${install_dir}'/artesky_flatbox/lib:'$LD_LIBRARY_PATH'"'
make server
mv ./artesky_srv ../bin/artesky_srv
cd ${install_dir}

printf "\n[-] Some clean up\n\n"
rm ./artesky_binaries.tar.xz
rm -rf ./bin/translations ./libartesky_SDK ./plugin ./src ./artesky-flat
sudo apt remove -y libboost-dev

printf "\n[-] Create User Service File and start\n\n"
install.service.file
install.autostart.file

printf "\n[-] Start service\n\n"
systemctl --user daemon-reload
systemctl --user enable ${SRVC}
systemctl --user start ${SRVC}

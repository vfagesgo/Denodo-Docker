#!/bin/bash
# -----------------------------------------------------------------------------
#  Environment variable JAVA_HOME must be set and exported
# -----------------------------------------------------------------------------

DENODO_INSTALL_DIR="/tmp/denodo-install-7.0/"

if [ ! -e "/denodo/bin" ]
then
  unset DISPLAY
  cd "$DENODO_INSTALL_DIR"
  chmod +x installer_cli.sh
  ./installer_cli.sh install --autoinstaller /opt/denodo/denodo_install.xml
fi

if [ ! -e "/denodo/bin/stop.sh" ]
then
  cd "/opt/denodo/"
  chmod +x stop.sh
  cp stop.sh /denodo/bin/
fi

replace () {
  file=$1
  var=$2
  new_value=$3
  sed -r -i -e "s/^$var=.*/$var=$new_value/" -e "s/^$var\t.*/$var\t$new_value/" $file
}

cp /etc/hosts ~/hosts.new
replace ~/hosts.new 127.0.0.1 "localhost $DOMAINE_NAME"
cp -f ~/hosts.new /etc/hosts
replace /denodo/conf/vdp/VDBConfiguration.properties com.denodo.vdb.vdbinterface.server.VDBManagerImpl.registryURL "$DOMAINE_NAME"

/denodo/bin/regenerateFiles.sh

# Denodo Express Demo

# Purpose
Denodo-Docker is aimed to provide a simple and rapid infrastructure for Denodo Express Virtual Data Integration Plateforme. Leveraging Docker container architecture, this document describes the installation steps on macOS platform.

You can find additional information on Denodo Express [here](https://www.denodo.com/en/denodo-platform/denodo-express)

# Architecture & Software stack

> Prerequisites

 - [ ] Docker demon installed
 - [ ] Docker-Compose installed
 - [ ] Install XQuartz X11 [here](https://www.xquartz.org/)
 - [ ] Get a local copy of this repository
 - [ ] Register with Denodo Express [here](https://auth.denodo.com/user-management/express-full-register)
 - [ ] Download Denodo Express binary [here](https://community.denodo.com/express/download)
 - [ ] Get Denodo Express License
 - [ ] Download MySQL Connector [here](https://dev.mysql.com/downloads/connector/j/)
 - [ ] Denodo Tutorial files [here](https://community.denodo.com/tutorials/files/denodo_tutorial_files.zip)

> Software Stack

 - XQuartz X11 Windows
 - Docker Container Ubuntu
 - MySQL
 - Jetty WebService
 - Denodo 7 Express

# Install
## XQuartz configuration

 - Install the latest XQuartz X11 server and run it
 - Activate the option ‘**Allow connections from network clients**’ in XQuartz settings
 - Quit & restart XQuartz (to activate the setting)

You can find additional information [here](https://medium.com/@mreichelt/how-to-show-x11-windows-within-docker-on-mac-50759f4b65cb)

## Build and start Docker Container with Docker-Compose
### Copy the binary and the license files
Copy to the root of the Denodo-Docker folder the install binary and license file.
- denodo-express-install-7_0-linux64.zip
- denodo-express-lic-7_0-201805.lic

### Edit docker-compose.yml
Edit the docker-compose.yml file and change accordingly the following arguments:
- DENODO_INSTALL
- DENODO_LICENSE

You can chose between full or light install by changing the DENODO_INSTALL_CONF argument
- denodo_install_light_7_0.xml
- denodo_install_full_7_0.xml

Switch the to the right X11 Environment DISPLAY depending if you run on Windows or Mac OS Host
- "DISPLAY=docker.for.mac.localhost:0" for Mac OS Host
- "DISPLAY=docker.for.win.localhost:0" for Mac Windows Host

### Build & install the Denodo image
    $cd Denodo-Docker
    $docker-compose up -d --build

## Launch Denodo Docker Container
Start a container named **denodo** using docker-compose sharing the with the local machine the denodo install directory.

    $cd <DONODOCK_DIR>
    $docker-compose up -d

## Enter into the Denodo container
Prior to enter the container make to allow access from localhost to the X11 display.

    $xhost + 127.0.0.1
Enter into the container

    $docker exec -it denodock bash
# Start the Denodo Control Center

    $cd /denodo/bin
    ./denodo_platform.sh

# Very important: configure the RMI Host Address
As Docker install is like having the Virtual DataPort Server and the Administration Tool or other clients are installed in different machines,
you may need to change the interface that the Server listens to your physical machine IP.
To change this, open the Denodo Control Center, open the Configuration dialog and change the RMI Host of the JVM Options.
See more details in the section Denodo Platform [Configuration of the Installation Guide](https://community.denodo.com/docs/html/browse/7.0/platform/installation/denodo_platform_control_center/virtual_machine_and_web_container_configuration/virtual_machine_and_web_container_configuration#denodo-platform-configuration).

**Omitting this configuration will result in a failure to get access to the Virtual DataPort Server with the Denodo JDBC Client.**

# Denodo Tutorial
The Denodo Tutorial files can be found under the following path:

    /opt/denodo/tutorial

# additional useful commands
#### Generate the silent instal configuration files

    $<DENODO_INSTALL_DIR>/installer_cli.sh generate response_file_7_0.xml
#### REST JSON End Point ####
    http://<host>:9090/denodo-restfulws/<virtual_database>/views/<view>
*Authorization type* **Basic Auth**

*Header Accept* **application/json**

#### WebService Demo ####
Start the jetty

    cd /opt/denodo/tutorial/jetty/
    /denodo/jre/bin/java -jar start.jar &

Sample WS EndPoint


#### ODATA ####
*Denodo RESTful WebServices*

    http://<host>:9090/denodo-restfulws/<virtual_database>

*OData Service*

    http://<host>:9090/denodo-odata4-service/denodo-odata.svc/<virtual_database>

*ODATA View*

    http://localhost:9090/denodo-odata4-service/denodo-odata.svc/tutorial/<view>
#### Useful Docker commands
*Stop composed containers*

    `docker-compose stop`
*Stop & remove composed containers*

    `docker-compose down`

*List the containers*

    `docker ps`
*Stop a container*

    docker stop <container_name>`

*Delete a container*

    `docker rm <container_name>`

*List the available images*

    `docker images`

*Delete an image*

    `docker rmi <image_name>`

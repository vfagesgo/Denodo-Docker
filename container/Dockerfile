FROM scratch as denodo

LABEL maintener="Vincent Fages <vfagesgo@gmail.com>"
LABEL contributor="Vincent Fages <vfagesgo@gmail.com>"

ADD ubuntu-bionic-core-cloudimg-amd64-root.tar.gz /

# a few minor docker-specific tweaks
# see https://github.com/docker/docker/blob/9a9fc01af8fb5d98b8eec0740716226fadb3735c/contrib/mkimage/debootstrap
RUN set -xe \
	\
# https://github.com/docker/docker/blob/9a9fc01af8fb5d98b8eec0740716226fadb3735c/contrib/mkimage/debootstrap#L40-L48
	&& echo '#!/bin/sh' > /usr/sbin/policy-rc.d \
	&& echo 'exit 101' >> /usr/sbin/policy-rc.d \
	&& chmod +x /usr/sbin/policy-rc.d \
	\
# https://github.com/docker/docker/blob/9a9fc01af8fb5d98b8eec0740716226fadb3735c/contrib/mkimage/debootstrap#L54-L56
	&& dpkg-divert --local --rename --add /sbin/initctl \
	&& cp -a /usr/sbin/policy-rc.d /sbin/initctl \
	&& sed -i 's/^exit.*/exit 0/' /sbin/initctl \
	\
# https://github.com/docker/docker/blob/9a9fc01af8fb5d98b8eec0740716226fadb3735c/contrib/mkimage/debootstrap#L71-L78
	&& echo 'force-unsafe-io' > /etc/dpkg/dpkg.cfg.d/docker-apt-speedup \
	\
# https://github.com/docker/docker/blob/9a9fc01af8fb5d98b8eec0740716226fadb3735c/contrib/mkimage/debootstrap#L85-L105
	&& echo 'DPkg::Post-Invoke { "rm -f /var/cache/apt/archives/*.deb /var/cache/apt/archives/partial/*.deb /var/cache/apt/*.bin || true"; };' > /etc/apt/apt.conf.d/docker-clean \
	&& echo 'APT::Update::Post-Invoke { "rm -f /var/cache/apt/archives/*.deb /var/cache/apt/archives/partial/*.deb /var/cache/apt/*.bin || true"; };' >> /etc/apt/apt.conf.d/docker-clean \
	&& echo 'Dir::Cache::pkgcache ""; Dir::Cache::srcpkgcache "";' >> /etc/apt/apt.conf.d/docker-clean \
	\
# https://github.com/docker/docker/blob/9a9fc01af8fb5d98b8eec0740716226fadb3735c/contrib/mkimage/debootstrap#L109-L115
	&& echo 'Acquire::Languages "none";' > /etc/apt/apt.conf.d/docker-no-languages \
	\
# https://github.com/docker/docker/blob/9a9fc01af8fb5d98b8eec0740716226fadb3735c/contrib/mkimage/debootstrap#L118-L130
	&& echo 'Acquire::GzipIndexes "true"; Acquire::CompressionTypes::Order:: "gz";' > /etc/apt/apt.conf.d/docker-gzip-indexes \
	\
# https://github.com/docker/docker/blob/9a9fc01af8fb5d98b8eec0740716226fadb3735c/contrib/mkimage/debootstrap#L134-L151
	&& echo 'Apt::AutoRemove::SuggestsImportant "false";' > /etc/apt/apt.conf.d/docker-autoremove-suggests

# delete all the apt list files since they're big and get stale quickly
RUN rm -rf /var/lib/apt/lists/*
# this forces "apt-get update" in dependent images, which is also good
# (see also https://bugs.launchpad.net/cloud-images/+bug/1699913)

# enable the universe
RUN sed -i 's/^#\s*\(deb.*universe\)$/\1/g' /etc/apt/sources.list

# make systemd-detect-virt return "docker"
# See: https://github.com/systemd/systemd/blob/aa0c34279ee40bce2f9681b496922dedbadfca19/src/basic/virt.c#L434
RUN mkdir -p /run/systemd && echo 'docker' > /run/systemd/container

# overwrite this with 'CMD []' in a dependent Dockerfile
CMD ["/bin/bash"]

# Prep for X11 Display for Denodo
RUN apt update
RUN apt-get install -y libxrender1 libxtst6 libxi6
RUN apt-get install -y unzip

# Install Oracle Java
RUN apt-get install -y software-properties-common
RUN add-apt-repository -y ppa:webupd8team/java

RUN echo debconf shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections
RUN echo debconf shared/accepted-oracle-license-v1-1 seen true | /usr/bin/debconf-set-selections
RUN apt-get update
RUN apt-get install -y vim
RUN apt-get install -y net-tools
RUN apt-get update
RUN apt-get install -y oracle-java8-installer
RUN export JAVA_HOME=/usr/bin

# Install supervisord
RUN apt-get install -y supervisor
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

#Denodo Plateforme
ARG DENODO_INSTALL
ARG DENODO_INSTALL_CONF
ARG DENODO_LICENSE

#RUN mkdir /src
#RUN mkdir /src/denodo_install
RUN mkdir /denodo
RUN mkdir /opt/denodo


ADD $DENODO_INSTALL /tmp/
RUN unzip /tmp/$DENODO_INSTALL -d /tmp

COPY $DENODO_INSTALL_CONF /opt/denodo/denodo_install.xml
COPY $DENODO_LICENSE /opt/denodo/denodo-express-lic-7_0.lic

COPY stop.sh /opt/denodo/
COPY denodoinstall.sh /opt/denodo/
RUN chmod +x /opt/denodo/denodoinstall.sh
#Remove CR LF ^M from Windows edited files
RUN sed -i -e 's/\r$//' /opt/denodo/stop.sh
RUN sed -i -e 's/\r$//' /opt/denodo/denodoinstall.sh

#Denodo Ports
EXPOSE 19996-19999
EXPOSE 19090
EXPOSE 10091
EXPOSE 9996-9999
EXPOSE 9090-9099
EXPOSE 8080
EXPOSE 8000
EXPOSE 80

#supervisord  --nodaemon --configuration /etc/supervisord.conf
CMD ["/usr/bin/supervisord"]

VOLUME /denodo
WORKDIR /denodo

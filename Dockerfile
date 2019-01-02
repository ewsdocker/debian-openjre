# =========================================================================
# =========================================================================
#
#	Dockerfile
#	  Dockerfile for OpenJDK-10-jre in a Debian container.
#
# =========================================================================
#
# @author Jay Wheeler.
# @version 9.6.0
# @copyright © 2017, 2018, 2019. EarthWalk Software.
# @license Licensed under the GNU General Public License, GPL-3.0-or-later.
# @package ewsdocker/debian-openjre
# @subpackage Dockerfile
#
# =========================================================================
#
#	Copyright © 2017, 2018, 2019. EarthWalk Software
#	Licensed under the GNU General Public License, GPL-3.0-or-later.
#
#   This file is part of ewsdocker/debian-openjre.
#
#   ewsdocker/debian-openjre is free software: you can redistribute 
#   it and/or modify it under the terms of the GNU General Public License 
#   as published by the Free Software Foundation, either version 3 of the 
#   License, or (at your option) any later version.
#
#   ewsdocker/debian-openjre is distributed in the hope that it will 
#   be useful, but WITHOUT ANY WARRANTY; without even the implied warranty 
#   of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.
#
#   You should have received a copy of the GNU General Public License
#   along with ewsdocker/debian-openjre.  If not, see 
#   <http://www.gnu.org/licenses/>.
#
# =========================================================================
# =========================================================================
#
#   Install openjdk-10-jre from jdk.java.net/10 .
#
# =========================================================================
FROM ewsdocker/debian-kaptain:9.6.0

MAINTAINER Jay Wheeler <EarthWalkSoftware@gmail.com>

# =========================================================================
#
#     The following must be modified before running a build,
#         as there is no way to specify them in the build 
#         command.
#
# 	  OPENJDK-10 website http://jdk.java.net/10/
#
#     repository address at 
#        https://download.java.net/java/GA/jdk10/10.0.2/19aef61b38124481863b1413dce1855f/13/openjdk-10.0.2_linux-x64_bin.tar.gz
#
# =========================================================================
ENV OPENJDK_RELEASE=jdk10 
ENV OPENJDK_VERS="10.0.2" 
ENV OPENJDK_PKG="openjdk-${OPENJDK_VERS}_linux-x64_bin.tar.gz"

ENV OPENJDK_PKG_DIR="${OPENJDK_RELEASE}/${OPENJDK_VERS}/19aef61b38124481863b1413dce1855f/13"

#ENV OPENJDK_HOST=http://alpine-nginx-pkgcache 
ENV OPENJDK_HOST="https://download.java.net/java/GA/${OPENJDK_PKG_DIR}"

ENV OPENJDK_URL="${OPENJDK_HOST}/${OPENJDK_PKG}"
 
# =========================================================================

ENV LMSBUILD_VERSION="9.6.0"
ENV LMSBUILD_NAME=debian-openjre
ENV LMSBUILD_REPO=ewsdocker 
ENV LMSBUILD_REGISTRY="" 

ENV LMSBUILD_PARENT="debian-kaptain:9.6.0"
ENV LMSBUILD_DOCKER="${LMSBUILD_REPO}/${LMSBUILD_NAME}:${LMSBUILD_VERSION}" 
ENV LMSBUILD_PACKAGE="${LMSBUILD_PARENT}, openjre-${OPENJDK_RELEASE}-${OPENJDK_VERS}"

# =========================================================================

RUN apt-get -y upgrade \
 && apt-get -y update \
 && apt-get -y install \
            java-common \
 && apt-get clean all \
 && mkdir /usr/lib/jvm \
 && cd /usr/lib/jvm \
 && wget ${OPENJDK_URL} \
 && tar xvf ${OPENJDK_PKG} \
 && rm ${OPENJDK_PKG} \
 && ln -s /usr/lib/jvm/jdk-${OPENJDK_VERS}/bin/java /usr/bin/java \
 && ln -s /usr/lib/jvm/jdk-${OPENJDK_VERS}/bin/java /etc/alternatives/java \
 && printf "${LMSBUILD_DOCKER} (${LMSBUILD_PACKAGE}), %s @ %s\n" `date '+%Y-%m-%d'` `date '+%H:%M:%S'` >> /etc/ewsdocker-builds.txt 
 
# =========================================================================

COPY scripts/. /

RUN chmod 775 /usr/local/bin/* 

# =========================================================================

ENTRYPOINT ["/my_init", "--quiet"]
CMD ["/bin/bash"]

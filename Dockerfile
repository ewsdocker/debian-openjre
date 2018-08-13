# =========================================================================
# =========================================================================
#
#	Dockerfile
#	  Dockerfile for OpenJDK-JRE in a Debian container.
#
# =========================================================================
#
# @author Jay Wheeler.
# @version 9.5.4
# @copyright © 2017, 2018. EarthWalk Software.
# @license Licensed under the GNU General Public License, GPL-3.0-or-later.
# @package ewsdocker/debian-openjre
# @subpackage Dockerfile
#
# =========================================================================
#
#	Copyright © 2017, 2018. EarthWalk Software
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
#   Install openjdk-8-jre from the Debian repository.
#
# =========================================================================
FROM ewsdocker/debian-base-gui:9.5.1

MAINTAINER Jay Wheeler <EarthWalkSoftware@gmail.com>

# =========================================================================
#
#     The following must be modified before running a build,
#         as there is no way to specify them in the build 
#         command.
#
# 	  OPENJDK repository address
#
# =========================================================================
ENV OPENJDK_RELEASE=jdk10 
ENV OPENJDK_VERS="10.0.2" 
ENV OPENJDK_PKG="openjdk-${OPENJDK_VERS}_linux-x64_bin.tar.gz"

ENV OPENJDK_PKG_DIR="${OPENJDK_RELEASE}/${OPENJDK_VERS}/19aef61b38124481863b1413dce1855f/13"

#ENV OPENJDK_HOST=http://pkgnginx 
ENV OPENJDK_HOST="https://download.java.net/java/GA/${OPENJDK_PKG_DIR}"

ENV OPENJDK_URL="${OPENJDK_HOST}/${OPENJDK_PKG}"
 
# =========================================================================

ENV LMSBUILD_VERSION="9.5.4"
ENV LMSBUILD_NAME=debian-openjre
ENV LMSBUILD_REPO=ewsdocker 
ENV LMSBUILD_REGISTRY="" 

ENV LMSBUILD_DOCKER="${LMSBUILD_REPO}/${LMSBUILD_NAME}:${LMSBUILD_VERSION}" 
ENV LMSBUILD_PACKAGE="openjre-${OPENJDK_RELEASE}-${OPENJDK_VERS}"

# =========================================================================

RUN apt-get -y update \
 && apt-get -y upgrade \
 && cd /usr/local/share \
 && wget ${OPENJDK_URL} \
 && tar xvf ${OPENJDK_PKG} \
 && apt-get -y install \
            libgtk2.0-0 \
            libgtk2.0-bin \
            libgtk2.0-common \
            libgtk-3-0 \
            libgtk-3-bin \
            libgtk-3-common \ 
 && printf "${LMSBUILD_DOCKER} (${LMSBUILD_PACKAGE}), %s @ %s\n" `date '+%Y-%m-%d'` `date '+%H:%M:%S'` >> /etc/ewsdocker-builds.txt  

# =========================================================================

COPY scripts/. /

RUN chmod 775 /usr/local/bin/* \
 && chmod 600 /usr/local/share/applications/debian-openjre-${LMSBUILD_VERSION}.desktop 

# =========================================================================

ENTRYPOINT ["/my_init", "--quiet"]
CMD ["/bin/bash"]

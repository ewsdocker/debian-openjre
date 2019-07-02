# =========================================================================
# =========================================================================
#
#	Dockerfile
#	  Dockerfile for OpenJDK-10-jre in a Debian container.
#
# =========================================================================
#
# @author Jay Wheeler.
# @version 9.7.0
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

ARG ARG_NAME="lms-library"
ARG ARG_LIBRARY="0.1.2"

#ARG ARG_SOURCE=http://alpine-nginx-pkgcache

# =========================================================================

ARG ARGBUILD_REGISTRY=""
ARG ARGBUILD_REPO="ewsdocker"
ARG ARGBUILD_NAME="debian-openjre"
ARG ARGBUILD_VERSION="9.7.0"
ARG ARGBUILD_VERS_EXT=

ARG ARGBUILD_TEMPLATE="gui"

ARG ARGBUILD_CATEGORIES="Graphics"
ARG ARGBUILD_DESKTOP_NAME="Gimp"
ARG ARGBUILD_ICON="gimp.png"

# =========================================================================

ARG ARGOPT_QUIET=0

# =========================================================================

ARG ARG_FROM_PARENT="debian-base-gui"

ARG ARG_FROM_REPO="ewsdocker/debian-base-gui"
ARG ARG_FROM_VERS="9.7.0"
ARG ARG_FROM_EXT=

FROM "${ARG_FROM_REPO}:${ARG_FROM_VERS}${ARG_FROM_EXT}"

# =========================================================================

MAINTAINER Jay Wheeler <EarthWalkSoftware@gmail.com>

# =========================================================================

ARG ARG_NAME
ARG ARG_LIBRARY

ARG ARG_SOURCE

ARG ARGBUILD_REGISTRY
ARG ARGBUILD_REPO

ARG ARGBUILD_NAME 
ARG ARGBUILD_VERSION
ARG ARGBUILD_VERS_EXT

ARG ARGBUILD_TEMPLATE
ARG ARGBUILD_CATEGORIES
ARG ARGBUILD_DESKTOP_NAME
ARG ARGBUILD_ICON

ARG ARG_FROM_PARENT
ARG ARG_FROM_REPO
ARG ARG_FROM_VERS
ARG ARG_FROM_EXT

ARG ARGOPT_QUIET

# =========================================================================
#
# 	  OPENJDK-10 website http://jdk.java.net/10/
#
#     repository address at 
#        https://download.java.net/java/GA/jdk10/10.0.2/19aef61b38124481863b1413dce1855f/13/openjdk-10.0.2_linux-x64_bin.tar.gz
#
# =========================================================================
ENV OPENJDK_RELEASE=jdk10 \
    OPENJDK_VERS="10.0.2" 

ENV OPENJDK_PKG="openjdk-${OPENJDK_VERS}_linux-x64_bin.tar.gz" \
    OPENJDK_PKG_DIR="${OPENJDK_RELEASE}/${OPENJDK_VERS}/19aef61b38124481863b1413dce1855f/13"

ENV OPENJDK_HOST=${ARG_SOURCE:-"https://download.java.net/java/GA/${OPENJDK_PKG_DIR}"}
ENV OPENJDK_URL="${OPENJDK_HOST}/${OPENJDK_PKG}"
 
# =========================================================================

ENV \
    \
    LMS_BASE="/usr/local" \
    LMS_HOME= \
    LMS_CONF= \
    \
    \
    LMSBUILD_REGISTRY=${ARGBUILD_REGISTRY} \
    LMSBUILD_REPO=${ARGBUILD_REPO} \
    \
	\
    LMSBUILD_NAME=${ARGBUILD_NAME} \
    LMSBUILD_VERSION=${ARGBUILD_VERSION} \
    LMSBUILD_VERS_EXT=${ARGBUILD_VERS_EXT} \
    LMSBUILD_TEMPLATE=${ARGBUILD_TEMPLATE:-"run"} \
    LMSBUILD_DESKTOP_CATEGORIES=${ARGBUILD_CATEGORIES} \
    LMSBUILD_DESKTOP_NAME=${ARGBUILD_DESKTOP_NAME} \
    LMSBUILD_ICON=${ARGBUILD_ICON}   

ENV \
    LMSBUILD_BASE="${ARG_FROM_PARENT}:${ARG_FROM_VERS}${ARG_FROM_EXT}" \
    \
    LMSBUILD_PARENT="${ARG_FROM_REPO}:${ARG_FROM_VERS}${ARG_FROM_EXT}" \
    LMSBUILD_DOCKER="${LMSBUILD_REPO}/${LMSBUILD_NAME}:${LMSBUILD_VERSION}${LMSBUILD_VERS_EXT}" 

ENV LMSBUILD_PACKAGE="${LMSBUILD_PARENT}, openjre-${OPENJDK_RELEASE}-${OPENJDK_VERS}"

# =========================================================================

ENV PKG_VERS="${ARG_LIBRARY}" 

ENV PKG_HOST=${ARG_SOURCE:-"https://github.com/ewsdocker/lms-utilities/releases/download/lms-library-${PKG_VERS}"} \
    PKG_NAME="lms-library-${PKG_VERS}.tar.gz" 

ENV PKG_URL="${PKG_HOST}/${PKG_NAME}"

# =========================================================================

ENV LMSOPT_QUIET=${ARGOPT_QUIET:-"0"}

# =========================================================================

COPY scripts/. /

# =========================================================================

RUN apt-get -y upgrade \
 && apt-get -y update \
 && apt-get -y install \
            java-common \
 #
 # =========================================================================
 #
 #    Install gtk2, if requested
 #
 # =========================================================================
 #
 && if test "${LMSBUILD_VERS_EXT}" = "-gtk2"; then apt-get -y install openjdk-8-jre openjdk-8-jre-headless; fi \ 
 #
 # =========================================================================
 #
 #    clean-up apt
 #
 # =========================================================================
 #
 && apt-get clean all \
 #
 # =========================================================================
 #
 #    If not gtk2 requested, download and install open-jdk
 #      then link open-jdk as java
 #
 # =========================================================================
 #
 && if [ "${LMSBUILD_VERS_EXT}" != "-gtk2" ]; then mkdir /usr/lib/jvm; cd /usr/lib/jvm; wget ${OPENJDK_URL}; tar xvf ${OPENJDK_PKG}; rm ${OPENJDK_PKG}; fi \
 && if [ "${LMSBUILD_VERS_EXT}" != "-gtk2" ]; then ln -s /usr/lib/jvm/jdk-${OPENJDK_VERS}/bin/java /usr/bin/java; ln -s /usr/lib/jvm/jdk-${OPENJDK_VERS}/bin/java /etc/alternatives/java; fi \
 #
 # =========================================================================
 #
 #   download and install lms-library
 #
 # =========================================================================
 #
 && cd / \
 && wget "${PKG_URL}" \
 && tar -xvf "${PKG_NAME}" \
 && rm "${PKG_NAME}" \
 #
 # =========================================================================
 #
 #    finish by registering the installed software
 #
 # =========================================================================
 #
 && printf "${LMSBUILD_DOCKER} (${LMSBUILD_PACKAGE}), %s @ %s\n" `date '+%Y-%m-%d'` `date '+%H:%M:%S'` >> /etc/ewsdocker-builds.txt \
 && chmod 775 /usr/local/bin/* 

# =========================================================================

ENTRYPOINT ["/my_init", "--quiet"]
CMD ["/bin/bash"]

# =========================================================================
# =========================================================================
#
#	Dockerfile
#	  Dockerfile for OpenJDK-JRE in a Debian container.
#
# =========================================================================
#
# @author Jay Wheeler.
# @version 9.5.9-jre-8
# @copyright © 2017, 2018. EarthWalk Software.
# @license Licensed under the GNU General Public License, GPL-3.0-or-later.
# @package ewsdocker/debian-openjre:openjdk-8-jre
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
FROM ewsdocker/debian-kaptain:9.5.4-gtk2

MAINTAINER Jay Wheeler <EarthWalkSoftware@gmail.com>

# =========================================================================

ENV LMSBUILD_VERSION="9.5.9-jre-8"
ENV LMSBUILD_NAME=debian-openjre 
ENV LMSBUILD_REPO=ewsdocker 
ENV LMSBUILD_REGISTRY="" 

ENV LMSBUILD_PARENT="debian-kaptain:9.5.4-gtk2"
ENV LMSBUILD_DOCKER="${LMSBUILD_REPO}/${LMSBUILD_NAME}:${LMSBUILD_VERSION}" 
ENV LMSBUILD_PACKAGE="${LMSBUILD_PARENT}, OpenJDK-8-JRE"

# =========================================================================

RUN apt-get -y update \
 && apt-get -y upgrade \
 && apt-get -y install \
     java-common \
     openjdk-8-jre \
     openjdk-8-jre-headless \
 && printf "${LMSBUILD_DOCKER} (${LMSBUILD_PACKAGE}), %s @ %s\n" `date '+%Y-%m-%d'` `date '+%H:%M:%S'` >> /etc/ewsdocker-builds.txt  

# =========================================================================

COPY scripts/. /

RUN chmod 775 /usr/local/bin/* 

# =========================================================================

ENTRYPOINT ["/my_init", "--quiet"]
CMD ["/bin/bash"]

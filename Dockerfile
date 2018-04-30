# =========================================================================
# =========================================================================
#
#	Dockerfile
#	  Dockerfile for OpenJDK-8-jre in a Debian 9.4 container.
#
# =========================================================================
#
# @author Jay Wheeler.
# @version 2.1.0
# @copyright © 2017, 2018. EarthWalk Software.
# @license Licensed under the Academic Free License version 3.0
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
 =========================================================================
# =========================================================================
#
#   Install openjdk-8-jre from the Debian repository.
#
# =========================================================================
FROM ewsdocker/debian-base-gui:3.0.5

MAINTAINER Jay Wheeler <EarthWalkSoftware@gmail.com>

# =========================================================================

RUN apt-get -y update \
 && apt-get -y upgrade \
 && apt-get -y install \
     java-common \
     libgtk2.0-bin \
     libgtk-3-0 \
     libgtk-3-bin \
     libgtk-3-common \ 
     libgtk2.0-0 \
     libgtk2.0-common \
     openjdk-8-jre \
     openjdk-8-jre-headless \
 && apt-get clean all 

# =========================================================================

ENTRYPOINT ["/my_init", "--quiet"]
CMD ["/bin/bash"]

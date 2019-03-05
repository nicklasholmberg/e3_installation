#!/bin/bash
yum -y --setopt=skip_missing_names_on_install=False install epel-release && \
#
# install some basic packages we need
# why sudo? It is used in many of the e3 scripts.
yum install -y --setopt=skip_missing_names_on_install=False git sudo make gcc gcc-c++ && \
#
# install the recommended packages for e3...
git clone https://github.com/jeonghanlee/pkg_automation && \
cd pkg_automation && \
# ...(sed command removes lines intended as comments which start with #)
yum install -y --setopt=skip_missing_names_on_install=False $(sed -e '/^#/d' pkg-common/common pkg-rpm/epics pkg-rpm/ess) && \
cd .. 

# get e3
git clone https://github.com/icshwi/e3 e3-"$1" && \
cd e3-"$1" && \
#
  install epics base with e3
bash e3_building_config.bash -y -t /epics -b "$1" -c "$1" setup && \
bash e3.bash base
bash e3.bash req && \
#
# install the e3 common modules
bash e3.bash -c vars && \
bash e3.bash -c mod

# create a bashrc to set the environment by default
echo "source /e3/tools/setenv" >> /root/.bashrc
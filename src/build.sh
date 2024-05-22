#!/usr/bin/env bash
set -e

# bzip2 required for extracting micromamba
apt update && apt install unzip bzip2 --yes

wget -qO- https://micro.mamba.pm/api/micromamba/linux-64/latest | tar -xvj bin/micromamba
export MAMBA_ROOT_PREFIX=./micromamba
eval "$(./bin/micromamba shell hook --shell=bash)"

micromamba create -n drozer -c conda-forge python=2 openjdk=7.0.161 conda-pack --yes
micromamba activate drozer
pip install twisted protobuf pyopenssl service_identity
git clone https://github.com/WithSecureLabs/drozer
cd drozer
git checkout develop
sed -i "s/version_cmd = ' '/pass #/" setup.py
python setup.py bdist_wheel
pip install dist/drozer-2.4.3-py2-none-any.whl
cd ..

wget https://dl.google.com/android/repository/platform-tools_r33.0.3-linux.zip
unzip platform-tools_r33.0.3-linux.zip -d ./micromamba/envs/drozer/bin/

rm -rf drozer
rm platform-tools_r33.0.3-linux.zip
micromamba clean -a --yes
conda-pack --prefix ./micromamba/envs/drozer/ --output drozer-a80c5f1.tar.gz
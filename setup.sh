#!/usr/bin/env bash

set -e

show_usage() {
  echo "Usage: $(basename $0) takes exactly 1 argument (install | uninstall)"
}

if [ $# -ne 1 ]
then
  show_usage
  exit 1
fi

check_env() {
  if [[ -z "${RALPM_TMP_DIR}" ]]; then
    echo "RALPM_TMP_DIR is not set"
    exit 1
  
  elif [[ -z "${RALPM_PKG_INSTALL_DIR}" ]]; then
    echo "RALPM_PKG_INSTALL_DIR is not set"
    exit 1
  
  elif [[ -z "${RALPM_PKG_BIN_DIR}" ]]; then
    echo "RALPM_PKG_BIN_DIR is not set"
    exit 1
  fi
}

install() {
  wget https://github.com/RAL0S/drozer/releases/download/va80c5f1/drozer-a80c5f1.tar.gz -O $RALPM_TMP_DIR/drozer-a80c5f1.tar.gz
  tar xf $RALPM_TMP_DIR/drozer-a80c5f1.tar.gz -C $RALPM_PKG_INSTALL_DIR/
  rm $RALPM_TMP_DIR/drozer-a80c5f1.tar.gz

  echo '#!/usr/bin/env sh' > $RALPM_PKG_BIN_DIR/drozer
  echo "PATH=$RALPM_PKG_INSTALL_DIR/bin:\$PATH $RALPM_PKG_INSTALL_DIR/bin/drozer \"\$@\"" >> $RALPM_PKG_BIN_DIR/drozer
  chmod +x $RALPM_PKG_BIN_DIR/drozer

  echo "This package adds the command: drozer"
}

uninstall() {
  rm -rf $RALPM_PKG_INSTALL_DIR/*
  rm $RALPM_PKG_BIN_DIR/drozer
}

run() {
  if [[ "$1" == "install" ]]; then 
    install
  elif [[ "$1" == "uninstall" ]]; then 
    uninstall
  else
    show_usage
  fi
}

check_env
run $1
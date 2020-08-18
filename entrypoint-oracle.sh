#!/usr/bin/env bash

PYTHON_VERSION=2.7
export ORACLE_HOME=/opt/instantclient_18_5/
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$ORACLE_HOME
export VERSION=18.5.0.0.0-3
export ARCH=x86_64
export PKG_CONFIG_PATH=$ORACLE_HOME
export TNS_ADMIN=$ORACLE_HOME/network/admin
export PATH=$ORACLE_HOME:$PATH
export LD_RUN_PATH=$ORACLE_HOME

if [[ -f requirements.txt ]]; then
	echo Instalando PIPINSTALL
    pip2.7 install -r requirements.txt
fi

exec /opt/python${PYTHON_VERSION}/bin/pyinstaller $@

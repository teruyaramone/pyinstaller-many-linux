#!/usr/bin/env bash

PYTHON_VERSION=2.7

if [[ -f requirements.txt ]]; then
	echo Instalando PIPINSTALL
    pip2.7 install -r requirements.txt
fi

exec /opt/python${PYTHON_VERSION}/bin/pyinstaller $@ --hidden-import=flask_api.parsers --hidden-import=flask_api.renderers

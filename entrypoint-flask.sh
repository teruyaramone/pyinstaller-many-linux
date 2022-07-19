#!/usr/bin/env bash

PYTHON_VERSION=3.6

if [[ -f requirements.txt ]]; then
	echo Instalando PIPINSTALL
    pip install -r requirements.txt
fi

exec /opt/python${PYTHON_VERSION}/bin/pyinstaller $@ --hidden-import=flask_api.parsers --hidden-import=flask_api.renderers

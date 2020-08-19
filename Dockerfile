FROM teruyaramone/pyinstaller-many-linux:python27

COPY entrypoint-schedule.sh /entrypoint.sh

RUN chmod u+x,g+x /entrypoint.sh
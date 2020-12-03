FROM teruyaramone/pyinstaller-many-linux:python3.6

COPY libaio-0.3.106-5.src.rpm /tmp/libaio-0.3.106-5.src.rpm

#RUN rpm -i /tmp/libaio-0.3.106-5.src.rpm
RUN yum install /tmp/libaio-0.3.106-5.src.rpm

COPY ./instantclient_12_2.tgz/. /opt/instantclient_12_2.tgz

COPY entrypoint-oracle.sh /entrypoint.sh

RUN cd /opt \
    && tar -xvf instantclient_12_2.tgz

ENV ORACLE_HOME=/opt/instantclient_12_2/
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$ORACLE_HOME:/opt/python3.6/lib/
ENV VERSION=12.2.0.1.0
ENV ARCH=x86_64
ENV PKG_CONFIG_PATH=$ORACLE_HOME
ENV TNS_ADMIN=$ORACLE_HOME/network/admin
ENV PATH=$ORACLE_HOME:$PATH:/opt/python3.6/lib/
ENV LD_RUN_PATH=$ORACLE_HOME

ENV LDFLAGS="-L/opt/python3.6/lib"

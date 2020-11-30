# Thanks https://blog.xmatthias.com/compiling-python-3-6-for-centos-5-11-with-openssl/
# for the major part of this Dockerfile
FROM centos:5.11

ARG PYINSTALLER_VERSION=4.1
ARG PYTHON_VERSION=3.6

# As centos5 has reached end of life, some manipulation are needed
# to get "yum" behave as expected in the container
RUN mkdir /var/cache/yum/base/ \
    && mkdir /var/cache/yum/extras/ \
    && mkdir /var/cache/yum/updates/ \
    && mkdir /var/cache/yum/libselinux/ \
    && echo "http://vault.centos.org/5.11/os/x86_64/" > /var/cache/yum/base/mirrorlist.txt \
    && echo "http://vault.centos.org/5.11/extras/x86_64/" > /var/cache/yum/extras/mirrorlist.txt \
    && echo "http://vault.centos.org/5.11/updates/x86_64/" > /var/cache/yum/updates/mirrorlist.txt \
    && echo "http://vault.centos.org/5.11/centosplus/x86_64/" > /var/cache/yum/libselinux/mirrorlist.txt

# http://vault.centos.org/5.11/os/i386/      

# Installing dependencies
RUN yum install -y gcc gcc44 zlib-devel python-setuptools readline-devel wget make perl sqlite-devel zlib-devel bzip2-devel readline-devel tk-devel gdbm-devel db4-devel libpcap-devel xz-devel expat-devel libffi-dev zlib libffi-devel  python3-dev   

# RUN yum install python36 \
#     && yum install python36-devel \
#     && yum install python36-pip \
#     && yum install python36-setuptools \
#     && easy_install-3.6 pip


COPY ./openssl-1.0.2l.tar.gz /tmp/openssl-1.0.2l.tar.gz

RUN cd /tmp \ 
   && tar xzvpf openssl-1.0.2l.tar.gz && cd openssl-1.0.2l \
   && ./config --prefix=/usr/local/ssl --openssldir=/usr/local/ssl \
   && sed -i.orig '/^CFLAG/s/$/ -fPIC/' Makefile \
   && make && make test && make install

# build and install openssl
# RUN cd /tmp && \ #wget https://www.openssl.org/source/openssl-1.0.2l.tar.gz \
#    && tar xzvpf openssl-1.0.2l.tar.gz && cd openssl-1.0.2l \
#    && ./config --prefix=/usr/local/ssl --openssldir=/usr/local/ssl \
#    && sed -i.orig '/^CFLAG/s/$/ -fPIC/' Makefile \
#    && make && make test && make Installing


COPY entrypoint.sh /entrypoint.sh


# build and install python${PYTHON_VERSION}
COPY ./python-for-docker/Python-3.6.8/ /tmp/Python-3.6.8/

RUN cd /tmp/Python-3.6.8/ \
    && ./configure --prefix=/opt/python${PYTHON_VERSION} && make altinstall \
    && ln -s /opt/python${PYTHON_VERSION}/bin/python${PYTHON_VERSION} /usr/local/bin/python${PYTHON_VERSION} \
    && ln -s /opt/python${PYTHON_VERSION}/bin/pip${PYTHON_VERSION} /usr/local/bin/pip${PYTHON_VERSION}


ENV LD_LIBRARY_PATH=/opt/python${PYTHON_VERSION}/lib

ENV PATH=$PATH:/opt/python${PYTHON_VERSION}/bin

COPY get-pip.py /opt/python${PYTHON_VERSION}/bin/get-pip.py

RUN /usr/local/bin/python${PYTHON_VERSION} - --user /opt/python${PYTHON_VERSION}/bin/get-pip.py

RUN  /usr/local/bin/pip${PYTHON_VERSION} install --no-build-isolation -vv pyinstaller \
    && rm -rf /tmp/ && chmod +x /entrypoint.sh

    #==$PYINSTALLER_VERSION   \

RUN mkdir /code
WORKDIR /code

ENTRYPOINT [ "/entrypoint.sh" ]

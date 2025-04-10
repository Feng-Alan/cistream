FROM XXXXX.XXXXX.com/XXX-dev/apollo:dev-x86_64-18.04-20210517_1712

LABEL version="5.8"
LABEL description="integrate apollo and XXX docker"

# set environment
ENV TZ=Asia/Shanghai
ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8
ENV LANGUAGE=C.UTF-8
ENV DEBIAN_FRONTEND=noninteractive

# environment instllation
RUN apt-get update && apt-get install -y ca-certificates \
                                                   gnupg2 \
                                                   tzdata \
                                                   netbase \
                                                   software-properties-common \
                                                   iputils-ping \
                                                   net-tools \
                                                   libtool \
                                                   tcl8.6 \
                                                   tcl8.6-dev \
                                                   ssh

# python3.10 installation and configuration
RUN apt-get update && apt-get install -y build-essential \
                                                   checkinstall \
                                                   libreadline-gplv2-dev \
                                                   libncursesw5-dev \
                                                   libssl-dev \
                                                   libsqlite3-dev \
                                                   tk-dev \
                                                   libgdbm-dev \
                                                   libc6-dev \
                                                   libbz2-dev \
                                                   libffi-dev \
                                                   zlib1g-dev \
                                                   libgdbm-compat-dev \
                                                   libdb-dev

RUN mkdir -p /home/root/app
COPY ./Python-3.10.15.tgz /home/root/app/Python-3.10.15.tgz
RUN cd /home/root/app \
    && tar -xzf Python-3.10.15.tgz \
    && cd Python-3.10.15 \
    && ./configure --enable-optimizations --prefix=/usr --enable-shared \
    && make -j8 \
    && sudo make altinstall

RUN sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.10 0

# XXX build environment prepared
RUN pip install minio

#XXX build environment prepared
RUN apt-get install python3-pip -y
RUN python -m pip install --upgrade pip
RUN pip install --upgrade requests urllib3
RUN pip install boto3
RUN pip install urllib3==1.26.20
RUN pip install pyyaml

# west installation
RUN pip install west -i https://pypi.tuna.tsinghua.edu.cn/simple
 
# temp file cleaning
RUN apt-get clean && rm -rf /tmp/* /var/tmp/*

#XXXbuildtools installation
ADD ./requirements.txt /home/root/app/requirements.txt
ADD ./XXXbuildtools-1.0.0-py310-none-any.whl /home/root/app/XXXbuildtools-1.0.0-py310-none-any.whl

RUN pip install -r /home/root/app/requirements.txt -i https://pypi.tuna.tsinghua.edu.cn/simple
RUN pip install /home/root/app/XXXbuildtools-1.0.0-py310-none-any.whl
RUN pip install west

RUN sudo chmod +x /usr/bin/XXXbuilder
# RUN echo "export PATH=~/.local/bin/:${PATH}" > ~/.bashrc

# remove installation file
RUN cd / \
    && rm -rf /home/root/app

# make workspace
# prepare folders
RUN mkdir -p /home/root/workspace
WORKDIR /home/root/workspace

RUN mkdir -p /home/root/workspace/src
RUN mkdir -p /home/root/workspace/config
RUN mkdir -p /home/root/workspace/build
RUN mkdir -p /home/root/workspace/output

# crosstool installation
RUN mkdir -p /crosstool
COPY ./crosstool/ /crosstool/
RUN ln -s /crosstool /home/root

FROM centos:centos7

# pull centos seven then install asterisk 16 and the testsuite python3 development branch

# make directories
RUN mkdir /var/lib/asterisk
RUN mkdir /var/lib/asterisk/phoneprov
WORKDIR /usr/src
# created to mount volume or bind later
RUN mkdir asterisk
RUN mkdir ast-tools

# core
RUN yum -y install git wget
RUN yum -y groupinstall core base "Development Tools"
RUN yum -y install python3 python3-pip python3-devel
RUN yum -y install libedit-devel libpcap-devel openssl-devel lksctp-tools-devel gsl-devel lua-devel libuuid-devel
# extras
RUN yum -y install epel-release

# optionally, but now's the time
RUN yum -y update

# Get asterisk 16
WORKDIR /usr/src/asterisk
RUN git clone "https://gerrit.asterisk.org/asterisk"
WORKDIR /usr/src/asterisk/asterisk
RUN git checkout 16
# Build asterisk so the test suite
RUN contrib/scripts/install_prereq install
RUN ./configure --enable-dev-mode --disable-binary-modules --with-jansson-bundled --with-pjproject-bundled
RUN make menuselect.makeopts
RUN menuselect/menuselect --enable DONT_OPTIMIZE menuselect.makeopts
RUN menuselect/menuselect --enable TEST_FRAMEWORK menuselect.makeopts
RUN menuselect/menuselect --enable MALLOC_DEBUG menuselect.makeopts
RUN menuselect/menuselect --enable DO_CRASH menuselect.makeopts
RUN menuselect/menuselect --disable COMPILE_DOUBLE menuselect.makeopts
RUN make
RUN make install
RUN make samples

# set python 3 as default, after all yum commands are complete
RUN rm /usr/bin/python
RUN ln -s /usr/bin/python3 /usr/bin/python
RUN ln -s /usr/bin/pip3 /usr/bin/pip
# Tag the latest branch/review- you can always replace the checked out version
WORKDIR /usr/src/asterisk
RUN git clone "https://gerrit.asterisk.org/testsuite"
WORKDIR /usr/src/asterisk/testsuite
RUN git fetch https://gerrit.asterisk.org/testsuite refs/changes/28/18528/12 && git checkout FETCH_HEAD
WORKDIR /usr/src/asterisk/testsuite/asttest
RUN make
RUN make install

# get pip ready
RUN python -m pip install --upgrade pip
RUN python -m pip install setuptools-rust
RUN python -m pip install Cython

# use supplied requirements from testsuite
# do not need a venv as this container already serves this purpose
WORKDIR /usr/src/asterisk/testsuite
RUN python -m pip install -r requirements.txt
RUN python -m pip install -r extras.txt

# yappcap acts odd when installed from requirements
WORKDIR /usr/src/ast-tools
RUN git clone https://github.com/asterisk/yappcap.git
RUN python -m pip install ./yappcap


# Old sipp downloads based on tags no longer recommended
WORKDIR /usr/src/ast-tools
RUN wget https://github.com/SIPp/sipp/releases/download/v3.6.0/sipp-3.6.0.tar.gz
RUN tar -xf sipp-3.6.0.tar.gz
WORKDIR /usr/src/ast-tools/sipp-3.6.0
RUN ./build.sh --prefix=/usr --with-openssl --with-pcap --with-rtpstream --with-sctp --with-gsl CFLAGS=-w
RUN make install

# Ready to rock and roll
WORKDIR /usr/src/asterisk/testsuite

FROM ubuntu:17.04

MAINTAINER William Stein <wstein@sagemath.com>

USER root

# See https://github.com/sagemathinc/cocalc/issues/921
ENV LC_ALL C.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV TERM screen

# So we can source (see http://goo.gl/oBPi5G)
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# Ubuntu software that are used by CoCalc (latex, pandoc, sage, jupyter)
RUN \
     apt-get update \
  && apt-get install -y \
       software-properties-common \
       texlive \
       texlive-latex-extra \
       texlive-xetex \
       tmux \
       flex \
       bison \
       libreadline-dev \
       htop \
       screen \
       pandoc \
       aspell \
       poppler-utils \
       net-tools \
       wget \
       git \
       python \
       python-pip \
       make \
       g++ \
       sudo \
       psmisc \
       haproxy \
       nginx \
       vim \
       bup \
       inetutils-ping \
       lynx \
       telnet \
       git \
       emacs \
       subversion \
       ssh \
       m4 \
       latexmk \
       libpq5 \
       libpq-dev \
       build-essential \
       gfortran \
       automake \
       dpkg-dev \
       libssl-dev \
       imagemagick \
       libcairo2-dev \
       libcurl4-openssl-dev \
       graphviz \
       smem \
       python3-yaml \
       locales \
       locales-all

# Jupyter from pip (since apt-get jupyter is ancient)
RUN \
  pip install "ipython<6" jupyter

RUN useradd -m main && echo "main:main" | chpasswd && adduser main sudo
RUN echo "main:main" | chpasswd && adduser main sudo

#### without password
RUN passwd --delete main
#### MAIN USER ####
USER main

RUN jupyter notebook --generate-config
ADD jupyter_notebook_config.py jupyter_notebook_config.py
RUN cp jupyter_notebook_config.py /home/main/.jupyter/
RUN sudo pip install plotly

# M4: macro processing language
RUN sudo apt-get update
RUN sudo apt-get -y install m4

# GMP LIB
RUN wget https://gmplib.org/download/gmp/gmp-6.1.2.tar.bz2
RUN tar -xvf gmp-6.1.2.tar.bz2 
RUN rm -f gmp-6.1.2.tar.bz2 
RUN cd ./gmp-6.1.2/ && ./configure && make && sudo make install && cd ../

# MPFR
RUN wget http://www.mpfr.org/mpfr-current/mpfr-4.0.0.tar.gz
RUN tar -xvf mpfr-4.0.0.tar.gz
RUN rm -f mpfr-4.0.0.tar.gz
RUN cd ./mpfr-4.0.0/ && ./configure && make && sudo make install && cd ../

# FLINT2
#- git clone --depth=50 --branch=master https://github.com/fredrik-johansson/flint2.git
RUN git clone https://github.com/fredrik-johansson/flint2.git
RUN cd ./flint2/ && ./configure && make && sudo make install && cd ../

# ARB
RUN git clone https://github.com/fredrik-johansson/arb.git
RUN cd ./arb/ && ./configure && make && sudo make install && cd ../

# python-flint
RUN sudo apt-get -y install cython python-dev
# RUN sudo pip install python-flint

RUN git clone https://github.com/fredrik-johansson/python-flint.git
RUN cd ./python-flint \
 && python ./setup.py build_ext --include-dirs=/home/main/flint2:/home/main/arb --library-dirs=/home/main/flint2:/home/main/arb \
 && python setup.py install \
 && cd ../
 
# flint path for PYTHON 2
ENV export LD_LIBRARY_PATH=/home/main/flint2:/home/main/arb:$LD_LIBRARY_PATH

# flint path solution for Jupyter (python 2 kernel)
RUN cp /home/main/flint2/libflint.so.13 anaconda2/lib/ \
 && cp -rf /home/main/arb/libarb.so.2* /home/main/anaconda2/lib/

# flint path for PYTHON 3 (I hope)
#RUN sudo pip install python-flint
RUN sudo pip --version

# symengine python 2 and 3
#RUN sudo pip2 install symengine
#RUN sudo pip install symengine


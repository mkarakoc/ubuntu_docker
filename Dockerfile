FROM ubuntu:16.04

MAINTAINER Mesut Karakoç <...@sagemath.com>
#https://github.com/jupyter/docker-stacks/blob/master/base-notebook/Dockerfile

###################
USER root
###################

# See https://github.com/sagemathinc/cocalc/issues/921
ENV LC_ALL C.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV TERM screen

# So we can source (see http://goo.gl/oBPi5G)
#RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# Ubuntu software that are used by CoCalc (latex, pandoc, sage, jupyter)
RUN \
     apt-get install -y \
       software-properties-common \
       wget \
       git \
       python \
       python-pip \
       make \
       g++ \
       sudo \
       subversion \
       ssh \
       m4 \
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

## create password-less user
RUN useradd -m main && echo "main:main" | chpasswd && adduser main sudo
RUN echo "main:main" | chpasswd && adduser main sudo

#### without password
RUN passwd --delete main

#### MAIN USER ####
USER main
###################

# Jupyter from pip (since apt-get jupyter is ancient)
RUN \
  sudo pip install "ipython<6" jupyter

RUN jupyter notebook --generate-config
ADD jupyter_notebook_config.py jupyter_notebook_config.py
RUN cp jupyter_notebook_config.py /home/main/.jupyter/
RUN sudo pip install plotly


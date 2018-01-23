FROM ubuntu:16.04

MAINTAINER Mesut Karakoç <...@sagemath.com>
#https://github.com/jupyter/docker-stacks/blob/master/base-notebook/Dockerfile

###################
USER root
###################

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


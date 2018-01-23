FROM ubuntu:latest

MAINTAINER Mesut Karakoç <...@sagemath.com>
#https://github.com/jupyter/docker-stacks/blob/master/base-notebook/Dockerfile

###################
USER root
###################

RUN \
     apt-get install -y sudo

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
  pip install "ipython<6" jupyter

RUN jupyter notebook --generate-config
ADD jupyter_notebook_config.py jupyter_notebook_config.py
RUN cp jupyter_notebook_config.py /home/main/.jupyter/



#####################################################################
# Dockerfile for Creating Pytorch + JupyterLab Containers
# For Traning things in Computer Vision
# Author: Theppasith N. <tutorgaming@gmail.com>
# Date: 6-May-2023
#####################################################################

#####################################################################
# 1. Base Image and Essential Things
#####################################################################

# Base Image from Nvidia (CUDA 11.8 + Ubuntu 20.04)
FROM nvidia/cuda:11.8.0-base-ubuntu20.04

# Base as Default Shell
ENV SHELL=/bin/bash

# Working Directory (First Remote in)
WORKDIR /workspace

# Install Essential things
RUN apt-get update && apt-get install -y \
    python3-pip \
    apt-utils \
    vim \
    git \
    wget \
    curl \
    net-tools

#####################################################################
# 2. Install Python 3.9 (JupyterLab need 3.9)
#####################################################################

# Install Timezone Data (tzdata) for software-properties-common (repo manager)
RUN ln -fs /usr/share/zoneinfo/UTC /etc/localtime
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y tzdata
RUN dpkg-reconfigure --frontend noninteractive tzdata

# Install Custom Repository Manager
RUN apt-get install software-properties-common -y

# Install py39 from deadsnakes repository
RUN add-apt-repository ppa:deadsnakes/ppa -y
RUN apt-get install python3.9 -y

# Install pip from standard ubuntu packages
RUN apt-get install python3-pip -y

# Link alias python='python3'
RUN ln -s /usr/bin/python3 /usr/bin/python

#####################################################################
# 3. Install NodeJS (for jupyterlab)
#####################################################################

# Install through NodeJS Version Manager (NVM)
RUN mkdir /usr/local/nvm
ENV NVM_DIR /usr/local/nvm
ENV NODE_VERSION 14.18.1
RUN curl https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash \
    && . $NVM_DIR/nvm.sh \
    && nvm install $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && nvm use default

ENV NODE_PATH $NVM_DIR/v$NODE_VERSION/lib/node_modules
ENV PATH $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH

#####################################################################
# 4. Install Pytorch Numpy and JupyterLab
#####################################################################

# Pip Essentials for Deep Learning
RUN pip3 install --upgrade setuptools pip
RUN pip install \
    numpy \
    scikit-learn \
    scikit-image \
    scipy \
    torch \
    torchvision \
    torchsummary \
    torchinfo \
    jupyterlab \
    pandas \
    matplotlib \
    plotly \
    tqdm \
    pillow \
    tensorflow \
    tensorboardcolab \
    tensorboard

#####################################################################
# 5. Install OpenCV
#####################################################################

# Install OpenCV base with Apt (For Dependencies gathering also)
RUN apt-get update && apt-get install python3-opencv libgl1 libglib2.0-dev -y
# Install OpenCV Contrib version of Python
RUN pip install opencv-contrib-python

#####################################################################
# 6. Install JupyterLab Extension
#####################################################################

# Install From PIP
RUN pip install \
    jupyterlab-horizon-theme \
    jupyterlab-git \
    jupyterlab-lsp \
    jupyterlab-system-monitor \
    lckr-jupyterlab-variableinspector \
    ipympl

# Code completion Language Server
RUN pip install \
    jedi-language-server

# Enable Extensions
COPY ./jupyterlab-setting/overrides.json /usr/local/share/jupyter/lab/settings/

#####################################################################
# 7. Install Misc.
#####################################################################
RUN pip install tz

#####################################################################
# Start Jupyter lab at Port 8888
#####################################################################

CMD ["jupyter", "lab", "--ip=0.0.0.0", "--port=8888", "--allow-root", "--no-browser"]
EXPOSE 8888

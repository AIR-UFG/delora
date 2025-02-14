# https://hub.docker.com/layers/rapidsai/ci-conda/cuda12.0.1-ubuntu20.04-py3.9/images/sha256-4916d0e7a8b30dab50a544c63fce2a1c327046ce7832629bfbdbf7157966a818?context=explore

FROM rapidsai/ci-conda:cuda12.0.1-ubuntu20.04-py3.9 

RUN apt update && apt install -y \
    git \
    nano \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release \
    && rm -rf /var/lib/apt/lists/*

# Install ros noetic
ENV DEBIAN_FRONTEND=noninteractive

RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list' && \
    curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | apt-key add - && \
    apt update && \
    apt install -y ros-noetic-desktop-full \
    ros-noetic-ros-numpy \
    python3-rosdep \
    python3-rosinstall \
    python3-rosinstall-generator \
    python3-wstool \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

RUN rosdep init && \
    rosdep update

COPY . /root/delora

WORKDIR /root/delora

RUN conda env create -f conda/DeLORA-py3.9.yml

RUN pip3 install -e .

RUN pip3 install mlflow jupyterlab

RUN echo "source /opt/ros/noetic/setup.bash" >> ~/.bashrc && \
    echo "conda init" >> ~/.bashrc && \
    echo "conda activate DeLORA-py3.9" >> ~/.bashrc

CMD ["/bin/bash"]
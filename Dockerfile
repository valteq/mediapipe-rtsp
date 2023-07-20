FROM nvidia/cuda:11.1.1-cudnn8-devel-ubuntu20.04

WORKDIR /io
WORKDIR /mediapipe_rtsp

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
        build-essential \
        gcc-8 g++-8 \
        ca-certificates \
        curl \
        ffmpeg \
        git \
        wget \
        unzip \
        nodejs \
        npm \
        python3-dev \
        python3-opencv \
        python3-pip \
        libopencv-core-dev \
        libopencv-highgui-dev \
        libopencv-imgproc-dev \
        libopencv-video-dev \
        libopencv-calib3d-dev \
        libopencv-features2d-dev \
        software-properties-common && \
    add-apt-repository -y ppa:openjdk-r/ppa && \
    apt-get update && apt-get install -y openjdk-8-jdk && \
    apt-get install -y mesa-common-dev libegl1-mesa-dev libgles2-mesa-dev && \
    apt-get install -y mesa-utils && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-8 100 --slave /usr/bin/g++ g++ /usr/bin/g++-8
RUN pip3 install --upgrade setuptools
RUN pip3 install wheel
RUN pip3 install future
RUN pip3 install absl-py numpy opencv-contrib-python protobuf==3.20.1
RUN pip3 install six==1.14.0
RUN pip3 install tensorflow
RUN pip3 install tf_slim

RUN ln -s /usr/bin/python3 /usr/bin/python

# Install bazel
ARG BAZEL_VERSION=6.1.1
RUN mkdir /bazel && \
    wget --no-check-certificate -O /bazel/installer.sh "https://github.com/bazelbuild/bazel/releases/download/${BAZEL_VERSION}/b\
azel-${BAZEL_VERSION}-installer-linux-x86_64.sh" && \
    wget --no-check-certificate -O  /bazel/LICENSE.txt "https://raw.githubusercontent.com/bazelbuild/bazel/master/LICENSE" && \
    chmod +x /bazel/installer.sh && \
    /bazel/installer.sh  && \
    rm -f /bazel/installer.sh
# If we want the docker image to contain the pre-built object_detection_offline_demo binary, do the following
# RUN bazel build -c opt --define MEDIAPIPE_DISABLE_GPU=1 mediapipe/examples/desktop/demo:object_detection_tensorflow_demo

##############################
# install mediapipe python package
RUN pip install mediapipe==0.10.2
RUN pip uninstall -y opencv-contrib-python
RUN pip uninstall opencv-python
RUN rm -rf /usr/lib/python3/dist-packages/cv2.cpython-38-x86_64-linux-gnu.so

##############################
# opencv
WORKDIR /
RUN apt update && apt install -y cmake libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev gstreamer1.0-plugins-ugly gstreamer1.0-rtsp python3-dev python3-numpy
RUN git clone --depth=1 -b 4.5.4 https://github.com/opencv/opencv
RUN cd opencv && \
    mkdir build && cd build && \
    cmake -D CMAKE_INSTALL_PREFIX=/usr -D WITH_GSTREAMER=ON .. && \
    make -j$(nproc)  && \
    make install 

RUN mkdir /usr/lib/python3.8/dist-packages
RUN ln -s /usr/lib/python3.8/site-packages/cv2 /usr/lib/python3.8/dist-packages/

################################
COPY . /mediapipe_rtsp/

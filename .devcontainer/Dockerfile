FROM mcr.microsoft.com/devcontainers/base:ubuntu-22.04

ARG DEBIAN_FRONTEND=noninteractive
ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=1000
ARG ZEPHYR_SDK_VERSION=0.16.5

# Core build dependencies for ZMK/Zephyr
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    ccache \
    cmake \
    device-tree-compiler \
    dfu-util \
    file \
    git \
    gperf \
    libffi-dev \
    libssl-dev \
    libusb-1.0-0 \
    ninja-build \
    patch \
    python3 \
    python3-dev \
    python3-pip \
    python3-setuptools \
    python3-venv \
    python3-wheel \
    unzip \
    wget \
    xz-utils \
  && rm -rf /var/lib/apt/lists/*

# Ensure the vscode user matches the host UID/GID when provided
RUN if [ "$(id -u ${USERNAME})" != "${USER_UID}" ]; then \
      usermod -u ${USER_UID} ${USERNAME}; \
    fi \
 && if [ "$(id -g ${USERNAME})" != "${USER_GID}" ]; then \
      groupmod -g ${USER_GID} ${USERNAME}; \
    fi

# Install west globally for convenience inside the container
RUN pip3 install --no-cache-dir --upgrade pip \
 && pip3 install --no-cache-dir west

# Install the minimal Zephyr SDK (ARM toolchain is sufficient for nice!nano targets)
RUN wget -q https://github.com/zephyrproject-rtos/sdk-ng/releases/download/v${ZEPHYR_SDK_VERSION}/zephyr-sdk-${ZEPHYR_SDK_VERSION}_linux-x86_64_minimal.tar.xz \
 && tar -xJf zephyr-sdk-${ZEPHYR_SDK_VERSION}_linux-x86_64_minimal.tar.xz -C /opt \
 && /opt/zephyr-sdk-${ZEPHYR_SDK_VERSION}/setup.sh -t arm-zephyr-eabi \
 && rm zephyr-sdk-${ZEPHYR_SDK_VERSION}_linux-x86_64_minimal.tar.xz

ENV ZEPHYR_TOOLCHAIN_VARIANT=zephyr
ENV ZEPHYR_SDK_INSTALL_DIR=/opt/zephyr-sdk-${ZEPHYR_SDK_VERSION}
ENV PATH=${ZEPHYR_SDK_INSTALL_DIR}/arm-zephyr-eabi/bin:${PATH}
ENV CCACHE_DIR=/workspaces/.ccache

USER ${USERNAME}

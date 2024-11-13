FROM mcr.microsoft.com/devcontainers/java:1-17-bullseye

RUN export DEBIAN_FRONTEND=noninteractive \
    && apt-get update \
    && apt-get install -y xdg-utils \
    && apt-get clean -y && rm -rf /var/lib/apt/lists/* 

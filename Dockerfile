FROM --platform=$TARGETPLATFORM debian:buster-slim

ARG BUILD_VERSION
ARG BUILD_DATE
ARG DEBIAN_FRONTEND=noninteractive

ARG CHROMEDP_VERSION=106.0.5238.1
ARG CHROMEDP_PORT=9222

LABEL org.label-schema.name="f4bio/docker-chromedp-headless-shell"
LABEL org.label-schema.description="Minimal container for Chrome's headless shell, useful for automating / driving the web"
LABEL org.label-schema.url="https://github.com/f4bio/docker-chromedp-headless-shell"
LABEL org.label-schema.application="chromedp-headless-shell"
LABEL org.label-schema.build-date=$BUILD_DATE
LABEL org.label-schema.version=$BUILD_VERSION
LABEL org.opencontainers.image.source="https://github.com/chromedp/headless-shell"

# Update system, install required & additional libraries
RUN apt-get --yes update \
  && apt-get --yes install \
  software-properties-common \
  unzip \
  git \
  gnupg \
  curl \
  ca-certificates \
  icecc ccache \
  libnspr4 libnss3 libexpat1 libfontconfig1 libuuid1
WORKDIR /workspace
COPY . .
RUN git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git
WORKDIR /workspace/chromium
RUN /workspace/depot_tools/fetch --nohooks chromium
WORKDIR /workspace/chromium/src
RUN /workspace/build-headless-shell.sh

# !DEV ONLY!
RUN apt-get --yes install nano bash

ENTRYPOINT [ "/bin/bash" ]

# COPY \
#     /workspace/out/$VERSION/headless-shell/headless-shell \
#     /workspace/out/$VERSION/headless-shell/.stamp \
#     /workspace/out/$VERSION/headless-shell/libEGL.so \
#     /workspace/out/$VERSION/headless-shell/libGLESv2.so \
#     /workspace/out/$VERSION/headless-shell/libvk_swiftshader.so \
#     /workspace/out/$VERSION/headless-shell/libvulkan.so.1 \
#     /workspace/out/$VERSION/headless-shell/vk_swiftshader_icd.json \
#     /headless-shell/
# EXPOSE 9222
# ENV LANG en-US.UTF-8
# ENV PATH /headless-shell:$PATH
# ENTRYPOINT [ "/headless-shell/headless-shell", "--no-sandbox", "--use-gl=angle", "--use-angle=swiftshader", "--remote-debugging-address=0.0.0.0", "--remote-debugging-port=9222" ]

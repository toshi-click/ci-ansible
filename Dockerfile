FROM ubuntu:18.04

RUN apt update && \
  apt upgrade -y && \
  apt -y install language-pack-ja-base language-pack-ja && \
  #    apt -y install locales task-japanese && \
  locale-gen ja_JP.UTF-8 && \
  rm -rf /var/lib/apt/lists/*

# set TimeZone
ENV TZ Asia/Tokyo
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# コンテナのデバッグ等で便利なソフト導入しておく
RUN apt update && \
  apt upgrade -y && \
  apt -y install vim git curl wget zip unzip net-tools iproute2 iputils-ping && \
  rm -rf /var/lib/apt/lists/*

# ansible
RUN apt update && \
  apt upgrade -y && \
  apt -y install ansible && \
  rm -rf /var/lib/apt/lists/*

## python
RUN apt update && \
  apt upgrade -y && \
  apt -y install python3-distutils && \
  curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py && \
  python3 get-pip.py && \
  pip install -U pip && \
  mkdir /code && \
  rm -rf /var/lib/apt/lists/* && \
  pip install ansible-lint awscli

# gcloud
# バージョンはhttps://console.cloud.google.com/storage/browser/cloud-sdk-release?authuser=0&pli=1 を確認
ARG CLOUD_SDK_VERSION=261.0.0
ENV CLOUD_SDK_VERSION=$CLOUD_SDK_VERSION
ENV PATH /google-cloud-sdk/bin:$PATH
RUN apt update && \
  apt upgrade -y && \
  apt -y install curl python && \
  curl -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz && \
  tar xzf google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz && \
  rm google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz && \
  gcloud components install kubectl && \
  gcloud config set core/disable_usage_reporting true && \
  gcloud config set component_manager/disable_update_check true && \
  gcloud config set metrics/environment github_docker_image

CMD ["/bin/bash"]

## ⚠️ INTENTIONALLY VULNERABLE IMAGE – FOR STO TESTING ONLY
FROM registry.access.redhat.com/ubi8/ubi:latest

USER root

# --------------------------------------------------
# Install OS packages with known CVEs
# --------------------------------------------------
RUN yum install -y \
    openssl \
    openssl-libs \
    curl \
    libcurl \
    bash \
    sudo \
    libxml2 \
    libxslt \
    tar \
    gzip \
    vim-minimal \
    java-1.8.0-openjdk \
    && yum clean all

# --------------------------------------------------
# Install Python and vulnerable Python dependencies
# --------------------------------------------------
RUN yum install -y python3 python3-pip && \
    pip3 install \
      django==2.2.28 \
      flask==1.0.2 \
      requests==2.19.1 \
      pyyaml==5.3 \
      cryptography==2.8 \
      urllib3==1.24.3

# --------------------------------------------------
# Install Node.js and vulnerable npm dependencies
# --------------------------------------------------
RUN curl -sL https://rpm.nodesource.com/setup_14.x | bash - && \
    yum install -y nodejs && \
    npm install -g \
      lodash@4.17.19 \
      minimist@0.0.8 \
      express@4.16.0

# --------------------------------------------------
# App setup
# --------------------------------------------------
WORKDIR /app
ADD ./run.py /app
ADD ./sqli /app/sqli
ADD ./config /app/config

## build image containing the required foundation artifacts
FROM registry.access.redhat.com/ubi8/ubi:latest
USER root
WORKDIR /foundation
ENV PYTHON ${PYTHON_VERSION_UBI}

COPY requirements.txt /tmp
RUN rm -rf /tmp/requirements.txt

WORKDIR /app
ADD ./run.py /app
ADD ./sqli /app/sqli
ADD ./config /app/config
 Build image containing the required foundation artifacts
FROM registry.access.redhat.com/ubi8/ubi:latest

USER root
WORKDIR /foundation

# Install a few packages with known vulnerabilities
RUN yum install -y \
    openssl-1.1.1 \
    curl \
    wget \
    && yum clean all

ENV PYTHON ${PYTHON_VERSION_UBI}
COPY requirements.txt /tmp
RUN pip3 install --no-cache-dir -r /tmp/requirements.txt

# Install a couple of vulnerable npm packages
RUN yum install -y nodejs npm && \
    npm install -g lodash@4.17.4 express@4.16.0

RUN rm -rf /tmp/requirements.txt

WORKDIR /app
ADD ./run.py /app
ADD ./sqli /app/sqli
ADD ./config /app/config

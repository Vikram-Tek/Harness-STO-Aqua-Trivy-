## build image containing the required foundation artifacts
FROM registry.access.redhat.com/ubi8/ubi:latest
USER root
WORKDIR /foundation

# ADD THESE NEW LINES HERE:
RUN yum install -y \
    openssl-1.1.1 \
    curl \
    wget \
    && yum clean all

RUN yum install -y nodejs npm && \
    npm install -g lodash@4.17.4 express@4.16.0
# END OF NEW LINES

ENV PYTHON ${PYTHON_VERSION_UBI}
COPY requirements.txt /tmp
WORKDIR /app
ADD ./run.py /app
ADD ./sqli /app/sqli
ADD ./config /app/config

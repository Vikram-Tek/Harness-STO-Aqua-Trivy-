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
RUN rm -rf /tmp/requirements.txt
ENV PYTHON ${PYTHON_VERSION_UBI}
COPY requirements.txt /tmp
RUN pip3 install Django==2.0.13 requests==2.6.0 urllib3==1.24.1 pyyaml==5.3.1 pillow==6.2.0
RUN pip3 install --no-cache-dir -r /tmp/requirements.txt
RUN rm -rf /tmp/requirements.txt
WORKDIR /app
ADD ./run.py /app
ADD ./sqli /app/sqli
ADD ./config /app/config

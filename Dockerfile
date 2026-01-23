## build image containing the required foundation artifacts
FROM registry.redhat.io/ubi8/ubi:8.10-1766090767 --confirm
USER root
WORKDIR /foundation
ENV PYTHON ${PYTHON_VERSION_UBI}

COPY requirements.txt /tmp
RUN rm -rf /tmp/requirements.txt

WORKDIR /app
ADD ./run.py /app
ADD ./sqli /app/sqli
ADD ./config /app/config

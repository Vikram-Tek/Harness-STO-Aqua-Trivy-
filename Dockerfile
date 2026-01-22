# Build image containing the required foundation artifacts
FROM registry.access.redhat.com/ubi8/ubi:latest

USER root
WORKDIR /foundation

ENV PYTHON ${PYTHON_VERSION_UBI}

# Install Python and pip
RUN yum install -y python38 python38-pip && yum clean all

# Install vulnerable Python packages that Trivy will detect
RUN pip3 install --no-cache-dir \
    Django==2.0.13 \
    requests==2.6.0 \
    urllib3==1.24.1 \
    pyyaml==5.3.1 \
    pillow==6.2.0 \
    jinja2==2.10.1 \
    cryptography==2.3

# Copy and install additional requirements
COPY requirements.txt /tmp
RUN pip3 install --no-cache-dir -r /tmp/requirements.txt
RUN rm -rf /tmp/requirements.txt

WORKDIR /app
ADD ./run.py /app
ADD ./sqli /app/sqli
ADD ./config /app/config

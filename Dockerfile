# Vulnerable Dockerfile for Security Testing
FROM registry.access.redhat.com/ubi8/ubi:latest

USER root
WORKDIR /foundation

# Use older, vulnerable versions of system packages
RUN yum install -y \
    openssl-1.1.1 \
    curl \
    wget \
    git \
    gcc \
    make \
    mysql \
    postgresql \
    sqlite \
    libxml2 \
    libxslt \
    java-1.8.0-openjdk \
    nodejs \
    npm \
    && yum clean all

# Install Python with known vulnerabilities
ENV PYTHON ${PYTHON_VERSION_UBI}
RUN yum install -y python38 python38-devel python38-pip

# Copy and install vulnerable Python packages
COPY requirements.txt /tmp
RUN pip3 install --no-cache-dir -r /tmp/requirements.txt

# Install additional vulnerable npm packages
RUN npm install -g \
    express@4.16.0 \
    lodash@4.17.4 \
    jquery@2.1.4 \
    minimist@1.2.0 \
    axios@0.18.0 \
    moment@2.19.3 \
    bootstrap@3.3.7

# Install vulnerable Ruby gems (install ruby first)
RUN yum install -y ruby ruby-devel rubygems && \
    gem install rails -v 4.2.0 && \
    gem install rack -v 1.6.0 && \
    gem install nokogiri -v 1.8.0

# Add outdated Java libraries with vulnerabilities
RUN mkdir -p /app/lib
WORKDIR /app/lib
RUN wget -q https://repo1.maven.org/maven2/commons-collections/commons-collections/3.2.1/commons-collections-3.2.1.jar && \
    wget -q https://repo1.maven.org/maven2/org/apache/struts/struts2-core/2.3.20/struts2-core-2.3.20.jar && \
    wget -q https://repo1.maven.org/maven2/log4j/log4j/1.2.17/log4j-1.2.17.jar

# Install vulnerable Go packages
RUN yum install -y golang && \
    go get github.com/gorilla/websocket@v1.4.0 && \
    go get gopkg.in/yaml.v2@v2.2.1

# Add ImageMagick with known CVEs
RUN yum install -y ImageMagick-6.9.10

# Install vulnerable compression libraries
RUN yum install -y \
    zlib-1.2.7 \
    bzip2-1.0.6

# Clean up requirements.txt
RUN rm -rf /tmp/requirements.txt

# Set up application directory
WORKDIR /app
ADD ./run.py /app
ADD ./sqli /app/sqli
ADD ./config /app/config

# Create directories with insecure permissions (additional security issues)
RUN mkdir -p /app/uploads /app/temp && \
    chmod 777 /app/uploads /app/temp

# Run as root (security anti-pattern)
USER root

# Expose multiple ports
EXPOSE 8080 3306 5432 27017 6379

# Add a vulnerable entrypoint script
RUN echo '#!/bin/bash' > /app/entrypoint.sh && \
    echo 'python3 /app/run.py' >> /app/entrypoint.sh && \
    chmod +x /app/entrypoint.sh

ENTRYPOINT ["/app/entrypoint.sh"]

FROM registry.access.redhat.com/ubi8/ubi:latest
USER root

# Install Python and pip first
# RUN yum install -y python3 python3-pip gcc gcc-c++ make && yum clean all

# # Install intentionally vulnerable Python dependencies (for STO baseline testing)
# RUN pip3 install \
#     Django==2.2.0 \
#     Flask==0.12.2 \
#     requests==2.19.1 \
#     urllib3==1.24.1 \
#     PyYAML==3.13 \
#     jsonschema==2.6.0 \
#     cryptography==2.3 \
#     pyjwt==1.7.1 \
#     Jinja2==2.10 \
#     MarkupSafe==1.0 \
#     lightgbm==2.2.3 \
#     numpy==1.16.0 \
#     pandas==0.24.2 \
#     Pillow==6.0.0 \
#     lxml==4.2.1

WORKDIR /app
ADD ./run.py /app
ADD ./sqli /app/sqli
ADD ./config /app/config

FROM ubuntu:latest

USER root

# Install dependencies
RUN apt-get update && apt-get install -y \
    tar \
    gnupg \
    glibc-tools \
    libglib2.0-0t64 \
    openssl \
    libc6 \ 
    wget

USER ubuntu
RUN cd /tmp && wget https://d3gcli72yxqn2z.cloudfront.net/downloads/connect/latest/bin/ibm-aspera-connect_4.2.13.820_linux_x86_64.tar.gz && tar xvfz ibm-aspera-connect_4.2.13.820_linux_x86_64.tar.gz && bash ibm-aspera-connect_4.2.13.820_linux_x86_64.sh

RUN wget https://ftp-trace.ncbi.nlm.nih.gov/sra/sdk/3.2.0/sratoolkit.3.2.0-ubuntu64.tar.gz && tar xvzf sratoolkit.3.2.0-ubuntu64.tar.gz

# Set the default command to run bash
CMD ["bash"]

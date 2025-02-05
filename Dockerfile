# Use a specific version of the Ubuntu image
FROM ubuntu:24.04
LABEL maintainer="Alisa Manning"

# Install dependencies
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y wget && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

USER ubuntu
WORKDIR /home/ubuntu
# Download and install IBM Aspera Connect
RUN wget https://d3gcli72yxqn2z.cloudfront.net/downloads/connect/latest/bin/ibm-aspera-connect_4.2.13.820_linux_x86_64.tar.gz && \
    tar -xvzf ibm-aspera-connect_4.2.13.820_linux_x86_64.tar.gz && \
    rm ibm-aspera-connect_4.2.13.820_linux_x86_64.tar.gz && \
    bash ibm-aspera-connect_4.2.13.820_linux_x86_64.sh && \
    rm ibm-aspera-connect_4.2.13.820_linux_x86_64.sh

# Download and extract SRA toolkit
RUN wget https://ftp-trace.ncbi.nlm.nih.gov/sra/sdk/3.2.0/sratoolkit.3.2.0-ubuntu64.tar.gz && \
    tar -xvzf sratoolkit.3.2.0-ubuntu64.tar.gz && \
    rm sratoolkit.3.2.0-ubuntu64.tar.gz

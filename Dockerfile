# Use a specific version of the Ubuntu image
FROM ubuntu:24.04
LABEL maintainer="Alisa Manning"

# Install dependencies
RUN apt-get update && apt-get upgrade -y && \
    #apt-get install -y \
#    gnupg \
#    glibc-tools \
#    libglib2.0-0t64 \
#    openssl \
#    libc6 && \
    apt-get install -y wget && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*


# Download and install IBM Aspera Connect

#ADD --chown=ubuntu --chmod=644 https://d3gcli72yxqn2z.cloudfront.net/downloads/connect/latest/bin/ibm-aspera-connect_4.2.13.820_linux_x86_64.tar.gz /home/ubuntu/
ADD  --chown=ubuntu --chmod=644 https://ftp-trace.ncbi.nlm.nih.gov/sra/sdk/3.2.0/sratoolkit.3.2.0-ubuntu64.tar.gz /home/ubuntu/

USER ubuntu
WORKDIR /home/ubuntu
#RUN
RUN wget https://d3gcli72yxqn2z.cloudfront.net/downloads/connect/latest/bin/ibm-aspera-connect_4.2.13.820_linux_x86_64.tar.gz && \
    tar -xvzf ibm-aspera-connect_4.2.13.820_linux_x86_64.tar.gz && \
    rm ibm-aspera-connect_4.2.13.820_linux_x86_64.tar.gz && \
    bash ibm-aspera-connect_4.2.13.820_linux_x86_64.sh && \
    rm ibm-aspera-connect_4.2.13.820_linux_x86_64.sh


# Download and extract SRA toolkit
#RUN tar -xvzf sratoolkit.3.2.0-ubuntu64.tar.gz && \
#    rm sratoolkit.3.2.0-ubuntu64.tar.gz

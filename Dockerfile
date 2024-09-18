FROM ubuntu:latest

USER root

# Install dependencies
RUN apt-get update && apt-get install -y \
    tar \
    gnupg \
    glibc-tools \
    libglib2.0-0t64 \
    openssl \
    libc6

USER ubuntu
# Copy and install Aspera CLI from the current directory
COPY ibm-aspera-connect_4.2.12.780_linux_x86_64.tar.gz /tmp/aspera-cli.tar.gz
RUN tar zxvf /tmp/aspera-cli.tar.gz -C /tmp
#    /tmp/ibm-aspera-connect-4.2.12.780-linux-x86_64.sh

# Set the default command to run bash
CMD ["bash"]
FROM ibmcom/aspera-cli:3.9

USER root

# Install wget
RUN sed -i 's/archive/old-releases/g' /etc/apt/sources.list  # Allows apt-get update to function with older Ubuntu version
RUN apt-get update; exit 0  # Update step throws unimportant error --> exit 0 to avoid
RUN apt-get install -y wget  


# Download SRA toolkit and add to path
RUN wget https://ftp-trace.ncbi.nlm.nih.gov/sra/sdk/2.10.8/sratoolkit.2.10.8-ubuntu64.tar.gz \
	&& tar xvzf sratoolkit.2.10.8-ubuntu64.tar.gz
ENV PATH="/sratoolkit.2.10.8-ubuntu64/bin:${PATH}"


# Install newer version of aspera
RUN wget https://d3gcli72yxqn2z.cloudfront.net/connect_latest/v4/bin/ibm-aspera-connect-3.11.2.63-linux-g2.12-64.tar.gz \
	&& tar zxvf ibm-aspera-connect-3.11.2.63-linux-g2.12-64.tar.gz
USER aspera
RUN ./ibm-aspera-connect-3.11.2.63-linux-g2.12-64.sh

USER root

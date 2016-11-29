FROM centos
MAINTAINER Imagine han<becausehan@gmail.com>

ENV SSH_PASSWORD = abc=1234

# Install base tool
RUN yum -y install wget vim tar

# Install SSH Service
RUN yum install -y openssh-server passwd
RUN sed -ri 's/#UsePAM no/UsePAM no/g' /etc/ssh/sshd_config && \
    echo "${SSH_PASSWORD}" | passwd "root" --stdin

# Install lnmp and define php and mysql version
RUN wget -c http://mirrors.duapp.com/lnmp/lnmp1.3-full.tar.gz && \
	tar zxf lnmp1.3-full.tar.gz && \
	cd lnmp1.3-full && \
	sed -i -e 's/read -p/# read -p/g' include/main.sh  && \
	sed -i -e 's/dd count=1 2>/# dd count=1 2>/g' include/main.sh && \
	sed -i 's/DBSelect="2"/DBSelect="6"/' include/main.sh  && \
	sed -i 's/PHPSelect="3"/PHPSelect="6"/' include/main.sh && \
	./install.sh lnmp

# Remove tar
RUN cd ../ && \
	rm -rf lnmp1.3*

# Run lnmp
RUN lnmp start

# EXPOSE 22 and 80 port
EXPOSE 22 80 3000

# Start run shell
CMD ["bash"]
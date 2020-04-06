# apache PHP certbot 

FROM centos:7
ENV container docker
#
# systemd stuff from: https://hub.docker.com/_/centos
#
RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == \
systemd-tmpfiles-setup.service ] || rm -f $i; done); \
rm -f /lib/systemd/system/multi-user.target.wants/*;\
rm -f /etc/systemd/system/*.wants/*;\
rm -f /lib/systemd/system/local-fs.target.wants/*; \
rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
rm -f /lib/systemd/system/basic.target.wants/*;\
rm -f /lib/systemd/system/anaconda.target.wants/*;



RUN yum -y install epel-release 
RUN yum -y install php php-cli certbot python2-certbot-apache httpd cronie inotify-tools; yum clean all 
COPY startup.sh /startup.sh
COPY startup.service /etc/systemd/system/startup.service
RUN systemctl enable httpd.service crond.service startup.service

EXPOSE 80 443

VOLUME [ "/sys/fs/cgroup" ]
CMD ["/usr/sbin/init"]

#sudo docker build --rm -t isuhpc/apache-php .
#sudo docker run -ti  -v /tmp/$(mktemp -d):/run -d --rm -v /sys/fs/cgroup:/sys/fs/cgroup:ro -p 80:80 --name apache-php isuhpc/apache-php
#sudo docker exec -ti  apache-php bash
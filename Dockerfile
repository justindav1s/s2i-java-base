# java-service-base
FROM  centos:7

MAINTAINER Justin Davis <justinndavis@gmail.com>

EXPOSE 8080

ENV BUILDER_VERSION 1.0 \
 TOMCAT_VERSION 7.0.72 \
 JAVA_VERSION 1.7

LABEL name="Centos Java Image" \
      vendor=jnd.org \
      license=GPLv2

LABEL io.k8s.description="Image for building micro-service based deployments" \
      io.k8s.display-name="Base Centos Java" \
      io.openshift.expose-services="8080:http" \
      io.openshift.tags="builder,java,http" \
      io.openshift.s2i.scripts-url="image:///usr/libexec/s2i"


RUN rpm -ivh http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-10.noarch.rpm && \
 yum -y install wget curl java-1.8.0-openjdk-devel git ansible pyOpenSSL libxml2 libxslt && \
 yum clean all -y && \
 mkdir -p /app

WORKDIR /app

RUN mkdir -p /usr/libexec/s2i

COPY ./.s2i/bin/ /usr/libexec/s2i

RUN groupadd -r service && useradd -u 1001 -g service service

RUN chown -R service:service /app && \
 chmod -R 777 /app && \
 find /app -type d -exec chmod g+x {} +

USER 1001

CMD ["/usr/libexec/s2i/usage"]
# Use a base image with CentOS 7
FROM centos:7

# Set environment variables for Java and Tomcat
ENV JAVA_HOME /usr/lib/jvm/java-11-openjdk
ENV CATALINA_HOME /opt/tomcat

# Install OpenJDK 11
RUN yum update -y && \
    yum install -y java-11-openjdk-devel && \
    yum clean all

# Install net-tools
RUN yum install -y curl tar net-tools && \
    yum clean all

# Download and install Apache Tomcat
ENV TOMCAT_MAJOR_VERSION=9
ENV TOMCAT_MINOR_VERSION=9.0.56
ENV TOMCAT_FILENAME apache-tomcat-$TOMCAT_MINOR_VERSION.tar.gz
ENV TOMCAT_DOWNLOAD_URL https://downloads.apache.org/tomcat/tomcat-$TOMCAT_MAJOR_VERSION/v$TOMCAT_MINOR_VERSION/bin/$TOMCAT_FILENAME

RUN curl -O $TOMCAT_DOWNLOAD_URL && \
    tar -xvf $TOMCAT_FILENAME -C /opt && \
    rm $TOMCAT_FILENAME && \
    ln -s /opt/apache-tomcat-$TOMCAT_MINOR_VERSION /opt/tomcat

# Copy the .war file to Tomcat's webapps directory
COPY HelloWorldWebApp.war $CATALINA_HOME/webapps/

# Add a user in tomcat-users.xml
RUN echo '<tomcat-users xmlns="http://tomcat.apache.org/xml" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://tomcat.apache.org/xml tomcat-users.xsd" version="1.0">\
  <role rolename="admin-gui,manager-gui"/>\
  <user username="admin" password="password" roles="admin-gui,manager-gui"/>\
</tomcat-users>' > $CATALINA_HOME/conf/tomcat-users.xml

# Expose Tomcat port
EXPOSE 7080

# Start Tomcat
CMD ["/opt/tomcat/bin/catalina.sh", "run"]


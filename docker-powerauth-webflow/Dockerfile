FROM tomcat:8.5
LABEL maintainer "petr@lime-company.eu"

# Clear root context
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy libraries
ADD deploy/lib/mysql-connector-java.jar /usr/local/tomcat/lib/
ADD deploy/lib/ojdbc6.jar /usr/local/tomcat/lib/

# Deploy and run applications
ADD deploy/conf/powerauth-webflow.xml /usr/local/tomcat/conf/Catalina/localhost/
ADD deploy/images/powerauth-webflow.war /usr/local/tomcat/webapps/

ADD deploy/conf/powerauth-data-adapter.xml /usr/local/tomcat/conf/Catalina/localhost/
ADD deploy/images/powerauth-data-adapter.war /usr/local/tomcat/webapps/

CMD ["catalina.sh", "run"]
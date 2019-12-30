FROM busybox AS builder

# Copy contents of resources folder in github project to /tmp/resources
COPY resources /tmp/resources

# Using base tomcat image provided by pega for enterprise deployments
FROM pegasystems/pega-ready

# Import prweb, prhelp, prsysmgmt to tomcat webapps directory
COPY --from=builder /tmp/resources/*.war ${CATALINA_HOME}/webapps/
# Replace enterprise level context.xml file with personal-edition specific context.xml file
COPY --from=builder /tmp/resources/context.xml.tmpl ${CATALINA_HOME}/conf

# ---------------------------------------------------------------------------------------------------------
# pegasystems/pega-ready uses adoptopenjdk java, 
# however this throws a java nullpointer exception for Pega 7.2.1 for hazelcast modules for which this build was created & tested. 
# instead of finding out the root cause of the exception, i have chosen to replace the java version to something
# that i know works. 
# IMPORTANT: This is meant for experiment on own developer machines only. Replacing an already tested java version like 
# this might cause security and performance issues. This is no way fit for an enterprise deployment.
#  >>> USE AT OWN RISK <<<< 

# remove java that came with pega's base image
RUN rm -rf /opt/java
# install version of java that i know works 
RUN apt-get update && apt-get install -y openjdk-8-jre
# set env for java as per new installation
ENV JAVA_HOME "/usr"
# ---------------------------------------------------------------------------------------------------------

# Make a jdbc driver available to tomcat applications
COPY --from=builder /tmp/resources/jdbc_drivers/* ${CATALINA_HOME}/lib/

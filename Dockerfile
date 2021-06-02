FROM openjdk:8-jre-alpine
ENV JMETER_VERSION=5.4.1
LABEL maintainer="emmanuel.gaillardon@orange.fr"
ENV JMETER_HOME=/opt/jmeter
ENV JMETER_DIR=${JMETER_HOME}/apache-jmeter-${JMETER_VERSION}

RUN apk add --no-cache openssl ca-certificates wget tar

WORKDIR ${JMETER_HOME}
ENV JMETER_PLUGINS_MANAGER_VERSION 1.4
ENV CMDRUNNER_VERSION 2.2
ENV JSON_LIB_VERSION 2.4
ENV JSON_LIB_FULL_VERSION ${JSON_LIB_VERSION}-jdk15
ENV NUMBER_OF_FILES_UNDER_LIB 166
ENV NUMBER_OF_FILES_UNDER_LIB_EXT 81
RUN cd /tmp/ \
 && curl --location --silent --show-error --output ${JMETER_HOME}/lib/ext/jmeter-plugins-manager-${JMETER_PLUGINS_MANAGER_VERSION}.jar http://search.maven.org/remotecontent?filepath=kg/apc/jmeter-plugins-manager/${JMETER_PLUGINS_MANAGER_VERSION}/jmeter-plugins-manager-${JMETER_PLUGINS_MANAGER_VERSION}.jar \
 && curl --location --silent --show-error --output ${JMETER_HOME}/lib/cmdrunner-${CMDRUNNER_VERSION}.jar http://search.maven.org/remotecontent?filepath=kg/apc/cmdrunner/${CMDRUNNER_VERSION}/cmdrunner-${CMDRUNNER_VERSION}.jar \
 && curl --location --silent --show-error --output ${JMETER_HOME}/lib/json-lib-${JSON_LIB_FULL_VERSION}.jar https://search.maven.org/remotecontent?filepath=net/sf/json-lib/json-lib/${JSON_LIB_VERSION}/json-lib-${JSON_LIB_FULL_VERSION}.jar \
 && java -cp ${JMETER_HOME}/lib/ext/jmeter-plugins-manager-${JMETER_PLUGINS_MANAGER_VERSION}.jar org.jmeterplugins.repository.PluginManagerCMDInstaller \
 && PluginsManagerCMD.sh install \
blazemeter-debugger=0.6,\
bzm-hls=3.0.1,\
bzm-http2=1.5,\
bzm-jmeter-citrix-plugin=0.5.5,\
bzm-parallel=0.9,\
bzm-random-csv=0.6,\
bzm-rte=2.3,\
bzm-siebel=0.1.0-beta,\
custom-soap=1.3.3,\
jmeter.backendlistener.azure=0.2.1,\
jmeter.backendlistener.elasticsearch=2.6.10,\
jpgc-casutg=2.9,\
jpgc-cmd=2.2,\
jpgc-csl=0.1,\
jpgc-csvars=0.1,\
jpgc-dbmon=0.1,\
jpgc-dummy=0.4,\
jpgc-filterresults=2.2,\
jpgc-functions=2.1,\
jpgc-ggl=2.0,\
jpgc-graphs-additional=2.0,\
jpgc-graphs-basic=2.0,\
jpgc-graphs-composite=2.0,\
jpgc-graphs-dist=2.0,\
jpgc-graphs-vs=2.0,\
jpgc-json=2.7,\
jpgc-mergeresults=2.1,\
# jpgc-oauth=0.1,\
jpgc-pde=0.1,\
jpgc-perfmon=2.1,\
jpgc-plancheck=2.4,\
# jpgc-plugins-manager=${JMETER_PLUGINS_MANAGER_VERSION},\
jpgc-webdriver=3.1,\
netflix-cassandra=0.2-SNAPSHOT,\
ssh-sampler=1.1.1-SNAPSHOT,\
 && jmeter --version \
 && PluginsManagerCMD.sh status \
 && chmod +x ${JMETER_HOME}/bin/*.sh \
 && if [ `ls -l /opt/apache-jmeter-*/lib/ | wc -l` != ${NUMBER_OF_FILES_UNDER_LIB} ]; then exit -1; fi \
 && if [ `ls -l /opt/apache-jmeter-*/lib/ext/ | wc -l` != ${NUMBER_OF_FILES_UNDER_LIB_EXT} ]; then exit -1; fi \
 && rm -fr /tmp/*

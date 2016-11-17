FROM jenkins:2.19.3
RUN /usr/local/bin/install-plugins.sh kubernetes:0.8 workflow-aggregator:2.4 credentials-binding:1.9 git:3.0.0 \
    && mkdir -p /usr/share/jenkins/ref/secrets/ \
    && echo "false" > /usr/share/jenkins/ref/secrets/slave-to-master-security-kill-switch

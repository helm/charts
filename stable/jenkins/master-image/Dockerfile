FROM jenkins:2.32.3
RUN /usr/local/bin/install-plugins.sh kubernetes:0.11 workflow-aggregator:2.5 credentials-binding:1.10 git:3.1.0 \
    && mkdir -p /usr/share/jenkins/ref/secrets/ \
    && echo "false" > /usr/share/jenkins/ref/secrets/slave-to-master-security-kill-switch

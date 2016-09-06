FROM jenkins:2.7.3
RUN /usr/local/bin/install-plugins.sh kubernetes:0.8 workflow-aggregator:2.3 \
    && mkdir -p /usr/share/jenkins/ref/secrets/ \
    && echo "false" > /usr/share/jenkins/ref/secrets/slave-to-master-security-kill-switch
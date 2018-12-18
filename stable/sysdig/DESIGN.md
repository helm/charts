# Design and Known Issues Justification Document

## Goal

The goal of this file is to document and give some context about some issues that
forced me to take some decisions in this Chart.

## Loading Custom App Checks using a ConfigMap and a Yaml file

In Helm, we are not able to add an external file to a Chart deployment, in fact,
there is an [issue](https://github.com/helm/helm/issues/3276) about this.

This means that external files like SSL certificates or pluggable files, like
Falco rules or Custom App Checks, should be managed using Helm exclusively. You
can see comments in [first Falco pull request](https://github.com/helm/charts/pull/5853).

And the way to manage them using Helm is to pass file contents as values to Chart
deployment. A nice tip is using a Yaml file and pass to deployment command line
using the -f flag.

## OpenShift support

Right now, there are an issue in [OpenShift](https://github.com/openshift/origin/issues/20788)
and other in [Helm](https://github.com/helm/helm/issues/4533) that makes a bit
cumbersome the OpenShift support for this Chart.

Eventually, they will be fixed. But meanwhile a workaround is to create a
serviceAccount using the `oc` utility. Also manage permissions for creating privileged
containers and allowing hostPath mount with `oc` and deploy the Chart with the
`serviceAccount.name` created with `oc`.

You can see more details about this workaround on [Sysdig Documentation about OpenShift](https://sysdigdocs.atlassian.net/wiki/spaces/Platform/pages/256671843/).

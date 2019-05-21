# Processes

This document outlines processes and procedures for some common tasks in the charts repository.

## Deprecating A Chart

When a chart is no longer maintained it can be [deprecated](https://en.wikipedia.org/wiki/Deprecation). Once a chart is deprecated the expectation is the chart will see no further development. The chart and its versions will still be accessible, though tools such as [monocular](https://github.com/kubernetes-helm/monocular) and [Kubeapps Hub](https://hub.kubeapps.com/) will no longer list the chart.

To deprecate a chart perform the following:

1. Increment the chart `version` in the `Chart.yaml` file. This is required as all charts are immutable.
1. Add a property to the `Chart.yaml` file of `deprecated: true` at the top level of the YAML structure.
1. Above the deprecated property add a comment noting that the chart is deprecated and linking to the deprecation policy.
1. Remove any maintainers from the chart as the chart is no longer maintained.
1. Prefix the description with "DEPRECATED"
1. Update READMEs and NOTES.txt to note that the chart is deprecated

For example, A `Chart.yaml` could start like:

```yaml
name: foo
# The foo chart is deprecated and no longer maintained. For details deprecation,
# including how to un-deprecate a chart see the PROCESSES.md file.
deprecated: true
description: DEPRECATED foo bar baz qux...
```

## Un-deprecating A Chart

When new maintainers are interested in bring a chart out of deprecation with
new features or new support that can be an option. To un-deprecate a chart:

1. Update the maintainers on the chart if any are listed. The previous maintainers should not be expected to maintain the chart unless they explicitly decide to do so.
1. If there is an OWNERS file in the chart that should be updated with the new reviewers and  approvers.
1. The deprecated property from the `Chart.yaml` file should be removed along with any associated comment.
1. The chart `version` needs to be incremented accordingly. If the same functionality is kept the version can be a patch increase. Otherwise the minor or major version needs to be incremented. For more detail on changing the version number see the [semver specification](http://semver.org).

## Promoting A Chart From Incubator To Stable

When promoting a chart from incubator to stable there are several steps that need to be carried out.

1. Prior to promoting the chart verify that it does not depend on any other incubator charts. Stable charts cannot depend on incubator charts.
1. The chart should be copied, not moved, from the incubator directory to the stable directory.
1. The chart in the incubator directory should be deprecated according to the [deprecation process](#deprecating-a-chart) described above with a comment noting that the chart has been promoted to stable.
1. The version of the chart in the stable directory should be updated so that any documentation or other details points to stable rather than incubator. The chart `version` will, also, need to be incremented.

## Reviewing A Pull Request

There are two parts to reviewing a pull request in the process to do so and the guidelines to follow. Both of those are outlined in the [Review Guidelines](REVIEW_GUIDELINES.md).

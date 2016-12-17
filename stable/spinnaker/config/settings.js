'use strict';

var feedbackUrl = 'http://localhost';
var gateHost = 'http://localhost:8084';
var bakeryDetailUrl = 'http://localhost:8087';

window.spinnakerSettings = {
  defaultProviders: ['aws', 'gce', 'azure', 'cf', 'kubernetes', 'titan'],
  feedbackUrl: feedbackUrl,
  gateUrl: gateHost,
  bakeryDetailUrl: bakeryDetailUrl,
  pollSchedule: 30000,
  defaultTimeZone: 'America/New_York', // see http://momentjs.com/timezone/docs/#/data-utilities/
  providers: {
    azure: {
      defaults: {
        account: 'azure-test',
        region: 'West US'
      },
    },
    aws: {
      defaults: {
        account: 'test',
        region: 'us-east-1'
      },
      defaultSecurityGroups: ['nf-datacenter-vpc', 'nf-infrastructure-vpc', 'nf-datacenter', 'nf-infrastructure'],
      loadBalancers: {
        // if true, VPC load balancers will be created as internal load balancers if the selected subnet has a purpose
        // tag that starts with "internal"
        inferInternalFlagFromSubnet: false,
      },
    },
    gce: {
      defaults: {
        account: 'my-google-account',
        region: 'us-central1',
        zone: 'us-central1-f',
      },
    },
    titan: {
      defaults: {
        account: 'titustest',
        region: 'us-east-1'
      },
    },
    kubernetes: {
      defaults: {
        account: 'my-kubernetes-account',
        namespace: 'default'
      },
    }
  },
  notifications: {
    email: {
      enabled: true,
    },
    hipchat: {
      enabled: true,
      botName: 'Skynet T-800'
    },
    sms: {
      enabled: true,
    },
    slack: {
      enabled: true,
      botName: 'spinnakerbot'
    }
  },
  whatsNew: {
    gistId: '32526cd608db3d811b38',
    fileName: 'news.md',
  },
  feature: {
    pipelines: true,
    jobs: true,
    notifications: false,
    fastProperty: false,
    vpcMigrator: false,
    clusterDiff: false,
    roscoMode: false,
    netflixMode: false,
    infrastructureStages: false, // Should 'createLoadBalancer' be a pipeline stage? (no).
  },
};

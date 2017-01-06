'use strict';

var feedbackUrl = 'http://localhost';
var gateHost = 'http://localhost:8084';
var bakeryDetailUrl = 'http://localhost:8087';

window.spinnakerSettings = {
  defaultProviders: ['kubernetes'],
  feedbackUrl: feedbackUrl,
  gateUrl: gateHost,
  bakeryDetailUrl: bakeryDetailUrl,
  pollSchedule: 30000,
  defaultTimeZone: 'America/Los_Angeles', // see http://momentjs.com/timezone/docs/#/data-utilities/
  providers: {
    kubernetes: {
      defaults: {
        account: 'local',
        namespace: 'default'
      },
    }
  },
  notifications: {
    email: {
      enabled: true,
    },
    hipchat: {
      enabled: false,
      botName: 'Skynet T-800'
    },
    sms: {
      enabled: false,
    },
    slack: {
      enabled: false,
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
    notifications: true,
    fastProperty: false,
    vpcMigrator: false,
    clusterDiff: false,
    roscoMode: false,
    netflixMode: false,
    infrastructureStages: true, // Should 'createLoadBalancer' be a pipeline stage? (no).
  },
};

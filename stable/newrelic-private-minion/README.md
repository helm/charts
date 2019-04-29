# New Relic Private Minion

This allows you to use New Relic Synthetics for for service that are not publically available for New Relic Synthetics to access.

### Setup
* [Create a private location](https://docs.newrelic.com/docs/synthetics/new-relic-synthetics/private-locations/private-locations-overview-monitor-internal-sites-add-new-locations#create-location)
* [Get private location key](https://docs.newrelic.com/docs/synthetics/new-relic-synthetics/private-locations/install-containerized-private-minions-cpms#private-location-key)
  * Specify this in your values `privateLocationKey: XXXX`

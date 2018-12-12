/**
 * This script parses the optional replica-config.js
 * to find the replica config for a particular member
 * of the replicaset.
 *
 * It then adds the member, along with their configuration,
 * to the replica.
 */
load('/init/replica-config.js');

var memberIndex = xxMEMBER_INDEXxx;
var memberConfig = setConfig ? setConfig[memberIndex] : {};
memberConfig.host = "xxMEMBER_HOSTxx";

if (rs.status().codeName === "NotYetInitialized") {
    memberConfig["_id"] = 0;
    rs.initiate({ '_id': 'xxREPLICA_SETxx', 'members': [memberConfig] });
} else {
    rs.add(memberConfig);
}

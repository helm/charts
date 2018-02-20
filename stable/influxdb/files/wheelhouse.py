#!/usr/bin/env python

# Author: Petr Michalec (epcim at apealive.net)
# Source: https://github.com/epcim/wheelhouse
# License: MIT
# Version: 1.0

import os
import sys
import salt.client
import salt.config
import salt.output
from glob import glob
import ruamel.yaml
import pprint
import argparse
import select


class Toolbox():

    @staticmethod
    def argparser():
        parser = argparse.ArgumentParser(description=
                                         "Wheelhouse script.\n"
                                         "Usage: `cat wheelhouse.yaml | wheelhouse.py [args]`")
        wh = parser.add_argument_group('Choosing what you want to execute')
        wh.add_argument('jobs', nargs="*",
                        help='Job names to execute')
        wh.add_argument('-c', '--config',
                        default=None,
                        help='YAML file containing run instructions')
        # PLACEHOLDER
        #wh.add_argument('-j', '--jobs',
        #                default=None,
        #                help='Comma separated list of job names to execute')
        # PLACEHOLDER
        #at.add_argument('-e', '--engine-opts',
        #                default=None,
        #                help='Engine specific options')
        wh.add_argument('-t', '--test', action='store_true',
                        default=False,
                        help='Run embedded pillar validation and tests')
        wh.add_argument('--dry', action='store_true',
                        help='Execute engine in a "dry" mode')
        at = parser.add_argument_group('Any extra attributes will ones spec. in config file)')
        # technically any string value on wheelhouse config can be overriden
        at.add_argument('extra', nargs=argparse.REMAINDER)
        # PLACEHOLDER
        #pl = parser.add_argument_group('Pillar control arguments')
        #pl.add_argument('-p', '--pillar-engine',
        #                default=None,
        #                help='Override pillar source or external if not in config')
        #pl.add_argument('--pillar-etcd-url',
        #                help='Override pillar source or external if not in config')
        return parser

    @staticmethod
    def arg2config(arg):
        """
        Example:
          --logging-severity=ABC
          --maps-list-values=A,B,C
        becomes dict like:
          logging:
            severity: ABC
          maps:
            list:
              values: [A, B , C]
        """
        t = arg.split('=')
        v = t[1:] # value
        if len(v) == 0:
          # no value -> boolean switch
          v = True
        else:
          v = v[0].split(',')
          v = v if len(v) > 1 else ''.join(v).strip()
        a = list(reversed(t[0].split('-')))
        r = {a[0]: v}
        for a in a[1:]:
          r = {a: r}
        return r

    @staticmethod
    def merge_dict(d1, d2):
      for k in d2:
        if k in d1 and isinstance(d1[k], dict) and isinstance(d2[k], dict):
            Toolbox.merge_dict(d1[k], d2[k])
        else:
            d1[k] = d2[k]


    @staticmethod
    def testconfig():
        return ruamel.yaml.YAML().load("""\
            enabled: true
            engine: salt
            image:  tcpcloud/salt-formulas
            logging:
              severity: info
            job:
                initdb:
                    wheel:
                        - initdb
                    logging:
                        severity: debug
                cron_data_prunning:
                    wheel:
                        - minion_influxdb_config
                        - delete_data
                dummy_test:
                    wheel:
                        - minion_influxdb_config
                        - dummy_direct_sls_invocation
            pillar:
                salt:
                  minion:
                      config:
                        # This section is only needed if salt state ``influxdb_continuous_query.present`` is used
                        influxdb:
                          host: localhost
                          port: 8086
                influxdb:
                    client:
                        enabled: true
                        server:
                          protocol: http
                          host: localhost
                          port: 8086
                          user: admin
                          password: admin
                        user:
                          1:
                            name: fluentd
                            password: password
                            enabled: true
                            admin: true
                        database:
                            1:
                                name: h2o_measurement
                                enabled: true
                                retention_policy:
                                - name: rp_a_month
                                  duration: 30d
                                  replication: 1
                                  is_default: true
                                continuous_query:
                                    cq_avg_bus_passengers: >-
                                        SELECT mean("h2o_quality") INTO "h2o_measurement"."rp_a_month"."average_quality" FROM "bus_data" GROUP BY time(1h)
                                    cq_br_downsample_all_hourly: >-
                                        SELECT mean(*) INTO "h2o_measurement"."ds_all_mean_h".:MEASUREMENT FROM /.*/ GROUP BY time(60m),*
                                query:
                                    drop_h2o: >-
                                        DROP MEASUREMENT h2o_measurement
                                    delete_h2o: >-
                                        DELETE FROM "h2o_measurement" WHERE type='h2o'
                        grant:
                            fluentd_h2o_measurement:
                                enabled: true
                                user: fluentd
                                database: h2o_measurement
                                privilege: all
            wheel:
                initdb:
                    state.apply:
                        - influxdb.client
                delete_data:
                    # Call formula state sls NS by an ID
                    state.sls_id:
                        - delete_h2o
                        - influxdb.query
                minion_influxdb_config:
                    state.apply:
                        /etc/salt/minion:
                            file.serialize:
                            - dataset_pillar:  salt:minion:config
                            - formatter:       yaml
                            - merge_if_exists: True
                            - makedirs: True
                dummy_direct_sls_invocation:
                    state.apply:
                        make_dir:
                            file.directory:
                            - name: /var/log/influxdb
                            - makedirs: True
                            - mode: 755
                        #create_dummy_database:
                        #    influxdb_database.present:
                        #        - name: dummy1
                        #set_a_year_retention_db_metrics:
                        #    influxdb_retention_policy.present:
                        #        - name: a_year
                        #        - database: dummy1
                        #        - duration: 52w
                        #        - retention: 1
                        #        - default: false
                        #        #- host: localhost
                        #        #- port: 8086
                        #insert_dummy_data:
                        #    module.run:
                        #      influxdb.query:
                        #        - database: h2o_measurement
                        #        - query: INSERT treasures,captain_id=pirate_king value=2
                        #set_continuous_queries:
                        #    influxdb_continuous_query.present:
                        #       ...
                        #       ...
        """)


class Wheel:

    def __init__(self, config, jobs=[]):
        self.logseverity = {'error': 1, 'info': 2, 'debug': 3}
        self.config = config
        self.jobs = jobs

    def log(self, msg, severity='info', level=0):
        if self.logseverity[severity] <= self.logseverity[self.config.get('logging', {}).get('severity', 'info')]:
            print('== {}'.format(' ' * level + str(msg)))

    def runner(self):
        """
        Iterates wheelhouse:jobs and trigger invidual wheels defined

        wheelhouse:
          job:
            <job_name>:
              wheel:
                - <wheel_name>
        """

        for job_nm in self.jobs:
            job = self.config['job'][job_nm]

            self.log('Job: {}'.format(job_nm))

            for wheel_nm in job.get('wheel', {}):
                wheel = self.config['wheel'][wheel_nm]

                self.log('wheel: {}'.format(wheel_nm))
                self.run(wheel_nm, wheel)

    def run(self, fn, values):
        pass

    def client(self):
        pass

    def dictify(self, _dict):
        for k in _dict.keys():
            if isinstance(_dict[k], ruamel.yaml.comments.CommentedMap):
                _dict[k] = self.dictify(dict(_dict[k]))
            # elif isinstance(_dict[k], ruamel.yaml.comments.CommentedSeq):
                #_dict[k] = list(_dict[k])
        return _dict

    def safeMergeDict(self, x, y):
        # python3:
        # return { **self.dictify(x), **self.dictify(y) }
        x = self.dictify(x)
        y = self.dictify(y)
        z = x.copy()   # start with x's keys and values
        z.update(y)    # modifies z with y's keys and values & returns None
        return z


class SaltWheel(Wheel):

    def __init__(self, config, jobs=None, dry=False):
        Wheel.__init__(self, config, jobs=jobs)
        self.salt_opts = {'state-output': 'changes', 'log-severity': 'info', 'with_grains': True, 'test': dry}
        self.salt_config = {}

    def client(self):
        """
        Init salt client (salt.client.Caller)
        """
        # Salt init
        # https://docs.saltstack.com/en/latest/ref/clients/

        __opts__ = salt.config.minion_config('/etc/salt/minion')
        default_config = dict(ruamel.yaml.YAML().load("""\
        file_client: local
        master: localhost
        file_roots:
          base:
           - {}
        retcode_passthrough: true
        """.format('/usr/share/salt-formulas/env')))
        __opts__ = self.safeMergeDict(__opts__, default_config)
        __opts__ = self.safeMergeDict(__opts__, self.config.get('config', {}).get('salt', {}).get('minion', {}))
        # TODO, __opts__ = self.safeMergeDict(__opts__, pillar:salt:minion:config)
        self.salt_config = __opts__
        return salt.client.Caller(mopts=self.salt_config)

    def run(self, wheel_nm, wheel):
        """
        Process individual wheel

        wheel:
            <wheel_name>:
               state.apply:
                - test.ping
                state.sls: { <sls> }
                test.ping: []
                ...
        """

        for fn, values in wheel.items():

            states = []
            salt_c = self.client()
            os.chdir(self.salt_config.get('file_roots', {}).get('base', ['/usr/share/salt-formulas/env'])[0])

            # TODO: clean up first->after # top.sls etc..
            for f in glob("*.sls"):
                try:
                    os.remove(f)
                except OSError:
                    pass

            # implement functions
            if fn in ['state.apply', 'state.sls']:
                if isinstance(values, list):
                    states = values
                elif isinstance(values, ruamel.yaml.comments.CommentedMap) or isinstance(values, dict):  # RAW SLS FILE ON VALUES
                    with open('top.sls', 'w') as out:
                        out.write(''.join((
                                "base:\n",
                            "  '*':\n",
                            "     - {}\n".format(wheel_nm)
                        )))
                    with open('{}.sls'.format(wheel_nm), 'w') as out:
                        ruamel.yaml.dump(values, out, Dumper=ruamel.yaml.RoundTripDumper)

            pillar = {'pillar': self.config.get('pillar', {})}
            args = [','.join(states)]
            kwargs = self.safeMergeDict(self.salt_opts, wheel.get('config', {}).get('salt', {}).get('opts', {}))
            kwargs = self.safeMergeDict(kwargs, pillar)

            ret = None
            try:
                ret = salt_c.cmd(fn, *args, **kwargs)

                # workaround, check for failed states:
                _retcode = 0
                for v in ret.values():
                    if not v.get('result', True):
                        _retcode = 1
                        break

                salt.output.display_output(
                    {'local': ret},
                    out=ret.get('out', 'highstate'),
                    opts=self.salt_config,
                    _retcode=ret.get('retcode', _retcode))

            except Exception as e:
                self.log('Exception: {} for a ret object: {} '.format(e, ret))
                pp = pprint.PrettyPrinter(indent=2, width=80)
                pp.pprint(ret)
                sys.exit(1)

            if self.salt_config.get('retcode_passthrough', False) and ret.get('retcode', _retcode) != 0:
                sys.exit(ret.get('retcode', _retcode))


# Main for ad-hoc, free hands execution:
if __name__ == '__main__':

    parser = Toolbox.argparser()
    args, extra = parser.parse_known_args()

    # construct simple override from extra args
    config_override = {}
    # implement poor introspection of extra attributes.
    for a in ' '.join(extra).split('--'):
        if a and a.strip() != '':
            Toolbox.merge_dict(config_override, Toolbox.arg2config(a))

    jobs = []
    config = {}

    # apply args
    if args.engine:
        config_override['engine'] = args.engine
    if args.test:
        # run embedded dummy test
        jobs = ['initdb', 'dummy_test']
        config = Toolbox.testconfig()
    if args.config:
        # load config from file
        with open(args.config, 'r') as stream:
            config = ruamel.yaml.YAML().load(stream)
    elif select.select([sys.stdin,],[],[],0.0)[0]:
        # expect wheelhouse yaml structured metadata
        config = ruamel.yaml.YAML().load(sys.stdin)

    jobs = args.jobs if args.jobs else jobs
    Toolbox.merge_dict(config, config_override)

    # Make it happen
    if len(jobs) > 1 and len(config) >1:
        if config.get('engine', '') == 'salt':
            # trigge Salt wheel
            SaltWheel(config, jobs=jobs).runner()
        elif True:
            pass

    #TODO, should we go over some errors?
    #RED_ERROR = termcolor.colored('FATAL ERROR:', 'red')
    #if args.debug:
    #else:
    #    try:
    #        run(args)
    #    except (errors.UserException, errors.BuildError) as exc:
    #        print(RED_ERROR, exc.args[0], file=sys.stderr)
    #        sys.exit(exc.CODE)

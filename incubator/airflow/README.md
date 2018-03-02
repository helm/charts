# Airflow

Airflow is a platform to programmatically author, schedule and monitor workflows.


## Install Chart

To install the Airflow Chart into your Kubernetes cluster :

```bash
helm install --namespace "airflow" --name "airflow" incubator/airflow
```

After installation succeeds, you can get a status of Chart

```bash
helm status "airflow"
```

If you want to delete your Chart, use this command:

```bash
helm delete  --purge "airflow"
```


## DAGs deployment: embedded DAGs or git-sync

This chart provide basically two way of deploying DAGs in your Airflow installation:

- embedded DAGs
- Git-Sync

This helm chart provide support for Persistant Storage but not for sidecar git-sync pod.
If you are willing to contribute, do not hesitate to do a Pull Request !

### Using embedded Git-Sync

Git-sync is the easiest way to automatically update your DAGs. It simply checks periodically (by
default every minute) a Git project on a given branch and check this new version out when available.
Scheduler and worker see changes almost real-time. There is no need to other tool and complex
rolling-update procedure.

While it is extremely cool to see its DAG appears on Airflow 60s after merge on this project, you should be aware of some limitations Airflow has with dynamic DAG updates:

    If the scheduler reloads a dag in the middle of a dagrun then the dagrun will actually start
    using the new version of the dag in the middle of execution.

This is a known issue with airflow and it means it's unsafe in general to use a git-sync
like solution with airflow without:

 - using explicit locking, ie never pull down a new dag if a dagrun is in progress
 - make dags immutable, never modify your dag always make a new one

Also keep in mind using git-sync may not be scalable at all in production if you have lot of DAGs.
The best way to deploy you DAG is to build a new docker image containing all the DAG and their
dependencies. To do so, fork this project

### Embedded DAGs

If you want more control on the way you deploy your DAGs, you can use embedded DAGs, where DAGs
are burned inside the Docker container deployed as Scheduler and Workers.

Be aware this requirement more heavy tooling than using git-sync, especially if you use CI/CD:

- your CI/CD should be able to build a new docker image each time your DAGs are updated.
- your CI/CD should be able to control the deployment of this new image in your kubernetes cluster

Example of procedure:
- Fork this project
- Place your DAG inside the `dags` folder of this project, update `requirements-dags.txt` to
  install new dependencies if needed (see bellow)
- Add build script connected to your CI that will build the new docker image
- Deploy on your Kubernetes cluster

You can avoid forking this project by:

- keep a git-project dedicated to storing only your DAGs + dedicated `requirements.txt`
- you can gate any change to DAGs in your CI (unittest, `pip install -r requirements-dags.txt`,.. )
- have your CI/CD makes a new docker image after each successful merge using

      DAG_PATH=$PWD
      cd /path/to/kube-aiflow
      make ENBEDDED_DAGS_LOCATION=$DAG_PATH

- trigger the deployment on this new image on your Kubernetes infrastructure

## Worker Statefulset

As you can see, Celery workers uses StatefulSet instead of deployment. It is used to freeze their
DNS using a Kubernetes Headless Service, and allow the webserver to requests the logs from each
workers individually. This requires to expose a port (8793) and ensure the pod DNS is accessible to
the web server pod, which is why StatefulSet is for.

## Python dependencies

If you want to add specific python dependencies to use in your DAGs, you simply declare them inside
the `requirements/dags.txt` file. They will be automatically installed inside the container during
build, so you can directly use these library in your DAGs.

To use another file, call:

    make REQUIREMENTS_TXT_LOCATION=/path/to/you/dags/requirements.txt

Please note this requires you set up the same tooling environment in your CI/CD that when using
Embedded DAGs.

## Documentation

Check [Airflow Documentation](http://pythonhosted.org/airflow/)

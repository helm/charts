from locust import HttpLocust, TaskSet, task
import json, requests

class ElbTasks(TaskSet):
  @task(1)
  def status(self):
      self.client.get("/status")

class ElbWarmer(HttpLocust):
  task_set = ElbTasks
  min_wait = 1000
  max_wait = 3000
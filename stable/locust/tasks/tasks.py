from locust import HttpLocust, TaskSet, task

class ElbTasks(TaskSet):
  @task
  def status(self):
      self.client.get("/status")

class ElbWarmer(HttpLocust):
  task_set = ElbTasks
  min_wait = 1000
  max_wait = 3000
# from locust import HttpLocust, TaskSet, task
#
# class ElbTasks(TaskSet):
#   @task
#   def status(self):
#       self.client.get('/api?action=setUserAttributes&apiVersion=1.0.6.&appId=app_WHWSfAt5LCeLRxWuRaBEiawqkr2vhSG62ZbfyyqAPcE&clientKey=dev_XeURceHkZ4jEfzOBAQD7Fv9j148eByWfxxvzr7eqlrE&userId=99e4f0ee79b3680e&userAttributes={"email":"praveen+20180806@leanplum.com", "horoscope_sign":"leo", "plum_pod":"dataPlatform", "favorite_color":"turquoise"}')
#
# class ElbWarmer(HttpLocust):
#   task_set = ElbTasks
#   min_wait = 1000
#   max_wait = 3000

from locust import HttpLocust, TaskSet, task

class WebsiteTasks(TaskSet):
    # def on_start(self):
    #     self.client.post("/login", {
    #         "username": "test_user",
    #         "password": ""
    #     })

    @task
    def index(self):
        self.client.get("/")

    @task
    def tour(self):
        self.client.get("/tour")

    @task
    def api(self):
        self.client.get('/api?action=setUserAttributes&apiVersion=1.0.6.&appId=app_WHWSfAt5LCeLRxWuRaBEiawqkr2vhSG62ZbfyyqAPcE&clientKey=dev_XeURceHkZ4jEfzOBAQD7Fv9j148eByWfxxvzr7eqlrE&userId=99e4f0ee79b3680e&userAttributes={"email":"praveen+20180806@leanplum.com", "horoscope_sign":"leo", "plum_pod":"dataPlatform", "favorite_color":"turquoise"}')

class WebsiteUser(HttpLocust):
    task_set = WebsiteTasks
    min_wait = 5000
    max_wait = 15000

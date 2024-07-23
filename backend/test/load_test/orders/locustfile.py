from locust import HttpUser, task, between, SequentialTaskSet

class UserBehavior(SequentialTaskSet):
    
    def on_start(self):
        self.user_id = None
        self.medicine_id = None

    @task
    def create_medicine(self):
        response = self.client.post("/medicines", json={
        "batch": "primeiro",
        "name": "rivotril",
        "stripe": "black"
})
        if response.status_code == 201:
            self.medicine_id = response.json().get("id")

    @task
    def create_user(self):
        response = self.client.post("/users", json={
            "email": "user@user",
            "name": "user",
            "password": "user",
            "role": "admin"
        })
        if response.status_code == 201:
            self.user_id = response.json().get("id")


    @task
    def create_order(self):
        if self.user_id:
            self.client.post("/orders", json={
                "medicine_id": self.medicine_id,
                "observation": "urgente",
                "priority": "alta",
                "quantity": 5,
                "user_id": self.user_id
            })

    @task
    def get_orders(self):
        self.client.get("/orders")

class WebsiteUser(HttpUser):
    wait_time = between(1, 5)
    tasks = [UserBehavior]

from locust import HttpUser, task, between

class WebsiteUser(HttpUser):
    wait_time = between(1, 5)

    @task
    def criar_usuario(self):
        self.client.post("/users", json={
        "email": "user",
        "name": "user",
        "password": "user@user",
        "role": "admin"
})

    @task
    def pegar_usuarios(self):
        self.client.get(f"/users")
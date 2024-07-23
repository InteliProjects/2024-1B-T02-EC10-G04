from locust import HttpUser, task, between

class WebsiteUser(HttpUser):
    wait_time = between(1, 5)

    @task
    def criar_usuario(self):
        self.client.post("/medicines", json={
        "batch": "primeira",
        "name": "rivotril",
        "stripe": "preta"
})

    @task
    def pegar_usuarios(self):
        self.client.get(f"/medicines")
from locust import HttpUser, task, between, SequentialTaskSet

class UserBehavior(SequentialTaskSet):
    
    def on_start(self):
        self.user_access_token = None

    @task
    def login_user(self):
        response = self.client.post("/users/login", json={
            "email": "user@user",
            "password": "user1234"
        })
        if response.status_code == 200:
            self.user_access_token = response.json().get("token")
            print(f"Login bem-sucedido, token: {self.user_access_token}")
        else:
            print(f"Falha no login: {response.status_code}, resposta: {response.text}")

    @task
    def create_pyxis(self):
        if self.user_access_token:
            headers = {'Authorization': f'Bearer {self.user_access_token}'}
            response = self.client.post("/pyxis", json={
                "label": "black"
            }, headers=headers)
            if response.status_code == 201:
                print("Pyxis criado com sucesso")
            else:
                print(f"Falha ao criar Pyxis: {response.status_code}, resposta: {response.text}")
        else:
            print("Sem token de acesso")

    @task
    def get_pyxis(self):
        if self.user_access_token:
            headers = {'Authorization': f'Bearer {self.user_access_token}'}
            response = self.client.get("/pyxis", headers=headers)
            if response.status_code == 200:
                print("Pyxis obtido com sucesso")
            else:
                print(f"Falha ao obter Pyxis: {response.status_code}, resposta: {response.text}")
        else:
            print("Sem token de acesso")

class WebsiteUser(HttpUser):
    wait_time = between(1, 5)
    tasks = [UserBehavior]

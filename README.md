# 2024-1B-T02-EC10-G04

<p align="center">
  <img src="./docs/static/img/logo.png" width="100" alt="project-logo">
</p>
<p align="center">
	<h1 align="center">GoMedice</h1>
</p>
<p align="center">
    <em> Projeto desenvolvido para o <a href="https://hospitalsiriolibanes.org.br/">Hospital Sírio-Libanês</a></em>
</p>
<p align="center">
	<img src="https://img.shields.io/github/license/Inteli-College/2024-1B-T02-EC10-G04?style=default&logo=opensourceinitiative&logoColor=white&color=78DCE8" alt="license">
</p>

<p> Uma plataforma de requisições para dispensadores de medicamentos </p>

Você pode achar mais informações sobre o projeto, acessado o link da [documentation](https://inteli-college.github.io/2024-1B-T02-EC10-G04/).


## Authors
-   [Antonio Angelo Teixeira](https://github.com/antonio-ang2)
-   [Emanuele Lacerda Morais Martins](https://github.com/emanuelemorais)
-   [Gustavo Ferreira de Oliveira](https://github.com/gustavofdeoliveira)
-   [Henrique Lemos Freire Matias](https://github.com/Lemos1347)
-   [Henrique Marlon Conceição Santos](https://github.com/henriquemarlon)
-   [Luana Dinamarca Parra Figueredo da Silva](https://github.com/luanaparra)
-   [Lyorrei Shono Quintão](https://github.com/lyorrei-inteli)
   

## Como Rodar o Projeto

### Back-end
   
1. Para rodar o Back-end do projeto, é necessário a instalação do Makefile, para isso, acessa o link [Makefile Windows](https://medium.com/@samsorrahman/how-to-run-a-makefile-in-windows-b4d115d7c516) ou [Makefile Linux](https://dev.to/skypy/linux-make-install-command-2dd6)
   
2. Após clonar o projeto, acesse a pasta `backend`, dentro dela execute os seguintes comandos:
3. `make env`: para criar todas as variáveis de ambiente necessárias para rodar o projeto.
4. `make infra`: para buildar a infraestrutura do projeto.
5. `make run`: para rodar o projeto.
6. Acesse o link [localhost:80/api/v1/docs/index.html](http://localhost:8000/api/v1/docs/index.html) para acessar a documentação da API.

### Front-end

1. Para rodar o Mobile do projeto, é necessário a instalação do Flutter, para isso, acesse o link [Flutter](https://flutter.dev/docs/get-started/install)
2. Após clonar o projeto, acesse a pasta `frontend`, dentro dela execute os seguintes comandos:
3. `flutter pub get`: para instalar todas as dependências do projeto.
4. `flutter run`: para rodar o projeto.
5. `flutter build apk`: para gerar o apk do projeto.

### Dashboard
1. Para rodar o Dashboard do projeto, é necessário a instalação do Docker, para isso, acesse o link [Docker](https://docs.docker.com/get-docker/)
2. Após clonar o projeto, acesse a pasta `dashboard`, dentro dela execute os seguintes comandos:
3. `docker build -t dashboard .`: para buildar a imagem do projeto.
4. `docker run -p 8501:8501 dashboard`: para rodar o projeto.
5. Aceesse o link [localhost:8501](http://localhost:8501) para acessar o Dashboard.


## License

<a rel="cc:attributionURL dct:creator" property="cc:attributionName" href="https://github.com/2023M8T2-Inteli/grupo1">Inteli</a> is licensed under <a href="http://creativecommons.org/licenses/by/4.0/?ref=chooser-v1" target="_blank" rel="license noopener noreferrer" style="display:inline-block;">Attribution 4.0 International</a>. <img style="height:22px!important;margin-left:3px;vertical-align:text-bottom;" src="https://mirrors.creativecommons.org/presskit/icons/cc.svg?ref=chooser-v1"><img style="height:22px!important;margin-left:3px;vertical-align:text-bottom;" src="https://mirrors.creativecommons.org/presskit/icons/by.svg?ref=chooser-v1"><p xmlns:cc="http://creativecommons.org/ns#" xmlns:dct="http://purl.org/dc/terms/"></p>

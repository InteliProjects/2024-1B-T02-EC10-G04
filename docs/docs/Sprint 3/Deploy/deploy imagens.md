---
title: Deploy das Imagens
sidebar_position: 1
slug: deploy-imagens
---

# Deploy das Imagens

A utilização do Docker para a criação de imagens facilita o deploy de aplicações, pois as imagens são portáveis e podem ser executadas em qualquer ambiente que tenha o Docker instalado. Dessa forma, a equipe de desenvolvimento pode criar imagens de suas aplicações e disponibilizá-las para a equipe de operações, que pode executá-las em qualquer ambiente que tenha o Docker instalado.

## Repositório Docker Hub

O Docker Hub é um serviço de registro de imagens Docker que permite armazenar, compartilhar e gerenciar imagens Docker. O Docker Hub é um serviço gratuito que permite armazenar imagens públicas e privadas, e é amplamente utilizado pela comunidade Docker para compartilhar imagens Docker.

Como o grupo optou por seguir a utilização de uma arquitetura fora da AWS, foi necessário a utilização do Docker Hub para armazenar as imagens das aplicações. Dessa forma, foi criado cada repositório no Docker Hub para armazenar as imagens das aplicações, que são utilizadas para realizar o deploy das aplicações em produção.

## Makefile

O Makefile é um arquivo que contém um conjunto de regras que são utilizadas para automatizar tarefas comuns de desenvolvimento, como a instalação de dependências, a execução de testes e o build de aplicações. O Makefile é um arquivo de texto que contém regras no formato `alvo: dependências` e `comandos`, onde `alvo` é o nome da regra, `dependências` são os arquivos ou regras que a regra depende e `comandos` são os comandos que serão executados para realizar a tarefa.

### Rodar localmente com o Makefile

Para rodar localmente as aplicações, é necessário executar alguns comandos no terminal. Sendo eles:

1. **``make env``**: Cria o arquivo `.env` com as variáveis de ambiente necessárias para a execução das aplicações.
2. **``make infra``**: Cria a infraestrutura necessária para a execução das aplicações localmente. Esse comando cria os containers do Zookeeper, Kafka, Redis, Postgres e Control Center.
3. **``make run``**: Inicia os containers das aplicações.

#### Arquivo Makefile

```makefile
START_LOG = @echo "================================================= START OF LOG ==================================================="
END_LOG = @echo "================================================== END OF LOG ===================================================="

.PHONY: env
env: ./.env.develop.tmpl
	$(START_LOG)
	@cp ./.env.develop.tmpl ./.env
	@echo "Environment file created at ./.env"
	$(END_LOG)

.PHONY: infra
infra:
	$(START_LOG)
	@docker compose \
		-f ../docker-compose.yml up \
		--build -d
	@echo "Creating kafka topics..."
	@sleep 30
	@docker compose \
		-f ../docker-compose.yml exec \
		kafka kafka-topics --bootstrap-server kafka:9094 \
		--create --topic orders \
		--partitions 10
	$(END_LOG)

.PHONY: run
run:
	$(START_LOG)
	@docker compose \
		-f ./deployments/compose.packages.yaml up \
		--build -d
	$(END_LOG)

.PHONY: swagger
swagger:
	$(START_LOG)
	@docker run --rm -v $(shell pwd):/code ghcr.io/swaggo/swag:latest i -g ./cmd/server/main.go -o ./api
	@go mod tidy
	$(END_LOG)
```

## Pipeline de Deploy

O processo de deploy envolve o Github Actions como agente principal, que é responsável por realizar o build e o push das imagens para o Docker Hub. O Github Actions é um serviço de integração contínua e entrega contínua (CI/CD) que permite automatizar o processo de build, testes e deploy de aplicações.

O pipeline de deploy é composto por um step de build, já que diferente da Azure, o Github Actions limpa a máquina virtual a cada execução. Dessa forma, o yml da pipeline foi configurado para realizar os seguintes passos:

1. **Instalação do Makefile:** Instala o Makefile na máquina virtual.
2. **Configuração das variáveis de ambiente:** Configura as variáveis de ambiente necessárias para o build e o push das imagens.
3. **Build das imagens:** Realiza o build das imagens a partir do Dockerfile.
4. **Tag das imagens:** Realiza o tag das imagens com a versão da aplicação.
5. **Push das imagens com a tag:** Realiza o push das imagens com a tag para o Docker Hub.

É valido ressaltar que o pipeline de deploy é executado automaticamente a cada push na branch `main` do repositório do Github ou de forma manual na página de Actions. Dessa forma, sempre que uma nova versão da aplicação é disponibilizada no repositório do Github, o pipeline de deploy é executado automaticamente, realizando o build e o push das imagens para o Docker Hub.

## Deploy das Imagens

Todo o processo de deploy das imagens foi criado por meio da utilização de um arquivo `yml` que pode ser encontrado na pasta `.github/workflows` no repositório do Github. Abaixo, é possível visualizar o arquivo `yml` que foi utilizado para realizar o deploy das imagens das aplicações no Docker Hub.

```yml
name: CI/CD Backend

on:
  push:
    branches:
      - main
  workflow_dispatch:

jobs:
  docker-build-deploy:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout repository
        uses: actions/checkout@v4

      - name: Install make
        run: sudo apt-get update && sudo apt-get install -y make

      - name: Set up Backend .env file
        working-directory: backend/
        run: make env

      - name: Set up Docker Buildx
        uses: docker/setup-buildx-action@v1
        id: buildx
        with:
          install: true

      - name: Build Docker images
        working-directory: backend/
        run: make infra

      - name: Show Docker Images after build
        run: docker images

      - name: Log in to Docker Hub
        env:
          DOCKER_USERNAME: ${{ secrets.DOCKER_USERNAME }}
          DOCKER_PASSWORD: ${{ secrets.DOCKER_PASSWORD }}
        run: |
          echo $DOCKER_PASSWORD | docker login -u $DOCKER_USERNAME --password-stdin
          docker login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD

      - name: Verify Docker login
        run: docker info

      - name: ZOOKEEPER - Tag and Push Docker image
        working-directory: backend/
        run: |
          IMAGE_ID=$(docker images -q confluentinc/cp-zookeeper)
          docker tag $IMAGE_ID ${{ secrets.DOCKER_USERNAME }}/confluentinc-cp-zookeeper:${{ github.sha }}
          docker tag $IMAGE_ID ${{ secrets.DOCKER_USERNAME }}/confluentinc-cp-zookeeper:latest
          docker push ${{ secrets.DOCKER_USERNAME }}/confluentinc-cp-zookeeper:${{ github.sha }}
          docker push ${{ secrets.DOCKER_USERNAME }}/confluentinc-cp-zookeeper:latest

      - name: KAFKA - Tag and Push Docker image
        working-directory: backend/
        run: |
          IMAGE_ID=$(docker images -q confluentinc/cp-kafka)
          docker tag $IMAGE_ID ${{ secrets.DOCKER_USERNAME }}/confluentinc-cp-kafka:${{ github.sha }}
          docker tag $IMAGE_ID ${{ secrets.DOCKER_USERNAME }}/confluentinc-cp-kafka:latest
          docker push ${{ secrets.DOCKER_USERNAME }}/confluentinc-cp-kafka:${{ github.sha }}
          docker push ${{ secrets.DOCKER_USERNAME }}/confluentinc-cp-kafka:latest

      - name: REDIS - Tag and Push Docker image
        working-directory: backend/
        run: |
          IMAGE_ID=$(docker images -q redis)
          docker tag $IMAGE_ID ${{ secrets.DOCKER_USERNAME }}/redis:${{ github.sha }}
          docker tag $IMAGE_ID ${{ secrets.DOCKER_USERNAME }}/redis:latest
          docker push ${{ secrets.DOCKER_USERNAME }}/redis:${{ github.sha }}
          docker push ${{ secrets.DOCKER_USERNAME }}/redis:latest

      - name: POSTGRES - Tag and Push Docker image
        working-directory: backend/
        run: |
          IMAGE_ID=$(docker images -q postgres)
          docker tag $IMAGE_ID ${{ secrets.DOCKER_USERNAME }}/postgres:${{ github.sha }}
          docker tag $IMAGE_ID ${{ secrets.DOCKER_USERNAME }}/postgres:latest
          docker push ${{ secrets.DOCKER_USERNAME }}/postgres:${{ github.sha }}
          docker push ${{ secrets.DOCKER_USERNAME }}/postgres:latest

      - name: CONTROL CENTER - Tag and Push Docker image
        working-directory: backend/
        run: |
          IMAGE_ID=$(docker images -q confluentinc/cp-enterprise-control-center)
          docker tag $IMAGE_ID ${{ secrets.DOCKER_USERNAME }}/confluentinc-cp-enterprise-control-center:${{ github.sha }}
          docker tag $IMAGE_ID ${{ secrets.DOCKER_USERNAME }}/confluentinc-cp-enterprise-control-center:latest
          docker push ${{ secrets.DOCKER_USERNAME }}/confluentinc-cp-enterprise-control-center:${{ github.sha }}
          docker push ${{ secrets.DOCKER_USERNAME }}/confluentinc-cp-enterprise-control-center:latest
```
## Conclusão

O deploy das imagens das aplicações foi realizado com sucesso, e as imagens estão disponíveis no Docker Hub para serem utilizadas em produção. O pipeline de deploy foi configurado para realizar o build e o push das imagens automaticamente a cada push na branch `main` do repositório do Github, o que facilita o processo de deploy posteriormente.
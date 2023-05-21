# Spring Data JPA: Repositórios, Consultas, Projeções e Specifications

Projeto do curso da Alura sobre JPA, Repositórios, Consultas, Projeções e Specifications.

Tecnologia utilizada:

- Java 20
- Spring Boot 3
- Docker e docker compose (banco de dados)

# Pré-requisitos (instalações necessárias)

- docker;
- docker compose;
- Java 20;

# Modelo conceitual

// TODO

# Execução do projeto

Na pasta raíz do projeto:

```bash
docker compose up -d --build
```

O comando acima cria um container e executa o banco de dados MariaDb. 

Para parar a execução do container com o banco de dados:

```bash
docker compose down
```

Para executar a aplicação Spring Boot, basta clicar no 'run (app)' na IDE do IntelliJ ou, no terminal e na pasta raíz do projeto:

```bash
mvn spring-boot:run
```

Obs: só funciona se o maven executar em uma versão do Java igual ou superior a versão do projeto. 

# Deploy

Não há deploy configurado para este projeto, pois este foi feito para execução local pela linha de comando.
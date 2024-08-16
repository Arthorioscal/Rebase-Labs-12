# Listagem de Exames - RebaseLabs

> Status do Projeto: Concluido com sucesso :heavy_check_mark:

### Tópicos 

:small_blue_diamond: [Descrição do projeto](#descrição-do-projeto-star)

:small_blue_diamond: [O que a aplicação é capaz de fazer](#o-que-a-aplicação-é-capaz-de-fazer-checkered_flag)

:small_blue_diamond: [Pré-requesitos](#pré-requesitos)

:small_blue_diamond: [Como rodar a aplicação](#como-rodar-a-aplicação-arrow_forward)

:small_blue_diamond: [Gems usadas](#gems-usadas)

:small_blue_diamond: [Documentação da API](#documentação-da-api)


## Descrição do projeto :star:
<p align="justify"> Listagem de Exames médicos, projeto em foco no aprendizado de Docker e conhecimentos mais crú de desenvolvimento Web, utilizando Sinatra. </p>

## O que a aplicação é capaz de fazer :checkered_flag:

Basicamente, o sistema consiste em duas aplicações interdependentes. A primeira aplicação permite o upload de um arquivo CSV contendo os exames a serem importados. A segunda aplicação, que é o backend, processa e importa esses dados para o banco de dados. O sistema fornece uma listagem completa dos exames médicos, com um campo de busca e a possibilidade de clicar nos "cards" para exibir mais detalhes sobre cada exame.

## Objetivos desse Projeto

Aprimorar o entendimento de aplicações Web e sua infraestrutura, explorando conceitos fundamentais como Docker, servidores web, processamento assíncrono, cache e requisições web. Utilizando o framework minimalista Sinatra para garantir que o processo seja realizado de forma manual, proporcionando um aprendizado mais profundo e prático.

## Pré-requesitos

Este projeto foi desenvolvido usando Docker 27.1.1, então os únicos requisitos necessários em sua maquina é a instalação do Docker Engine e suas pêndencias.

:warning: [Docker](https://docs.docker.com/engine/)

## Como rodar a aplicação :arrow_forward:

1. Clone o repositório do projeto.
2. Entre no diretório do projeto e execute os seguintes comandos:

```bash
docker compose up 
```

É normal este comando levar alguns minutos para concluir, no final ele deve abrir as portas no localhost:4567 ( backend) e localhost:3000 (frontend).

## Como rodar os testes :rocket:

Existem testes para a aplicação de fronted e de backend, com toda a lógica de setup de Banco de Dados dedicado para os testes, juntamente com seu cleanup. Para poder rodar os testes, como temos o uso de docker será necessário 2 comandos:

Para o Backend
```bash
docker compose exec backend rake spec
```

Para o Frontend:
```bash
docker compose exec frontend rake spec
```

Os testes de Frontend tendem a levar um pouco mais de tempo por conta do Javascript e do Selenium

## Principais Gems Usadas:

- **sinatra**: Framework Web bem minimalista que foi utilizado tanto para o frontend quanto o backend.

- **pg**: Gem para se conectar com o banco de dados Postgres

- **rack**: Fornece uma interface entre web server e o framework web sinatra.

- **puma**:  Servidor Web HTTP para lidar com as requisições

- **redis**: Banco de dados em memória, foi utilizado para o enfileiramento de processos assíncronos e serviço de cache

- **sidekiq**: Biblioteca para os backgroundjobs utilizada ( Também permite a visualização web das fileiras ao acessar o localhost:4567/sidekiq )

- **rspec**: Biblioteca de testes utilizada

- **faraday**: Biblioteca HTTP para o Ruby, fornecendo uma interface boa para as requisições HTTP entre frontend e backend

## Documentação da API:
A API está disponível na porta 4567, dentro do container de backend. As rotas são gerenciadas pelo `controller.rb` utilizando o framework Sinatra. As requisições ao banco de dados são feitas através do PostgreSQL (PG), e o Redis é utilizado para cache.


## Listagem de Exames
Este endpoint fornece uma listagem completa dos exames importados do arquivo CSV

**Endpoint**: `GET api/v1tests`

#### Resposta:

Retorna um array de objetos em json, onde cada objeto representa um exame. Cada exame inclui algumas informações como sobre o paciente, médico e tipo de exame.

#### Exemplo de Resposta:

```json
[
  {
    "result_token": "IQCZ17",
    "result_date": "2021-08-05",
    "cpf": "048.973.170-88",
    "name": "Emilly Batista Neto",
    "email": "gerald.crona@ebert-quigley.com",
    "birthday": "2001-03-11",
    "doctor": {
      "crm": "B000BJ20J4",
      "crm_state": "PI",
      "name": "Maria Luiza Pires"
    },
    "tests": [
      {
        "test_type": "hemácias",
        "test_limits": "45-52",
        "result": "97"
      },
      {
        "test_type": "ácido úrico",
        "test_limits": "15-61",
        "result": "2"
      }
    ]
  },
  {
    "result_token": "0W9I67",
    "result_date": "2021-07-09",
    "cpf": "048.108.026-04",
    "name": "Juliana dos Reis Filho",
    "email": "mariana_crist@kutch-torp.com",
    "birthday": "1995-07-03",
    "doctor": {
      "crm": "B0002IQM66",
      "crm_state": "SC",
      "name": "Maria Helena Ramalho"
    },
    "tests": [
      {
        "test_type": "hemácias",
        "test_limits": "45-52",
        "result": "28"
      },
      {
        "test_type": "ácido úrico",
        "test_limits": "15-61",
        "result": "78"
      }
    ]
  },
  {
    "result_token": "T9O6AI",
    "result_date": "2021-11-21",
    "cpf": "066.126.400-90",
    "name": "Matheus Barroso",
    "email": "maricela@streich.com",
    "birthday": "1972-03-09",
    "doctor": {
      "crm": "B000B7CDX4",
      "crm_state": "SP",
      "name": "Sra. Calebe Louzada"
    },
    "tests": [
      {
        "test_type": "hemácias",
        "test_limits": "45-52",
        "result": "48"
      },
      {
        "test_type": "leucócitos",
        "test_limits": "9-61",
        "result": "75"
      },
      {
        "test_type": "ácido úrico",
        "test_limits": "15-61",
        "result": "10"
      }
    ]
  },
]
```

## Detalhes de um Teste
Fornece detalhes de um teste específico ao fornecer um token para a busca.

**Endpoint**: `GET api/v1tests/:token`

#### Parâmetros Aceitos:

- `id`: Token do Teste desejado.

#### Resposta:

Retorna um corpo em JSON contendo os detalhes daquele exame, como nome do paciente e médico, crm e etc...

#### Exemplo de Resposta:

```json
{
  "result_token": "AIWH8Y",
  "result_date": "2021-06-29",
  "cpf": "071.488.453-78",
  "name": "Antônio Rebouças",
  "email": "adalberto_grady@feil.org",
  "birthday": "1999-04-11",
  "doctor": {
    "crm": "B0002W2RBG",
    "crm_state": "CE",
    "name": "Dra. Isabelly Rêgo"
  },
  "tests": [
    {
      "test_type": "hemácias",
      "test_limits": "45-52",
      "result": "6"
    },
    {
      "test_type": "vldl",
      "test_limits": "48-72",
      "result": "88"
    },
    {
      "test_type": "eletrólitos",
      "test_limits": "2-68",
      "result": "66"
    },
    {
      "test_type": "tsh",
      "test_limits": "25-80",
      "result": "59"
    },
    {
      "test_type": "ácido úrico",
      "test_limits": "15-61",
      "result": "43"
    }
  ]
}
```

## Import de Dados de um arquivo CSV
Fornece um endpoint que recebe um arquivo CSV e executa um programa Ruby em processamento assíncrono para importar os dados e inseri-los no banco de dados PostgreSQL. ( Idealmente esse upload é realizado através da interface no frontend )

**Endpoint**: `POST api/v1/import`

#### Parâmetros Aceitos:

- `data.csv`: Arquivo CSV contendo os dados a serem importados.

#### Resposta:

Resposta: Enfileira no redis usando os background jobs do sidekiq a tarefa de importação dos dados do arquivo recebido, após a inserção dos dados contidos no arquivo no banco de dados o arquivo CSV é deletado


#### Exemplo de Resposta de Sucesso:

```json
{ message: 'Data import started successfully' }
```

## Considerações Finais :star:

#### O que eu planejo mudar ou implementar nesse projeto no futuro?

Gostaria de ter implementado a lógica de cache de maneira mais organizada e eficiente. A utilização do Redis para fazer o cache acabou se tornando um pouco confusa e que gerou muitos problemas, principalmente por ser algo novo para mim. Além disso, hesitei em implementar um reverse proxy com NGINX, pensando que não agregaria tanto ao projeto, mas eu acredito que seria um excelente material de estudo e valeria a pena. Além disso deixar o frontend mais reativo e eficiente seria interessante também.

Muito Obrigado!
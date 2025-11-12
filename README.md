# ChitChat-API

API for ChitChat, a chating service made as a test project for Instabug.

### Details:

-  Ruby version ~> 3.4.7

-  System dependencies  
   `MySQL - Redis - RabbitMQ - Elasticsearch` checkout `docker-compose.yml` for more info.

-  Configuration  
   checkout `.env.example` I also added a `.env` file for a demo

## Instructions

1- Add the `.env`  
2- Run `$ docker compose up`  
3- ..wait for eternity  
4- Open the added postman collection and add postman environment variables  
4- Start chatting

## Description

It's a producer/consumer archeticture. Client should interface with the producer "API" for creating Apps, Chats, and Mesages.  
At creating chats and messages the API won't make a call to the database for fast response. Instead it will queue this instruction on RabbitMQ while serving and adding chats and messages counters on the Redis Cache.  
After queuing, the consumers would eventually recieve the instructions and persist them into the database "MySQL" and the Elasticsearch service.

## .env values

```
RAILS_ENV=development

API_PORT=3000
RAILS_MAX_THREADS=5
RAILS_MASTER_KEY=ea7cdd5c5c0c8e4bb13200098471191d

DB_HOST=127.0.0.1
DB_PORT=3307
DB_USERNAME=admin
DB_PASSWORD=Why#does-Spider@Man-only+have-11*months?-He-lost%may
DB_NAME=chitchat

CACHE_HOST=localhost
CACHE_PORT=6379
CACHE_PASSWORD=cacheadmin

QUEUE_HOST=localhost
QUEUE_PORT=5672
QUEUE_MANAGEMENT_PORT=15672
QUEUE_USER=admin
QUEUE_PASSWORD=queueadmin

SEARCH_HOST=localhost
SEARCH_PORT=9200
SEARCH_PASSWORD=searchadmin
```

#### Have fun

# ChitChat

API for ChitChat, a chating service made as a test project for Instabug.

### Details:

* Ruby version ~> 5.0.0

* System dependencies  
  `MySQL - Redis - RabbitMQ - Elasticsearch` checkout `docker-compose.yml` for more info.

* Configuration  
  checkout `.env.example` I also added a `.env` file for a demo

## Instructions  

run  
``` 
$ docker compose up 
```  
..wait for eternity  
then in a new terminal run these commands
```
$ docker compose exec chitchat-api rails db:migrate
$ docker compose exec chitchat-api rake consumers
```

The `rails db:migrate` should build the database tables  
The `rake consumers` should run the consumer workers, whom would persist the new chats and messages into the database and elasticsearch  

## Description  
It's a producer/consumer archeticture. Client should interface with the producer "API" for creating Apps, Chats, and Mesages.  
At creating chats and messages the API won't make a call to the database for fast response. Instead it will queue this instruction on RabbitMQ while serving and adding chats and messages counters on the Redis Cache.  
After queuing, the consumers would eventually recieve the instructions and persist them into the database "MySQL" and the Elasticsearch service.  

## Known Problem  

I've tried to connect the Elasticsearch client `elasticsearch-rails` to the `chitchat-search` container but It won't make the connection to the right host. It gives this error.  
```
Faraday::ConnectionFailed (Failed to open TCP connection to localhost:9200 (Cannot assign requested address - connect(2) for "localhost" port 9200)):
```
I've tried plenty of configurations and searched a lot for answers. I've even tried to connect while disabeling the user and password. but I couldn't make it. However the insertion of messages and searching logic is implemented. It just won't work. I would really appreciate any comments regarding this issue.  

#### Have fun

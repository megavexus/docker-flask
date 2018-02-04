# Dockerized flask application

This Dockerfile creates a minimal alpine docker who runs python and mount a Flask application to keep it running.

# Use

With this docker, we can create different contenarized light flask applications easily, and configure it to work in different ports. Is ideal when we have many apps in development, and we have to work with them.

To use it, we only have to get this structure in our applications:
```
example_app
├── Dockerfile
├── app
│   └── __init__.py
└── requirements.txt
```

And then, in the root of the project, we have to do:

`$ sudo docker run -v .:/flask_app -p 5000:5000 --name flask_app`

In this repository, we have a sample docker compose file too, that will show how to have multiple flask proyects at the same time. The structu of this project is like:

```
.
├── app1
│   ├── Dockerfile
│   ├── app
│   │   └── __init__.py
│   └── requirements.txt
├── app2
│   ├── Dockerfile
│   ├── app
│   │   └── __init__.py
│   └── requirements.txt
.....
└── docker-compose.yml
```

and in our dockerfile, we only have to put all the directories well written:

```yml
# Flask/docker-compose.yml
version: '3'

services:
  app1:
    container_name: app1
    hostname: app1
    build: ./app1
    environment:
      APP_NAME: "Flask example app"
      FLASK_DEBUG: "True"
    ports:
      - "5001:5000"
    volumes:
      - ./app1:/flask_app
    restart: on-failure
    networks:
      - flask_network

   app2:
     container_name: app2
     hostname: app2
     build: ./app2
     environment:
       APP_NAME: "Example test 2"
       FLASK_DEBUG: "True"
     ports:
       - "5002:5000"
     volumes:
       - ./app2:/flask_app
     restart: on-failure
     networks:
       - flask_network

networks:
  flask_network:
    driver: bridge
```

Then, we only have to run `docker-compose up -d` to set un all the directories.

# Environment Variables
- FLASK_DEBUG. It can be True or False, and it activate or deactivate the debug mode of flask.
- APP_NAME. It is the name of the flask app that we will run.

# Add new App

To add a new app, we need to create a new directory in `/` with the name of the app, and copy the Dockerfile in it (we can found it on `./app1/Dockerfile`)

# Use cases
- When need to create multiple dockerized FLask Apps
- In combination of a reverse proxy (nginx/apache), as a production tool for maintaining multiple flask services

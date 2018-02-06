# Dockerized flask application

## Tags:
* latest - flask running on python 2.7
---

This Dockerfile creates a minimal alpine docker who runs python and mount a Flask application to keep it running.

# Use

With this docker, we can create different contenarized light flask applications easily, and configure it to work in different ports. Is ideal when we have many apps in development, and we have to work with them.

To use it, we only have to get this structure in our applications:
```
example_app
├── app
│   └── __init__.py
└── requirements.txt
```

And then, in the root of the project, we have to do:

```bash
$ sudo docker run --name flask_app --restart=always \
        -v /path/to/app/:/flask_app \
        -p 5000:5000 \
        -d megavexus/alpine-flask
```

- `-v /path/to/app/:/app` - specifies the path to the folder containing a file named app.py, which should be your main application

- `-p 5000:5000` - the image exposes port 80, in this example it is mapped to port 80 on the host

- `--restart=always` - This will make the container to try to restart when it fails. Is usefull because in the development process is normal to make some erors.
---
## Use with Docker Compose

In this repository, we have a sample docker compose file too, that will show how to have multiple flask proyects at the same time. The structu of this project is like:

```
.
├── app1
│   ├── app
│   │   ├── __init__.py
│   │   └── ....py
│   └── requirements.txt
├── app2
│   ├── Dockerfile
│   ├── app
│   │   ├── __init__.py
│   │   └── ....py
│   ├── requirements-image.txt
│   └── requirements.txt
.....
└── docker-compose.yml
```

beeing the `<appname>/app/__init__.py` when we

and in our dockerfile, we only have to put all the directories well written:

```yml
# Flask/docker-compose.yml
version: '3'

services:
  app1:
    container_name: app1
    hostname: app1
    build: ./app1
    image: megavexus/alpine-python
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
     image: megavexus/alpine-python
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

## Environment Variables
- **APP_DIR**. Is the main app instalation path. For default, it is `/flask_app`.
- **APP\_FILE\_MAIN**. Is the path of the executable main file inside the app. The default is `/app/__init__.py`.
- **FLASK_DEBUG**. It can be True or False, and it activate or deactivate the debug mode of flask.
- **APP_NAME**. It is the name of the flask app that we will run.

## Add new App

To add a new app, we need to create a new directory in `/` with the name of the app (for example, "myapp"), and having in the root folder the requirements.txt with the python dependencies, and the requirements-image.txt with the alpine (linux) dependencies. Also, we will put the source code in the `app` subfolder:

```
myapp
├── app
│   └── __init__.py
├── requirements-image.txt
└── requirements.txt
```

and now, we will create the docker:

```bash
$ cd myapp
$ sudo docker run --name myapp --restart=always \
        -v .:/flask_app \
        -p 5000:5000 \
        -d megavexus/alpine-flask
```
---
## Installing additional python or flask packages
This image comes with a basic set of python packages and the basic flask and python-pip installation.

If you need any non-default python or flask packages, the container will install them on its first run using python pip and a requirements.txt file. Save a requirements.txt file in the root folder of your app, which is mounted to the /app folder of the container. The format of the file is described in the [pip documentation](https://pip.readthedocs.org/en/1.1/requirements.html#requirements-file-format). After that you can create a new container with the above docker command. The entrypoint script will take care of the package installation listed in the requirements file.

If we need new packages during our development process, we can install it 'in hot' using two files that we will put in the root of our project, in the requirements.txt, and we can call:

```sh
docker exec YOUR_CONTAINER_ID/NAME install_requirements
```

Also, if an additional package is needed during runtime of the container and we dont want to add it to the requirements file, it can be installed with following command.

``` sh
docker exec YOUR_CONTAINER_ID/NAME /bin/sh -c "pip install package-name"
```

## Installing additional Alpine packages
Sometimes, additional python or flask packages need to build some dependecies. Additional Alpine packages can be installed into the container using a requirements file similar to the python requirements file. Listed packages will be installed on the first run of the container.

You need to save a file named requirements_image.txt into the root folder of your app, which is mounted to the /app folder of the container. Just write the packages separated with space or a new line into the file.

If we want to add new packages 'in hot', we also can use the requirements_image.txt file, and the, execute:

```sh
docker exec YOUR_CONTAINER_ID/NAME install_dependencies
```
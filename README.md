# docker_django_dev_env
### A template for quickly deploying a set of Docker containers(Docker Compose) for developing, debugging and running a simple Django project - Django, debugpy, PostgreSQL.

## Description:
This template is intended only for running on a developer's machine, not for deployment to production. A deployed set of containers will allow:
- Editing django project files on the host and the changes will immediately be applied in the container, without the need for rebuilding (mounting the project code into the container via bind mount is configured). A user on the host and in the container with the same name and uid, which avoids conflicts with file rights.
- Debugging code running in a container in VS Code (using the debugpy package and the VS Code configuration file for debugging).
- Launching a container with the project code only after checking that the container with postgres is functioning properly and the database necessary for django has been created in it (healthcheck in docker compose).

## Settings:
1. Copy the project from github.
2. Create a django project in the app folder. 
- The requirements.dev.txt file (which is in the app folder) contains the minimum required packages for working with django, postgres and debugging in the container; add your own packages if necessary.
- In the .env file, replace the environment variables for the django project with your own.
3. To build containers with django and postgres, run
> docker compose -f docker-compose.dev.yml build --build-arg USER=$USER --build-arg UID=$UID
4. To launch all containers in the background, run
> docker compose -f docker-compose.dev.yml up -d
5. To stop all containers, run
> docker compose -f docker-compose.dev.yml stop
6. To start stopped containers, run
> docker compose -f docker-compose.dev.yml start
7. To remove all containers (with volumes attached to them, argument -v) run
> docker compose -f docker-compose.dev.yml down -v
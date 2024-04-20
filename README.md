# docker_django_dev_env
### A template for quickly deploying a set of Docker containers(Docker Compose) for developing, debugging and running a simple Django project - Django, debugpy, PostgreSQL.

## Description:
This template is intended only for running on a developer's machine, not for deployment to production. A deployed set of containers will allow:
- Editing django project files on the host and the changes will immediately be applied in the container, without the need for rebuilding (mounting the project code into the container via bind mount is configured). A user on the host and in the container with the same name and uid, which avoids conflicts with file rights.
- Debugging code running in a container in VS Code (using the debugpy package and the VS Code configuration file for debugging).
- Launching a container with the project code only after checking that the container with postgres is functioning properly and the database necessary for django has been created in it (healthcheck in docker compose).

## Setup:
1. Create a root folder with name your django project and go to it. Copy the template project from github there.
```bash
mkdir name_your_django_project  
cd name_your_django_project  
git clone git@github.com:weirdoomer/docker_django_dev_env.git
cd docker_django_dev_env
```
2. In the **docker_django_dev_env** folder, copy the project's django repository, adding it to the **app** folder
```bash
git clone your_repository_link ./app
```
- The requirements.dev.txt file contains the minimum required packages for working with django, postgres and debugging in the container; add your own packages if necessary.
- In the .env file, replace the environment variables for the django project with your own.
3. To configure debugging in container via debugpy, add to the manage.py file
```python
if settings.DEBUG:
        if os.environ.get('RUN_MAIN'):
            import debugpy
            debugpy.listen(('0.0.0.0', 3000))
            print('debugpy attached!') 
```
4. To build containers with django and postgres, run
```bash
docker compose -f docker-compose.dev.yml build --build-arg USER=$USER --build-arg UID=$UID
```
5. To launch all containers in the background, run
```bash
docker compose -f docker-compose.dev.yml up -d
```
6. To stop all containers, run
```bash
docker compose -f docker-compose.dev.yml stop
```
7. To start stopped containers, run
```bash
docker compose -f docker-compose.dev.yml start
```
8. To remove all containers (with volumes attached to them, argument -v) run
```bash
docker compose -f docker-compose.dev.yml down -v
```

## Development:
- Edit the code and save. When saving files, the runserver inside the container will restart.
- **Django shell** should be used inside a container, not on the host machine (since the database is also deployed inside the container, and not on the host machine). To use **django shell** run
```bash
docker compose -f docker-compose.dev.yml exec web python manage.py shell
```
- Creating and applying migrations as well as other **manage.py** commands should also be executed to the web container via **docker compose exec**

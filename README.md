# docker_django_dev_env
### A template for quickly deploying a set of Docker containers(Docker Compose) for developing, debugging and running a simple Django project - Django, debugpy, PostgreSQL.

## Description:
### This template is intended only for running on a developer's machine, not for deployment to production! 
A deployed set of containers will allow:
- Editing django project files on the host and the changes will immediately be applied in the container, without the need for rebuilding (mounting the project code into the container via bind mount is configured). A user on the host and in the container with the same name and uid, which avoids conflicts with file rights.
- Debugging code running in a container in VS Code (using the debugpy package and the VS Code configuration file for debugging).
- Launching a container with the project code only after checking that the container with postgres is functioning properly and the database necessary for django has been created in it (healthcheck in docker compose).

## Setup:
1. Create a root folder with name your django project and go to it. Copy the template project from github there.
```bash
mkdir name_your_django_project  
cd name_your_django_project  
git clone https://github.com/weirdoomer/docker_django_dev_env.git
cd docker_django_dev_env
```
2. In the **docker_django_dev_env** folder, copy the project's django repository, adding it to the **app** folder
```bash
git clone your_repository_link ./app
```
- In the **app** folder (in which the repository with the django project is cloned) there should be a file called **requirements.txt** and the following packages necessary for the containers to work: **Django, "psycopg[binary]", debugpy**
```bash
(pip freeze command output)

asgiref==3.8.1
debugpy==1.8.1
Django==4.2.11
psycopg==3.1.18
psycopg-binary==3.1.18
sqlparse==0.5.0
typing_extensions==4.11.0
```
- The **docker_django_dev_env** folder should contain a **.env** file with the following environment variables necessary for building containers and running a django project. Instead of **paste_your_variable_value**, paste your values from **settings.py**
```bash
DEBUG=True
SECRET_KEY=paste_your_variable_value
ALLOWED_HOSTS=localhost 127.0.0.1
POSTGRES_ENGINE=django.db.backends.postgresql
POSTGRES_DB=paste_your_variable_value
POSTGRES_USER=paste_your_variable_value
POSTGRES_PASSWORD=paste_your_variable_value
POSTGRES_HOST=db
POSTGRES_PORT=5432
```
3. To configure debugging in container via debugpy, add to the manage.py file
```python
from django.conf import settings


    if settings.DEBUG:
        if os.environ.get('RUN_MAIN'):
            import debugpy
            debugpy.listen(('0.0.0.0', 3000))
            print('debugpy attached!')
```
4. Docker commands:
- to build containers with django and postgres, run
```bash
docker compose build --build-arg USER=$USER --build-arg UID=$UID
```
- to launch all containers in the background, run
```bash
docker compose up -d
```
- to stop all containers, run
```bash
docker compose stop
```
- to start stopped containers, run
```bash
docker compose start
```
- to remove all containers (with volumes attached to them, argument -v) run
```bash
docker compose down -v
```
- to delete all stopped containers, all networks not used by at least one container, all images without at least one container associated to them, all build cache
```bash
docker system prune -a
```

## Development:
- The template has a file with vs code workspace (.vscode/project.code-workspace) and debug config (.vscode/launch.json). To open a project in vs code, open the file **project.code-workspace**.
- The **docker_django_dev_env** folder will contain the template's git repository, the **app** folder will contain your django project's git repository - they are not related to each other. To update the deployment template files, you should do a **git pull** in the **docker_django_dev_env** folder. This will not affect your django project files, which are located in the **app** folder.
- Edit the code and save. When saving files, the runserver inside the container will restart.
- To debug the django project code, set breakpoints in the django project code, then in vs code click on the **Run and Debug** icon in the right panel and click on **the green play button** (the debugging configuration name will be **Python Debugging: Remote Attach**).
- **Django shell** should be used inside a container, not on the host machine (since the database is also deployed inside the container, and not on the host machine). To use **django shell** run
```bash
docker compose exec web python manage.py shell
```
- Creating and applying migrations as well as other **manage.py** commands should also be executed to the web container via **docker compose exec**

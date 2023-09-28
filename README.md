# Docker tutorial

Welcome to this hands-on Docker tutorial. The following exercises will take you on a tour to experience the features of Docker.

## Exercise 1 (optional): Basic Setup

If your docker environment is already set up, you can skip to the end of this exercise to verify that you are good to go.
Otherwise, set up your environment as follows.

### Docker Installation
First of all, install docker while ensuring no prior Docker installation corrupts the installation process:
```
sudo apt update
sudo apt-get remove docker docker-engine docker.io containerd runc
sudo apt install docker.io -y
```

### Autostart
Add Docker to autostart:
```
echo '# Start Docker daemon automatically when logging in if not running.' >> ~/.bashrc
echo 'RUNNING=`ps aux | grep dockerd | grep -v grep`' >> ~/.bashrc
echo 'if [ -z "$RUNNING" ]; then' >> ~/.bashrc
echo '    sudo dockerd > /dev/null 2>&1 &' >> ~/.bashrc
echo '    disown' >> ~/.bashrc
echo 'fi' >> ~/.bashrc
```

### Grant Docker Permissions
Add the current user to docker-Group
```
sudo usermod -a -G docker $USER
```
Now you need to log out and log back in again to make this change effective.

### Verify That You Are Good To Go
To verify that you are good to go, check that Docker is installed correctly by displaying the installed Docker version:
```
docker -v
docker version
```

Now, display some Docker-related system information:
```
docker info
```

Now, try to create and run the Docker 'hello-world' container. This may take a while for the first time:
```
docker run hello-world
```
Read the output of the command. It tells you what Docker did behind the scenes to create this output.

You can now check that the 'hello-world' container had been started and is now stopped by running the following command:
```
docker ps -a
```

## Exercise 2: Containers
In this exercise, you will learn about Docker containers.

### Local List of Images
Containers are instantiated from images. Display your locally available images by running the following command:
```
docker images
```
Probably, there won't be much to see beyond the 'hello-world' container image, unless you previously played around with your local Docker installation.

### Output Containers
Check the list of instantiated containers. The `-a` switch is used to included stopped containers; without it, the command would only display containers that are currently running:
```
docker ps -a
```

### Set up Demo Container Images
Before we explore the commands to create, start and manipulate containers, we first need a few suitable container images. Execute the following commands. The first time, this may take a while.
```
cd todo-app/cli
docker build --tag=todo-cli:v1 .
cd ../api
docker build --tag=todo-api:v1 .
cd ../ui
docker build --tag=todo-ui:v1 .
cd ../../
```
Don't worry if you don't exactly understand what you just did, we will get to that later. (But if you are curious: you just build your first container images!)

Now, check the list of locally available images again.
```
docker images
```
You should now see entries named 'todo-cli', 'todo-api', and 'todo-ui'.

### Create a Container

Using the container image, create a container named 'my-todo-cli' from the image 'todo-cli:v1' (but don't start it yet):
```
docker create -it --name my-todo-cli todo-cli:v1
```

### Start the Container
Start the newly created container:
```
docker start -i my-todo-cli
```
You should see the Spring Boot logo, some logging, and a list of todos. Congratulations, you just ran a Spring Boot java application without needing to worry about having the correct Java runtime environment installed!

List your locally instiated containers again: the container 'my-todo-cli' you just started is already stopped again, because its main process has termined:
```
docker ps -a
```

### Remove the Container
Now remove the container again:
```
docker rm my-todo-cli
```

### Create and Start the Container in One Go
Run and directly start a container named 'my-todo-cli' from the image 'todo-cli:v1'
```
docker run -it --name my-todo-cli todo-cli:v1
```
As you can see, the Docker command 'run' is basically a combination of the commands 'create' and 'start'.

### Prune Unused Containers
We want to remove the container again, but while we are at it, we can also remove other stopped containers we no longer use, for example the one from the first exercise (if you didn't skip it):
```
docker container prune
```

List your locally instiated containers again:
```
docker ps -a
```
The list should be empty now.

### Port Mappings
Create and directly run a container named 'my-todo-api' from the image 'todo-api:v1' (`--rm` will cause the container to be removed once it stops)
```
docker run --rm -d --name my-todo-api -p 80:9080 todo-api:v1
```
At this point, it makes sense to check the port using the browser: you should be able to call http://localhost/api/v1/todos and see some cryptic output (JSON, to be precise).

### Pause Container
Pause the container:
```
docker pause my-todo-api
docker ps -a
```
Check http://localhost/api/v1/todos again. It won't respond.

### Resume Container
Resume the container:
```
docker unpause my-todo-api
docker ps -a
```
Check http://localhost/api/v1/todos again. It should respond again.

### Stop Self-Removing Container
Stop the container 'my-todo-api' (and thereby directly remove it, due to the `--rm` switch at the start):
```
docker stop my-todo-api
docker ps -a
```

As you can see, the container is gone. For the remainder of the tutorial, we will almost always use the `--rm` switch when starting containers, so that they get cleaned up automatically.

## Exercise 3: Images
We will now take a closer look at images, which basically are the blueprints of containers.

### Pulling Images
You may have noticed that some of the images we used in the previous exercises were built locally, but in the first exercise, we used an image called 'hello-world' that we didn't build locally. It was pulled from a Docker registry automatically when we ran it.
However, we can also pull images from a registry manually.

First of all, remove the existing 'hello-world' image, if you have it:
```
docker image rm hello-world
docker images
```
The 'hello-world' image should not appear in the list.

Now, without running it, pull the image from the registry manually and list your local images again:
```
docker pull docker.io/library/hello-world:latest
docker images
```
The list should now contain the image 'hello-world'.

### Inspect Images
List the currently available images again:
```
docker images
```

Inspect the image 'hello-world' more closely:
```
docker image inspect hello-world
docker image history hello-world
```

You can to the same for the image 'todo-cli':
```
docker image inspect todo-cli:v1
docker image history todo-cli:v1
```

### Tagging Images
Give a custom tag to the image 'todo-cli':
```
docker image tag todo-cli:v1 my-todo-cli:latest
docker images
```

### Remove Custom Tag
Remove the tag:
```
docker image rm my-todo-cli:latest
docker images
```

### Manipulating Containers
instantiate the 'todo-ui:v1' image to a container 'my-todo-ui':

```
docker run --rm -d -p 80:80 --rm --name my-todo-ui todo-ui:v1
```

Check the website http://localhost. It should show you an empty list of todos and a text input field and button to add new items to the list.
You may be wondering why the list is empty and why the button doesn't work. It's because the API that serves this web application is not running yet. You can easily fix this by running a container 'my-todo-api' from the image 'todo-api:v1' we already used in an earlier exercise:
```
docker run --rm -d --name my-todo-api -p 9080:9080 todo-api:v1
```

Now wait until the API container is started up (this may take a few seconds, up to about half a minute) and refresh http://localhost in your browser. It should show you a list of todos (the same we already saw on the command line in an earlier exercise), and the button should work now. Try it out!

Now imagine you are asked to change the color of the button to red. (*This should usually be part of the development process and produce a new image, but for the sake of the exercise, we do it directly in the place.*)

```
docker exec 'my-todo-ui' sh -c "/bin/echo '.btn-primary { background-color: red "'!'"important; }' > /usr/share/nginx/html/assets/override.css"
```
You do not need to understand the details of the command, but what you just did is that you used `docker exec` to execute a command inside a running docker container to modify its internal file system. You can verify your change by refreshing http://localhost.

### Create Image from Modified Container
Note that the previous change only applies to the specific container instance. Once the container is removed, and you instantiate a new container from the image 'todo-ui', the button is blue again.

You can, however, create a new image from your modification using `docker commit`:
```
docker commit my-todo-ui todo-ui:v2
docker stop my-todo-ui
docker run --rm -d -p 80:80 --rm --name my-todo-ui todo-ui:v2
```
Because you used the new image to run the new container, the button is still red.

### Optional: Push Container
If you have write access to a container registry (for example, using a free account at https://hub.docker.com/), you can push the new image to that registry, making it availble to others:
```
docker login -u your_user_name # Use your account name from hub.docker.com here instead of 'your_user_name'
docker image tag todo-ui:v2 your_user_name/todo-ui:v2 # Again, replace 'your_user_name' as above
docker push your_user_name/todo-ui:v2 # Again, replace 'your_user_name' as above
```

Before we move on to the next exercise, stop the running containers:
```
docker stop my-todo-ui my-todo-api
```

## Exercise 4: Dockerfile
In the previous exercise, we saw that we can create images from containers, but if that felt hacky and backwards to you, its because it was. The usual way to create an image is using a Dockerfile.

### Prepare Application
First of all, we will prepare the application.
Copy the UI application to a new directory:
```
mkdir todo-app/ui-v3
cp -r todo-app/ui/dist todo-app/ui-v3/
```
Now, using the editor of your choice, modify the file `todo-app/ui-v3/dist/assets/override.css` such that it contains the following contents:
```
.btn-primary { background-color: green !important; }
```
Double check to verify that there are no comments ("/*", "*/") and the color is green, not red. Save the file.

### Containerize a Prebuilt Application
Now, create a new file `todo-app/ui-v3/Dockerfile` and fill it with the following contents:
```
# syntax=docker/dockerfile:1
FROM nginx:1.25-alpine
COPY dist /usr/share/nginx/html

CMD ["/bin/sh",  "-c",  "envsubst < /usr/share/nginx/html/assets/env.template.js > /usr/share/nginx/html/assets/env.js ; exec nginx -g 'daemon off;'"]
```
Try to understand the instructions you just put into the Dockerfile:
- The first line `# syntax=docker/dockerfile:1` is optional and just an instruction to your editor to apply the correct syntax highlighting, if it supports Dockefiles
- `FROM nginx:1.25-alpine` specifies the base image. We use nginx, because it is a suitable, reasonably lightweight webserver.
- `COPY dist /usr/share/nginx/html` copies the application files into the image file system.
- `CMD` specifies the process to be executed. You don't need to understand the details of the command here, but basically it runs the nginx webserver.

```
cd todo-app/ui-v3
docker build --tag=todo-ui:v3 .
docker images
cd ../..
```

Now create and run a container from the new image:
```
docker run --rm -d -p 80:80 --rm --name my-todo-ui todo-ui:v3
```

Check http://localhost to see that the button is green, then stop the container.
```
docker stop my-todo-ui
```

### Build and Containerize an Application
We just used a Dockefile to containerize a pre-built web application, which was pretty simple.

Of course, Dockerfiles are more powerful than that. For example, they can also be used to build the application from the source code beforehand, in a well-defined build environment.

Now, create a new file `todo-app/ui-src/Dockerfile` and fill it with the following contents:
```
# syntax=docker/dockerfile:1
#################
# Build the app #
#################
FROM node:20-alpine as build-step
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm install
COPY . .
RUN npm install -g @angular/cli
RUN ng build --configuration production --output-path=/dist

################
# Run in NGINX #
################
FROM nginx:1.25-alpine
COPY --from=build-step /dist /usr/share/nginx/html

# When the container starts, replace the env.js with values from environment variables
CMD ["/bin/sh",  "-c",  "envsubst < /usr/share/nginx/html/assets/env.template.js > /usr/share/nginx/html/assets/env.js ; exec nginx -g 'daemon off;'"]
```
As you can see, the instructions now first build the web application from its source code. This is done in a dedicated build environment specified using `FROM node:20-alpine as build-step`.
The results of the build are accessed in a second step (that is similar to the previous Dockerfile) using the instruction `COPY --from=build-step /dist /usr/share/nginx/html`.

Now, build the image:
```
cd todo-app/ui-src
docker build --tag=todo-ui:v4 .
docker images
cd ../..
```

## Exercise 5: Troubleshooting
In this exercise, we will explore some options to gain insights into what is happening (or has happened) inside a container.

### Log Drivers
A common requirement during troubleshooting is viewing logs.
Depending on which log driver is configured for a container, logs may look differently.

#### Json-File
Try the default log driver: json-file
```
docker run --name my-todo-cli-ex5a todo-cli:v1
docker inspect -f '{{.HostConfig.LogConfig.Type}}' my-todo-cli-ex5a
docker logs my-todo-cli-ex5a
```

#### None
Try the log driver 'none':
```
docker run --name my-todo-cli-ex5b --log-driver 'none' todo-cli:v1
docker inspect -f '{{.HostConfig.LogConfig.Type}}' my-todo-cli-ex5b
docker logs my-todo-cli-ex5b
```

#### Local
Try the log driver 'local':
```
docker run --name my-todo-cli-ex5c --log-driver 'local' todo-cli:v1
docker inspect -f '{{.HostConfig.LogConfig.Type}}' my-todo-cli-ex5c
docker logs my-todo-cli-ex5c
```

After inspecting and comparing the different outputs, clean up the containers:
```
docker rm my-todo-cli-ex5a my-todo-cli-ex5b my-todo-cli-ex5c
```

### Docker Exec
We already used `docker exec` in a previous exercise. Of course, it can also be used to inspect a container from the inside:

```
docker run --rm -d -p 80:80 --rm --name my-todo-ui-5 todo-ui:v1
docker exec my-todo-ui-5 ls /
docker exec my-todo-ui-5 cat /usr/share/nginx/html/assets/override.css
```
The first of the two exec commands listed the contents of the container file system's root folder. The second exec command printed the contents of a file inside the container's file system.

`docker exec` can also be used to get an interactive shell inside the container:
```
docker exec -it my-todo-ui-5 sh
```
Inside this shell, you can execute arbitrary commands supported by the container, such as `ls /`.
You can quit the interactive session in the usual way, i.e., by issuing the `exit` command:
```
/ # exit
```

Stop the container after you are done:
```
docker stop my-todo-ui-5
```

## Exercise 6: Persistence
In the previous exercises, the todo demo application we are using stored the items you add in a database in the container's own file system. This means that data is not shared with other containers instantiated from the same image, and that once you remove the container, the data is gone.

### No Persistence
Instantiate the 'todo-api:v1' image to a container 'my-todo-api' and
instantiate the 'todo-ui:v1' image to a container 'my-todo-ui':

```
docker run --rm -d --name my-todo-api -p 9080:9080 todo-api:v1
docker run --rm -d -p 80:80 --rm --name my-todo-ui todo-ui:v1
```

Visit http://localhost and add some items. (Remember that you may need to wait a few seconds until the API is ready.)
Now restart the container:
```
docker restart my-todo-api
```

Again, wait a few seconds until the API is started up, then revisit http://localhost. The items you added are still there, because the container was not removed, only restarted.

Now stop (and thereby remove, due to the `--rm` switch) and rerun the API container:

```
docker stop my-todo-api
docker run --rm -d --name my-todo-api -p 9080:9080 todo-api:v1
```

Again, wait a few seconds until the API is started up, then revisit http://localhost. The items you added are gone.

Stop the API container in preparation for the next section:
```
docker stop my-todo-api
```

### Volumes
Create a docker volume and use it for the API container:
```
docker volume create todo-app
docker run --rm -d --name my-todo-api -p 9080:9080 --mount 'type=volume,source=todo-app,target=/local-db' todo-api:v1
```

Visit http://localhost and add some items. (Remember that you may need to wait a few seconds until the API is ready.)

Now stop (and thereby remove, due to the `--rm` switch) and rerun the API container:

```
docker stop my-todo-api
docker run --rm -d --name my-todo-api -p 9080:9080 --mount 'type=volume,source=todo-app,target=/local-db' todo-api:v1
```

Again, wait a few seconds until the API is started up, then revisit http://localhost. The items you added are still there.

Stop the API container in preparation for the next section:
```
docker stop my-todo-api
```

### Bind Mounts
Another option is using bind mounts.
Create a bind mount on the docker host to share it with the container:

```
mkdir mountdir
mountdir=`readlink -f mountdir/`
```

Now, use the bind mount to run the API container:
```
docker run --rm -d --name my-todo-api -p 9080:9080 --mount 'type=bind,source=${mountdir},target=target=/local-db' todo-api:v1
```

Visit http://localhost and add some items. (Remember that you may need to wait a few seconds until the API is ready.) Stop and rerun the API container:

```
docker stop my-todo-api
docker run --rm -d --name my-todo-api -p 9080:9080 --mount 'type=bind,source=${mountdir},target=target=/local-db' todo-api:v1
```

Again, wait a few seconds until the API is started up, then revisit http://localhost. The items you added are still there.

Stop the API container in preparation for the next section:
```
docker stop my-todo-api
```

### Optional: Tmpfs (Not Supported on Windows)
Another mount option is using `tmpfs`. However, this feature does not add persistence, it reduces it: contents of `tmpfs` are lost as soon as a container stops, even if you restart the same container again.

```
docker run --rm -d --name my-todo-api -p 9080:9080 --mount 'type=tmpfs,target=target=/local-db' todo-api:v1
```

Visit http://localhost and add some items. (Remember that you may need to wait a few seconds until the API is ready.) Stop and rerun the API container:

```
docker restart my-todo-api
```

Again, wait a few seconds until the API is started up, then revisit http://localhost. The items you added are gone.

Stop the containers in preparation for the next exercise:
```
docker stop my-todo-ui my-todo-api
```

## Exercise 7: Network
In practical use cases, some containers will need to talk to each other, while others should explicitly be isolated. The concept of networks is used to control how containers can communicate with each other and the host.

### Network Types
First, we take a look at the basic network types offered by Docker.

#### Bridge (default)
The default network type is called `bridge`.
Instantiate the 'todo-api:v1' image to a container 'my-todo-api' and
instantiate the 'todo-ui:v1' image to a container 'my-todo-ui', using the `bridge` network type for each of them:
```
docker run --rm -d --name my-todo-api -p 9080:9080 --network 'bridge' todo-api:v1
docker run --rm -d -p 80:80 --rm --name my-todo-ui --network 'bridge' todo-ui:v1
```
This is basically the network type we used in the previous exercises, only now we specified it explicitly. Visit http://localhost to check that everything works as expected.

Stop the containers in preparation for the next section:
```
docker stop my-todo-ui my-todo-api
```

#### Optional: Host (Not Supported in WSL2)
Another network type is called `host`. It is used to have a container share the host's network interface.
Instantiate the 'todo-api:v1' image to a container 'my-todo-api' and
instantiate the 'todo-ui:v1' image to a container 'my-todo-ui', using the `host` network type for each of them:
```
docker run --rm -d --name my-todo-api --network 'host' todo-api:v1
docker run --rm -d --rm --name my-todo-ui --network 'host' todo-ui:v1
```
Visit http://localhost to check that everything works as expected. Note that no port mapping was required.

Stop the containers in preparation for the next section:
```
docker stop my-todo-ui my-todo-api
```

### Network: None
Another network type is called `none`. It is used to prevent all communication.
Instantiate the 'todo-api:v1' image to a container 'my-todo-api' and
instantiate the 'todo-ui:v1' image to a container 'my-todo-ui', using the `none` network type for each of them:
```
docker run --rm -d --name my-todo-api -p 9080:9080 --network 'bridge' todo-api:v1
docker run --rm -d -p 80:80 --rm --name my-todo-ui --network 'bridge' todo-ui:v1
```
Visit http://localhost. Note that even though we provide a network mapping, the network type `none` prevents all communication, even from the host to the container.

Stop the containers in preparation for the next section:
```
docker stop my-todo-ui my-todo-api
```

### Dedicated Bridge Networks
We will now take a look at how we can create bridge networks to let specific groups of containers talk to each other.

First of all, create a new bridge network called 'todo-api'
```
docker network create --driver 'bridge' todo-api
```

Instantiate the 'todo-api:v1' image to a container 'my-todo-api' and connect it to the newly created bridge network 'todo-api'.
```
docker run --rm -d --name my-todo-api -p 9080:9080 --net 'todo-api' todo-api:v1
```
Instantiate the 'todo-ui:v1' image to a container 'my-todo-ui' using the default network:
```
docker run --rm -d -p 80:80 --rm --name my-todo-ui todo-ui:v1
```
Visit http://localhost. Note that the web app works despite the two containers being in different networks, because the UI is only served by the 'my-todo-ui' container and is actually running on the host (inside the browser, specifically), which can access the 'my-todo-api' container via the port mapping.

To see a difference, we need to try to access the container from another container, so we create a new one we can use as a terminal.
First of all, we try to directly access the API from this new container:
```
docker run --rm -t alpine/curl 'localhost:9080/api/v1/todos'
```
This does not work, because 'localhost' is interpreted *in the context of the container*, i.e., it points to the terminal container, not to the Docker host system.

So we can retry using the correct hostname, which is the name of the API container: 'my-todo-api':
```
docker run --rm -t alpine/curl 'my-todo-api:9080/api/v1/todos'
```
However, this also does not work, because the terminal container is not in the same bridge network as the API container. Fix this by adding the parameter `--net todo-api`:
```
docker run --rm -t --net todo-api alpine/curl 'my-todo-api:9080/api/v1/todos'
```
Now you should see the correct ouput, which is the JSON list of todo items.

## Exercise 8: Security
To finish up, we take a brief look at some basic security measures.

### Image Digest
Run hello-world from image digest, once without tag, once with a made-up tag:
```
docker run --rm hello-world@sha256:aa0cc8055b82dc2509bed2e19b275c8f463506616377219d9642221ab53cf9fe
docker run --rm hello-world:my-madeup-tag@sha256:aa0cc8055b82dc2509bed2e19b275c8f463506616377219d9642221ab53cf9fe
```
Note that even though the tag does not exist, the second command works just as well as the first one, because the tag is ignored.

### Security Bench
Run security bench:
```
docker run -it --net host --pid host --userns host --cap-add audit_control \
    -e DOCKER_CONTENT_TRUST=$DOCKER_CONTENT_TRUST \
    -v /var/lib:/var/lib \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v /usr/lib/systemd:/usr/lib/systemd \
    -v /etc:/etc --label docker_bench_security \
    docker/docker-bench-security
```
Take a look at the output. This report is an example of what security bench can do for any container image.
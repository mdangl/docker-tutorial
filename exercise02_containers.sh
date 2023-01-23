#/bin/sh!

# Output Docker version information
docker -v
docker version
# Output Docker-related system informationen
docker info


# Output local list of images
docker images
# Output containers ("-a": including stopped ones)
docker ps -a


# Create a container named "my-hello-world" from the image "hello-world" (but don't start it yet)
docker create -it --name my-hello-world hello-world
# Start the newly created container
docker start -i my-hello-world
# Output containers ("-a": including stopped ones): the previously started container is already stopped again, because its main process has termined)
docker ps -a
# Remove the previously started container
docker rm my-hello-world


# Run and directly start a container named "my-hello-world" from the image "hello-world"
docker run -it --name my-hello-world hello-world
# Remove the previously started container
docker rm my-hello-world


# Load the image "nginx" from the Docker registry
docker pull nginx
# Create and directly run a container named "nginx" from the image "nginx" ("--rm" will cause the container to be removed once it stops)
docker run --rm -d --name -p 80:80 nginx nginx
# (at this point, it makes sense to check the port using the browser; nginx should respond)

# Pause container "nginx"
docker pause nginx
docker ps -a
# (at this point, it makes sense to check the port using the browser; nginx should not respond)

# Resume container "nginx"
docker unpause nginx
docker ps -a
# (at this point, it makes sense to check the port using the browser; nginx should respond again)

# Stop container "nginx" (and thereby directly remove it, due to the "--rm" switch at the start)
docker stop nginx
docker ps -a

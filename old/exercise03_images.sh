#/bin/sh!

# List currently locally available images
docker images
# Inspect image "hello-world" more closely
docker image inspect hello-world
docker image history hello-world

# Pull the image "getting-started" from the registry
docker pull docker.io/docker/getting-started:latest
# Give a custom tag to the image
docker image tag docker/getting-started my-getting-started
# List currently locally available images
docker images
# Remove custom tag
docker image rm my-getting-started
docker images

# Instantiate "getting-started" image to a container "getting-started-ex03"
docker run -d -p 80:80 --rm --name getting-started-ex03 docker/getting-started
# (at this point, it makes snese to check the corresponding port with a web browser to inspect the hosted website)

# Modify website
docker exec getting-started-ex03 /bin/sed -i 's/Congratulations!/<span style="color: green">Congratulations!<\/span>/g' /usr/share/nginx/html/tutorial/index.html
# (the modification should be visible using the browser)

# Create new image from the running (modified!) container
docker commit getting-started-ex03 getting-started-ex03-result
# Stop container
docker stop getting-started-ex03

## If desired: remove new image
#docker image rm getting-started-ex03-result

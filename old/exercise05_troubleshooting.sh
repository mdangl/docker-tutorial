#/bin/sh!

# Try the default log driver: json-file
docker run --name hello-world-ex05a hello-world
docker inspect -f '{{.HostConfig.LogConfig.Type}}' hello-world-ex05a
docker logs hello-world-ex05a

# Try the log driver 'none'
docker run --name hello-world-ex05b --log-driver 'none' hello-world
docker inspect -f '{{.HostConfig.LogConfig.Type}}' hello-world-ex05b
docker logs hello-world-ex05b

# Try the log driver 'local'
docker run --name hello-world-ex05c --log-driver 'local' hello-world
docker inspect -f '{{.HostConfig.LogConfig.Type}}' hello-world-ex05c
docker logs hello-world-ex05c

# Clean up containers
docker rm hello-world-ex05a hello-world-ex05b hello-world-ex05c

# Docker exec
docker run -p 3000:3000 --name getting-started-ex05a --rm --detach getting-started:ex04c
#docker exec -it getting-started-ex05a sh
docker exec getting-started-ex05a ls /
docker exec getting-started-ex05a cat /app/src/static/index.html
echo



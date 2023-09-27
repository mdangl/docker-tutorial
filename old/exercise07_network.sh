#/bin/sh!

# Network: bridge (default)
echo "===== Bridge: ===== "
docker run -p 3000:3000 --name getting-started-ex07a --network 'bridge' --rm --detach getting-started:ex04c
sleep 1
curl 'http://localhost:3000/items'
echo
docker stop getting-started-ex07a

# Network: host
echo "===== Host (not supported in WSL2): ===== "
docker run --name getting-started-ex07b --network 'host' --rm --detach getting-started:ex04c
sleep 1
curl 'http://localhost:3000/items'
docker stop getting-started-ex07b

# Network: none
echo "===== None: ===== "
docker run -p 3000:3000 --name getting-started-ex07c --network 'none' --rm --detach getting-started:ex04c
sleep 1
curl 'http://localhost:3000/items'
docker stop getting-started-ex07c

# Create a new bridge network
docker network create --driver 'bridge' bridge-ex07
# Create a postgres container in the new bridge network
docker run --net 'bridge-ex07' --rm --detach -e POSTGRES_HOST_AUTH_METHOD=trust --name postgres-ex07a postgres
# Create a postgres container in the default bridge network
docker run --net 'bridge' --rm --detach -e POSTGRES_HOST_AUTH_METHOD=trust --name postgres-ex07b postgres
# Create a pgAdmin container in the new bridge network
docker run --net 'bridge-ex07' --rm -p 5050:80 -e PGADMIN_DEFAULT_EMAIL=docker@ars.de -e PGADMIN_DEFAULT_PASSWORD=012345 --name pgAdmin --detach dpage/pgadmin4
# (Now verify that you can add the first postgres server, but not the second one, to pgAdmin)

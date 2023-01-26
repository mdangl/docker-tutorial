#/bin/sh!

# Try without persistence
echo '===== Without persistence ====='
docker run -p 3000:3000 --name getting-started-ex06a --rm --detach getting-started:ex04c
sleep 1
echo "Initial list:"
curl 'http://localhost:3000/items'
echo
curl 'http://localhost:3000/items' -H 'Content-Type: application/json' --data-raw '{"name":"Dishes"}'
echo
echo "After adding 'Dishes':"
curl 'http://localhost:3000/items'
echo
docker restart getting-started-ex06a
sleep 1
echo "After restart:"
curl 'http://localhost:3000/items'
echo
docker stop getting-started-ex06a
docker run -p 3000:3000 --name getting-started-ex06a --rm --detach getting-started:ex04c
sleep 1
echo "After removal and creation of a new container:"
curl 'http://localhost:3000/items'
echo
docker stop getting-started-ex06a

# Try out volumes
echo '===== Using volumes ====='
docker volume create getting-started-ex06
docker run -p 3000:3000 --name getting-started-ex06b --rm --detach --mount 'type=volume,source=getting-started-ex06,target=/etc/todos' getting-started:ex04c
sleep 1
echo "Initial list:"
curl 'http://localhost:3000/items'
echo
curl 'http://localhost:3000/items' -H 'Content-Type: application/json' --data-raw '{"name":"Dishes"}'
echo
echo "After adding 'Dishes':"
curl 'http://localhost:3000/items'
echo
docker restart getting-started-ex06b
sleep 1
echo "After restart:"
curl 'http://localhost:3000/items'
echo
docker stop getting-started-ex06b
docker run -p 3000:3000 --name getting-started-ex06b --rm --detach --mount 'type=volume,source=getting-started-ex06,target=/etc/todos' getting-started:ex04c
sleep 1
echo "After removal and creation of a new container:"
curl 'http://localhost:3000/items'
echo
docker stop getting-started-ex06b
docker volume prune -f

# Try out bind mounts
echo '===== Using bind mounts ====='
mkdir mountdir
mountdir=`readlink -f mountdir/`
docker run -p 3000:3000 --name getting-started-ex06c --rm --detach --mount "type=bind,source=${mountdir},target=/etc/todos" getting-started:ex04c
sleep 1
echo "Initial list:"
curl 'http://localhost:3000/items'
echo
curl 'http://localhost:3000/items' -H 'Content-Type: application/json' --data-raw '{"name":"Dishes"}'
echo
echo "After adding 'Dishes':"
curl 'http://localhost:3000/items'
echo
docker restart getting-started-ex06c
sleep 1
echo "After restart:"
curl 'http://localhost:3000/items'
echo
docker stop getting-started-ex06c
docker run -p 3000:3000 --name getting-started-ex06c --rm --detach --mount "type=bind,source=${mountdir},target=/etc/todos" getting-started:ex04c
sleep 1
echo "After removal and creation of a new container:"
curl 'http://localhost:3000/items'
echo
docker stop getting-started-ex06c
rm -rf mountdir

# Try out tmpfs
echo '===== Using tmpfs ====='
docker volume create getting-started-ex06
docker run -p 3000:3000 --name getting-started-ex06d --rm --detach --mount 'type=tmpfs,target=/etc/todos' getting-started:ex04c
sleep 1
echo "Initial list:"
curl 'http://localhost:3000/items'
echo
curl 'http://localhost:3000/items' -H 'Content-Type: application/json' --data-raw '{"name":"Dishes"}'
echo
echo "After adding 'Dishes':"
curl 'http://localhost:3000/items'
echo
docker restart getting-started-ex06d
sleep 1
echo "After restart:"
curl 'http://localhost:3000/items'
echo
docker stop getting-started-ex06d

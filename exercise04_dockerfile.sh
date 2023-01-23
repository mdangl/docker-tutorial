#/bin/sh!

dockerLogin="mdangl.azurecr.io"

# Create image from Dockerfile (getting-started)
git clone https://github.com/docker/getting-started.git
cd getting-started/app

echo '# syntax=docker/dockerfile:1' > Dockerfile
echo 'FROM node:18-alpine' >> Dockerfile
echo 'WORKDIR /app' >> Dockerfile
echo 'COPY . .' >> Dockerfile
echo 'RUN yarn install --production' >> Dockerfile
echo 'CMD ["node", "src/index.js"]' >> Dockerfile
echo 'EXPOSE 3000' >> Dockerfile

docker build -t getting-started-ex04a .
docker images

# Modify Dockerfile
sed -i 's/18-alpine/19-alpine/g' Dockerfile
docker build -t getting-started-ex04b .

# Push image to Azure
docker tag getting-started-ex04b "${dockerLogin}/getting-started-ex04b:v1"
az acr login --name $dockerLogin
docker push "${dockerLogin}/getting-started-ex04b:v1 "
docker images

# Create and apply Kubernetes configuration
echo "apiVersion: apps/v1
kind: Deployment
metadata:
  name: getting-started
  labels:
    app.kubernetes.io/name: getting-started
spec:
  selector:
    matchLabels:
      app: getting-started
  replicas: 1
  template:
    metadata:
      labels:
        app: getting-started
    spec:
      containers:
      - name: getting-started
        image: ${dockerLogin}/getting-started-ex04b:v1
        ports:
        - containerPort: 3000
          name: http-gs
---
apiVersion: v1
kind: Service
metadata:
  name: getting-started
spec:
  type: LoadBalancer
  ports:
    - protocol: TCP
      port: 80
      targetPort: http-gs
  selector:
    app: getting-started" | kubectl apply -f -

cd ../..
rm -rf getting-started

# Create Lynx image from STDIN
echo '# syntax=docker/dockerfile:1
FROM debian:latest
RUN apt update
RUN apt install lynx -y
CMD ["lynx"]
' | docker build -t lynx-ex04 -
docker images
docker image rm lynx-ex04
docker images

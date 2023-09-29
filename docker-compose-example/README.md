# Docker compose tutorial

You may have noticed that the handling with the single docker run commands is not optimal for a production environment. The individual containers are started independently, for example the user interface only works if we wait long enough for the api container. Another issue is, for example port sharing on the host system. In a produtcive environment you often want few ports to be shared and route the accesses through a gateway or proxy. All these things, and many more we can achieve with a Docker compose file.

## Advantages

Docker Compose is a tool used within the Docker ecosystem to simplify the definition and management of multiple Docker containers. It offers several advantages, including:

- Easy Container Orchestration: Docker Compose allows you to start, stop, and manage multiple containers simultaneously, making it easier to orchestrate complex applications consisting of multiple interacting containers.

- Declarative Configuration: Docker Compose uses YAML files to describe your application's configuration. This makes the configuration easy to understand and well-documented. You can define the desired containers, their settings, and connections in a single file.

- Isolation: Docker containers are inherently isolated, and Docker Compose helps maintain this isolation while allowing you to share resources among containers. Each container has its own environment, and dependencies between containers can be clearly defined.

- Reusability: You can reuse Docker Compose files across different environments (development, testing, production), making it easier to scale and customize your application as needed.

- Rapid Development and Testing: Docker Compose significantly simplifies local development and testing of applications. Developers can build and run container images without having to replicate the production environment.

- Scalability: While Docker Compose is primarily used for local development and testing, it can also serve as a foundation for orchestration tools like Docker Swarm or Kubernetes. This allows for seamless scaling of your application from a single development environment to a production-ready cluster.

- Community Support: Docker Compose is widely used and has an active community. You'll find many pre-built Docker images and Compose files for commonly used applications and services.

- Consistency: Docker Compose ensures that your application is deployed consistently across different environments, using the same containers and configurations.

Overall, Docker Compose significantly simplifies the management of Docker containers and provides an efficient way to develop, test, and run containerized applications.


## Getting Started

To use our example, we need to make a few preparations. For this we need to create a network and a volume.

```
docker network create --driver bridge todo-app-network
docker volume create todo-app-volume
```
After that we can run our stack by executing the following command

```
docker compose up -d
```

What are we trying to achieve here?

- avoid that we have to start the containers one by one
- the user interface is started as soon as the API is "healthy"
- the containers are created in the same network
- our api container uses an volume
- the containers are restarted automatically in case of failures
- we do not get container name and port conflicts
- the containers are not directly accessible via the host system but via a proxy
- that a simple load balancing can be used

### Advanced 
We can also define how many containers there should be of a certain type or service

**`Attention the api is not able to be started multiple times in the current state because of the way the database is implemented.`**

```
docker compose up -d --scale ui=4 --scale api=1
```



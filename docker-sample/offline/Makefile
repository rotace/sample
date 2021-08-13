

REGISTRY_NAME=registry1
REGISTRY_HOST=localhost
REGISTRY_PORT=5000

# docker command
ps:
	sudo docker ps

psa:
	sudo docker ps -a

images:
	sudo docker image ls

volumes:
	sudo docker volume ls

df:
	sudo docker system df

clean:
	sudo docker system prune -a

# docker-compose command
com.ps:
	sudo docker-compose ps

com.images:
	sudo docker-compose images

com.check:
	sudo docker-compose config

com.build:
	sudo docker-compose build

com.up: com.build
	sudo docker-compose up -d

com.down:
	sudo docker-compose down


# offline task
reg.start:
	sudo docker run -d --name=${REGISTRY_NAME} --restart=always -p ${REGISTRY_PORT}:${REGISTRY_PORT} -v registry_data:/var/lib/registry registry

reg.ls:
	curl http://${REGISTRY_HOST}:${REGISTRY_PORT}/v2/_catalog

reg.stop:
	sudo docker stop ${REGISTRY_NAME}

reg.clean: reg.stop
	sudo docker rm ${REGISTRY_NAME}


git.start: com.up

git.ls: com.ps

git.clean: com.down
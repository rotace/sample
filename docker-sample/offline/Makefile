

REGISTRY_NAME=registry1
REGISTRY_HOST=localhost
REGISTRY_PORT=5000

ps:
	sudo docker ps

psa:
	sudo docker ps -a

images:
	sudo docker image ls

volumes:
	sudo docker volume ls


reg.start:
	sudo docker run -d --name=${REGISTRY_NAME} --restart=always -p ${REGISTRY_PORT}:${REGISTRY_PORT} -v /var/opt:/var/lib/registry registry

reg.ls:
	curl http://${REGISTRY_HOST}:${REGISTRY_PORT}/v2/_catalog

reg.stop:
	sudo docker stop ${REGISTRY_NAME}

reg.clean: reg.stop
	sudo docker rm ${REGISTRY_NAME}


push:
	sudo docker pull httpd
	sudo docker tag httpd ${REGISTRY_HOST}:${REGISTRY_PORT}/httpd
	sudo docker push ${REGISTRY_HOST}:${REGISTRY_PORT}/httpd
	sudo docker pull ubuntu
	sudo docker tag ubuntu ${REGISTRY_HOST}:${REGISTRY_PORT}/ubuntu
	sudo docker push ${REGISTRY_HOST}:${REGISTRY_PORT}/ubuntu

clean:
	sudo docker system prune -a


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





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


# online task
push.httpd:
	sudo docker pull httpd
	sudo docker tag httpd ${REGISTRY_HOST}:${REGISTRY_PORT}/httpd
	sudo docker push ${REGISTRY_HOST}:${REGISTRY_PORT}/httpd

push.doxygen:
	sudo docker pull hrektts/doxygen
	sudo docker tag hrektts/doxygen ${REGISTRY_HOST}:${REGISTRY_PORT}/doxygen
	sudo docker push ${REGISTRY_HOST}:${REGISTRY_PORT}/doxygen

push.cpp:
	sudo docker build -t ${REGISTRY_HOST}:${REGISTRY_PORT}/cpp ./cpp
	sudo docker push ${REGISTRY_HOST}:${REGISTRY_PORT}/cpp

push.python:
	sudo docker build -t ${REGISTRY_HOST}:${REGISTRY_PORT}/python ./python
	sudo docker push ${REGISTRY_HOST}:${REGISTRY_PORT}/python

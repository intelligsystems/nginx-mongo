#!/bin/bash

# Start Docker Nginx with MongoDB

# Get date in format
pdate=$(date "+%Y-%m-%d %H:%M:%S")

# Path - file location
path='/home/docker/mongo/'

# Container name
name='is-mongo'

# Image name
image='mongo'

# Database files location
data='data:/data/db'

# Docker compose file location
yml='docker-compose.yml'

# Tag 
tag='latest'

# Tar file - docker save and load function
tarfile='mongo.tar'

# Stack name
stack='mongostack'

function exitlog() {
	echo "$pdate $1" > "$path""last.log"
	echo "$pdate Script has been stopped" >> "$path""last.log"
	echo "$1"
	echo 'Script has been stopped.'
	exit
} 

# Check yml file
if [ ! -f "$yml" ]
then 
	message="$yml not exist! Please check yml file."
	exitlog "$message"
fi

case $1 in
run)	
	# Check container status
	status=$(docker inspect --format='{{.State.Status}}' "$name")
	if [ "$status" = "running" ]
	then
		echo "Cannot create "$name" because "$name" is $status"
	else
		docker run --name "$name" -v "$path""$data" -d "$image":"$tag"
	fi
	;;
start)	
	docker start "$name"
	;;
stop)	
	docker stop "$name"
	;;
rm)	
	docker rm "$name"
	;;
load)	
	docker load --input "$path""$tarfile"
	;;
save)	
	docker save --output "$path""$tarfile" "$image":"$tag"
	;;
stack)	
	# Check container status
	status=$(docker inspect --format='{{.State.Status}}' "$name")
	if [ "$status" = "running" ]
	then
		# If container is running ask
		echo "You are going to create $stack. At this moment $name container is $status, are you sure? (y/n)" 
		# Read decision
		read decide
		[ "$decide" = 'y' ] && docker stack deploy -c "$path""$yml" "$stack"
	else
		docker stack deploy -c "$path""$yml" "$stack"
	fi
	;;
rmstack)	
	docker stack rm "$stack"
	;;
stackstatus)	
	# Stack status 
	docker stack ps "$stack"
	docker stack services "$stack"
	;;
*)
	echo "Usage: $0 run|start|stop|rm|load|save|stack|rmstack|stackstatus"
esac

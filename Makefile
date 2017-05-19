cleanup:
	#docker ps -a | grep Exit | cut -d ' ' -f 1 | xargs docker rm
	# Remove just the web ones:
	docker ps -a | grep "numerai_web" | awk '{print $1}' | xargs docker rm
work:
	docker-compose scale worker=3

run:
	docker-compose up

setup:
	# Build the image:
	# docker-compose build
	# Set up the databse:
	docker-compose run web rake db:setup
	# Get the data
	docker-compose run web rake numerai:fetch
	# Load the data
	docker-compose run web rake numerai:load
	docker-compose run web rake numerai:load_tournament

diagrams:
	dot -Tpng -o doc/job_diagram.png doc/job_diagram.dot

# Aliases for my use:
cleanup:
	#docker ps -a | grep Exit | cut -d ' ' -f 1 | xargs docker rm
	# Remove just the web ones:
	docker ps -a | grep "numerai_web" | awk '{print $$1}' | xargs docker rm
work:
	docker-compose scale worker=3

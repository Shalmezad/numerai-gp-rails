cleanup:
	#docker ps -a | grep Exit | cut -d ' ' -f 1 | xargs docker rm
	# Remove just the web ones:
	docker ps -a | grep "numerai_web" | awk '{print $$1}' | xargs docker rm
work:
	docker-compose scale worker=3
fix:
	git filter-branch --env-filter "GIT_AUTHOR_DATE='Fri May 19 10:00:00 2017 -0500'; GIT_COMMITTER_DATE='Fri May 19 10:00:00 2017 -0500';"

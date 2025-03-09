APP=myapp

clean:
	rm -rf build

dev: app
	pnpm dev

build: app
	pnpm build

gr8s-build: build
	pnpm gr8s-prepare

gr8s-deploy: build
	pnpm gr8s-deploy

docker-gr8s: app
	docker buildx build -f docker/Dockerfile-gr8s -t ${APP}-gr8s .

docker-ssr: app
	docker buildx build -f docker/Dockerfile-ssr -t ${APP}-ssr .

compare-ssr-gr8s-results: docker-gr8s docker-ssr
	mkdir -p compare-ssr-gr8s-results/node compare-ssr-gr8s-results/gr8s
	docker run --name ${APP}-node -p 3000:3000 -d ${APP}-ssr
	docker run --name ${APP}-gr8s -p 8338:8338 -d ${APP}-gr8s
	sleep 5s
	ab -n 1000 -c 50 -k \
	   -H "Accept-Encoding: gzip, deflate" \
		-g compare-ssr-gr8s-results/node/results.csv \
		-e compare-ssr-gr8s-results/node/detailed_results.csv -r -v 2 \
		'http://localhost:3000/' > compare-ssr-gr8s-results/node/summary_report.txt
	ab -n 1000 -c 50 -k \
	   -H "Accept-Encoding: gzip, deflate" \
		-g compare-ssr-gr8s-results/gr8s/results.csv \
		-e compare-ssr-gr8s-results/gr8s/detailed_results.csv -r -v 2 \
		'http://localhost:8338/' > compare-ssr-gr8s-results/gr8s/summary_report.txt
	echo -e 'comparison done. try commands like these to view the metrics\n    docker stats\n    tail compare-ssr-gr8s-results/*/summary_report.txt'

install:
	bundle install --path vendor/bundle

setup:
	cp .envrc.sample .envrc
	cp .post.json.sample .post.json

dev:
	bundle exec rerun 'bundle exec rackup config.ru -p $(PORT) -o 0.0.0.0'

run:
	bundle exec rackup config.ru -p $(PORT) -o 0.0.0.0

post:
	curl -X POST $(BOT_URL):$(PORT)/callback \
	-H "Content-Type: application/json" \
	-H "X-Line-Signature: abcdefg12345678hijklmnop" \
	-d @.post.json

test:
	bundle exec rspec

deploy:
	docker build --platform linux/amd64 -t gcr.io/$(PROJECT_ID)/bot .
	docker push gcr.io/$(PROJECT_ID)/bot
	gcloud run deploy bot --image gcr.io/$(PROJECT_ID)/bot --platform managed --region asia-northeast1 --allow-unauthenticated
	gcloud run deploy worker --image gcr.io/$(PROJECT_ID)/bot --platform managed --region asia-northeast1

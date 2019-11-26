TAG=docker.home.spike.cx/quake-ost-vinyl-check

all: build push

build: .PHONY
	docker build --tag $(TAG) .

push: .PHONY
	docker push $(TAG)

run: .PHONY
	docker run \
		-e MAILGUN_URL="$(MAILGUN_URL)" \
		-e MAILGUN_KEY="$(MAILGUN_KEY)" \
		$(TAG)

.PHONY:

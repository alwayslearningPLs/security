certs:
	@openssl req -x509 -newkey rsa:4096 -keyout ./key.pem -out ./cert.pem -sha256 -days 365 -nodes -subj "/C=ES/ST=Galicia/L=Ourense/O=myhouse/OU=Org/CN=localhost"

build: main.go
	CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o ./secure-server ./...

run: secure-server key.pem cert.pem
	./secure-server

test: cert.pem
	@curl --cacert ./cert.pem https://localhost:8080/hello

all: certs build run

clean:
	@rm secure-server key.pem cert.pem

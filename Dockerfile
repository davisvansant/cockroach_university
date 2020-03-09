FROM ubuntu:18.04

WORKDIR /cockroach

RUN apt-get update && apt-get install -y wget && wget -qO- https://binaries.cockroachdb.com/cockroach-v19.2.2.linux-amd64.tgz | tar -xvz --directory . --strip-components=1

CMD ./cockroach

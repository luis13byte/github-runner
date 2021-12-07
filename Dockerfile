FROM ubuntu:20.04
LABEL maintainer="@luis13byte"

ARG DEBIAN_FRONTEND="noninteractive"
ARG RUNNER_VERSION="2.285.0"   
ARG HASH_VERSION="87e4f032839466086dc7828f2e044bfd8fff33d57a009a2df7a03c163ac0f87b"
ARG RUNNER_ORG_URL
ARG ACCESS_TOKEN
ARG RUNNER_NAME   
ARG RUNNER_WORKDIR

RUN apt-get update && apt-get install -y tar curl libdigest-sha-perl \
    && mkdir /actions-runner
WORKDIR /actions-runner   
RUN curl -o actions-runner-linux-x64-$RUNNER_VERSION.tar.gz -L https://github.com/actions/runner/releases/download/v$RUNNER_VERSION/a>
    && echo "$HASH_VERSION  actions-runner-linux-x64-$RUNNER_VERSION.tar.gz" | shasum -a 256 -c \
    && tar xzf ./actions-runner-linux-x64-$RUNNER_VERSION.tar.gz

RUN ./bin/installdependencies.sh && rm -rf /var/lib/apt/lists/*
RUN useradd runner && chown runner: /actions-runner -R && chmod u+x ./entrypoint.sh
COPY ./entrypoint.sh ./
USER runner

CMD ./entrypoint.sh

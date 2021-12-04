FROM ubuntu:20.04
LABEL maintainer="@luis13byte

ARG DEBIAN_FRONTEND="noninteractive"
ARG RUNNER_VERSION="2.285.0"
ARG CORRECT_HASH="87e4f032839466086dc7828f2e044bfd8fff33d57a009a2df7a03c163ac0f87b"
ARG RUNNER_ORG_URL
ARG ACCESS_TOKEN
ARG RUNNER_NAME
ARG RUNNER_WORKDIR

ENV RUNNER_ALLOW_RUNASROOT="1"

RUN apt-get update && apt-get install -y tar curl libdigest-sha-perl
RUN mkdir /actions-runner
WORKDIR /actions-runner
RUN curl -o actions-runner-linux-x64-$RUNNER_VERSION.tar.gz -L https://github.com/actions/runner/releases/download/v$RUNNER_VERSION/actions-runner-linux-x64-$RUNNER_VERSION.tar.gz
RUN echo "$CORRECT_HASH  actions-runner-linux-x64-$RUNNER_VERSION.tar.gz" | shasum -a 256 -c \
    && tar xzf ./actions-runner-linux-x64-$RUNNER_VERSION.tar.gz
    
RUN useradd runner && chown runner: /actions-runner -R
USER runner
RUN ./bin/installdependencies.sh

CMD ./config.sh --unattended --url $RUNNER_ORG_URL --token $ACCESS_TOKEN --name $RUNNER_NAME --work $RUNNER_WORKDIR --replace && ./run.sh

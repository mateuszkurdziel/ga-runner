FROM ubuntu:22.04

RUN apt update && \
    apt install -y curl git

RUN useradd -m runner

USER runner
WORKDIR /home/runner/actions-runner

RUN git config --global --add safe.directory /home/runner/actions-runner

USER root
RUN curl -o actions-runner-linux-x64-2.311.0.tar.gz -L https://github.com/actions/runner/releases/download/v2.311.0/actions-runner-linux-x64-2.311.0.tar.gz && \
    tar xzf ./actions-runner-linux-x64-2.311.0.tar.gz && \
    ./bin/installdependencies.sh


RUN curl -fsSL https://get.docker.com | sh
RUN curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl" && \
    chmod +x ./kubectl && \
    mv ./kubectl /usr/local/bin

ENV KUBECONFIG=/etc/.kube/config

COPY start.sh /home/runner/actions-runner/start.sh
RUN chmod +x /home/runner/actions-runner/start.sh && \
    chown runner:runner /home/runner/actions-runner/start.sh

USER runner
WORKDIR /home/runner/actions-runner

ENTRYPOINT ["./start.sh"]
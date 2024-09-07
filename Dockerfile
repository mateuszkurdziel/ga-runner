FROM ubuntu:22.04

RUN apt update && apt install -y curl git
RUN useradd runner &&\
mkdir /home/runner &&\
chown runner:runner /home/runner &&\
cd /home/runner &&\
mkdir actions-runner && cd actions-runner

RUN git config --global --add safe.directory /home/runner/actions-runner
RUN cd /home/runner/actions-runner &&\
curl -o actions-runner-linux-x64-2.311.0.tar.gz -L https://github.com/actions/runner/releases/download/v2.311.0/actions-runner-linux-x64-2.311.0.tar.gz &&\
tar xzf ./actions-runner-linux-x64-2.311.0.tar.gz &&\
./bin/installdependencies.sh

RUN curl -fsSL https://get.docker.com | sh
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
RUN chmod +x ./kubectl
RUN mv ./kubectl /usr/local/bin
ENV KUBECONFIG=/etc/.kube/config

COPY start.sh start.sh

USER runner 

ENTRYPOINT ["./start.sh"]
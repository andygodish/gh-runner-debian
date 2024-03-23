FROM debian:12-slim

RUN useradd -ms /bin/bash -u 1000 appuser
WORKDIR /home/appuser

# Avoid warnings by switching to noninteractive
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y sudo lsb-release procps ca-certificates gnupg build-essential jq iputils-ping curl unzip net-tools && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    usermod -aG sudo appuser  && \
    echo "%sudo ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Switch back to dialog for any ad-hoc use of apt-get
ENV DEBIAN_FRONTEND=dialog

RUN install -m 0755 -d /etc/apt/keyrings
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
RUN sudo chmod a+r /etc/apt/keyrings/docker.gpg

RUN echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

RUN apt-get update

RUN sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

RUN mkdir actions-runner

WORKDIR /home/appuser/actions-runner

COPY --chown=appuser:appuser get-runner-release.bash ./get-runner-release.bash
RUN chmod +x ./get-runner-release.bash

RUN bash ./get-runner-release.bash
RUN sudo ./bin/installdependencies.sh

COPY --chown=appuser:appuser entrypoint.sh ./
COPY --chown=appuser:appuser uid.sh ./
COPY --chown=appuser:appuser register.sh ./
COPY --chown=appuser:appuser check-docker.sh ./

RUN sudo chmod u+x ./entrypoint.sh 
RUN sudo chmod u+x ./uid.sh
RUN sudo chmod u+x ./register.sh
RUN sudo chmod u+x ./check-docker.sh

USER appuser
RUN sudo usermod -aG docker appuser
RUN sudo chown appuser:appuser -R /home/appuser/actions-runner 

ENTRYPOINT ["/bin/bash", "/home/appuser/actions-runner/entrypoint.sh"]


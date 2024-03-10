FROM debian:bookworm-slim
LABEL maintainer="Windix <windix@gmail.com> / David Stefan <stefda@gmail.com>"

RUN apt update && \
  DEBIAN_FRONTEND=noninteractive apt install -yq --no-install-recommends rsync && \
  apt clean autoclean && \
  apt autoremove -y && \
  rm -rf /var/lib/apt/lists/*

EXPOSE 873
ADD ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

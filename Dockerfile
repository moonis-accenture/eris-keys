# TODO - build eris/base
FROM eris/base:latest

MAINTAINER Eris Industries <support@erisindustries.com>

RUN apt-get update && \
  apt-get install -y --no-install-recommends \
    libgmp3-dev && \
  rm -rf /var/lib/apt/lists/*

ENV REPOSITORY "github.com/eris-ltd/eris-keys"
COPY . /go/src/$REPOSITORY/
WORKDIR /go/src/$REPOSITORY/

RUN chown -R $USER:$USER ./
RUN go install

USER $USER

ENV DATA "/home/eris/.eris/keys"
RUN mkdir -p $DATA
RUN chown -R $USER:$USER $DATA

# Final Config
VOLUME $DATA
EXPOSE 4767
#ENTRYPOINT ["eris-keys"]
CMD ["eris-keys", "server", "--host", "0.0.0.0"]

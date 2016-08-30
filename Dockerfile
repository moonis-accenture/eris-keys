# TODO - build eris/base
FROM quay.io/eris/build

MAINTAINER Eris Industries <support@erisindustries.com>

ENV REPOSITORY "github.com/eris-ltd/eris-keys"
COPY . /go/src/$REPOSITORY/
WORKDIR /go/src/$REPOSITORY/

RUN go get github.com/Masterminds/glide && glide install -s -v

RUN chown -R $USER:$USER ./
RUN go install

# set the repo and install mint-client
ENV REPOSITORY github.com/eris-ltd/mint-client
ENV BRANCH master
RUN mkdir -p $GOPATH/src/$REPOSITORY
WORKDIR $GOPATH/src/$REPOSITORY
RUN git clone --quiet https://$REPOSITORY . && \
  git checkout --quiet $BRANCH && \
  go install ./mintkey && \
  mv $GOPATH/bin/mintkey /usr/local/bin

USER $USER
ENV DATA "/home/eris/.eris/keys"
RUN mkdir -p $DATA
RUN chown -R $USER:$USER $DATA

# Final Config
WORKDIR /home/$USER/.eris
VOLUME $DATA
EXPOSE 4767
CMD ["eris-keys", "server", "--host", "0.0.0.0", "--log", "3", "-d"]

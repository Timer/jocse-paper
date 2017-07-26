FROM ubuntu:12.04

ENV DEBIAN_FRONTEND noninteractive

RUN mkdir -p /home/travis/bin

RUN apt-get update
RUN apt-get install curl -y
RUN curl -L https://github.com/yihui/ubuntu-bin/releases/download/latest/pandoc.tar.gz | tar xvz -C /home/travis/bin
ENV PATH="$PATH:/home/travis/bin"

RUN apt-get install texlive-full -y

VOLUME /out

WORKDIR /out

RUN apt-get install make -y

ADD Makefile /out
ADD templates/ /out/templates/
ADD paper.md /out

CMD make

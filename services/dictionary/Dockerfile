FROM redis

RUN mkdir /usr/src/data
WORKDIR /usr/src/data

RUN apt-get update && apt-get install -y netcat

COPY . /usr/src/data

CMD ["sh", "/usr/src/data/entrypoint.sh"]

FROM python:3.7-bookworm
LABEL maintainer="datapunt@amsterdam.nl"

EXPOSE 8000

WORKDIR /app

ARG OS_URL
ENV OS_URL=$OS_URL

RUN adduser --system datapunt

RUN chown datapunt -R /app

COPY seeding.yaml /app/
COPY docker-entrypoint.sh /bin

RUN pip install MapProxy==1.13.2

USER datapunt

CMD /bin/docker-entrypoint.sh

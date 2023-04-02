FROM python:3.9-bullseye

RUN apt update
RUN apt upgrade -y
RUN apt install unixodbc-dev -y
WORKDIR /usr/src/app
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt
RUN apt install odbc-postgresql -y
COPY . .

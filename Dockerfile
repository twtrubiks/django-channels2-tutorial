FROM python:3.6.4
LABEL maintainer twtrubiks
ENV PYTHONUNBUFFERED 1
RUN mkdir /django_channels2_tutorial
WORKDIR /django_channels2_tutorial
COPY . /django_channels2_tutorial/
RUN pip install -r requirements.txt
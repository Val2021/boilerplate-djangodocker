FROM python:3.11-alpine3.18
LABEL mantainer="https://github.com/Val2021"

#This environment variable is used to control whether Python should
#write bytecode (.pyc) files to disk. 1 = No, 0 = Yes

ENV PYTHONDONTWRITEBYTECODE 1

#Sets the output of Python to be displayed immediately on the console 
#or other output devices, without being buffered.
#In short, you will see Python outputs in real-time.

ENV PYTHONUNBUFFERED 1

#Copies the "app" and "scripts" folders into the container.
COPY ./app /app
COPY ./scripts /scripts

#Sets the working directory inside the container to the app folder.
WORKDIR /app

#The port 8000 will be available for external connections to the container.
#This is the port we will use for Django.
EXPOSE 8000

#RUN executes commands in a shell inside the container to build the image.
#The result of running the command is stored in the image's file system as a new layer.
#Grouping commands in a single RUN can reduce the number of image layers and make it more efficient.
RUN python -m venv /venv && \
  /venv/bin/pip install --upgrade pip && \
  /venv/bin/pip install -r /app/requirements.txt && \
  adduser --disabled-password --no-create-home duser && \
  mkdir -p /data/web/static && \
  mkdir -p /data/web/media && \
  chown -R duser:duser /venv && \
  chown -R duser:duser /data/web/static && \
  chown -R duser:duser /data/web/media && \
  chmod -R 755 /data/web/static && \
  chmod -R 755 /data/web/media && \
  chmod -R +x /scripts

#Adds the scripts folder and venv/bin to the $PATH of the container.
ENV PATH="/scripts:/venv/bin:$PATH"

#Changes the user to duser
USER duser

#Executes the scripts/commands.sh file
CMD ["commands.sh"]
FROM python:3.8-slim-buster
# Allows docker to cache installed dependencies between builds
COPY requirements.txt requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

COPY . code
WORKDIR /code

CMD [ "python3", "-m" , "flask", "run", "--host=127.0.0.1"]

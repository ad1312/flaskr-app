FROM python:3.6-alpine

RUN adduser -D flaskr

WORKDIR /home/flaskr

COPY requirements.txt requirements.txt
RUN pip install flask
RUN python -m venv venv
RUN venv/bin/pip install -r requirements.txt
RUN venv/bin/pip install gunicorn

COPY flaskr flaskr
COPY setup.py setup.cfg boot.sh ./
RUN chmod +x boot.sh

ENV FLASK_APP flaskr

RUN chown -R flaskr:flaskr ./
USER flaskr

EXPOSE 5000
ENTRYPOINT ["./boot.sh"]

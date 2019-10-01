FROM ubuntu:latest
FROM continuumio/anaconda3:4.4.0
MAINTAINER Krishna Manoj

EXPOSE 8000

RUN apt-get update && apt-get install -y apache2 \
    apache2-dev\
    vim \
    && apt-get install -y locales \ 
    && apt-get clean \
    && apt-get autoremove \
    && rm -rf /var/lib/apt/lists/*

RUN localedef -i en_US -f UTF-8 en_US.UTF-8
WORKDIR /var/www/flask_test/
COPY ./flask_test.wsgi /var/www/flask_test/flask_test.wsgi

COPY ./ml_pickling /var/www/flask_test

RUN locale-gen en_US.UTF-8 en_GB.UTF-8 de_DE.UTF-8 es_ES.UTF-8 fr_FR.UTF-8 it_IT.UTF-8 km_KH sv_SE.UTF-8 fi_FI.UTF-8
#RUN localedef -i en_US -f UTF-8 en_US.UTF-8
RUN pip install -r requirements.txt
#CMD ["python","ML_Testing_PKL.py"]
#ENTRYPOINT ["python","ML_Testing_PKL.py"]
RUN /opt/conda/bin/mod_wsgi-express install-module

RUN mod_wsgi-express setup-server flask_test.wsgi --port=5000 \
    --user www-data --group www-data \
    --server-root=/etc/mod_wsgi-express-80
CMD /etc/mod_wsgi-express-80/apachectl start -D FOREGROUND
#ENTRYPOINT ["python","ML_Testing_PKL.py"]
#CMD ["python","ML_Testing_PKL.py"]


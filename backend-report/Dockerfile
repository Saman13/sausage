FROM python:3
RUN mkdir -p ~/.mongodb && \
    wget "https://storage.yandexcloud.net/cloud-certs/CA.pem" \
         --output-document ~/.mongodb/root.crt && \
    chmod 0644 ~/.mongodb/root.crt
ADD . /app
WORKDIR /app
RUN pip install -r requirements.txt
ENTRYPOINT ["python"]
CMD ["app.py"]
EXPOSE 8080


FROM debian:stretch-slim

MAINTAINER Nick Linnell <nick@kyan.com>

RUN apt-get update && \
      apt-get install -y \
      ttf-freefont \
      curl \
      libcurl3 \
      xfonts-75dpi \
      xfonts-base \
      libxrender1 \
      libxext6 \
      libxcb1 \
      libx11-6 \
      libjpeg62-turbo \
      fontconfig \
      python-pip && \
      rm -rf /var/lib/apt/lists/*


WORKDIR /tmp

RUN curl -OL https://downloads.wkhtmltopdf.org/0.12/0.12.5/wkhtmltox_0.12.5-1.stretch_amd64.deb && \
      dpkg -i wkhtmltox_0.12.5-1.stretch_amd64.deb && \
      rm -f wkhtmltox_0.12.5-1.stretch_amd64.deb

RUN ln -s /usr/local/bin/wkhtmltopdf /usr/bin/wkhtmltopdf
RUN ln -s /usr/local/bin/wkhtmltoimage /usr/bin/wkhtmltoimage

WORKDIR /

COPY app.py /app.py
COPY requeriments.txt /requeriments.txt

RUN pip install -r requeriments.txt

EXPOSE 8080

CMD ["python","app.py"]

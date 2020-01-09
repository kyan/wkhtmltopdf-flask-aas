ARG RUBY_VERSION

FROM ruby:${RUBY_VERSION} as gembuilder

LABEL Name="wkhtmltopdf-aas" Version="1"

ENV APP_HOME /app
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

ENV LANG=C.UTF-8 \
  BUNDLE_JOBS=4 \
  BUNDLE_RETRY=3 \
  BUNDLE_GEMFILE=$APP_HOME/Gemfile

ADD Gemfile* $APP_HOME/

ARG BUILD_DEVELOPMENT
ENV BUILD_DEVELOPMENT=${BUILD_DEVELOPMENT:-false}

RUN [ "$BUILD_DEVELOPMENT" = "true" ] && bundle install \
      || bundle install --without development test --force --clean --no-cache

# Build stage 2
FROM ruby:${RUBY_VERSION}-slim

ENV APP_HOME /app

WORKDIR $APP_HOME

COPY --from=gembuilder /usr/local/bundle /usr/local/bundle

RUN apt-get update && \
      apt-get install -y \
      curl \
      fontconfig \
      fonts-freefont-ttf \
      libcurl4 \
      libjpeg62-turbo \
      libx11-6 \
      libxcb1 \
      libxext6 \
      libxrender1 \
      xfonts-75dpi \
      xfonts-base \
      && apt-get clean \
      && rm -rf \
      /var/lib/apt/lists/* \
      /tmp/* \
      /var/tmp/* \
      /usr/local/share/.cache/* \
      && truncate -s 0 /var/log/*log

WORKDIR /tmp

RUN curl -OL https://downloads.wkhtmltopdf.org/0.12/0.12.5/wkhtmltox_0.12.5-1.stretch_amd64.deb && \
      dpkg -i wkhtmltox_0.12.5-1.stretch_amd64.deb && \
      rm -f wkhtmltox_0.12.5-1.stretch_amd64.deb

WORKDIR $APP_HOME

ADD . $APP_HOME

EXPOSE 8080

CMD ["bundle", "exec", "rackup", "--host", "0.0.0.0", "-p", "8080"]

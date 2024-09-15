FROM ruby:3.3.4

WORKDIR /app

COPY Gemfile* /app/
ENV BUNDLE_FROZEN=true
RUN bundle install --without development test

COPY . /app

# ポートを公開する設定
EXPOSE 8080

CMD ["make", "run"]

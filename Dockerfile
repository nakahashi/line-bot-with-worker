# ベースイメージを指定
FROM ruby:3.3.4

# アプリケーションディレクトリを作成
WORKDIR /app

# GemfileとGemfile.lockをコピーして、依存関係をインストール
COPY Gemfile* /app/
ENV BUNDLE_FROZEN=true
RUN bundle install --without development test

# アプリケーションのソースコードをコピー
COPY . /app

# ポートを公開する設定
EXPOSE 8080

# アプリケーションを実行
CMD ["make", "run"]

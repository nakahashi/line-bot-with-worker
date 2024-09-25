# これは何？

非同期処理機能付きのシンプルなLINE botのテンプレートです。

Google Cloud の Cloud Run、Cloud Tasksの組み合わせによる動作を想定しています。

# 実現できる機能

* Lineからのコールバック受付 & 署名認証 & レスポンス
* Workerへの処理リクエスト
* Workerでのリプライメッセージ送信


# Macでの動作確認

```zsh
make dev
```

```zsh
make post
```

# Macからのデプロイ方法

```zsh
make deploy
```

事前に Google Cloud SDK をインストールして下さい。

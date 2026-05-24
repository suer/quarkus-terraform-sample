# quarkus-terraform-sample

AWS Lambda 上で Quarkus (Java 21) を動かすサンプルプロジェクト。  
API Gateway HTTP API 経由でブラウザからアクセスできる。

```
.
├── terraform/   — IAM ロール・CloudWatch Logs・Lambda 関数の箱・API Gateway
├── lambroll/    — lambroll 定義・Lambda デプロイ用 Makefile
├── app/         — Quarkus アプリ（Java）
└── docker/      — Docker 用 Dockerfile
```

## 前提条件

- [Terraform](https://developer.hashicorp.com/terraform/install) >= 1.0
- [lambroll](https://github.com/fujiwara/lambroll) >= 1.0
- Java 21 / Maven 3.9+
- Docker（native ビルド時）
- AWS CLI の認証設定済み

## ローカル開発

Quarkus の dev モードを使うと、Lambda にデプロイせずローカルで動作確認できる。

```bash
cd app
mvn quarkus:dev
```

起動後に `http://localhost:8080` でアクセスできる。ファイルを変更すると次のリクエスト時に自動で反映される（再起動不要）。

## Lambda へのデプロイ

### 1. Terraform で Lambda の箱と API Gateway を作る

```bash
cd terraform
terraform init
terraform apply
```

以下のリソースが作成される：IAM ロール・CloudWatch Logs グループ・Lambda 関数（placeholder）・API Gateway HTTP API

`lifecycle { ignore_changes }` により、以降の `terraform apply` で lambroll がデプロイしたコードは上書きされない。

### 2. ビルドして Lambda にデプロイする

```bash
cd lambroll
export AWS_ACCOUNT_ID=123456789012  # 自分の AWS アカウント ID に変える
make deploy
```

`make deploy` は `build-lambda` → `lambroll deploy` の順に実行される。

### 3. ブラウザで動作確認する

```bash
curl $(cd terraform && terraform output -raw api_endpoint)/hello
```

## Docker イメージのビルド

```bash
cd docker
make docker
```

`build` → `docker build` の順に実行される。起動は以下の通り。

```bash
docker run --rm -p 8080:8080 quarkus-hello:latest
```

## Makefile ターゲット

### lambroll/

| ターゲット | 内容 |
|-----------|------|
| `make build` | Lambda 用 native ビルド（`-Plambda,native`）→ `function.zip` |
| `make deploy` | `build` 後に lambroll でデプロイ |
| `make invoke` | lambroll 経由で Lambda を直接呼び出して確認 |

### docker/

| ターゲット | 内容 |
|-----------|------|
| `make build` | Docker 用 native ビルド（`-Pnative`）→ native バイナリ |
| `make docker` | `build` 後に Docker イメージをビルド |

## 構成メモ

| 項目 | 値 |
|------|-----|
| Lambda Runtime | `provided.al2023`（native）|
| Lambda Architecture | `arm64` |
| エンドポイント | `GET /hello`、`GET /`、`POST /` |
| アクセス方法 | API Gateway HTTP API |
| ビルド成果物（Lambda） | `app/target/function.zip` |
| ビルド成果物（Docker） | `app/target/*-runner` |
| メモリ | 512 MB |
| タイムアウト | 30 秒 |

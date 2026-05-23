# quarkus-terraform-sample

AWS Lambda 上で Quarkus (Java 21) を動かすサンプルプロジェクト。  
API Gateway HTTP API 経由でブラウザからアクセスできる。

- **terraform/** — IAM ロール・CloudWatch Logs・Lambda 関数の箱・API Gateway を管理
- **lambroll/** — Quarkus アプリのビルドと Lambda へのコードデプロイを管理

## 前提条件

- [Terraform](https://developer.hashicorp.com/terraform/install) >= 1.0
- [lambroll](https://github.com/fujiwara/lambroll) >= 1.0
- Java 21 / Maven 3.9+
- AWS CLI の認証設定済み

## デプロイ手順

### 1. Terraform で Lambda の箱と API Gateway を作る

```bash
cd terraform
terraform init
terraform apply
```

以下のリソースが作成される：

- IAM ロール
- CloudWatch Logs グループ
- Lambda 関数（空の placeholder コード）
- API Gateway HTTP API（`$default` ステージ・全リクエストを Lambda に転送）

`lifecycle { ignore_changes }` により、以降の `terraform apply` で lambroll がデプロイしたコードは上書きされない。

API のエンドポイントは `terraform output api_endpoint` で確認できる。

### 2. Quarkus アプリをビルドして Lambda にデプロイする

```bash
cd lambroll
export AWS_ACCOUNT_ID=123456789012  # 自分の AWS アカウント ID に変える
make deploy
```

内部では以下が実行される：

1. `mvn package -DskipTests` → `app/target/function.zip` を生成
2. `lambroll deploy --src=app/target/function.zip` → Lambda にデプロイ

### 3. ブラウザで動作確認する

```bash
curl $(cd terraform && terraform output -raw api_endpoint)/hello
# => Hello from Quarkus Lambda!
```

## Makefile ターゲット

| ターゲット | 内容 |
|-----------|------|
| `make build` | Quarkus アプリをビルドして `function.zip` を生成 |
| `make deploy` | ビルド後に lambroll でデプロイ |
| `make invoke` | lambroll 経由で Lambda を直接呼び出して確認 |

## 構成メモ

| 項目 | 値 |
|------|-----|
| Lambda Runtime | `java21` |
| Lambda Handler | `io.quarkus.amazon.lambda.runtime.QuarkusStreamHandler::handleRequest` |
| エンドポイント | `GET /hello` |
| アクセス方法 | API Gateway HTTP API |
| ビルド成果物 | `lambroll/app/target/function.zip` |
| メモリ | 512 MB |
| タイムアウト | 30 秒 |

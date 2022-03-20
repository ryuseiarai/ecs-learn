# Terrafomr実行手順

## WrokDirectoryに移動する

```
cd env/{対象環境}
```

## 対象のWorkspaceに切り替える

```
tfenv use 1.1.7
terraform init #初回のみ
terraform workspaece select {対象wrokspace}
```

## AWS SSOログインする

前提条件
~/.aws/configにプロファイルを設定していること

```
export AWS_PROFILE=<対象プロファイル名>
aws sso login
```

## tfstate用環境

```
cd env/common
tfenv use 1.1.7
terraform init #初回のみ
terraform workspace select common

terraform plan -var-file secret.tfvars 
terraform apply -var-file secret.tfvars 
```
# Infrastructure

## Login

```shell
source ~/dev/aws-tf.sh
aws s3 ls | grep techeffe-terraform
```

## Operations

Commons (GitHub, secrets)
```shell
make plan STACK=common
```

Core (Networking, ALB, ECS Cluster)
```shell
make plan STACK=core
```

App (ECS Service, Task Def, ECR):
```shell
make plan STACK=app
```


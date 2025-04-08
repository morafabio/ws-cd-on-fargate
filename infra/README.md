# Infrastructure

## Login

```shell
source ~/dev/aws-tf.sh
aws s3 ls | grep techeffe-terraform
```

## Operations

Commons (GitHub, secrets)
```shell
make apply STACK=common
```

Core (Networking, ALB, ECS Cluster)
```shell
make apply STACK=core
```

App (ECS Service, Task Def, ECR):
```shell
make apply STACK=app
```


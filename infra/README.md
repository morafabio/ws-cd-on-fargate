# Infrastructure

@fixme WiP

## Debug

```shell
source ~/dev/aws-tf.sh
aws s3 ls | grep techeffe-terraform
```

```shell
source ~/dev/aws-tf.sh
make apply STACK=common
make apply STACK=core
make apply STACK=app
```


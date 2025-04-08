# ws-cd-on-fargate

## App

### Development

Build:
```shell
docker build -f build/Dockerfile -t app-cd-on-fargate/web:test .
```

Run:
```shell
docker run --rm -ti -p 8080:8080 -v "$(pwd)/src:/app" app-cd-on-fargate/web:test
```

### Test

#### Endpoints

Root:
```shell
curl localhost:8080/health
```

Hash:
```shell
curl -X POST -d '{"text": "I absolutely love this!"}' http://localhost:8080/hash
curl -X POST -d '{"text": "Today is a cloudy day with mild temperatures."}' http://localhost:8080/hash
curl -X POST -d '{"text": "This is the worst experience ever."}' http://localhost:8080/hash
curl -X POST -d '{"text": "¡Este producto es fantástico!"}' http://localhost:8080/hash
```

#### Features

Run:
```shell
docker network create test-network || true
docker run --rm -ti \
  --network test-network \
  --name app -p 8080:8080 -v "$(pwd)/src:/app" \
  app-cd-on-fargate/web:test
```

```shell
docker run --rm -ti \
  --network test-network \
  -v "$(pwd)/test/tests.js:/app/tests.js" \
  grafana/k6 run /app/tests.js
```
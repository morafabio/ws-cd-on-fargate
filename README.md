# ws-cd-on-fargate

## App

### Development

Build:
```shell
docker build -f build/Dockerfile -t app-web:latest .
```

Run:
```shell
docker run --rm -ti -p 8080:8080 -v "$(pwd)/src:/app" app-web:latest
```

### Test

#### Endpoints

Root:
```shell
curl localhost:8080/
```

Inference:
```shell
curl -X POST -d '{"text": "I absolutely love this!"}' http://localhost:8080/predict
curl -X POST -d '{"text": "Today is a cloudy day with mild temperatures."}' http://localhost:8080/predict
curl -X POST -d '{"text": "This is the worst experience ever."}' http://localhost:8080/predict
curl -X POST -d '{"text": "¡Este producto es fantástico!"}' http://localhost:8080/predict
```

#### Features

```shell
docker run --rm -ti \
  -v "$(pwd)/test/features.js:/app/tests.js" \
  -e BASE_URL=http://host.docker.internal:8080 \
  grafana/k6 run /app/tests.js
```
# ws-cd-on-fargate

A hello-world app to experiment Continuous Delivery with Terraform, GitHub Actions and AWS on Fargate.

## Local

### Development

Build:
```shell
docker build -f build/Dockerfile -t app-cd-on-fargate/web:test .
```

Run:
```shell
(docker network create test-network || true) # network init

docker run --rm -ti --network test-network \
  --name app -p 8080:8080 -v "$(pwd)/src:/app" \
  app-cd-on-fargate/web:test
```

### Test

#### Functional

`GET /health` (with headers):
```shell
curl localhost:8080/health
curl -i -s localhost:8080/health | grep 'x-api'
```

`POST /hash`:
```shell
curl -d '{"text": "I absolutely love this!"}' localhost:8080/hash
curl -d '{"text": "Today is a cloudy day with mild temperatures."}' localhost:8080/hash
curl -d '{"text": "This is the worst experience ever."}' localhost:8080/hash
curl -d '{"text": "¡Este producto es fantástico!"}' localhost:8080/hash
```

`POST /hash` (with headers):
```shell
curl -i -d '{"text": "Hello LPA!"}' localhost:8080/hash
curl -s -i -d '{"text": "Hello LPA!"}' localhost:8080/hash | grep 'x-api'
```

#### End-to-End (k6)

```shell
docker run --rm -ti \
  --network test-network \
  -v "$(pwd)/test/tests.js:/app/tests.js" \
  grafana/k6 run /app/tests.js
```

## Infrastructure

Continue at [infra/README.md](infra/README.md)

## Notes

- Author: [fabiomora.com](https://www.fabiomora.com/)
- License: https://www.gnu.org/licenses/gpl-3.0.html
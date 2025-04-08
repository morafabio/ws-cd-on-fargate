import http from 'k6/http';
import { check, group, sleep } from 'k6';

export let options = {
  stages: [
    { duration: '5s', target: 1 },
  ],
  thresholds: {
    http_req_duration: ['p(95)<500'],
  },
};

const baseUrl = __ENV.BASE_URL || 'http://app:8080';

const testCases = [
  { description: "Valid text", text: "I absolutely love this!", expectError: false },
  { description: "Empty text", text: "", expectError: true },
  { description: "Long text", text: "This is a long text. ".repeat(10), expectError: false },
  { description: "Special characters", text: "¡@#$%^&*()_+", expectError: false },
];

export default function () {
  group("Health Check", () => {
    let res = http.get(`${baseUrl}/health`);
    check(res, {
      "GET /health status is 200": (r) => r.status === 200,
      "Content-Type is application/json": (r) => r.headers["Content-Type"] && r.headers["Content-Type"].includes("application/json"),
      "uptime_seconds exists": (r) => r.json().hasOwnProperty("uptime_seconds"),
      "hostname exists": (r) => r.json().hasOwnProperty("hostname"),
    });
  });

  group("Hash Endpoint - Fixture Coverage", () => {
    testCases.forEach((tc) => {
      let payload = JSON.stringify({ text: tc.text });
      let headers = {
        "Content-Type": "application/json",
        "X-Test-Header": "k6-test"
      };
      let res = http.post(`${baseUrl}/hash`, payload, { headers: headers });

      check(res, {
        "POST /hash status is 200": (r) => r.status === 200,
        "Content-Type header is application/json": (r) => r.headers["Content-Type"] && r.headers["Content-Type"].includes("application/json"),
      });

      if (tc.expectError) {
        check(res, {
          "Error message returned for empty text": (r) => r.json().error === "No text provided",
        });
      } else {
        let jsonResponse = res.json();
        check(jsonResponse, {
          "Contains md5 (32 hex chars)": (o) => o.hasOwnProperty("md5") && typeof o.md5 === "string" && o.md5.length === 32,
          "Contains sha1 (40 hex chars)": (o) => o.hasOwnProperty("sha1") && typeof o.sha1 === "string" && o.sha1.length === 40,
          "Contains sha256 (64 hex chars)": (o) => o.hasOwnProperty("sha256") && typeof o.sha256 === "string" && o.sha256.length === 64,
          "Contains base64": (o) => o.hasOwnProperty("base64") && typeof o.base64 === "string" && o.base64.length > 0,
        });
      }
    });
  });

  group("Performance", () => {
    let payload = JSON.stringify({ text: "Performance test text" });
    let headers = { "Content-Type": "application/json" };
    let res = http.post(`${baseUrl}/hash`, payload, { headers: headers });
    check(res, {
      "Performance POST /hash status is 200": (r) => r.status === 200,
    });
  });

  sleep(1);
}

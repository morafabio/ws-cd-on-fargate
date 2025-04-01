import http from 'k6/http';
import { check, group } from 'k6';

export let options = {
  stages: [
    { duration: '5s', target: 0 },
  ],
};

const baseUrl = __ENV.BASE_URL || 'http://127.0.0.1:8080';

const sentiments = [
  { text: "This is good. ".repeat(5), expected: "POSITIVE" },
  { text: "", expected: "error" },
  { text: "I love this product, it's amazing!", expected: "POSITIVE" },
  { text: "This is terrible and I hate it.", expected: "NEGATIVE" },
  { text: "The sky is blue and the grass is green.", expected: "POSITIVE" },
  { text: "Good!", expected: "POSITIVE" },
  { text: "Awful!", expected: "NEGATIVE" },
  { text: "Je déteste ce produit.", expected: "NEGATIVE" },
];

export default function () {
  group("Health Check", function () {
    let res = http.get(`${baseUrl}/`);
    check(res, {
      "GET / status is 200": (r) => r.status === 200,
      "uptime is present": (r) => r.json().hasOwnProperty("uptime_seconds"),
      "hostname is present": (r) => r.json().hasOwnProperty("hostname"),
    });
  });

  group("Sentiment Prediction", function () {
    sentiments.forEach((testCase) => {
      let payload = JSON.stringify({ text: testCase.text });
      let headers = { "Content-Type": "application/json" };
      let res = http.post(`${baseUrl}/predict`, payload, { headers: headers });
      check(res, {
        "POST /predict status is 200": (r) => r.status === 200,
        "response has label": (r) => r.json().hasOwnProperty("label"),
        "response has score": (r) => r.json().hasOwnProperty("score"),
      });
    });
  });
}

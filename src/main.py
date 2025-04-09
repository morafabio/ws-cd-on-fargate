from fastapi import FastAPI, Request, Response
from fastapi.responses import JSONResponse
import time, socket, hashlib, base64, json

start_time = time.time()
hostname = socket.gethostname()
api_version = "1.0"

class PrettyJSONResponse(JSONResponse):
    def render(self, content: any) -> bytes:
        return json.dumps(content, indent=2).encode("utf-8")

app = FastAPI(default_response_class=PrettyJSONResponse)

@app.middleware("http")
async def add_version_header(request: Request, call_next):
    response: Response = await call_next(request)
    response.headers["X-API-Version"] = api_version
    return response

@app.get("/health")
def root():
    uptime = round(time.time() - start_time, 2)
    return {
        "status": "ok",
        "uptime_seconds": uptime,
        "hostname": hostname,
        "API-Version": api_version
    }

@app.post("/hash")
async def generate_hash(req: Request):
    data = await req.json()
    text = data.get("text", "")
    if not text:
        return {"error": "No text provided"}

    text_bytes = text.encode('utf-8')

    hashes = {
        "md5": hashlib.md5(text_bytes).hexdigest(),
        "sha1": hashlib.sha1(text_bytes).hexdigest(),
        "sha224": hashlib.sha224(text_bytes).hexdigest(),
        "sha256": hashlib.sha256(text_bytes).hexdigest(),
        "sha384": hashlib.sha384(text_bytes).hexdigest(),
        "sha512": hashlib.sha512(text_bytes).hexdigest(),
        "blake2b": hashlib.blake2b(text_bytes).hexdigest(),
        "blake2s": hashlib.blake2s(text_bytes).hexdigest(),
        # "base64": base64.b64encode(text_bytes).decode('utf-8')
    }
    return hashes

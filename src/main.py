from fastapi import FastAPI, Request
from fastapi.responses import JSONResponse
import time, socket, hashlib, base64, json

start_time = time.time()
hostname = socket.gethostname()

class PrettyJSONResponse(JSONResponse):
    def render(self, content: any) -> bytes:
        return json.dumps(content, indent=2).encode("utf-8")

app = FastAPI(default_response_class=PrettyJSONResponse)

@app.get("/")
def root():
    uptime = round(time.time() - start_time, 2)
    return {
        "status": "ok",
        "uptime_seconds": uptime,
        "hostname": hostname
    }

@app.post("/hash")
async def generate_hash(req: Request):
    data = await req.json()
    text = data.get("text", "")
    if not text:
        return {"error": "No text provided"}

    text_bytes = text.encode('utf-8')

    hashes = {
        "md5": hashlib.md5(text_bytes).hexdigest(),          # 128-bit hash
        "sha1": hashlib.sha1(text_bytes).hexdigest(),          # 160-bit hash
        "sha224": hashlib.sha224(text_bytes).hexdigest(),      # 224-bit hash
        "sha256": hashlib.sha256(text_bytes).hexdigest(),      # 256-bit hash
        "sha384": hashlib.sha384(text_bytes).hexdigest(),      # 384-bit hash
        "sha512": hashlib.sha512(text_bytes).hexdigest(),      # 512-bit hash
        "blake2b": hashlib.blake2b(text_bytes).hexdigest(),    # variable output, default 512-bit
        "blake2s": hashlib.blake2s(text_bytes).hexdigest(),    # variable output, default 256-bit
        "base64": base64.b64encode(text_bytes).decode('utf-8')   # reversible encoding (not a hash)
    }
    return hashes

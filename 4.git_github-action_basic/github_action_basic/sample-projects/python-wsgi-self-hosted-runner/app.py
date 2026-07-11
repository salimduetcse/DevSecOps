from flask import Flask, jsonify

app = Flask(__name__)


@app.route("/")
def home():
    return "Hello from Python WSGI Self-Hosted Deployment!"


@app.route("/health")
def health():
    return jsonify({"status": "healthy", "app": "python-wsgi-self-hosted-runner"})


# Gunicorn imports "app:app" — this block is only used for local dev
if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8000)

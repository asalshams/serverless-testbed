# file: server.py

from flask import Flask, request, jsonify

app = Flask(__name__)

def fibonacci(n):
    if n <= 1:
        return n
    return fibonacci(n - 1) + fibonacci(n - 2)

@app.route("/", methods=["GET"])
def compute_fib():
    try:
        n = int(request.args.get("n", "10"))
        result = fibonacci(n)
        return jsonify({"input": n, "output": result})
    except Exception as e:
        return jsonify({"error": str(e)}), 400

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)

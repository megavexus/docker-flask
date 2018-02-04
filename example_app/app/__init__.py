import os
from flask import Flask

app=Flask(os.getenv("APP_NAME", __name__))


@app.route("/")
def hello():
    return "Hello, i'm the app1"


if __name__ == "__main__":
    # Get the data
    debug_mode = bool(os.getenv("FLASK_DEBUG", False))
    #port = bool(os.getenv("FLAS_PORT", 5000))
    #host = bool(os.getenv("FLASK_HOST", '0.0.0.0'))

    app.run(host="0.0.0.0", port=5000, debug=debug_mode)

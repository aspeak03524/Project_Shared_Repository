To successfully connect your Flask app to Redis running in a Docker container, you need to update the get_redis() function to correctly reference Redis, especially since you're running Redis in Docker and exposing it via port 6379 on localhost. Below are the recommended changes and explanations:

1. Update the get_redis() function:
Hostname: If you're running Redis in a Docker container on your local machine, you should use localhost or 127.0.0.1 for the Redis host, not redis, because redis will only work if you're within the Docker network (e.g., inside another container).
Updated Code:
python
Copia el codi
from flask import Flask, render_template, request, make_response, g
from redis import Redis
import os
import socket
import random
import json
import logging

option_a = os.getenv('OPTION_A', "Cats")
option_b = os.getenv('OPTION_B', "Dogs")
hostname = socket.gethostname()

app = Flask(__name__)

gunicorn_error_logger = logging.getLogger('gunicorn.error')
app.logger.handlers.extend(gunicorn_error_logger.handlers)
app.logger.setLevel(logging.INFO)

def get_redis():
    # Update the Redis host to 'localhost' if running on your local machine
    if not hasattr(g, 'redis'):
        g.redis = Redis(host="localhost", port=6379, db=0, socket_timeout=5)
    return g.redis

@app.route("/", methods=['POST','GET'])
def hello():
    voter_id = request.cookies.get('voter_id')
    if not voter_id:
        voter_id = hex(random.getrandbits(64))[2:-1]

    vote = None

    if request.method == 'POST':
        redis = get_redis()
        vote = request.form['vote']
        app.logger.info('Received vote for %s', vote)
        data = json.dumps({'voter_id': voter_id, 'vote': vote})
        redis.rpush('votes', data)

    resp = make_response(render_template(
        'index.html',
        option_a=option_a,
        option_b=option_b,
        hostname=hostname,
        vote=vote,
    ))
    resp.set_cookie('voter_id', voter_id)
    return resp


if __name__ == "__main__":
    app.run(host='0.0.0.0', port=80, debug=True, threaded=True)
Key Changes:
Changed Redis Host:

From host="redis" to host="localhost", since Redis is exposed on the host machine's localhost or 127.0.0.1 (as per Docker's port mapping of 0.0.0.0:6379->6379/tcp).
Ensure Correct Redis Port:

Explicitly setting the port to 6379, which is the default Redis port.
2. Verify Redis Container Is Running
Ensure your Redis container is running and that it's correctly mapped to port 6379 on your host machine:

bash
Copia el codi
docker ps
This should confirm that Redis is running and mapping port 6379 on your host machine.

3. Test the Connection Locally
Test the connection by running a small Redis test snippet outside your Flask app:

python
Copia el codi
from redis import Redis

try:
    redis = Redis(host='localhost', port=6379, db=0)
    redis.ping()  # This should return 'PONG' if Redis is reachable
    print("Connection to Redis successful!")
except Exception as e:
    print(f"Connection to Redis failed: {e}")
This will help verify whether the Flask app can actually connect to Redis on your local machine. If this works, your Flask app should also be able to connect.

4. Firewall / Network Configuration (Optional)
If you're still facing connection issues after these changes, ensure no firewall or security settings are blocking access to port 6379 on your local machine.

5. Docker Network Configuration (If Using Docker Compose)
If you're using Docker Compose or running multiple containers (e.g., one for the Flask app and one for Redis), you might need to use the service name (redis) instead of localhost. But since you're running Redis directly in a Docker container on your host, localhost should work.

After making these changes, your Flask app should be able to connect to Redis running in the Docker container.




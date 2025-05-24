from flask import Flask, request, render_template, jsonify
import requests
import json
from datetime import datetime
import os

sample = Flask(__name__)

@sample.route("/")
def main():
    return render_template("index.html")

# BONUS: Weather API endpoint
@sample.route("/api/weather/<city>")
def get_weather(city):
    """Get weather information for a city using OpenWeatherMap API"""
    try:
        # You can get a free API key from openweathermap.org
        api_key = "1f79bac14f2e6d0c2f967b22f5cc3c9d"  # Replace with actual API key
        url = f"http://api.openweathermap.org/data/2.5/weather?q={city}&appid={api_key}&units=metric"
        
        response = requests.get(url, timeout=5)
        if response.status_code == 200:
            weather_data = response.json()
            return jsonify({
                "city": weather_data["name"],
                "temperature": weather_data["main"]["temp"],
                "description": weather_data["weather"][0]["description"],
                "humidity": weather_data["main"]["humidity"],
                "timestamp": datetime.now().isoformat()
            })
        else:
            return jsonify({"error": "City not found"}), 404
    except requests.RequestException:
        return jsonify({"error": "Weather service unavailable"}), 503

# BONUS: Random fact API endpoint
@sample.route("/api/fact")
def get_random_fact():
    """Get a random fact from an external API"""
    try:
        response = requests.get("https://uselessfacts.jsph.pl/random.json?language=en", timeout=5)
        if response.status_code == 200:
            fact_data = response.json()
            return jsonify({
                "fact": fact_data["text"],
                "source": fact_data["source_url"],
                "timestamp": datetime.now().isoformat()
            })
        else:
            return jsonify({"error": "Fact service unavailable"}), 503
    except requests.RequestException:
        return jsonify({"error": "External API unavailable"}), 503

# BONUS: System information API
@sample.route("/api/system")
def get_system_info():
    """Get system information about the container"""
    return jsonify({
        "container_id": os.environ.get("HOSTNAME", "unknown"),
        "python_version": os.sys.version,
        "current_time": datetime.now().isoformat(),
        "environment": "Docker Container",
        "app_version": "2.0.0-bonus"
    })

# BONUS: Health check endpoint
@sample.route("/api/health")
def health_check():
    """Health check endpoint for monitoring"""
    return jsonify({
        "status": "healthy",
        "timestamp": datetime.now().isoformat(),
        "version": "2.0.0-bonus"
    })

# BONUS: Echo API for testing
@sample.route("/api/echo", methods=["GET", "POST"])
def echo():
    """Echo endpoint that returns the request data"""
    if request.method == "POST":
        return jsonify({
            "method": "POST",
            "data": request.get_json() if request.is_json else str(request.data),
            "timestamp": datetime.now().isoformat()
        })
    else:
        return jsonify({
            "method": "GET",
            "args": dict(request.args),
            "timestamp": datetime.now().isoformat()
        })

if __name__ == "__main__":
    sample.run(host="0.0.0.0", port=5050, debug=True)
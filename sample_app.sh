#!/bin/bash
mkdir tempdir
mkdir tempdir/templates
mkdir tempdir/static
cp sample_app.py tempdir/.
cp requirements.txt tempdir/.  # ← ADD THIS LINE
cp -r templates/* tempdir/templates/.
cp -r static/* tempdir/static/.
echo "FROM python:3.9-slim" >> tempdir/Dockerfile
echo "WORKDIR /home/myapp" >> tempdir/Dockerfile
echo "COPY requirements.txt ." >> tempdir/Dockerfile
echo "RUN pip install --no-cache-dir -r requirements.txt" >> tempdir/Dockerfile
echo "COPY ./static /home/myapp/static/" >> tempdir/Dockerfile
echo "COPY ./templates /home/myapp/templates/" >> tempdir/Dockerfile
echo "COPY sample_app.py /home/myapp/" >> tempdir/Dockerfile
echo "EXPOSE 5050" >> tempdir/Dockerfile
echo "HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 CMD curl -f http://localhost:5050/api/health || exit 1" >> tempdir/Dockerfile
echo "CMD [\"python3\", \"sample_app.py\"]" >> tempdir/Dockerfile
cd tempdir
docker build -t sampleapp:enhanced .
docker run -t -d -p 5050:5050 --name samplerunning sampleapp:enhanced
docker ps -a
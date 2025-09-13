FROM python:3.9-slim
WORKDIR /app
COPY requirements.txt requirements.txt
RUN pip install flask
COPY . .
CMD ["python", "app.py"]

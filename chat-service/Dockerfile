# Dockerfile

# Use an official Python image
FROM python:3.12.7-slim

# Set the working directory in the container
WORKDIR /app

# Copy requirements and install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy the project files
COPY . .

# Set up volume for data persistence
VOLUME /data

# Run the main script (adjust as needed)
CMD ["python", "train_model/chromadb.py"]

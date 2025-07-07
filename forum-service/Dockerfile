# Use the official Python image as the base image
FROM python:3.10-slim

# Set the working directory in the container
WORKDIR /app

# Copy the requirements file into the container
COPY requirements.txt .

# Install the dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application code into the container
COPY . .

# Expose the port your application runs on
EXPOSE 9006

# Set the environment variables
ENV DATABASE_URL=mysql+mysqlconnector://root:password@14.225.218.42:3306/forum_service
ENV API_AUTH_URL=http://localhost:9001
ENV SECRET_KEY=your-secret-key
ENV DB_IP=14.225.218.42
ENV DB_PORT=3306
ENV DB_USERNAME=root
ENV DB_PASSWORD=password
ENV DB_NAME=forum_service

# Command to run the application
CMD ["python", "main.py"]
# Use a slim Python image to keep the container size down
FROM python:3.9-slim

### Set environment variables
ENV PYTHONUNBUFFERED 1
ENV FLASK_APP app.py
ENV PORT 8080

# Set the working directory inside the container
WORKDIR /app

# Copy the requirements file and install dependencies
COPY requirements.txt requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Copy the application code into the container
COPY . .

# Expose the port theapp runs on
EXPOSE 8080

# Add a health check to ensure the application is running
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:8080/products/SKU001 || exit 1

# Command to run the application using Gunicorn
CMD ["gunicorn", "--bind", "0.0.0.0:8080", "app:app"]

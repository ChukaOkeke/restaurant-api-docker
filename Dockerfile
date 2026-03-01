# Using a slim version of the Python base image to keep the image small
FROM python:3.12-slim

# Set environment variables to optimize Python for Docker
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Set the working directory inside the container
WORKDIR /app

# Install system dependencies required for mysqlclient and patch vulnerabilities identified by Trivy (CVE-2025-13699 for mariadb)
RUN apt-get update && apt-get install -y --no-install-recommends \
    default-libmysqlclient-dev \
    gcc \
    mariadb-common \
    netcat-openbsd \
    pkg-config \  
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Patch vulnerabilities identified by Trivy (CVE-2025-8869 and CVE-2026-21441)
RUN pip install --no-cache-dir --upgrade pip==25.3 urllib3==2.6.3

# Install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the project code
COPY . .

# Expose Django's default port
EXPOSE 8000

# Explicitly set executable permissions for the entrypoint
RUN chmod +x /app/entrypoint.sh

# Run database migrations and start the Django development server from the shell script
ENTRYPOINT ["/app/entrypoint.sh"]
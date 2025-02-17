# Extend the official Apache Superset image
FROM apache/superset:latest

# Switch to root user to install dependencies
USER root

# Install flask_cors
RUN pip install flask_cors

# Copy the custom Superset config file
COPY superset_config.py /app/pythonpath/superset_config.py

# Set correct permissions
RUN chown superset:superset /app/pythonpath/superset_config.py

# Switch back to the superset user
USER superset

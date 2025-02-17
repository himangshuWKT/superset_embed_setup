#!/bin/bash

# Load the environment variables from the .env file
if [ -f .env ]; then
    source .env
else
    echo ".env file not found!"
    exit 1
fi

# Handling command-line arguments for loading examples
load_examples="ask"

while getopts ":yn" opt; do
    case $opt in
        y) load_examples="y" ;;
        n) load_examples="n" ;;
        \?) echo "Invalid option: -$OPTARG. Use -y to load examples or -n to skip." >&2
            exit 1 ;;
    esac
done

# Check if necessary environment variables are set
if [[ -z "${SUPPORT_DOMAIN}" || -z "${SUPPORT_PORT}" || -z "${ADMIN_USERNAME}" || -z "${ADMIN_FIRSTNAME}" || -z "${ADMIN_LASTNAME}" || -z "${ADMIN_EMAIL}" || -z "${ADMIN_PASSWORD}" ]]; then
    echo "Required environment variables are missing!"
    exit 1
fi

echo "Starting Superset container..."
sudo docker-compose up -d  # Start Superset in detached mode

echo "Waiting for Superset to be ready..."
# Wait for the container to be healthy before proceeding
until [[ "$(curl -s -o /dev/null -w '%{http_code}' http://${SUPPORT_DOMAIN}:${SUPPORT_PORT}/health)" == "200" ]]; do
    echo "Waiting for Superset to be healthy..."
    sleep 5
done

echo "Running database migrations..."
docker exec -it embedd_superset superset db upgrade

echo "Creating an admin user..."
docker exec -it embedd_superset superset fab create-admin \
    --username "${ADMIN_USERNAME}" \
    --firstname "${ADMIN_FIRSTNAME}" \
    --lastname "${ADMIN_LASTNAME}" \
    --email "${ADMIN_EMAIL}" \
    --password "${ADMIN_PASSWORD}"

echo "Initializing Superset..."
docker exec -it embedd_superset superset init

# If no argument is provided, ask the user
if [[ "$load_examples" == "ask" ]]; then
    while true; do
        read -p "Do you want to load example dashboards? (y/n): " user_input
        case $user_input in
            [Yy]) load_examples="y"; break ;;
            [Nn]) load_examples="n"; break ;;
            *) echo "Invalid input. Please enter 'y' or 'n'." ;;
        esac
    done
fi

# Load examples if the user chose 'y'
if [[ "$load_examples" == "y" ]]; then
    echo "Loading example dashboards..."
    docker exec -it embedd_superset superset load_examples
else
    echo "Skipping example dashboards loading."
fi

echo "Restarting Superset..."
docker restart embedd_superset

echo "Superset setup complete!"

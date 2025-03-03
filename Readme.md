# Apache Superset Embedded Setup

This repository contains the necessary configuration to set up and run an Apache Superset instance using Docker for embedding into your application.

## Prerequisites
- Docker & Docker Compose installed
- `.env` file configured with required environment variables

## Setup Instructions

### 1. Clone the Repository
Using HTTPS:
```sh
git clone https://github.com/himangshuWKT/superset_embed_setup.git
```

or

Using SSH:
```sh
git clone git@github.com:himangshuWKT/superset_embed_setup.git
```

finally go to repository folder:
```sh
cd embed_superset
```


### 2. Configure Environment Variables
Create a `.env` file in the project root and populate it with the required values:
```env
SUPERSET_SECRET_KEY=Your_secret_key
SUPERSET_CONFIG_PATH=/app/pythonpath/superset_config.py
SUPPORT_DOMAIN=the_domain_you_wish_run_superset_on
SUPPORT_PORT=the_port_you_wish_to_run_superset_on
ADMIN_USERNAME=your_admin_username
ADMIN_FIRSTNAME=your_firstname
ADMIN_LASTNAME=your_lastname
ADMIN_EMAIL=your_email
ADMIN_PASSWORD=your_password
```

### 3. Build and Start Superset
```sh
./init_superset.sh
```

To skip prompts and auto-load example dashboards:
```sh
./init_superset.sh -y
```
To skip loading example dashboards:
```sh
./init_superset.sh -n
```

### 4. Access Superset
Once the setup is complete, open:
```
http://localhost:8088
```
Login with the admin credentials provided in the `.env` file.

---

## Project Structure
```
.
├── Dockerfile
├── docker-compose.yml
├── superset_config.py
├── init_superset.sh
├── .env (not committed to the repository)
└── README.md
```

### **File Descriptions:**
- **Dockerfile**: Extends the official Apache Superset image and applies custom configurations.
- **docker-compose.yml**: Defines the Superset container with necessary environment variables.
- **superset_config.py**: Custom configurations for enabling embedded dashboards, CORS, and JWT authentication.
- **init_superset.sh**: Automates setup, including migrations, user creation, and dashboard examples.
- **.env**: Stores environment variables (should not be committed to version control).

## Configuration
### `superset_config.py`
This file includes:
- Enabling **embedded dashboards**
- Configuring **CORS** for frontend integration
- Setting up **JWT authentication** for guest access

Example Configuration:
```python
FEATURE_FLAGS = {
    "EMBEDDED_SUPERSET": True
}

TALISMAN_ENABLED = False
ENABLE_CORS = True
WTF_CSRF_ENABLED = False
WTF_CSRF_EXEMPT_LIST = ["superset.views.api"]

CORS_OPTIONS = {
    "supports_credentials": True,
    "allow_headers": ["*"],
    "resources": ["/*"],
    "origins": ["http://localhost:3000"],
}

GUEST_ROLE_NAME = "Gamma"
GUEST_TOKEN_JWT_SECRET = "your-secret-key"
GUEST_TOKEN_JWT_ALGO = "HS256"
GUEST_TOKEN_HEADER_NAME = "X-GuestToken"
GUEST_TOKEN_JWT_EXP_SECONDS = 300
```

## Troubleshooting
### 1. Superset is stuck at startup
Check logs:
```sh
docker logs embedd_superset
```
If Superset is not running, restart it:
```sh
docker restart embedd_superset
```

### 2. Configuration changes are not applied
Rebuild the container:
```sh
docker-compose down --volumes
./init_superset.sh
```

### 3. Cannot access Superset at `http://localhost:8088`
Ensure the container is running:
```sh
docker ps
```
Restart the container:
```sh
docker restart embedd_superset
```

## License
This project is licensed under the MIT License.

---

## Author
Himangshu Das


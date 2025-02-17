FEATURE_FLAGS = {
    "EMBEDDED_SUPERSET": True
}

TALISMAN_ENABLED = False
#HTTP_HEADERS={}
ENABLE_CORS = True
WTF_CSRF_ENABLED = False
WTF_CSRF_EXEMPT_LIST = ["superset.views.api"]

CORS_OPTIONS = {
    "supports_credentials": True,
    "allow_headers": ["*"],
    "resources": ["/*"],
    "origins": ["http://localhost:3000"],
}

 # Dashboard embedding 
GUEST_ROLE_NAME = "Gamma" 
GUEST_TOKEN_JWT_SECRET = "O0nWCoikcaMfrYrrLnFkvVgt9Uc+MJZgpDB/jrM10NU=" 
GUEST_TOKEN_JWT_ALGO = "HS256" 
GUEST_TOKEN_HEADER_NAME = "X-GuestToken" 
GUEST_TOKEN_JWT_EXP_SECONDS = 300 # 5 minutes

PUBLIC_ROLE_LIKE = "Gamma"
SESSION_COOKIE_SAMESITE = "None"
SESSION_COOKIE_SECURE = True
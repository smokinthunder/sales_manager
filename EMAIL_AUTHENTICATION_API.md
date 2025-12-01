# Email Authentication API Documentation

## Overview

The Email Authentication API provides secure email/password-based authentication for administrative users (client_admin and superadmin roles only). This system complements the existing OTP-based authentication and includes features for login, password reset, password change, and email availability checking.

**Base URL:** `/api/v1/auth/email`

**Authentication Type:** JWT (JSON Web Token) Bearer Token

**Supported Roles:** 
- `client_admin`
- `superadmin`

---

## Table of Contents

1. [Authentication Flow](#authentication-flow)
2. [Security Features](#security-features)
3. [API Endpoints](#api-endpoints)
   - [Login](#1-login)
   - [Forgot Password](#2-forgot-password)
   - [Reset Password](#3-reset-password)
   - [Change Password](#4-change-password)
   - [Check Email Availability](#5-check-email-availability)
4. [Data Models](#data-models)
5. [Error Handling](#error-handling)
6. [Rate Limiting](#rate-limiting)

---

## Authentication Flow

### Initial Login Flow
```
User → POST /api/v1/auth/email/login
     ↓
Validate credentials
     ↓
Generate JWT tokens (access + refresh)
     ↓
Store refresh token in Redis
     ↓
Return tokens + user info
```

### Password Reset Flow
```
User → POST /api/v1/auth/email/forgot-password
     ↓
Generate secure reset token
     ↓
Display token in terminal (dev mode)
     ↓
User → POST /api/v1/auth/email/reset-password
     ↓
Validate token + new password
     ↓
Update password hash
     ↓
Return success message
```

---

## Security Features

1. **Password Hashing**: Uses bcrypt for secure password storage
2. **Login Attempt Tracking**: Monitors failed login attempts
3. **Account Lockout**: Locks account after 5 failed attempts for 30 minutes
4. **Reset Token Expiry**: Password reset tokens expire after 1 hour
5. **Password Strength Validation**: Enforces strong password requirements
6. **Rate Limiting**: 5 requests per minute per endpoint
7. **JWT Tokens**: Secure token-based authentication
8. **Refresh Token Storage**: Redis-based token management (7-day expiry)
9. **Tenant Isolation**: Enforces tenant_id for multi-tenancy support

---

## API Endpoints

### 1. Login

Authenticate a user with email and password credentials.

**Endpoint:** `POST /api/v1/auth/email/login`

**Tags:** `email-authentication`

#### Query Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `email` | string | Yes | User's email address |
| `password` | string | Yes | User's password |
| `tenant_id` | string | Yes | Tenant identifier for multi-tenancy |

#### Request Example

```http
POST /api/v1/auth/email/login?email=admin@example.com&password=SecurePass123!&tenant_id=aquastar
```

#### Response (200 OK)

```json
{
  "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "refresh_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "token_type": "bearer",
  "expires_in": 3600,
  "user": {
    "id": 1,
    "email": "admin@example.com",
    "name": "Admin User",
    "role": "client_admin",
    "status": "active",
    "tenant_id": "aquastar",
    "auth_type": "email"
  }
}
```

#### Error Responses

| Status Code | Description | Response Body |
|-------------|-------------|---------------|
| 400 | Validation error | `{"detail": "Validation error message"}` |
| 401 | Invalid credentials | `{"detail": "Invalid email or password"}` |
| 401 | Account locked | `{"detail": "Account is temporarily locked due to multiple failed login attempts"}` |
| 401 | Inactive account | `{"detail": "Account is not active"}` |
| 429 | Rate limit exceeded | `{"detail": "Too many requests"}` |
| 500 | Server error | `{"detail": "Internal server error"}` |

#### Working Details

1. **User Lookup**: Retrieves user authentication record by email from data layer
2. **Status Check**: Verifies user account is active
3. **Lock Check**: Validates account is not locked due to failed attempts
4. **Password Verification**: Compares provided password with stored bcrypt hash
5. **Failed Attempt Handling**: Increments login_attempts counter on failure
6. **Account Locking**: Locks account for 30 minutes after 5 failed attempts
7. **Success Handling**: Resets login_attempts to 0, updates last_login timestamp
8. **Token Generation**: Creates access token (1 hour) and refresh token (7 days)
9. **Redis Storage**: Stores refresh token with key `refresh_token:{user_id}:{tenant_id}`
10. **Response**: Returns tokens and user payload

---

### 2. Forgot Password

Request a password reset token for account recovery.

**Endpoint:** `POST /api/v1/auth/email/forgot-password`

**Tags:** `email-authentication`

#### Query Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `email` | string | Yes | User's email address |
| `tenant_id` | string | Yes | Tenant identifier |

#### Request Example

```http
POST /api/v1/auth/email/forgot-password?email=admin@example.com&tenant_id=aquastar
```

#### Response (200 OK)

```json
{
  "message": "Password reset token has been generated and displayed in the terminal",
  "email": "admin@example.com",
  "expires_at": "2025-12-01T15:30:00",
  "note": "Check the backend terminal/logs for the reset token"
}
```

#### Terminal Output (Development Mode)

```
============================================================
🔐 PASSWORD RESET TOKEN
============================================================
Email: admin@example.com
Tenant: aquastar
Reset Token: xYz123AbC456DeF789...
Expires: 2025-12-01 15:30:00
Valid for: 15 minutes
============================================================
Use this token to reset password via API:
POST /api/v1/auth/email/reset-password
Params: reset_token=xYz123AbC456DeF789...&tenant_id=aquastar
============================================================
```

#### Error Responses

| Status Code | Description | Response Body |
|-------------|-------------|---------------|
| 429 | Rate limit exceeded | `{"detail": "Too many requests"}` |
| 500 | Server error | Returns generic success message for security |

#### Working Details

1. **User Lookup**: Searches for user by email in specified tenant
2. **Role Validation**: Verifies user has admin role (client_admin or superadmin)
3. **Security Measure**: Returns generic success message even if email doesn't exist
4. **Token Generation**: Creates 32-byte URL-safe token using `secrets.token_urlsafe(32)`
5. **Expiry Setting**: Sets token expiration to 1 hour from generation time
6. **Data Storage**: Stores reset token in data layer with email and expiry timestamp
7. **Terminal Display**: Prints token details to backend terminal/console (development)
8. **Production Note**: In production, this would send email instead of terminal output
9. **Response**: Returns generic message to prevent email enumeration attacks

**Security Note:** The endpoint always returns a success message regardless of whether the email exists to prevent account enumeration attacks.

---

### 3. Reset Password

Reset password using a valid reset token.

**Endpoint:** `POST /api/v1/auth/email/reset-password`

**Tags:** `email-authentication`

#### Query Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `reset_token` | string | Yes | Password reset token from forgot-password request |
| `new_password` | string | Yes | New password (must meet strength requirements) |
| `tenant_id` | string | Yes | Tenant identifier |

#### Request Example

```http
POST /api/v1/auth/email/reset-password?reset_token=xYz123AbC456DeF789...&new_password=NewSecurePass123!&tenant_id=aquastar
```

#### Password Requirements

- Minimum 8 characters
- At least 1 uppercase letter
- At least 1 lowercase letter
- At least 1 number
- At least 1 special character (`!@#$%^&*()_+-=[]{}|;:,.<>?`)

#### Response (200 OK)

```json
{
  "message": "Password reset successfully",
  "user_id": 1
}
```

#### Error Responses

| Status Code | Description | Response Body |
|-------------|-------------|---------------|
| 400 | Invalid token | `{"detail": "Invalid or expired reset token"}` |
| 400 | Password too short | `{"detail": "Password must be at least 8 characters long"}` |
| 400 | Missing uppercase | `{"detail": "Password must contain at least one uppercase letter"}` |
| 400 | Missing lowercase | `{"detail": "Password must contain at least one lowercase letter"}` |
| 400 | Missing number | `{"detail": "Password must contain at least one number"}` |
| 400 | Missing special char | `{"detail": "Password must contain at least one special character"}` |
| 429 | Rate limit exceeded | `{"detail": "Too many requests"}` |
| 500 | Server error | `{"detail": "Internal server error"}` |

#### Working Details

1. **Password Validation**: Checks new password meets all strength requirements
2. **Password Hashing**: Generates bcrypt hash of new password using `get_password_hash()`
3. **Token Verification**: Validates reset token exists and has not expired
4. **User Identification**: Retrieves user associated with reset token
5. **Password Update**: Updates user's password_hash in data layer
6. **Token Invalidation**: Removes or marks reset token as used
7. **Response**: Returns success message with user_id

---

### 4. Change Password

Change password for an authenticated user (requires current password).

**Endpoint:** `PUT /api/v1/auth/email/change-password`

**Tags:** `email-authentication`

**Authentication:** Required (Bearer Token)

#### Headers

```http
Authorization: Bearer <access_token>
```

#### Query Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `current_password` | string | Yes | User's current password |
| `new_password` | string | Yes | New password (must meet strength requirements) |

#### Request Example

```http
PUT /api/v1/auth/email/change-password?current_password=OldPass123!&new_password=NewSecurePass123!
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

#### Response (200 OK)

```json
{
  "message": "Password changed successfully"
}
```

#### Error Responses

| Status Code | Description | Response Body |
|-------------|-------------|---------------|
| 400 | Validation error | `{"detail": "Password validation error message"}` |
| 401 | Invalid token | `{"detail": "Could not validate credentials"}` |
| 401 | Wrong password | `{"detail": "Current password is incorrect"}` |
| 403 | Unauthorized role | `{"detail": "Password change is only available for admin users"}` |
| 429 | Rate limit exceeded | `{"detail": "Too many requests"}` |
| 500 | Server error | `{"detail": "Internal server error"}` |

#### Working Details

1. **Token Validation**: Extracts and validates JWT access token from Authorization header
2. **Role Check**: Verifies user role is either client_admin or superadmin
3. **User Extraction**: Gets user_id and tenant_id from token payload
4. **Password Validation**: Validates new password meets strength requirements
5. **Password Hashing**: Generates bcrypt hash of new password
6. **Update Operation**: Updates password_hash in data layer for user_id
7. **Response**: Returns success message

**Note:** This endpoint requires an active JWT token, meaning the user must be logged in.

---

### 5. Check Email Availability

Check if an email address is available for registration (utility endpoint).

**Endpoint:** `GET /api/v1/auth/email/check-email`

**Tags:** `email-authentication`

#### Query Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `email` | string | Yes | Email address to check |
| `tenant_id` | string | Yes | Tenant identifier |

#### Request Example

```http
GET /api/v1/auth/email/check-email?email=newadmin@example.com&tenant_id=aquastar
```

#### Response (200 OK)

```json
{
  "email": "newadmin@example.com",
  "available": true,
  "message": "Email availability check completed"
}
```

#### Error Responses

| Status Code | Description | Response Body |
|-------------|-------------|---------------|
| 500 | Server error | `{"detail": "Internal server error"}` |

#### Working Details

1. **Email Lookup**: Queries data layer for existing user with provided email
2. **Tenant Check**: Ensures check is scoped to specific tenant
3. **Availability**: Returns true if email not found, false if already in use
4. **Response**: Returns availability status

**Note:** This is currently a placeholder implementation and needs to be connected to the data layer for actual email checking.

---

## Data Models

### AuthResponse

**Description:** Response model returned after successful authentication.

```typescript
{
  access_token: string;      // JWT access token
  refresh_token: string;     // JWT refresh token
  token_type: string;        // Always "bearer"
  expires_in: number;        // Token expiration in seconds (3600 = 1 hour)
  user: {                    // User information object
    id: number;              // User ID
    email: string;           // User's email
    name: string;            // User's full name
    role: string;            // User role (client_admin | superadmin)
    status: string;          // Account status (active | inactive)
    tenant_id: string;       // Tenant identifier
    auth_type: string;       // Authentication type ("email")
  }
}
```

### Password Reset Request Response

```typescript
{
  message: string;           // Status message
  email: string;             // Email address
  expires_at: string;        // ISO 8601 timestamp
  note: string;              // Additional information
}
```

### Password Reset Response

```typescript
{
  message: string;           // Success message
  user_id: number;           // User ID whose password was reset
}
```

### Password Change Response

```typescript
{
  message: string;           // Success message
}
```

### Email Availability Response

```typescript
{
  email: string;             // Checked email address
  available: boolean;        // true if available, false if taken
  message: string;           // Status message
}
```

---

## Error Handling

### Error Response Format

All errors follow a consistent format:

```json
{
  "detail": "Error message describing what went wrong"
}
```

### Common Error Types

| Error Type | Status Code | Description |
|------------|-------------|-------------|
| `AuthenticationError` | 401 | Invalid credentials or authentication failure |
| `ValidationError` | 400 | Input validation failure or business logic violation |
| `AuthorizationError` | 403 | Insufficient permissions for operation |
| `NotFoundError` | 404 | Requested resource not found |
| `ConflictError` | 409 | Resource conflict (e.g., duplicate email) |
| `RateLimitError` | 429 | Too many requests in time window |
| `ServerError` | 500 | Internal server error |

### Account Lockout Details

- **Trigger:** 5 consecutive failed login attempts
- **Duration:** 30 minutes from last failed attempt
- **Reset:** Automatic after lockout period expires
- **Message:** "Account is temporarily locked due to multiple failed login attempts"

### Token Expiry Details

- **Access Token:** 1 hour (3600 seconds)
- **Refresh Token:** 7 days (604800 seconds)
- **Reset Token:** 1 hour (3600 seconds)

---

## Rate Limiting

All email authentication endpoints are protected by rate limiting to prevent abuse.

**Configuration:**
- **Limit:** 5 requests per minute per endpoint
- **Window:** 60 seconds
- **Scope:** Per IP address or client identifier
- **Response:** HTTP 429 (Too Many Requests)

**Rate-Limited Endpoints:**
- `/api/v1/auth/email/login`
- `/api/v1/auth/email/forgot-password`
- `/api/v1/auth/email/reset-password`
- `/api/v1/auth/email/change-password`

---

## Implementation Checklist

When implementing email authentication in the backend, ensure:

### Database Schema
- [ ] `user_auth` table with columns:
  - `user_id` (FK to users)
  - `email` (unique per tenant)
  - `password_hash` (bcrypt)
  - `login_attempts` (integer)
  - `locked_until` (timestamp, nullable)
  - `reset_token` (string, nullable)
  - `reset_token_expires` (timestamp, nullable)
  - `last_login` (timestamp, nullable)
  - `created_at`, `updated_at`, `created_by`, `updated_by`

### Data Layer Endpoints
- [ ] `GET /api/user-auth/{tenant_id}/by-email` - Get user auth by email
- [ ] `POST /api/user-auth/{tenant_id}/reset-token` - Store reset token
- [ ] `POST /api/user-auth/{tenant_id}/verify-reset` - Verify and consume reset token
- [ ] `PUT /api/user-auth/{tenant_id}/{user_id}` - Update auth record
- [ ] `GET /api/users/{tenant_id}/by-email` - Get user by email

### Services
- [ ] Password hashing using bcrypt (via `get_password_hash()`)
- [ ] Password verification (via `verify_password()`)
- [ ] JWT token generation (access + refresh)
- [ ] Redis integration for refresh token storage
- [ ] Login attempt tracking
- [ ] Account lockout mechanism
- [ ] Password strength validation
- [ ] Reset token generation and validation

### Security
- [ ] Rate limiting on all endpoints
- [ ] Tenant isolation enforcement
- [ ] Generic responses for forgot-password to prevent enumeration
- [ ] Secure token generation using `secrets` module
- [ ] Password requirements enforcement
- [ ] JWT token validation
- [ ] Refresh token rotation (optional enhancement)

### Configuration
- [ ] `EMAIL_AUTH_ENABLED` environment variable
- [ ] `MAX_LOGIN_ATTEMPTS` (default: 5)
- [ ] `ACCOUNT_LOCKOUT_DURATION` (default: 30 minutes)
- [ ] `RESET_TOKEN_EXPIRY` (default: 1 hour)
- [ ] `ACCESS_TOKEN_EXPIRY` (default: 1 hour)
- [ ] `REFRESH_TOKEN_EXPIRY` (default: 7 days)

### Testing
- [ ] Unit tests for password validation
- [ ] Integration tests for login flow
- [ ] Test account lockout mechanism
- [ ] Test password reset flow
- [ ] Test password change flow
- [ ] Test rate limiting
- [ ] Test tenant isolation
- [ ] Test error scenarios

---

## Usage Examples

### Complete Authentication Flow (cURL)

#### 1. Login
```bash
curl -X POST "http://localhost:8000/api/v1/auth/email/login?email=admin@example.com&password=SecurePass123!&tenant_id=aquastar"
```

#### 2. Use Access Token
```bash
curl -X GET "http://localhost:8000/api/v1/users" \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
```

#### 3. Forgot Password
```bash
curl -X POST "http://localhost:8000/api/v1/auth/email/forgot-password?email=admin@example.com&tenant_id=aquastar"
```

#### 4. Reset Password
```bash
curl -X POST "http://localhost:8000/api/v1/auth/email/reset-password?reset_token=xYz123AbC456DeF789&new_password=NewSecurePass123!&tenant_id=aquastar"
```

#### 5. Change Password
```bash
curl -X PUT "http://localhost:8000/api/v1/auth/email/change-password?current_password=NewSecurePass123!&new_password=AnotherPass456!" \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
```

### Python Client Example

```python
import requests

BASE_URL = "http://localhost:8000/api/v1/auth/email"

# Login
response = requests.post(
    f"{BASE_URL}/login",
    params={
        "email": "admin@example.com",
        "password": "SecurePass123!",
        "tenant_id": "aquastar"
    }
)
auth_data = response.json()
access_token = auth_data["access_token"]

# Use authenticated endpoint
headers = {"Authorization": f"Bearer {access_token}"}
user_response = requests.get(
    "http://localhost:8000/api/v1/users",
    headers=headers
)

# Change password
change_response = requests.put(
    f"{BASE_URL}/change-password",
    params={
        "current_password": "SecurePass123!",
        "new_password": "NewSecurePass123!"
    },
    headers=headers
)
```

---

## Additional Notes

### Development vs Production

**Development Mode:**
- Reset tokens printed to terminal/console
- Detailed error messages
- Less strict rate limiting (can be adjusted)

**Production Mode:**
- Reset tokens sent via email (requires email service integration)
- Generic error messages
- Strict rate limiting
- Enhanced logging and monitoring

### Future Enhancements

1. **Email Service Integration**: Replace terminal output with actual email sending
2. **Multi-Factor Authentication (MFA)**: Add optional 2FA for admin accounts
3. **Password History**: Prevent password reuse
4. **Session Management**: Track active sessions per user
5. **Refresh Token Rotation**: Automatic token rotation on refresh
6. **Account Recovery Options**: Security questions or backup codes
7. **Login Notifications**: Alert users of new login attempts
8. **IP-based Rate Limiting**: More sophisticated rate limiting per IP
9. **Audit Logging**: Comprehensive audit trail for authentication events
10. **Password Expiry**: Force password change after N days

---

## Support & Troubleshooting

### Common Issues

**Issue:** "Account is temporarily locked"
- **Solution:** Wait 30 minutes or manually unlock account via database

**Issue:** "Invalid or expired reset token"
- **Solution:** Request new reset token (tokens expire after 1 hour)

**Issue:** Password validation errors
- **Solution:** Ensure password meets all requirements (length, uppercase, lowercase, number, special character)

**Issue:** "Password change is only available for admin users"
- **Solution:** This endpoint is restricted to client_admin and superadmin roles only

**Issue:** Rate limit exceeded
- **Solution:** Wait for rate limit window to reset (1 minute)

---

## Version History

- **v1.0** - Initial implementation
  - Email/password login
  - Password reset flow
  - Password change for authenticated users
  - Email availability check
  - Rate limiting
  - Account lockout mechanism

---

**Last Updated:** December 1, 2025

**API Version:** v1

**Maintained By:** Backend Development Team

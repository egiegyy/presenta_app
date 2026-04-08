# 📚 API Reference

Base URL: `https://appabsensi.mobileprojp.com/api`

All timestamps in ISO 8601 format (UTC).

---

## 🔐 Authentication Endpoints

### POST /login
Login user with email and password.

**Request:**
```json
{
  "email": "user@example.com",
  "password": "password123"
}
```

**Success Response (200/201):**
```json
{
  "token": "eyJhbGciOiJIUzI1NiIs...",
  "user": {
    "id": 1,
    "name": "John Doe",
    "email": "user@example.com",
    "photo": null,
    "created_at": "2024-01-15T10:30:00Z"
  }
}
```

**Error Response (400/401):**
```json
{
  "message": "Invalid credentials"
}
```

**Curl Example:**
```bash
curl -X POST https://appabsensi.mobileprojp.com/api/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "user@example.com",
    "password": "password123"
  }'
```

---

### POST /register
Register new user account.

**Request:**
```json
{
  "name": "John Doe",
  "email": "user@example.com",
  "password": "password123",
  "gender": "L|P",
  "batch": "1",
  "training": "1"
}
```

**Success Response (200/201):**
```json
{
  "message": "Registration successful",
  "data": {
    "id": 1,
    "name": "John Doe",
    "email": "user@example.com"
  }
}
```

**Error Response (400):**
```json
{
  "message": "Email already registered"
}
```

**Curl Example:**
```bash
curl -X POST https://appabsensi.mobileprojp.com/api/register \
  -H "Content-Type: application/json" \
  -d '{
    "name": "John Doe",
    "email": "user@example.com",
    "password": "password123",
    "gender": "L",
    "batch": "1",
    "training": "1"
  }'
```

---

## 👤 User Endpoints

### GET /profile
Get current user profile.

**Headers:**
```
Authorization: Bearer TOKEN
```

**Success Response (200):**
```json
{
  "data": {
    "id": 1,
    "name": "John Doe",
    "email": "user@example.com",
    "phone": "082123456789",
    "photo": "https://...",
    "gender": "L",
    "batch": "Batch 1",
    "training": "Frontend",
    "created_at": "2024-01-15T10:30:00Z"
  }
}
```

**Error Response (401):**
```json
{
  "message": "Unauthorized"
}
```

**Curl Example:**
```bash
curl -X GET https://appabsensi.mobileprojp.com/api/profile \
  -H "Authorization: Bearer TOKEN"
```

---

### PUT /edit-profile
Update user profile.

**Headers:**
```
Authorization: Bearer TOKEN
Content-Type: application/json
```

**Request:**
```json
{
  "name": "John Updated",
  "email": "newemail@example.com",
  "phone": "082123456789",
  "photo": "base64_encoded_image_data"
}
```

**Success Response (200):**
```json
{
  "message": "Profile updated successfully",
  "data": {
    "id": 1,
    "name": "John Updated",
    "email": "newemail@example.com",
    "phone": "082123456789",
    "photo": "https://..."
  }
}
```

**Curl Example:**
```bash
curl -X PUT https://appabsensi.mobileprojp.com/api/edit-profile \
  -H "Authorization: Bearer TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "John Updated",
    "email": "newemail@example.com"
  }'
```

---

## 📍 Attendance Endpoints

### POST /absen-check-in
Record check-in with location.

**Headers:**
```
Authorization: Bearer TOKEN
Content-Type: application/json
```

**Request:**
```json
{
  "latitude": -6.2088,
  "longitude": 106.8456,
  "note": "Check in from office"
}
```

**Success Response (200/201):**
```json
{
  "message": "Check in recorded",
  "data": {
    "id": 123,
    "user_id": 1,
    "check_in_time": "2024-04-07T08:30:00Z",
    "check_in_location": "-6.2088, 106.8456",
    "note": "Check in from office"
  }
}
```

**Curl Example:**
```bash
curl -X POST https://appabsensi.mobileprojp.com/api/absen-check-in \
  -H "Authorization: Bearer TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "latitude": -6.2088,
    "longitude": 106.8456,
    "note": "Check in from office"
  }'
```

---

### POST /absen-check-out
Record check-out with location.

**Headers:**
```
Authorization: Bearer TOKEN
Content-Type: application/json
```

**Request:**
```json
{
  "latitude": -6.2088,
  "longitude": 106.8456,
  "note": "Check out from office"
}
```

**Success Response (200/201):**
```json
{
  "message": "Check out recorded",
  "data": {
    "id": 123,
    "user_id": 1,
    "check_out_time": "2024-04-07T17:30:00Z",
    "check_out_location": "-6.2088, 106.8456",
    "note": "Check out from office"
  }
}
```

---

### GET /history-absen
Get attendance history.

**Headers:**
```
Authorization: Bearer TOKEN
```

**Query Parameters (Optional):**
```
?limit=10
?offset=0
?start_date=2024-01-01
?end_date=2024-12-31
```

**Success Response (200):**
```json
{
  "data": [
    {
      "id": 1,
      "date": "2024-04-07",
      "check_in_time": "08:30:00",
      "check_out_time": "17:30:00",
      "check_in_location": "-6.2088, 106.8456",
      "check_out_location": "-6.2088, 106.8456",
      "status": "Present"
    },
    {
      "id": 2,
      "date": "2024-04-06",
      "check_in_time": "08:15:00",
      "check_out_time": "17:45:00",
      "check_in_location": "-6.2088, 106.8456",
      "check_out_location": "-6.2088, 106.8456",
      "status": "Present"
    }
  ]
}
```

**Curl Example:**
```bash
curl -X GET "https://appabsensi.mobileprojp.com/api/history-absen" \
  -H "Authorization: Bearer TOKEN"
```

---

### DELETE /delete-absen
Delete attendance record.

**Headers:**
```
Authorization: Bearer TOKEN
```

**Query Parameters:**
```
?id=1
```

**Success Response (200):**
```json
{
  "message": "Attendance record deleted successfully"
}
```

**Error Response (404):**
```json
{
  "message": "Record not found"
}
```

**Curl Example:**
```bash
curl -X DELETE "https://appabsensi.mobileprojp.com/api/delete-absen?id=1" \
  -H "Authorization: Bearer TOKEN"
```

---

## 📋 Dropdown Data Endpoints

### GET /batches
Get list of available batches for registration.

**Request:**
```
GET https://appabsensi.mobileprojp.com/api/batches
```

**Success Response (200):**
```json
{
  "data": [
    {
      "id": 1,
      "name": "Batch 1 - 2024"
    },
    {
      "id": 2,
      "name": "Batch 2 - 2024"
    }
  ]
}
```

**Curl Example:**
```bash
curl -X GET https://appabsensi.mobileprojp.com/api/batches
```

---

### GET /trainings
Get list of available trainings for registration.

**Request:**
```
GET https://appabsensi.mobileprojp.com/api/trainings
```

**Success Response (200):**
```json
{
  "data": [
    {
      "id": 1,
      "name": "Frontend Development"
    },
    {
      "id": 2,
      "name": "Backend Development"
    },
    {
      "id": 3,
      "name": "Mobile Development"
    }
  ]
}
```

**Curl Example:**
```bash
curl -X GET https://appabsensi.mobileprojp.com/api/trainings
```

---

## 🔄 Common Response Patterns

### Success Response
```json
{
  "message": "Operation successful",
  "data": { /* response data */ }
}
```

### Error Response
```json
{
  "message": "Error message",
  "errors": {
    "field_name": ["Error detail"]
  }
}
```

### List Response
```json
{
  "data": [
    { /* item 1 */ },
    { /* item 2 */ }
  ],
  "meta": {
    "total": 100,
    "per_page": 10,
    "current_page": 1,
    "last_page": 10
  }
}
```

---

## 🚨 HTTP Status Codes

| Code | Meaning | Example |
|------|---------|---------|
| 200 | OK | Successful request |
| 201 | Created | Resource created |
| 400 | Bad Request | Invalid input data |
| 401 | Unauthorized | Token expired or invalid |
| 403 | Forbidden | User not allowed |
| 404 | Not Found | Resource not found |
| 422 | Unprocessable Entity | Validation error |
| 500 | Internal Server Error | Server error |
| 503 | Service Unavailable | Server down |

---

## 🔑 Authentication

All protected endpoints require Bearer token in Authorization header:

```
Authorization: Bearer eyJhbGciOiJIUzI1NiIs...
```

Token obtained from `/login` endpoint.

### Token Expiration
- Default: 24 hours
- On expiration: Return 401 status
- App should logout and redirect to login

---

## 📝 Request/Response Examples

### Complete Login Flow
```bash
# 1. Login
curl -X POST https://appabsensi.mobileprojp.com/api/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "user@example.com",
    "password": "password123"
  }'

# Response: {"token": "...", "user": {...}}

# 2. Get Profile using token
curl -X GET https://appabsensi.mobileprojp.com/api/profile \
  -H "Authorization: Bearer TOKEN"

# Response: {"data": {...}}

# 3. Check In
curl -X POST https://appabsensi.mobileprojp.com/api/absen-check-in \
  -H "Authorization: Bearer TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "latitude": -6.2088,
    "longitude": 106.8456,
    "note": "Check in"
  }'

# Response: {"message": "Check in recorded", "data": {...}}
```

---

## 🧪 Testing with cURL

Save as `test_api.sh`:
```bash
#!/bin/bash

BASE_URL="https://appabsensi.mobileprojp.com/api"
EMAIL="user@example.com"
PASSWORD="password123"

# Login
TOKEN=$(curl -s -X POST $BASE_URL/login \
  -H "Content-Type: application/json" \
  -d "{\"email\": \"$EMAIL\", \"password\": \"$PASSWORD\"}" \
  | grep -o '"token":"[^"]*' | cut -d'"' -f4)

echo "Token: $TOKEN"

# Get Profile
curl -X GET $BASE_URL/profile \
  -H "Authorization: Bearer $TOKEN"
```

Run: `bash test_api.sh`

---

## 📖 Postman Collection

Import this as Raw JSON in Postman:

```json
{
  "info": {
    "name": "Presenta API",
    "schema": "https://schema.getpostman.com/json/collection/v2.1.0/collection.json"
  },
  "item": [
    {
      "name": "Login",
      "request": {
        "method": "POST",
        "url": "{{base_url}}/login",
        "body": {
          "mode": "raw",
          "raw": "{\"email\": \"user@example.com\", \"password\": \"password123\"}"
        }
      }
    },
    {
      "name": "Get Profile",
      "request": {
        "method": "GET",
        "header": [
          {
            "key": "Authorization",
            "value": "Bearer {{token}}"
          }
        ],
        "url": "{{base_url}}/profile"
      }
    }
  ],
  "variable": [
    {
      "key": "base_url",
      "value": "https://appabsensi.mobileprojp.com/api"
    },
    {
      "key": "token",
      "value": ""
    }
  ]
}
```

---

## 🐛 Debugging Tips

1. **Check Status Code**: 400/422 = validation, 401 = auth, 500 = server
2. **Read Error Message**: API usually returns helpful `message` field
3. **Verify Token**: Make sure token is included in header
4. **Check Timestamps**: Ensure timestamps are in UTC
5. **Validate Data**: Ensure all required fields are present
6. **Use Postman**: Test API before implementing in code

---

## 📞 Support

For API issues:
1. Check this documentation
2. Verify request format matches examples
3. Check server status
4. Contact API maintainer with error details

---

**Last Updated**: April 2026
**API Version**: 1.0
**Base URL**: https://appabsensi.mobileprojp.com/api


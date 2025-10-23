# 📮 Postman API Testing Collection

## Quick Start Guide

### Import Settings
- **Base URL**: `http://localhost:5000/api/auth`
- **Content-Type**: `application/json`

---

## 📝 Test Requests

### 1️⃣ Register User

**Method**: `POST`  
**URL**: `http://localhost:5000/api/auth/register`

**Headers**:
```
Content-Type: application/json
```

**Body** (raw JSON):
```json
{
  "username": "johndoe",
  "email": "john@example.com",
  "password": "SecurePass123"
}
```

**Expected Response** (200 OK):
```json
{
  "success": true,
  "message": "User registered successfully",
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiIxIiwidXNlcm5hbWUiOiJqb2huZG9lIiwiZW1haWwiOiJqb2huQGV4YW1wbGUuY29tIiwianRpIjoiZGY1NjdhZDQtYTk4Zi00YzJkLWIwMmUtYzA4NzU2ZjUzOGY1IiwiZXhwIjoxNjk5MjAwMDAwLCJpc3MiOiJBdXRoQXBpIiwiYXVkIjoiRmx1dHRlckF1dGhBcHAifQ.signature",
  "user": {
    "id": 1,
    "username": "johndoe",
    "email": "john@example.com"
  }
}
```

**⚠️ Copy the `token` value for next requests!**

---

### 2️⃣ Login User

**Method**: `POST`  
**URL**: `http://localhost:5000/api/auth/login`

**Headers**:
```
Content-Type: application/json
```

**Body** (raw JSON):
```json
{
  "usernameOrEmail": "johndoe",
  "password": "SecurePass123"
}
```

**Alternative** (login with email):
```json
{
  "usernameOrEmail": "john@example.com",
  "password": "SecurePass123"
}
```

**Expected Response** (200 OK):
```json
{
  "success": true,
  "message": "Login successful",
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "user": {
    "id": 1,
    "username": "johndoe",
    "email": "john@example.com"
  }
}
```

---

### 3️⃣ Validate Token

**Method**: `POST`  
**URL**: `http://localhost:5000/api/auth/validate`

**Headers**:
```
Content-Type: application/json
```

**Body** (raw JSON):
```json
{
  "token": "YOUR_JWT_TOKEN_HERE"
}
```

**Example**:
```json
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiIxIiwidXNlcm5hbWUiOiJqb2huZG9lIiwiZW1haWwiOiJqb2huQGV4YW1wbGUuY29tIiwianRpIjoiZGY1NjdhZDQtYTk4Zi00YzJkLWIwMmUtYzA4NzU2ZjUzOGY1IiwiZXhwIjoxNjk5MjAwMDAwLCJpc3MiOiJBdXRoQXBpIiwiYXVkIjoiRmx1dHRlckF1dGhBcHAifQ.signature"
}
```

**Expected Response** (200 OK - Token Valid):
```json
{
  "success": true,
  "message": "Token is valid",
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "user": {
    "id": 1,
    "username": "johndoe",
    "email": "john@example.com"
  }
}
```

**Expected Response** (401 Unauthorized - Token Invalid):
```json
{
  "success": false,
  "message": "Invalid or expired token",
  "token": null,
  "user": null
}
```

---

### 4️⃣ Auto-Login with Token (No Password Required!)

**Method**: `POST`  
**URL**: `http://localhost:5000/api/auth/login`

**Headers**:
```
Content-Type: application/json
Authorization: Bearer YOUR_JWT_TOKEN_HERE
```

**Body** (can be empty or `{}`):
```json
{}
```

**Expected Response** (200 OK):
```json
{
  "success": true,
  "message": "Token is valid",
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "user": {
    "id": 1,
    "username": "johndoe",
    "email": "john@example.com"
  }
}
```

**✨ This is how Flutter automatically logs you in without asking for password!**

---

### 5️⃣ Get Protected Profile

**Method**: `GET`  
**URL**: `http://localhost:5000/api/auth/profile`

**Headers**:
```
Authorization: Bearer YOUR_JWT_TOKEN_HERE
```

**No Body Required**

**Expected Response** (200 OK):
```json
{
  "userId": "1",
  "username": "johndoe",
  "email": "john@example.com",
  "message": "This is a protected endpoint"
}
```

**Expected Response** (401 Unauthorized - No Token):
```json
{
  "type": "https://tools.ietf.org/html/rfc7235#section-3.1",
  "title": "Unauthorized",
  "status": 401
}
```

---

## 🔄 Complete Test Flow

### Step 1: Register a New User
```
POST /api/auth/register
Body: { "username": "alice", "email": "alice@example.com", "password": "Alice123" }
Response: Get token and save it
```

### Step 2: Test Login
```
POST /api/auth/login
Body: { "usernameOrEmail": "alice", "password": "Alice123" }
Response: Get token again
```

### Step 3: Validate Token
```
POST /api/auth/validate
Body: { "token": "YOUR_TOKEN" }
Response: Should return success: true
```

### Step 4: Access Protected Endpoint
```
GET /api/auth/profile
Header: Authorization: Bearer YOUR_TOKEN
Response: Should return user profile data
```

### Step 5: Test Auto-Login
```
POST /api/auth/login
Header: Authorization: Bearer YOUR_TOKEN
Body: {} (empty)
Response: Should log you in without password!
```

---

## 🧪 Test Scenarios

### ✅ Successful Scenarios

1. **Register with valid data** → Returns token
2. **Login with username** → Returns token
3. **Login with email** → Returns token
4. **Validate valid token** → Returns user data
5. **Auto-login with token** → Returns user data
6. **Access protected endpoint with token** → Returns profile

### ❌ Error Scenarios

1. **Register with existing username** → 400 Bad Request
   ```json
   {
     "success": false,
     "message": "Username already exists"
   }
   ```

2. **Register with existing email** → 400 Bad Request
   ```json
   {
     "success": false,
     "message": "Email already exists"
   }
   ```

3. **Login with wrong password** → 401 Unauthorized
   ```json
   {
     "success": false,
     "message": "Invalid credentials"
   }
   ```

4. **Login with non-existent user** → 401 Unauthorized
   ```json
   {
     "success": false,
     "message": "Invalid credentials"
   }
   ```

5. **Validate expired/invalid token** → 401 Unauthorized
   ```json
   {
     "success": false,
     "message": "Invalid or expired token"
   }
   ```

6. **Access protected endpoint without token** → 401 Unauthorized

---

## 📊 Environment Variables (Optional)

Create a Postman environment with these variables:

```json
{
  "name": "Flutter Auth API",
  "values": [
    {
      "key": "baseUrl",
      "value": "http://localhost:5000/api/auth",
      "enabled": true
    },
    {
      "key": "token",
      "value": "",
      "enabled": true
    }
  ]
}
```

Then use `{{baseUrl}}` and `{{token}}` in your requests:
- URL: `{{baseUrl}}/register`
- Header: `Authorization: Bearer {{token}}`

---

## 🎯 Quick Test Commands (cURL)

### Register
```bash
curl -X POST http://localhost:5000/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{"username":"testuser","email":"test@example.com","password":"Test123"}'
```

### Login
```bash
curl -X POST http://localhost:5000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"usernameOrEmail":"testuser","password":"Test123"}'
```

### Validate Token
```bash
curl -X POST http://localhost:5000/api/auth/validate \
  -H "Content-Type: application/json" \
  -d '{"token":"YOUR_TOKEN_HERE"}'
```

### Get Profile
```bash
curl -X GET http://localhost:5000/api/auth/profile \
  -H "Authorization: Bearer YOUR_TOKEN_HERE"
```

---

## 📝 Notes

- **Token Expiry**: Tokens expire after 24 hours (configurable in `appsettings.json`)
- **Password Requirements**: No strict requirements in this demo (add validation as needed)
- **Rate Limiting**: Not implemented (consider adding for production)
- **Database**: Using in-memory database (data resets when API restarts)

---

## 🚀 Ready to Test!

1. Start the .NET API: `cd AuthApi && dotnet run`
2. Open Postman
3. Follow the test flow above
4. Save your tokens for authenticated requests
5. Test all scenarios

**Happy Testing! 🎉**

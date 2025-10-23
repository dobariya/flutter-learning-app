# Flutter Authentication App with .NET Web API

A complete full-stack authentication application built with Flutter and .NET 8 Web API, featuring JWT token-based authentication, secure storage, and automatic login.

## 📋 Table of Contents

- [Features](#features)
- [Project Structure](#project-structure)
- [Backend Setup (.NET Web API)](#backend-setup-net-web-api)
- [Frontend Setup (Flutter)](#frontend-setup-flutter)
- [API Documentation](#api-documentation)
- [Testing with Postman](#testing-with-postman)
- [Connecting Flutter to Backend](#connecting-flutter-to-backend)
- [Screenshots](#screenshots)
- [Troubleshooting](#troubleshooting)

---

## ✨ Features

### Backend (.NET 8 Web API)
- ✅ User registration with password hashing (BCrypt)
- ✅ User login with JWT token generation
- ✅ Token validation and auto-login support
- ✅ Entity Framework Core with In-Memory Database
- ✅ Protected endpoints with JWT authentication
- ✅ CORS enabled for Flutter app
- ✅ Swagger UI for API testing

### Frontend (Flutter)
- ✅ Beautiful Material Design UI
- ✅ Registration screen with form validation
- ✅ Login screen with remember me (automatic token validation)
- ✅ Home screen with user information
- ✅ Secure token storage using `flutter_secure_storage`
- ✅ Automatic login on app launch
- ✅ Loading indicators and error handling
- ✅ Logout functionality

---

## 📁 Project Structure

```
d:/fluter/
├── AuthApi/                          # .NET Web API Backend
│   ├── Controllers/
│   │   └── AuthController.cs
│   ├── Data/
│   │   └── AppDbContext.cs
│   ├── DTOs/
│   │   ├── AuthResponse.cs
│   │   ├── LoginDto.cs
│   │   └── RegisterDto.cs
│   ├── Models/
│   │   └── User.cs
│   ├── Services/
│   │   ├── IAuthService.cs
│   │   └── AuthService.cs
│   ├── Program.cs
│   ├── appsettings.json
│   └── AuthApi.csproj
│
└── flutter_auth_app/                 # Flutter Frontend
    ├── lib/
    │   ├── models/
    │   │   ├── auth_response.dart
    │   │   └── user_model.dart
    │   ├── screens/
    │   │   ├── home_screen.dart
    │   │   ├── login_screen.dart
    │   │   └── register_screen.dart
    │   ├── services/
    │   │   ├── api_service.dart
    │   │   └── storage_service.dart
    │   └── main.dart
    └── pubspec.yaml
```

---

## 🚀 Backend Setup (.NET Web API)

### Prerequisites
- .NET 8 SDK installed
- Visual Studio 2022 or VS Code

### Step 1: Navigate to Backend Directory
```bash
cd d:/fluter/AuthApi
```

### Step 2: Restore NuGet Packages
```bash
dotnet restore
```

### Step 3: Build the Project
```bash
dotnet build
```

### Step 4: Run the API
```bash
dotnet run
```

The API will start at:
- **HTTP**: `http://localhost:5000`
- **HTTPS**: `https://localhost:5001`
- **Swagger UI**: `http://localhost:5000/swagger`

### Step 5: Verify API is Running
Open your browser and navigate to `http://localhost:5000`. You should see:
```json
{
  "message": "AuthApi is running!",
  "endpoints": {
    "register": "POST /api/auth/register",
    "login": "POST /api/auth/login",
    "validate": "POST /api/auth/validate",
    "profile": "GET /api/auth/profile (protected)"
  }
}
```

---

## 📱 Frontend Setup (Flutter)

### Prerequisites
- Flutter SDK installed (3.0.0 or higher)
- Android Studio / Xcode (for emulators)
- VS Code with Flutter extension

### Step 1: Navigate to Flutter Directory
```bash
cd d:/fluter/flutter_auth_app
```

### Step 2: Get Flutter Dependencies
```bash
flutter pub get
```

### Step 3: Update API Base URL

**IMPORTANT**: Update the `baseUrl` in `lib/services/api_service.dart` based on your testing device:

```dart
// For Windows/Mac running on localhost
static const String baseUrl = 'http://localhost:5000/api/auth';

// For Android Emulator
static const String baseUrl = 'http://10.0.2.2:5000/api/auth';

// For iOS Simulator
static const String baseUrl = 'http://localhost:5000/api/auth';

// For Physical Device (replace with your computer's IP)
static const String baseUrl = 'http://192.168.1.100:5000/api/auth';
```

**To find your local IP address:**
- **Windows**: Open Command Prompt and run `ipconfig`
- **Mac/Linux**: Open Terminal and run `ifconfig`

### Step 4: Run the Flutter App
```bash
flutter run
```

Or select a device in VS Code and press F5.

---

## 📖 API Documentation

### Base URL
```
http://localhost:5000/api/auth
```

### Endpoints

#### 1. **Register User**
Creates a new user account and returns a JWT token.

**Endpoint:** `POST /api/auth/register`

**Request Body:**
```json
{
  "username": "johndoe",
  "email": "john@example.com",
  "password": "password123"
}
```

**Success Response (200 OK):**
```json
{
  "success": true,
  "message": "User registered successfully",
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "user": {
    "id": 1,
    "username": "johndoe",
    "email": "john@example.com"
  }
}
```

**Error Response (400 Bad Request):**
```json
{
  "success": false,
  "message": "Username already exists",
  "token": null,
  "user": null
}
```

---

#### 2. **Login User**
Authenticates a user and returns a JWT token.

**Endpoint:** `POST /api/auth/login`

**Request Body:**
```json
{
  "usernameOrEmail": "johndoe",
  "password": "password123"
}
```

**Success Response (200 OK):**
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

**Auto-Login with Token (Optional):**
If you include an `Authorization` header with a valid Bearer token, the API will validate it automatically without requiring credentials:

**Headers:**
```
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

**Request Body:** (can be empty)
```json
{}
```

---

#### 3. **Validate Token**
Checks if a JWT token is valid and not expired.

**Endpoint:** `POST /api/auth/validate`

**Request Body:**
```json
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

**Success Response (200 OK):**
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

**Error Response (401 Unauthorized):**
```json
{
  "success": false,
  "message": "Invalid or expired token",
  "token": null,
  "user": null
}
```

---

#### 4. **Get Profile (Protected)**
Returns user profile data. Requires authentication.

**Endpoint:** `GET /api/auth/profile`

**Headers:**
```
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

**Success Response (200 OK):**
```json
{
  "userId": "1",
  "username": "johndoe",
  "email": "john@example.com",
  "message": "This is a protected endpoint"
}
```

---

## 🧪 Testing with Postman

### Setup

1. **Download Postman**: https://www.postman.com/downloads/
2. **Create a new Collection**: "Flutter Auth API"

### Test 1: Register a New User

1. Create a new request: `POST Register User`
2. **URL**: `http://localhost:5000/api/auth/register`
3. **Method**: POST
4. **Headers**:
   - `Content-Type: application/json`
5. **Body** (raw JSON):
   ```json
   {
     "username": "testuser",
     "email": "test@example.com",
     "password": "Test@123"
   }
   ```
6. Click **Send**
7. **Expected Response**: 200 OK with token and user data
8. **Save the token** for next requests

### Test 2: Login

1. Create a new request: `POST Login`
2. **URL**: `http://localhost:5000/api/auth/login`
3. **Method**: POST
4. **Headers**:
   - `Content-Type: application/json`
5. **Body** (raw JSON):
   ```json
   {
     "usernameOrEmail": "testuser",
     "password": "Test@123"
   }
   ```
6. Click **Send**
7. **Expected Response**: 200 OK with token

### Test 3: Validate Token

1. Create a new request: `POST Validate Token`
2. **URL**: `http://localhost:5000/api/auth/validate`
3. **Method**: POST
4. **Headers**:
   - `Content-Type: application/json`
5. **Body** (raw JSON):
   ```json
   {
     "token": "YOUR_TOKEN_HERE"
   }
   ```
6. Click **Send**
7. **Expected Response**: 200 OK if token is valid

### Test 4: Get Protected Profile

1. Create a new request: `GET Profile`
2. **URL**: `http://localhost:5000/api/auth/profile`
3. **Method**: GET
4. **Headers**:
   - `Authorization: Bearer YOUR_TOKEN_HERE`
5. Click **Send**
6. **Expected Response**: 200 OK with user profile data

### Test 5: Auto-Login with Token

1. Create a new request: `POST Auto Login`
2. **URL**: `http://localhost:5000/api/auth/login`
3. **Method**: POST
4. **Headers**:
   - `Content-Type: application/json`
   - `Authorization: Bearer YOUR_TOKEN_HERE`
5. **Body**: Leave empty or `{}`
6. Click **Send**
7. **Expected Response**: 200 OK with user data (no password needed!)

---

## 🔗 Connecting Flutter to Backend

### Configuration Checklist

1. **Backend is Running**: Ensure the .NET API is running on `http://localhost:5000`

2. **Update Base URL in Flutter**:
   - Open `lib/services/api_service.dart`
   - Update the `baseUrl` constant based on your device:
   
   ```dart
   // Android Emulator
   static const String baseUrl = 'http://10.0.2.2:5000/api/auth';
   
   // iOS Simulator or Chrome
   static const String baseUrl = 'http://localhost:5000/api/auth';
   
   // Physical Device (use your PC's IP)
   static const String baseUrl = 'http://192.168.1.100:5000/api/auth';
   ```

3. **Test Connection**:
   - Run the Flutter app
   - Try to register a new user
   - If you see "Connection error", check:
     - Backend is running
     - Base URL is correct
     - Firewall is not blocking port 5000

### Common Issues

**Issue 1: "Connection refused" on Android Emulator**
- **Solution**: Use `http://10.0.2.2:5000` instead of `localhost`

**Issue 2: "Failed host lookup" on Physical Device**
- **Solution**: 
  1. Find your computer's IP address
  2. Update `baseUrl` to use that IP
  3. Make sure your phone and computer are on the same Wi-Fi network

**Issue 3: API returns 401 Unauthorized**
- **Solution**: Token might be expired (24 hours). Clear app data and login again.

---

## 🎨 Application Flow

### 1. App Launch
```
SplashScreen
    ↓
Check if token exists?
    ├─ No → LoginScreen
    └─ Yes → Validate token
         ├─ Valid → HomeScreen
         └─ Invalid → LoginScreen
```

### 2. Registration Flow
```
RegisterScreen
    ↓
Fill form → Validate
    ↓
Send POST /register
    ↓
Success?
    ├─ Yes → Save token → HomeScreen
    └─ No → Show error
```

### 3. Login Flow
```
LoginScreen
    ↓
Fill form → Validate
    ↓
Send POST /login
    ↓
Success?
    ├─ Yes → Save token → HomeScreen
    └─ No → Show error
```

### 4. Auto-Login Flow
```
App Launch
    ↓
Token exists?
    ↓
Send POST /validate with token
    ↓
Token valid?
    ├─ Yes → HomeScreen (no login needed!)
    └─ No → Delete token → LoginScreen
```

---

## 🔐 JWT Token Details

### Token Structure
```
Header.Payload.Signature
```

### Token Claims
```json
{
  "userId": "1",
  "username": "johndoe",
  "email": "john@example.com",
  "jti": "unique-token-id",
  "exp": 1234567890,
  "iss": "AuthApi",
  "aud": "FlutterAuthApp"
}
```

### Token Expiry
- Default: **24 hours** (1 day)
- Configured in `appsettings.json` → `Jwt:ExpiryInDays`

### Security Best Practices
- ✅ Tokens are stored securely using `flutter_secure_storage`
- ✅ Passwords are hashed with BCrypt (never stored in plain text)
- ✅ HTTPS should be used in production
- ✅ JWT secret key should be stored in environment variables in production

---

## 🐛 Troubleshooting

### Backend Issues

**Problem**: `dotnet: command not found`
- **Solution**: Install .NET 8 SDK from https://dotnet.microsoft.com/download

**Problem**: Port 5000 is already in use
- **Solution**: 
  ```bash
  # Change port in Properties/launchSettings.json
  # Or kill the process using port 5000
  ```

**Problem**: Swagger UI not loading
- **Solution**: Make sure you're accessing `http://localhost:5000/swagger` (not HTTPS)

### Flutter Issues

**Problem**: `flutter: command not found`
- **Solution**: Install Flutter SDK and add to PATH

**Problem**: Package version conflicts
- **Solution**: 
  ```bash
  flutter clean
  flutter pub get
  ```

**Problem**: Cannot connect to API from Flutter
- **Solution**: Check the base URL matches your device type (see [Connecting Flutter to Backend](#connecting-flutter-to-backend))

---

## 📝 Next Steps & Improvements

### Suggested Enhancements
1. **Token Refresh**: Implement refresh tokens for seamless experience
2. **Password Reset**: Add forgot password functionality
3. **Email Verification**: Send verification emails on registration
4. **Profile Updates**: Allow users to update their information
5. **Persistent Database**: Replace in-memory DB with SQL Server/PostgreSQL
6. **Social Login**: Add Google/Facebook authentication
7. **Multi-Factor Authentication**: Add 2FA for extra security

---

## 📄 License

This project is open-source and available for educational purposes.

---

## 👨‍💻 Author

Created as a demonstration of full-stack Flutter + .NET development with JWT authentication.

---

## 🎉 Summary

You now have a complete authentication system with:
- ✅ Secure user registration and login
- ✅ JWT token-based authentication
- ✅ Automatic login on app launch
- ✅ Beautiful Flutter UI
- ✅ RESTful API with .NET 8
- ✅ In-memory database (easy testing)
- ✅ Complete API documentation

**Happy Coding! 🚀**

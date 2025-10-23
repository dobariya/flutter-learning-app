# ⚡ Quick Start Guide

Get your Flutter Auth App running in 5 minutes!

---

## 🎯 Prerequisites Checklist

Before you begin, make sure you have:

- [ ] **.NET 8 SDK** installed ([Download](https://dotnet.microsoft.com/download))
- [ ] **Flutter SDK** installed ([Download](https://flutter.dev/docs/get-started/install))
- [ ] **VS Code** or **Visual Studio** (optional but recommended)
- [ ] **Android Studio** or **Xcode** (for mobile emulators)

**Check installations:**
```bash
# Check .NET version
dotnet --version
# Should show: 8.0.x or higher

# Check Flutter version
flutter --version
# Should show: 3.0.0 or higher
```

---

## 🚀 Step-by-Step Setup

### STEP 1: Start the Backend API (2 minutes)

Open a terminal/command prompt:

```bash
# Navigate to backend directory
cd d:/fluter/AuthApi

# Restore dependencies
dotnet restore

# Run the API
dotnet run
```

**✅ Success Indicator:**
```
Now listening on: http://localhost:5000
Now listening on: https://localhost:5001
Application started. Press Ctrl+C to shut down.
```

**🌐 Test in Browser:**
Open `http://localhost:5000` - you should see:
```json
{
  "message": "AuthApi is running!",
  "endpoints": { ... }
}
```

**Keep this terminal open!**

---

### STEP 2: Configure Flutter App (1 minute)

Open a **NEW** terminal/command prompt:

```bash
# Navigate to Flutter directory
cd d:/fluter/flutter_auth_app

# Get dependencies
flutter pub get
```

**📝 Important: Update API URL**

Open `lib/services/api_service.dart` and update line 10:

```dart
// Choose based on your device:

// For Android Emulator:
static const String baseUrl = 'http://10.0.2.2:5000/api/auth';

// For iOS Simulator or Chrome:
static const String baseUrl = 'http://localhost:5000/api/auth';

// For Physical Device (replace with your PC's IP):
static const String baseUrl = 'http://192.168.1.X:5000/api/auth';
```

**💡 How to find your PC's IP:**
- **Windows**: Run `ipconfig` in Command Prompt, look for "IPv4 Address"
- **Mac**: Run `ifconfig` in Terminal, look for "inet" under your network adapter

---

### STEP 3: Run the Flutter App (2 minutes)

In the Flutter terminal:

```bash
# List available devices
flutter devices

# Run on specific device
flutter run -d <device_id>

# Or just run (will ask you to choose)
flutter run
```

**Example output:**
```
Connected devices:
  • Windows (desktop)        • windows • windows-x64    • Microsoft Windows
  • Chrome (web)             • chrome  • web-javascript • Google Chrome
  • Android Emulator (mobile)• emulator-5554 • android • Android 13 (API 33)

[1]: Windows (windows)
[2]: Chrome (chrome)
[3]: Android Emulator (emulator-5554)

Please choose one:
```

Choose your device and wait for the app to build.

**✅ Success Indicator:**
- App launches and shows a splash screen
- Then navigates to the Login screen
- No error messages in the terminal

---

## 🎉 Test the App!

### Test Flow 1: Register a New User

1. On the **Login Screen**, tap **"Register"**
2. Fill in the form:
   - **Username**: `testuser`
   - **Email**: `test@example.com`
   - **Password**: `Test123`
   - **Confirm Password**: `Test123`
3. Tap **"Register"**
4. You should see a green success message
5. App navigates to **Home Screen** automatically

### Test Flow 2: Logout and Login

1. On **Home Screen**, tap the **Logout icon** (top right)
2. You're back at **Login Screen**
3. Login with:
   - **Username or Email**: `testuser`
   - **Password**: `Test123`
4. Tap **"Login"**
5. You should be on **Home Screen** again

### Test Flow 3: Auto-Login (The Magic!)

1. **Close the app** completely (don't just minimize)
2. **Restart the app**
3. **Watch**: The app automatically logs you in without asking for credentials!
4. You go straight to **Home Screen**

**🎯 This is JWT token authentication in action!**

---

## 🐛 Troubleshooting

### Issue: "Connection Error" in Flutter App

**Possible causes:**
1. Backend API is not running
2. Wrong Base URL in `api_service.dart`
3. Firewall blocking port 5000

**Solutions:**
```bash
# 1. Check if backend is running
# Open http://localhost:5000 in browser

# 2. Verify base URL
# Android Emulator → use http://10.0.2.2:5000/api/auth
# iOS Simulator → use http://localhost:5000/api/auth
# Physical Device → use http://YOUR_IP:5000/api/auth

# 3. Check firewall (Windows)
# Allow port 5000 in Windows Firewall
```

### Issue: Backend won't start

**Error**: "Port 5000 is already in use"

**Solution**:
```bash
# Windows
netstat -ano | findstr :5000
taskkill /PID <PID> /F

# Mac/Linux
lsof -i :5000
kill -9 <PID>
```

### Issue: Flutter build fails

**Solutions**:
```bash
# Clean and rebuild
flutter clean
flutter pub get
flutter run
```

---

## 📱 Device-Specific Setup

### Android Emulator

1. **Start AVD Manager** in Android Studio
2. **Create/Start** an emulator
3. **Base URL**: `http://10.0.2.2:5000/api/auth`
4. **Run**: `flutter run`

### iOS Simulator (Mac only)

1. **Open Xcode**
2. **Start simulator**: Xcode → Open Developer Tool → Simulator
3. **Base URL**: `http://localhost:5000/api/auth`
4. **Run**: `flutter run`

### Physical Android Device

1. **Enable USB Debugging** on your phone
2. **Connect** phone via USB
3. **Base URL**: `http://YOUR_PC_IP:5000/api/auth`
4. **Allow USB debugging** on phone when prompted
5. **Run**: `flutter run`

### Chrome (Web)

1. **Base URL**: `http://localhost:5000/api/auth`
2. **Run**: `flutter run -d chrome`

**Note**: Chrome may have CORS restrictions. Use mobile/desktop for best experience.

---

## 📊 What's Happening Behind the Scenes?

### When You Register:
```
Flutter App → POST /register → Backend API
                               ↓
                        Create User in DB
                               ↓
                        Hash Password
                               ↓
                        Generate JWT Token
                               ↓
Backend API → Response with Token → Flutter App
                                     ↓
                              Store Token Securely
                                     ↓
                              Navigate to Home
```

### When You Launch App:
```
Flutter App → Check if Token Exists
              ↓
        Yes → Validate Token with API
              ↓
        Valid? → Yes → Navigate to Home
              ↓
        No → Navigate to Login
```

---

## 🎓 Next Steps

Once you have the basic app running, try:

1. **Register multiple users** - Test username/email uniqueness
2. **Test wrong passwords** - See error handling
3. **Wait 24 hours** - Test token expiration
4. **Test Postman** - See [POSTMAN_COLLECTION.md](POSTMAN_COLLECTION.md)
5. **Modify UI** - Make it your own!

---

## 📚 File Structure Reference

```
d:/fluter/
├── AuthApi/                    ← Backend (.NET)
│   ├── Controllers/
│   ├── Services/
│   ├── Models/
│   ├── Program.cs             ← Start here to understand backend
│   └── appsettings.json       ← JWT configuration
│
└── flutter_auth_app/          ← Frontend (Flutter)
    ├── lib/
    │   ├── main.dart          ← Start here to understand frontend
    │   ├── services/
    │   │   └── api_service.dart  ← API calls
    │   └── screens/
    │       ├── login_screen.dart
    │       ├── register_screen.dart
    │       └── home_screen.dart
    └── pubspec.yaml           ← Dependencies
```

---

## ✅ Success Checklist

- [ ] Backend API running on `http://localhost:5000`
- [ ] Flutter dependencies installed (`flutter pub get`)
- [ ] Base URL updated in `api_service.dart`
- [ ] Flutter app running on emulator/device
- [ ] Successfully registered a user
- [ ] Successfully logged in
- [ ] Auto-login works after app restart
- [ ] Can access protected profile data

---

## 🆘 Still Having Issues?

1. **Check README.md** - Full documentation
2. **Check POSTMAN_COLLECTION.md** - Test API directly
3. **Verify prerequisites** - All tools installed?
4. **Console logs** - Look for error messages in both terminals

---

## 🎉 You're All Set!

Your full-stack authentication app is now running! 

**What you've built:**
- ✅ Secure user authentication with JWT
- ✅ Password hashing with BCrypt
- ✅ Automatic token validation
- ✅ Beautiful Flutter UI
- ✅ RESTful API with .NET 8

**Time to celebrate! 🚀**

---

**Happy Coding!**

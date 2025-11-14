# Quick Start

Get this running in 5 minutes.

## What You Need

- Android Studio
- NDK and CMake (install via SDK Manager)
- Node.js
- Android device or emulator

## Setup

**1. Open in Android Studio**
Wait for Gradle to sync.

**2. Setup OpenCV (2 min)**
```powershell
.\setup-opencv.ps1
```

**3. Run the app (1 min)**
Hit the Run button, grant camera permission.

**4. Setup web viewer (1 min)**
```bash
cd web
npm install
npm run build
node test-server.js
```

## Test It

1. Note the endpoint URL from the Android app (like `http://192.168.1.100:8080/frame`)
2. Open `web/src/live-viewer.html` in your browser
3. Paste the URL and click "Start Auto-Refresh"
4. You should see live edge detection frames

## Common Issues

- **OpenCV not found?** Run `.\setup-opencv.ps1`
- **NDK errors?** Install NDK via SDK Manager
- **Camera crashes?** Grant permission in device settings
- **Web viewer blank?** Check the URL and make sure both devices are on the same network
- **TypeScript errors?** Run `npm install` in the web folder

## Next

Check [README.md](README.md) for the full docs.

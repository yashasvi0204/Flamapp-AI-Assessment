# Real-Time Edge Detection Viewer

This Android app grabs camera frames, runs edge detection on them using OpenCV in C++, displays the results with OpenGL, and streams everything to a web browser over HTTP.

## What's Inside

**Android App:**
- Camera capture with CameraX
- Canny edge detection (OpenCV in C++)
- OpenGL rendering with custom shaders
- JNI bridge connecting Java and C++
- YUV to RGB frame conversion
- Built-in HTTP server for streaming
- FPS and processing time monitoring

**Web Viewer:**
- TypeScript viewer that fetches frames from the app
- Shows frame metadata (resolution, FPS, processing time)
- Works on desktop and mobile browsers
- Auto-refresh mode for live viewing
- Test suite included

## Screenshots

_TODO: Add screenshots here once you run the app_

## Demo

_TODO: Add a GIF showing the app in action_

## What You Need

- Android Studio (Arctic Fox or newer)
- Android NDK r21+
- OpenCV Android SDK 4.x
- Android SDK 24+ (Android 7.0)
- Node.js (for the web viewer)

## Getting Started

### Install Android Studio and NDK

1. Grab [Android Studio](https://developer.android.com/studio) and install it
2. Open **Tools > SDK Manager**
3. Under **SDK Tools**, install:
   - NDK (Side by side)
   - CMake
   - Android SDK Platform 34

### Setup OpenCV

**Easy way:**
```powershell
.\setup-opencv.ps1
```

**Manual way:**
1. Download OpenCV Android SDK from [opencv.org](https://opencv.org/releases/) (version 4.8.0+)
2. Extract it
3. Copy files to:
   - `opencv/src/main/java/` from `OpenCV-android-sdk/sdk/java/src/`
   - `opencv/src/main/jniLibs/` from `OpenCV-android-sdk/sdk/native/libs/`
   - `app/src/main/cpp/opencv/` from `OpenCV-android-sdk/sdk/`

Check [OPENCV_SETUP.md](OPENCV_SETUP.md) if you run into issues.

### Setup Web Viewer

```bash
cd web
npm install
npm run build
node test-server.js  # optional, for testing
```

### Build and Run

1. Open the project in Android Studio
2. Let Gradle sync finish
3. Hit **Build > Make Project**
4. Connect your Android device (or start an emulator)
5. Click **Run**
6. Grant camera permission when asked

The app will show you the edge-detected camera feed and display an HTTP endpoint URL (something like `http://192.168.1.100:8080/frame`).

### View in Browser

**Live viewer:**
1. Open `web/src/live-viewer.html`
2. Paste the endpoint URL from your phone
3. Click "Start Auto-Refresh"

**Test suite:**
```bash
cd web
node test-server.js
# Go to http://localhost:8000/test-suite.html
```

## How It Works

Here's the flow:

1. **Camera** → CameraX grabs frames (YUV format, 640×480)
2. **Conversion** → `FrameConverter.kt` turns YUV into RGB/grayscale
3. **JNI Bridge** → Frame data crosses from Java to C++ via `image_processor.cpp`
4. **Edge Detection** → OpenCV's Canny algorithm finds edges (with Gaussian blur first)
5. **Back to Java** → Processed frame returns through JNI
6. **Display** → OpenGL renders it on screen using custom shaders
7. **HTTP Server** → `SimpleHttpServer.kt` serves frames as PNG on port 8080
8. **Web Viewer** → TypeScript app fetches and displays frames in browser

The JNI bridge is key here - it lets us run the heavy OpenCV processing in native C++ (way faster than Java) while keeping the Android UI stuff in Kotlin. We use direct ByteBuffers to avoid copying memory around.

For rendering, OpenGL ES 2.0 handles the display with custom GLSL shaders. The web viewer is just TypeScript + HTML5 Canvas, pulling frames over HTTP and showing metadata like FPS and processing time.

**Tech stack:**
- Android: CameraX, OpenGL ES 2.0, JNI
- Native: OpenCV C++, NDK, CMake
- Web: TypeScript, HTML5 Canvas

## Troubleshooting

**OpenCV not found?**
- Make sure `app/src/main/cpp/opencv/sdk/` exists
- Check the path in `CMakeLists.txt`
- Try **Build > Clean Project** then rebuild

**NDK/CMake errors?**
- Update `app/build.gradle` to match your CMake version
- Check **Tools > SDK Manager > SDK Tools** for installed versions

**App crashes on launch?**
- Grant camera permission in device settings
- Or uninstall and reinstall to get the permission prompt again

**Web viewer not loading frames?**
- Make sure the Android app is running
- Check that the endpoint URL matches your device's IP
- Verify both devices are on the same WiFi network
- Check if your firewall is blocking port 8080

**TypeScript won't compile?**
```bash
cd web
rm -rf node_modules dist
npm install
npm run build
```

## Testing

**Android:**
```bash
./gradlew installDebug
```

**Web viewer:**
```bash
cd web
npm run build
node test-server.js
# Open http://localhost:8000/test-suite.html
```

The test suite checks TypeScript compilation, image loading, metadata display, and responsive behavior.

## Project Structure

Check [PROJECT_STRUCTURE.md](PROJECT_STRUCTURE.md) for the full file layout. Main files:
- `MainActivity.kt` - App entry point
- `CameraManager.kt` - Camera handling
- `image_processor.cpp` - Edge detection (C++)
- `GLRenderer.kt` - OpenGL display
- `SimpleHttpServer.kt` - HTTP server
- `web/src/viewer.ts` - Web viewer logic

## Known Issues

- HTTP server handles one client at a time
- No HTTPS (don't use on untrusted networks)
- ~100-200ms streaming latency
- Manual endpoint configuration needed

## Future Ideas

See [OPTIONAL_FEATURES.md](OPTIONAL_FEATURES.md) for what's planned:
- More edge detection algorithms
- Live parameter tuning
- WebSocket streaming
- Multi-client support
- Frame recording

## License

Educational/demo purposes.

---

Questions? Open an issue.

# Project Structure

This document describes the complete structure of the Real-Time Edge Detection Viewer Android project.

## Root Directory

```
EdgeDetectionViewer/
├── app/                          # Main application module
├── opencv/                       # OpenCV library module
├── gradle/                       # Gradle wrapper files
├── .gitignore                    # Git ignore rules
├── build.gradle                  # Root build configuration
├── settings.gradle               # Project settings and modules
├── gradle.properties             # Gradle properties
├── README.md                     # Main project documentation
├── OPENCV_SETUP.md              # OpenCV setup guide
├── PROJECT_STRUCTURE.md         # This file
└── setup-opencv.ps1             # Automated OpenCV setup script
```

## App Module Structure

```
app/
├── src/
│   └── main/
│       ├── java/com/example/edgedetection/
│       │   ├── MainActivity.kt              # (To be implemented in Task 2)
│       │   ├── CameraManager.kt             # (To be implemented in Task 2)
│       │   ├── JNIBridge.kt                 # (To be implemented in Task 3)
│       │   └── gl/
│       │       ├── GLRenderer.kt            # (To be implemented in Task 5)
│       │       └── ShaderUtils.kt           # (To be implemented in Task 5)
│       ├── cpp/
│       │   ├── opencv/                      # OpenCV SDK (to be added)
│       │   │   └── sdk/
│       │   │       └── native/jni/
│       │   ├── CMakeLists.txt               # CMake build configuration
│       │   ├── image_processor.cpp          # (To be implemented in Task 4)
│       │   └── image_processor.h            # (To be implemented in Task 4)
│       ├── res/
│       │   ├── layout/
│       │   │   └── activity_main.xml        # Main activity layout
│       │   ├── values/
│       │   │   ├── strings.xml              # String resources
│       │   │   ├── colors.xml               # Color resources
│       │   │   └── themes.xml               # App themes
│       │   ├── xml/
│       │   │   ├── backup_rules.xml         # Backup configuration
│       │   │   └── data_extraction_rules.xml # Data extraction rules
│       │   └── mipmap-*/                    # App icons (to be added)
│       └── AndroidManifest.xml              # App manifest with permissions
├── build.gradle                             # App module build configuration
└── proguard-rules.pro                       # ProGuard rules
```

## OpenCV Module Structure

```
opencv/
├── src/
│   └── main/
│       ├── java/                            # OpenCV Java sources (to be added)
│       │   └── org/opencv/
│       ├── jniLibs/                         # OpenCV native libraries (to be added)
│       │   ├── arm64-v8a/
│       │   ├── armeabi-v7a/
│       │   ├── x86/
│       │   └── x86_64/
│       └── AndroidManifest.xml              # OpenCV module manifest
├── build.gradle                             # OpenCV module build configuration
├── proguard-rules.pro                       # ProGuard rules for OpenCV
└── consumer-rules.pro                       # Consumer ProGuard rules
```

## Key Configuration Files

### build.gradle (Root)
- Defines Android Gradle Plugin version (8.1.0)
- Defines Kotlin version (1.9.0)
- Applies to all subprojects

### app/build.gradle
- Application ID: `com.example.edgedetection`
- Min SDK: 24 (Android 7.0)
- Target SDK: 34 (Android 14)
- Compile SDK: 34
- Dependencies:
  - AndroidX Core, AppCompat, Material
  - Camera2 API (CameraX)
  - OpenCV module
- NDK configuration:
  - Supported ABIs: armeabi-v7a, arm64-v8a, x86, x86_64
  - C++ standard: C++14
- CMake configuration for native code

### app/src/main/cpp/CMakeLists.txt
- CMake minimum version: 3.22.1
- Project name: native-processor
- C++ standard: 14
- Links OpenCV libraries
- Creates shared library: libnative-processor.so

### settings.gradle
- Includes app module
- Includes opencv module
- Configures repositories (Google, Maven Central)

### AndroidManifest.xml
- Declares camera permissions
- Declares camera hardware features
- Declares OpenGL ES 2.0 requirement
- Defines MainActivity as launcher activity
- Portrait orientation

## Dependencies

### Android Dependencies
- androidx.core:core-ktx:1.12.0
- androidx.appcompat:appcompat:1.6.1
- com.google.android.material:material:1.11.0
- androidx.constraintlayout:constraintlayout:2.1.4
- androidx.camera:camera-camera2:1.3.1
- androidx.camera:camera-lifecycle:1.3.1
- androidx.camera:camera-view:1.3.1

### Native Dependencies
- OpenCV Android SDK 4.x
- Android NDK r21+
- CMake 3.22.1+

### Build Tools
- Gradle 8.0
- Android Gradle Plugin 8.1.0
- Kotlin 1.9.0

## Permissions

### Runtime Permissions
- `android.permission.CAMERA` - Required for camera access

### Hardware Features
- `android.hardware.camera` - Required
- `android.hardware.camera.autofocus` - Optional
- OpenGL ES 2.0 - Required

## Build Outputs

### Debug Build
- APK: `app/build/outputs/apk/debug/app-debug.apk`
- Native libraries: `app/build/intermediates/cmake/debug/obj/`

### Release Build
- APK: `app/build/outputs/apk/release/app-release.apk`
- Native libraries: `app/build/intermediates/cmake/release/obj/`

## Next Implementation Tasks

1. **Task 2**: Implement camera capture module
   - CameraManager.kt
   - MainActivity.kt (camera initialization)

2. **Task 3**: Implement JNI bridge
   - JNIBridge.kt
   - Native JNI functions in image_processor.cpp

3. **Task 4**: Implement OpenCV processing
   - image_processor.cpp
   - image_processor.h
   - Canny edge detection
   - Grayscale conversion

4. **Task 5**: Implement OpenGL rendering
   - GLRenderer.kt
   - ShaderUtils.kt
   - GLSL shaders

5. **Task 6**: Integration in MainActivity
   - Wire all components together
   - Lifecycle management

6. **Task 7**: Create TypeScript web viewer
   - Separate web/ directory
   - TypeScript implementation

## Notes

- OpenCV SDK files are excluded from Git (too large)
- Use `setup-opencv.ps1` script or follow `OPENCV_SETUP.md` for setup
- Native code is compiled for multiple ABIs
- Project uses Kotlin for Android code and C++ for native processing

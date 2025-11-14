# OpenCV Android SDK Setup Guide

This guide provides detailed instructions for setting up the OpenCV Android SDK for this project.

## Directory Structure

After extraction, you should see:
```
OpenCV-android-sdk/
├── apk/
├── samples/
└── sdk/
    ├── etc/
    ├── java/
    │   └── src/
    │       └── org/
    │           └── opencv/
    ├── native/
    │   ├── jni/
    │   ├── libs/
    │   └── staticlibs/
    └── LICENSE
```

## Copy Files to Project

### Step 1: Copy Java Sources

Copy the Java source files to the opencv module:

**Source:** `OpenCV-android-sdk/sdk/java/src/`  
**Destination:** `opencv/src/main/java/`

This should create:
```
opencv/src/main/java/org/opencv/
```

### Step 2: Copy Native Libraries

Copy the native libraries to the opencv module:

**Source:** `OpenCV-android-sdk/sdk/native/libs/`  
**Destination:** `opencv/src/main/jniLibs/`

This should create:
```
opencv/src/main/jniLibs/
├── arm64-v8a/
│   └── libopencv_java4.so
├── armeabi-v7a/
│   └── libopencv_java4.so
├── x86/
│   └── libopencv_java4.so
└── x86_64/
    └── libopencv_java4.so
```

### Step 3: Copy SDK for Native Code

Copy the entire SDK directory for CMake/NDK integration:

**Source:** `OpenCV-android-sdk/sdk/`  
**Destination:** `app/src/main/cpp/opencv/sdk/`

This should create:
```
app/src/main/cpp/opencv/sdk/
├── etc/
├── java/
├── native/
│   ├── jni/
│   │   ├── abi-arm64-v8a/
│   │   ├── abi-armeabi-v7a/
│   │   ├── abi-x86/
│   │   ├── abi-x86_64/
│   │   └── OpenCVConfig.cmake
│   ├── libs/
│   └── staticlibs/
└── LICENSE
```

## Verification

After copying, verify the following files exist:

1. **Java sources:**
   - `opencv/src/main/java/org/opencv/core/Core.java`
   - `opencv/src/main/java/org/opencv/imgproc/Imgproc.java`

2. **Native libraries:**
   - `opencv/src/main/jniLibs/arm64-v8a/libopencv_java4.so`
   - `opencv/src/main/jniLibs/armeabi-v7a/libopencv_java4.so`

3. **CMake configuration:**
   - `app/src/main/cpp/opencv/sdk/native/jni/OpenCVConfig.cmake`

## Build and Test

1. Open the project in Android Studio
2. Sync Gradle: **File > Sync Project with Gradle Files**
3. Build the project: **Build > Make Project**
4. Check for any OpenCV-related errors in the build output

## Common Issues

### Issue: "OpenCV not found" during CMake configuration

**Solution:** Verify that `app/src/main/cpp/opencv/sdk/native/jni/OpenCVConfig.cmake` exists.

### Issue: "libopencv_java4.so not found" at runtime

**Solution:** Verify that native libraries are in `opencv/src/main/jniLibs/` with correct ABI folders.

### Issue: Java class not found errors

**Solution:** Verify that Java sources are in `opencv/src/main/java/org/opencv/`.

## Alternative: Manual Download Script

If you prefer automation, you can use this PowerShell script (Windows):

```powershell
# Download OpenCV Android SDK
$opencvVersion = "4.8.0"
$downloadUrl = "https://github.com/opencv/opencv/releases/download/$opencvVersion/opencv-$opencvVersion-android-sdk.zip"
$zipFile = "opencv-android-sdk.zip"

# Download
Invoke-WebRequest -Uri $downloadUrl -OutFile $zipFile

# Extract
Expand-Archive -Path $zipFile -DestinationPath "opencv-temp"

# Copy files
Copy-Item -Path "opencv-temp/OpenCV-android-sdk/sdk/java/src/*" -Destination "opencv/src/main/java/" -Recurse
Copy-Item -Path "opencv-temp/OpenCV-android-sdk/sdk/native/libs/*" -Destination "opencv/src/main/jniLibs/" -Recurse
Copy-Item -Path "opencv-temp/OpenCV-android-sdk/sdk" -Destination "app/src/main/cpp/opencv/" -Recurse

# Cleanup
Remove-Item -Path $zipFile
Remove-Item -Path "opencv-temp" -Recurse

Write-Host "OpenCV setup complete!"
```

Save this as `setup-opencv.ps1` and run it from the project root.

## Next Steps

Once OpenCV is set up, you can proceed with implementing the native image processing code in Task 4.

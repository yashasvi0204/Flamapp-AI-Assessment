# OpenCV Android SDK Setup Script
# This script downloads and sets up OpenCV Android SDK for the project

param(
    [string]$OpenCVVersion = "4.8.0"
)

$ErrorActionPreference = "Stop"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "OpenCV Android SDK Setup" -ForegroundColor Cyan
Write-Host "Version: $OpenCVVersion" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Configuration
$downloadUrl = "https://github.com/opencv/opencv/releases/download/$OpenCVVersion/opencv-$OpenCVVersion-android-sdk.zip"
$zipFile = "opencv-android-sdk.zip"
$extractPath = "opencv-temp"
$sdkPath = "$extractPath/OpenCV-android-sdk/sdk"

# Check if OpenCV is already set up
if (Test-Path "opencv/src/main/java/org/opencv/core/Core.java") {
    Write-Host "OpenCV appears to be already set up." -ForegroundColor Yellow
    $response = Read-Host "Do you want to re-download and overwrite? (y/n)"
    if ($response -ne "y") {
        Write-Host "Setup cancelled." -ForegroundColor Yellow
        exit 0
    }
}

# Download OpenCV
Write-Host "Downloading OpenCV $OpenCVVersion..." -ForegroundColor Green
try {
    Invoke-WebRequest -Uri $downloadUrl -OutFile $zipFile -UseBasicParsing
    Write-Host "Download complete!" -ForegroundColor Green
} catch {
    Write-Host "Failed to download OpenCV. Please check your internet connection and the version number." -ForegroundColor Red
    Write-Host "URL: $downloadUrl" -ForegroundColor Red
    exit 1
}

# Extract archive
Write-Host "Extracting archive..." -ForegroundColor Green
try {
    Expand-Archive -Path $zipFile -DestinationPath $extractPath -Force
    Write-Host "Extraction complete!" -ForegroundColor Green
} catch {
    Write-Host "Failed to extract archive." -ForegroundColor Red
    exit 1
}

# Verify extraction
if (-not (Test-Path $sdkPath)) {
    Write-Host "Error: SDK path not found after extraction." -ForegroundColor Red
    Write-Host "Expected path: $sdkPath" -ForegroundColor Red
    exit 1
}

# Copy Java sources
Write-Host "Copying Java sources..." -ForegroundColor Green
$javaSrc = "$sdkPath/java/src"
$javaDest = "opencv/src/main/java"
if (Test-Path $javaSrc) {
    New-Item -ItemType Directory -Force -Path $javaDest | Out-Null
    Copy-Item -Path "$javaSrc/*" -Destination $javaDest -Recurse -Force
    Write-Host "Java sources copied successfully!" -ForegroundColor Green
} else {
    Write-Host "Warning: Java sources not found at $javaSrc" -ForegroundColor Yellow
}

# Copy native libraries
Write-Host "Copying native libraries..." -ForegroundColor Green
$nativeLibs = "$sdkPath/native/libs"
$nativeDest = "opencv/src/main/jniLibs"
if (Test-Path $nativeLibs) {
    New-Item -ItemType Directory -Force -Path $nativeDest | Out-Null
    Copy-Item -Path "$nativeLibs/*" -Destination $nativeDest -Recurse -Force
    Write-Host "Native libraries copied successfully!" -ForegroundColor Green
} else {
    Write-Host "Warning: Native libraries not found at $nativeLibs" -ForegroundColor Yellow
}

# Copy SDK for CMake
Write-Host "Copying SDK for native code..." -ForegroundColor Green
$sdkDest = "app/src/main/cpp/opencv"
if (Test-Path $sdkPath) {
    New-Item -ItemType Directory -Force -Path $sdkDest | Out-Null
    Copy-Item -Path $sdkPath -Destination $sdkDest -Recurse -Force
    Write-Host "SDK copied successfully!" -ForegroundColor Green
} else {
    Write-Host "Warning: SDK not found at $sdkPath" -ForegroundColor Yellow
}

# Cleanup
Write-Host "Cleaning up temporary files..." -ForegroundColor Green
Remove-Item -Path $zipFile -Force -ErrorAction SilentlyContinue
Remove-Item -Path $extractPath -Recurse -Force -ErrorAction SilentlyContinue
Write-Host "Cleanup complete!" -ForegroundColor Green

# Verification
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Verification" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

$allGood = $true

# Check Java sources
if (Test-Path "opencv/src/main/java/org/opencv/core/Core.java") {
    Write-Host "[OK] Java sources" -ForegroundColor Green
} else {
    Write-Host "[FAIL] Java sources not found" -ForegroundColor Red
    $allGood = $false
}

# Check native libraries
if (Test-Path "opencv/src/main/jniLibs/arm64-v8a/libopencv_java4.so") {
    Write-Host "[OK] Native libraries (arm64-v8a)" -ForegroundColor Green
} else {
    Write-Host "[FAIL] Native libraries not found" -ForegroundColor Red
    $allGood = $false
}

# Check CMake config
if (Test-Path "app/src/main/cpp/opencv/sdk/native/jni/OpenCVConfig.cmake") {
    Write-Host "[OK] CMake configuration" -ForegroundColor Green
} else {
    Write-Host "[FAIL] CMake configuration not found" -ForegroundColor Red
    $allGood = $false
}

Write-Host ""
if ($allGood) {
    Write-Host "========================================" -ForegroundColor Green
    Write-Host "Setup completed successfully!" -ForegroundColor Green
    Write-Host "========================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "Next steps:" -ForegroundColor Cyan
    Write-Host "1. Open the project in Android Studio" -ForegroundColor White
    Write-Host "2. Sync Gradle files" -ForegroundColor White
    Write-Host "3. Build the project" -ForegroundColor White
} else {
    Write-Host "========================================" -ForegroundColor Red
    Write-Host "Setup completed with errors!" -ForegroundColor Red
    Write-Host "========================================" -ForegroundColor Red
    Write-Host ""
    Write-Host "Please check the error messages above and refer to OPENCV_SETUP.md for manual setup instructions." -ForegroundColor Yellow
}

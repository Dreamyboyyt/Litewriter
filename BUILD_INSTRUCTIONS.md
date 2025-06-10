# Litewriter - Build Instructions

## Prerequisites

To build the Litewriter Android app, you'll need:

1. **Flutter SDK** (3.0 or higher)
2. **Android Studio** with Android SDK
3. **Java Development Kit (JDK)** 8 or higher

## Setup Instructions

### 1. Install Flutter

```bash
# Download Flutter SDK
git clone https://github.com/flutter/flutter.git -b stable
export PATH="$PATH:`pwd`/flutter/bin"

# Verify installation
flutter doctor
```

### 2. Install Android Studio

1. Download Android Studio from https://developer.android.com/studio
2. Install Android SDK (API level 21 or higher)
3. Set up Android emulator or connect physical device

### 3. Configure Environment

```bash
# Set Android SDK path
export ANDROID_HOME=/path/to/android/sdk
export PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools
```

## Building the App

### 1. Get Dependencies

```bash
cd litewriter
flutter pub get
```

### 2. Generate Code

```bash
flutter packages pub run build_runner build --delete-conflicting-outputs
```

### 3. Build APK

```bash
# Debug build
flutter build apk --debug

# Release build
flutter build apk --release
```

### 4. Install on Device

```bash
# Install debug APK
flutter install

# Or manually install
adb install build/app/outputs/flutter-apk/app-release.apk
```

## Development

### Running in Development

```bash
# Start with hot reload
flutter run

# Run on specific device
flutter run -d <device_id>
```

### Testing

```bash
# Run tests
flutter test

# Analyze code
flutter analyze
```

## Project Structure

```
litewriter/
├── lib/
│   ├── main.dart                 # App entry point
│   ├── models/                   # Data models
│   ├── viewmodels/              # Business logic
│   ├── views/                   # UI screens
│   ├── services/                # Data services
│   └── theme/                   # App theming
├── android/                     # Android-specific files
├── pubspec.yaml                 # Dependencies
└── README.md                    # Documentation
```

## Troubleshooting

### Common Issues

1. **Android SDK not found**
   - Ensure ANDROID_HOME is set correctly
   - Run `flutter doctor` to check setup

2. **Build errors**
   - Run `flutter clean` and `flutter pub get`
   - Regenerate code with build_runner

3. **Hive adapter errors**
   - Run `flutter packages pub run build_runner build --delete-conflicting-outputs`

### Performance Tips

- Use `flutter build apk --release` for production builds
- Enable R8 code shrinking in android/app/build.gradle
- Test on physical devices for accurate performance

## Deployment

### Google Play Store

1. Create signed APK with release keystore
2. Follow Google Play Console guidelines
3. Upload APK and complete store listing

### Direct Distribution

1. Build release APK
2. Enable "Install from unknown sources" on target devices
3. Distribute APK file directly

## Support

For issues or questions:
- Check Flutter documentation: https://flutter.dev/docs
- Review Android development guide: https://developer.android.com/guide

---

**Created by Sleepy 😴**

*A creative sanctuary for novel writers*


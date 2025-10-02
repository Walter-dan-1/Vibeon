# VibeOn - Setup Guide

This repository is a ready-to-run Flutter skeleton for **VibeOn** with core features:
- Firebase Auth (Email & Google Sign-In)
- Firestore (Posts, Likes, Comments, Followers)
- Storage (Video uploads)
- Upload, Feed (FYP), Profile, Comments UI
- Dark/Light mode toggle
- Codemagic config included

## Quick start (local)

1. Install Flutter (stable channel) and Android SDK.
2. Unzip this project and open in Android Studio or VS Code.
3. Run `flutter pub get`.
4. Replace Firebase placeholders:
   - `android/app/google-services.json` (download from Firebase console)
   - `ios/Runner/GoogleService-Info.plist` (if using iOS)
   - `web/firebase-config.js` (if using web)
5. Run on an Android device or emulator:
   ```bash
   flutter clean
   flutter run
   ```

## Firebase setup (Android)

1. Go to https://console.firebase.google.com/ and create a project (e.g. **vibeon-project**).
2. In Project Settings → Your apps → Add Android app.
   - **Android package name**: `com.vibeon.app`
   - **App nickname**: VibeOn (optional)
   - **Debug signing certificate SHA-1**: add your SHA-1 (see below)
3. Download `google-services.json` and place it into `android/app/`.
4. In Firebase Console enable:
   - Authentication → Sign-in method → Email/Password and Google
   - Firestore Database → start in production mode (or test for dev)
   - Storage → set rules as needed (test mode for dev)
   - Cloud Messaging (for push notifications)

### How to get SHA-1 (for Google Sign-In)
- Using Android Studio: **Gradle** panel → :app → Tasks → android → signingReport. Copy the SHA-1.
- OR using keytool (for debug key):
  ```bash
  # on Windows (Git Bash)
  keytool -list -v -alias androiddebugkey -keystore "%USERPROFILE%/.android/debug.keystore" -storepass android -keypass android
  # on macOS/Linux
  keytool -list -v -alias androiddebugkey -keystore ~/.android/debug.keystore -storepass android -keypass android
  ```
- Paste SHA-1 into Firebase app settings and re-download `google-services.json` if needed.

## Codemagic (Android-only quick setup)

1. Connect your GitHub repo to Codemagic.
2. Add this repository and configure workflow (codemagic.yaml present).
3. Ensure `android/app/google-services.json` is added in your repo or provided via Codemagic UI (recommended to add via secure file or environment).
4. For signed Play Store releases, upload keystore and configure code signing in Codemagic.

## Notes & Next steps

- Replace placeholder `google-services.json` with your Firebase file before building.
- The app contains placeholder UI for some screens; customize styling and features as needed.
- If you want, I can add full comment moderation, reporting, and admin dashboard in a later pass.

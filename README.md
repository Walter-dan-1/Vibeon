# VibeOn (Expanded)
This is an expanded, production-style Flutter skeleton for the VibeOn app.
It includes:
- Firebase platform placeholders for Android, iOS, Web, macOS (replace them with your files)
- Auth (Email + Google)
- Firestore models: users, posts, likes, comments, followers
- Upload flow: upload file to Storage and add metadata to Firestore
- Likes and Comments
- Trending feed (basic algorithm: likes desc, then views)
- Profile screens with followers/following counts
- Dark/Light mode toggle

**Important**
- Replace platform Firebase placeholder files with your real config:
  - android/app/google-services.json
  - ios/Runner/GoogleService-Info.plist
  - web/firebase-config.js
  - macos/firebase_app_id_file.json
- Run `flutter pub get` then platform-specific setup for Firebase.
- No dummy data included.

**Quick start**
1. Unzip project
2. Add Firebase config files (see above)
3. Run `flutter pub get`
4. Run on Android/iOS/Emulator


# Medical Store Flutter App (MediQuick Store)

A good-looking and easy-to-use Flutter + Dart medical store app with:
- Search medicines/products
- Category filters
- Product list with ratings and stock labels
- Add-to-cart interaction
- Cart summary and place-order flow

## Project Structure
- `lib/main.dart`: Complete app UI and logic.
- `test/widget_test.dart`: Basic widget smoke test.

## Build APK
After installing Flutter SDK locally, run:

```bash
flutter pub get
flutter test
flutter build apk --release
```

The generated APK will be available at:
`build/app/outputs/flutter-apk/app-release.apk`

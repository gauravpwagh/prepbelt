# Android release: signing and Play Console internal testing

How to build a signed PrepBelt bundle and get it to internal testers. The Play Console steps happen in the owner's Google account; nothing here does them automatically.

## 1. Upload key (done once, on the owner's machine)

- `android/key.properties` points at the upload keystore. It holds passwords, so it stays out of git (`android/.gitignore`).

  ```
  storePassword=…
  keyPassword=…
  keyAlias=upload
  storeFile=C:\\path\\outside\\the\\repo\\upload-keystore.jks
  ```

- **Back up the keystore and its passwords somewhere safe**, such as a password manager. With Play App Signing (step 3), Google can reset a lost upload key, but the reset is slow.
- `android/app/build.gradle.kts` signs release builds with this key. Without `key.properties` it refuses to build a Play bundle (`bundleRelease`), so a debug-signed upload cannot happen by accident. `flutter run --release` still works with the debug key.

## 2. Build

1. Raise the build number in `pubspec.yaml` for every upload. In `version: 0.1.0+1`, the `+1` is the versionCode, and Play rejects a versionCode it has seen before. Keep `lib/core/config/app_info.dart` in step.
2. Run:

   ```
   flutter build appbundle --release
   ```

3. Upload `build/app/outputs/bundle/release/app-release.aab`.

Release builds are shrunk by R8. The reminder's icon (`res/drawable/ic_notification.xml`) is kept by `res/raw/keep.xml`, which was checked in the release APK.

## 3. Play Console

### Create the app and set it up

1. Create a developer account at https://play.google.com/console. It costs USD 25 once, and identity verification can take a few days.
2. **Create app**, with these settings:
   - App name: PrepBelt;
   - default language: English (India) or English (US);
   - App (not game), Free;
   - accept the declarations.
3. **Play App Signing:** keep the default, Google manages the app signing key. Your key is then only the upload key.
4. **App content** (Policy → App content). Answers that match how 1.0 behaves:

   | Item | Answer |
   | --- | --- |
   | Privacy policy | A public URL showing `docs/release/privacy-policy.md`, for example the repo file on GitHub or GitHub Pages. |
   | App access | All functionality is available without special access (there are no accounts). |
   | Ads | No ads. |
   | Content rating | Questionnaire category "Utility, productivity, communication or other". No violence, sexuality, gambling, user interaction or sharing of location. Expect "Everyone" / "3+". |
   | Target audience | 13–15, 16–17 and 18+ (exam students). Leave the under-13 groups unticked unless you mean to follow the Families policy. |
   | News app | No. |
   | Data safety | **No data collected, no data shared.** Everything stays on the device, there is no network access, no analytics, and cloud auto-backup is off (`android:allowBackup="false"`). Exports happen only when the user chooses them. |
   | Government app / financial features / health | No. |

5. **Store listing** (only needed before a public release; internal testing works without a full listing):
   - Short description: "Exam prep, belt by belt: plan, study and review every chapter before exam day."
   - Icon: `assets/brand/icon.png` (1024 px). Play asks for 512 px, so export it from `design/brand/`.

### Internal testing

1. Go to Testing → Internal testing → Create new release.
2. Upload `app-release.aab`. Release name: "0.1.0 (1)". Release notes: "First internal build: sources, survey, reading as you go, reviews, planner, redefine, backup."
3. Under Testers, create an email list (up to 100 Google accounts), then save and roll out.
4. Share the opt-in link Play shows. Testers accept it, then install from the Play Store. The first build can take up to a few hours to become available.

### Before the first rollout, check

- [ ] The versionCode is new.
- [ ] `flutter analyze` and `flutter test` pass.
- [ ] The release APK was tried on a device or the emulator:
  - first launch;
  - adding a source;
  - a session: open, return, rate;
  - a backup export.

## Changes made for release (D45)

- **App name:** the label is "PrepBelt" on Android and iOS (it was "prepbelt" / "Prepbelt").
- **Signing:** release builds use the upload key from `key.properties`, and a Play bundle can't be built without it.
- **compileSdk 37:** `receive_sharing_intent` compiles against it. targetSdk stays Flutter's.
- **Notification icon:** a white silhouette, kept through shrinking.
- **Cloud auto-backup off:** so study data never leaves the phone unasked, matching "Works offline. Nothing leaves your phone unless you export it." PrepBelt's own backup file covers moving to a new phone.

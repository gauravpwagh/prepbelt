# receive_sharing_intent 1.9.0, patched for PrepBelt

A copy of https://pub.dev/packages/receive_sharing_intent 1.9.0 (Apache 2.0;
`LICENSE`), without its example and tests. PrepBelt patches the Android side
only; every change is marked "PrepBelt patch" in the code.

1. `FileDirectory.getAbsolutePath` copies every `content://` URI into the
   cache. Upstream returned the raw storage path for files shared from the
   Files app (`/storage/emulated/0/Download/…`), which apps can't read under
   scoped storage, so the PDF could not be opened.
2. `toJsonObject` catches a failed copy and passes an empty path, so Dart
   shows Add source without a file instead of the app crashing
   (upstream threw a `SecurityException` on the main thread).
3. `build.gradle` applies the Kotlin plugin, which Flutter 3.44 does for
   every plugin. We stay on Flutter 3.41 (D1).

Drop this copy when upstream fixes 1 and 2 and we move to Flutter 3.44.

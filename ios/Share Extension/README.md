# Share Extension (share into PrepBelt)

The files here are ready, but the Xcode target must be created on a Mac,
because the project file can't be edited reliably by hand. Steps, from the
receive_sharing_intent 1.9.0 README:

1. `flutter config --enable-swift-package-manager` (the plugin is SPM only).
2. In Xcode, File › New › Target › Share Extension, named `Share Extension`,
   bundle id `io.github.gauravpwagh.prepbelt.ShareExtension`, iOS 13.0 like
   Runner. When Xcode generates files, keep the ones in this folder: delete
   its storyboard and replace its `ShareViewController.swift` and
   `Info.plist` with these.
3. Share Extension target › General › Frameworks and Libraries › + ›
   `receive-sharing-intent`.
4. Signing & Capabilities › App Groups on **both** Runner and Share
   Extension: `group.io.github.gauravpwagh.prepbelt`. Point
   `CODE_SIGN_ENTITLEMENTS` at `Runner/Runner.entitlements` and
   `Share Extension/Share Extension.entitlements`.
5. Runner › Build Phases: move "Embed Foundation Extensions" above
   "Thin Binary".

`Runner/Info.plist` already has `AppGroupId` and the `ShareMedia-…` URL
scheme, and `Runner/SceneDelegate.swift` already uses the scene lifecycle
the plugin needs.

import 'dart:async';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

import '../files/file_picking.dart';

/// Something another app shared into PrepBelt (docs/05-architecture.md,
/// "Share into the app"). Add source opens pre-filled with it.
sealed class SharedItem {
  const SharedItem();
}

/// A PDF, still in the share cache. Add source copies it into app storage
/// when the student saves.
final class SharedPdf extends SharedItem {
  const SharedPdf(this.file);

  final PickedFile file;
}

/// A web link, with the title that came with it, if any (a browser or
/// YouTube shares "Title https://…").
final class SharedLink extends SharedItem {
  const SharedLink(this.url, {this.title});

  final String url;
  final String? title;
}

/// Anything else: text without a link, or a file that is not a PDF. Add
/// source opens without a type chosen.
final class SharedOther extends SharedItem {
  const SharedOther();
}

final _url = RegExp(r'''https?://[^\s<>"']+''', caseSensitive: false);

/// Reads a link and its title out of shared text. Null when the text has
/// no web link.
SharedLink? linkFromText(String text) {
  final match = _url.firstMatch(text);
  if (match == null) return null;
  final url = match.group(0)!.replaceFirst(RegExp(r'[.,;:!?)\]]+$'), '');
  final rest = text
      .replaceRange(match.start, match.end, ' ')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim()
      .replaceAll(RegExp(r'^[\s\-–—:|·]+|[\s\-–—:|·]+$'), '');
  return SharedLink(url, title: rest.isEmpty ? null : rest);
}

/// Chooses what to add from one share. A share can carry several items
/// (Safari sends the page link and its title); the first PDF wins, then
/// the first link.
SharedItem? sharedItemFrom(List<SharedMediaFile> media) {
  if (media.isEmpty) return null;
  for (final m in media) {
    if (m.type != SharedMediaType.file) continue;
    final isPdf =
        m.mimeType == 'application/pdf' ||
        p.extension(m.path).toLowerCase() == '.pdf';
    final file = File(m.path);
    if (isPdf && file.existsSync()) {
      return SharedPdf(
        PickedFile(
          path: m.path,
          name: p.basename(m.path),
          bytes: file.lengthSync(),
        ),
      );
    }
  }
  for (final m in media) {
    if (m.type != SharedMediaType.text && m.type != SharedMediaType.url) {
      continue;
    }
    final link = linkFromText([m.path, ?m.message].join(' '));
    if (link != null) return link;
  }
  return const SharedOther();
}

/// Where shares arrive. An interface so tests can share without a
/// platform channel.
abstract interface class ShareInbox {
  /// The share that launched the app, if any.
  Future<SharedItem?> initial();

  /// Shares that arrive while the app is running.
  Stream<SharedItem> get incoming;

  /// Marks the latest share as handled, so it is not delivered again.
  Future<void> handled();
}

/// Never receives anything: web, which has no share-in (1.1 gets file
/// upload only), and tests that start the whole app.
final class NoShareInbox implements ShareInbox {
  const NoShareInbox();

  @override
  Future<SharedItem?> initial() async => null;

  @override
  Stream<SharedItem> get incoming => const Stream.empty();

  @override
  Future<void> handled() async {}
}

/// receive_sharing_intent: Android intent filters and the iOS share
/// extension.
final class SystemShareInbox implements ShareInbox {
  const SystemShareInbox();

  static ReceiveSharingIntent get _plugin => ReceiveSharingIntent.instance;

  @override
  Future<SharedItem?> initial() async =>
      sharedItemFrom(await _plugin.getInitialMedia());

  @override
  Stream<SharedItem> get incoming => _plugin
      .getMediaStream()
      .map(sharedItemFrom)
      .where((i) => i != null)
      .cast();

  @override
  Future<void> handled() async {
    await _plugin.reset();
  }
}

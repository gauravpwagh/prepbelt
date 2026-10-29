import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:prepbelt/platform/share_in/share_in.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

void main() {
  test('a link and its title come out of shared text', () {
    SharedLink? l(String text) => linkFromText(text);
    expect(
      (l('https://youtu.be/abc123')?.url, l('https://youtu.be/abc123')?.title),
      ('https://youtu.be/abc123', null),
    );
    final yt = l('Rotational motion | One shot - https://youtu.be/x9?si=q');
    expect(
      (yt?.url, yt?.title),
      ('https://youtu.be/x9?si=q', 'Rotational motion | One shot'),
    );
    final article = l('Read this: https://example.org/kinematics.');
    expect(
      (article?.url, article?.title),
      ('https://example.org/kinematics', 'Read this'),
    );
    expect(l('Chapter 3 notes for tomorrow'), isNull);
  });

  test('the first PDF wins, then the first link, else other', () {
    final dir = Directory.systemTemp.createTempSync('share_in');
    addTearDown(() => dir.deleteSync(recursive: true));
    final pdf = File('${dir.path}/HC Verma.pdf')..writeAsStringSync('%PDF');

    SharedMediaFile m(String path, SharedMediaType type, [String? mime]) =>
        SharedMediaFile(path: path, type: type, mimeType: mime);

    final file = sharedItemFrom([
      m('https://example.org', SharedMediaType.url),
      m(pdf.path, SharedMediaType.file, 'application/pdf'),
    ]);
    final shared = (file! as SharedPdf).file;
    expect((shared.name, shared.bytes), ('HC Verma.pdf', 4));

    final link = sharedItemFrom([
      m('Kinematics https://example.org/k', SharedMediaType.text),
    ]);
    expect((link! as SharedLink).url, 'https://example.org/k');

    expect(
      sharedItemFrom([m('${dir.path}/photo.jpg', SharedMediaType.image)]),
      isA<SharedOther>(),
    );
    expect(sharedItemFrom([]), isNull);
  });
}

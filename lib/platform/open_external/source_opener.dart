import 'dart:io';

import 'package:open_filex/open_filex.dart';
import 'package:url_launcher/url_launcher.dart';

/// Opens a source in its own app (docs/05-architecture.md, "Open
/// externally"). Neither plugin can open a PDF at a page (D31).
abstract interface class SourceOpener {
  /// Opens [file] if given, else [uri]. Returns false when nothing could
  /// open it.
  Future<bool> open({File? file, String? uri});
}

final class SystemSourceOpener implements SourceOpener {
  const SystemSourceOpener();

  @override
  Future<bool> open({File? file, String? uri}) async {
    if (file != null) {
      final result = await OpenFilex.open(file.path);
      return result.type == ResultType.done;
    }
    final parsed = uri == null ? null : Uri.tryParse(uri);
    if (parsed == null || !parsed.hasScheme) return false;
    return launchUrl(parsed, mode: LaunchMode.externalApplication);
  }
}

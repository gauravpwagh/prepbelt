// Enforces the architecture rules in CLAUDE.md that a linter cannot:
//
// 1. lib/engines/ imports only Dart, pure packages, other engine files,
//    core/time and core/config. Never Flutter or Drift (decision D5).
// 2. Only lib/engines/review/ imports the fsrs package.
// 3. Screens (features/*/ui) never import the database or repositories.
// 4. DateTime.now() appears only in lib/core/time/.
//
// Run: dart run tool/check_imports.dart   (exit code 1 on violations)
import 'dart:io';

/// Packages an engine may import.
const _enginePackages = {
  'fsrs',
  'meta',
  'collection',
  'freezed_annotation',
  'json_annotation',
};

final _import = RegExp(
  r'''^\s*(?:import|export)\s+['"]([^'"]+)['"]''',
  multiLine: true,
);
final _now = RegExp(r'DateTime\.now\(\)');

/// Returns one message per violation under [libDir].
List<String> checkImports(Directory libDir) {
  final root = libDir.absolute.path.replaceAll(r'\', '/');
  final violations = <String>[];
  final files = libDir
      .listSync(recursive: true)
      .whereType<File>()
      .where((f) => f.path.endsWith('.dart'));

  for (final file in files) {
    final path = file.absolute.path.replaceAll(r'\', '/');
    final rel = path.substring(root.length + 1);
    final source = file.readAsStringSync();
    final dir = rel.contains('/') ? rel.substring(0, rel.lastIndexOf('/')) : '';

    for (final m in _import.allMatches(source)) {
      final uri = m[1]!;
      final target = _resolve(uri, dir);

      if (rel.startsWith('engines/')) {
        final ok = uri.startsWith('dart:')
            ? !uri.startsWith('dart:ui')
            : target != null
            ? target.startsWith('engines/') ||
                  target.startsWith('core/time/') ||
                  target.startsWith('core/config/')
            : _enginePackages.contains(_package(uri));
        if (!ok) violations.add('$rel: engines may not import $uri');
      }

      if (_package(uri) == 'fsrs' && !rel.startsWith('engines/review/')) {
        violations.add('$rel: only lib/engines/review may import fsrs');
      }

      if (RegExp(r'^features/[^/]+/ui/').hasMatch(rel) &&
          target != null &&
          (target.startsWith('core/db/') ||
              RegExp(r'^features/[^/]+/data/').hasMatch(target))) {
        violations.add(
          '$rel: screens read and write through providers, not $uri',
        );
      }
    }

    if (!rel.startsWith('core/time/') && _now.hasMatch(source)) {
      violations.add('$rel: use the injected Clock, not DateTime.now()');
    }
  }
  return violations..sort();
}

/// The lib-relative path of an import inside this package, else null.
String? _resolve(String uri, String fromDir) {
  if (uri.startsWith('package:prepbelt/')) {
    return uri.substring('package:prepbelt/'.length);
  }
  if (uri.contains(':')) return null;
  final parts = [if (fromDir.isNotEmpty) ...fromDir.split('/')];
  for (final seg in uri.split('/')) {
    if (seg == '..') {
      if (parts.isNotEmpty) parts.removeLast();
    } else if (seg != '.') {
      parts.add(seg);
    }
  }
  return parts.join('/');
}

String? _package(String uri) =>
    uri.startsWith('package:') ? uri.substring(8).split('/').first : null;

void main() {
  final violations = checkImports(Directory('lib'));
  for (final v in violations) {
    stderr.writeln(v);
  }
  if (violations.isNotEmpty) {
    stderr.writeln('${violations.length} import rule violation(s).');
    exitCode = 1;
  } else {
    stdout.writeln('Import rules: OK');
  }
}

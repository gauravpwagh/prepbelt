import 'package:drift/drift.dart' show Value;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/db/app_database.dart';
import '../../../core/providers/core_providers.dart';
import '../../../platform/files/file_picking.dart';
import '../../../platform/files/file_store.dart';
import '../../../platform/pdf_outline/pdf_outline.dart';
import '../../../platform/share_in/share_in.dart';
import '../data/source_repository.dart';

export '../data/source_repository.dart' show SourceSummary;

part 'source_providers.g.dart';

@Riverpod(keepAlive: true)
SourceRepository sourceRepository(Ref ref) =>
    SourceRepository(ref.watch(writeContextProvider));

@riverpod
Stream<List<Source>> sources(Ref ref) =>
    ref.watch(sourceRepositoryProvider).watchAll();

@riverpod
Stream<Source?> source(Ref ref, String id) =>
    ref.watch(sourceRepositoryProvider).watch(id);

/// Sources with survey progress, in Sources-list order.
@riverpod
Stream<List<SourceSummary>> sourceSummaries(Ref ref) =>
    ref.watch(sourceRepositoryProvider).watchSummaries();

/// Where imported files are copied. Tests override it with a temp folder.
@Riverpod(keepAlive: true)
Future<FileStore> fileStore(Ref ref) async => FileStore(
  root: await getApplicationDocumentsDirectory(),
  ids: ref.watch(writeContextProvider).ids,
);

@Riverpod(keepAlive: true)
PdfPicker pdfPicker(Ref ref) => const SystemPdfPicker();

@Riverpod(keepAlive: true)
PdfOutlineReader pdfOutlineReader(Ref ref) => const PdfOutlineReader();

/// PDFs and links shared from other apps. Tests override it.
@Riverpod(keepAlive: true)
ShareInbox shareInbox(Ref ref) =>
    kIsWeb ? const NoShareInbox() : const SystemShareInbox();

/// Rename, remove and undo from the Sources list.
@riverpod
class SourceActions extends _$SourceActions {
  @override
  void build() {}

  Future<void> rename(String id, String title) => ref
      .read(sourceRepositoryProvider)
      .update(id, title: Value(title.trim()))
      .then((_) {});

  Future<void> remove(String id) =>
      ref.read(sourceRepositoryProvider).softDelete(id);

  Future<void> undo(String id) => ref.read(sourceRepositoryProvider).undo(id);
}

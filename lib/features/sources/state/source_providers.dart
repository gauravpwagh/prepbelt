import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/db/app_database.dart';
import '../../../core/providers/core_providers.dart';
import '../data/source_repository.dart';

part 'source_providers.g.dart';

@Riverpod(keepAlive: true)
SourceRepository sourceRepository(Ref ref) =>
    SourceRepository(ref.watch(writeContextProvider));

@riverpod
Stream<List<Source>> sources(Ref ref) =>
    ref.watch(sourceRepositoryProvider).watchAll();

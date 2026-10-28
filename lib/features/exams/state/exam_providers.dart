import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/db/app_database.dart';
import '../../../core/providers/core_providers.dart';
import '../data/exam_repository.dart';

part 'exam_providers.g.dart';

@Riverpod(keepAlive: true)
ExamRepository examRepository(Ref ref) =>
    ExamRepository(ref.watch(writeContextProvider));

/// The one upcoming exam of 1.0.
@riverpod
Stream<Exam?> currentExam(Ref ref) =>
    ref.watch(examRepositoryProvider).watchCurrent();

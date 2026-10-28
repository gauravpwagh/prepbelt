/// Errors that domain code can raise on purpose. UI maps them to messages.
sealed class AppError implements Exception {
  const AppError(this.message);

  final String message;

  @override
  String toString() => '$runtimeType: $message';
}

/// The row to act on does not exist or is soft-deleted.
final class NotFoundError extends AppError {
  const NotFoundError(super.message);
}

/// The operation is valid in general but not for this row's state.
final class InvalidOperationError extends AppError {
  const InvalidOperationError(super.message);
}

/// There is nothing to undo for this entity.
final class NothingToUndoError extends AppError {
  const NothingToUndoError(super.message);
}

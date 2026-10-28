import 'package:file_picker/file_picker.dart';

/// A file the student picked, still at its original location.
final class PickedFile {
  const PickedFile({
    required this.path,
    required this.name,
    required this.bytes,
  });

  final String path;
  final String name;
  final int bytes;
}

/// Lets the student choose a PDF from the device. An interface so widget
/// tests can supply a file without the platform picker.
abstract interface class PdfPicker {
  /// Null when the student cancels.
  Future<PickedFile?> pickPdf();
}

/// The platform picker (file_picker).
final class SystemPdfPicker implements PdfPicker {
  const SystemPdfPicker();

  @override
  Future<PickedFile?> pickPdf() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: const ['pdf'],
    );
    final file = result?.files.singleOrNull;
    final path = file?.path;
    if (file == null || path == null) return null;
    return PickedFile(path: path, name: file.name, bytes: file.size);
  }
}

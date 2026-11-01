import 'study_folder.dart';

/// A file the student picked, or one shared into the app.
final class PickedFile {
  const PickedFile({
    required this.path,
    required this.name,
    required this.bytes,
    this.inFolder,
  });

  /// A readable copy on this device.
  final String path;
  final String name;
  final int bytes;

  /// Its path inside the study folder when picked from there (D51): it is
  /// used in place, not copied.
  final String? inFolder;
}

/// Lets the student choose a PDF, starting in the study folder. An
/// interface so widget tests can supply a file without the platform picker.
abstract interface class PdfPicker {
  /// Null when the student cancels.
  Future<PickedFile?> pickPdf(String folder);
}

/// The study folder's picker.
final class FolderPdfPicker implements PdfPicker {
  const FolderPdfPicker(this.files);

  final Future<StudyFolder> Function() files;

  @override
  Future<PickedFile?> pickPdf(String folder) async {
    final pick = await (await files()).pickPdf(folder);
    if (pick == null) return null;
    return PickedFile(
      path: pick.localCopy,
      name: pick.name,
      bytes: pick.bytes,
      inFolder: pick.inFolder,
    );
  }
}

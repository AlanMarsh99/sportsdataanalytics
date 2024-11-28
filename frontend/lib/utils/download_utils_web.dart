import 'dart:typed_data';
import 'dart:html' as html;

/// Downloads a file on Web platforms.
/// 
/// - [filename]: Name of the file to be downloaded.
/// - [bytes]: Byte data of the file.
/// - [mimeType]: MIME type of the file (e.g., 'application/pdf').
Future<void> downloadFile(String filename, Uint8List bytes, String mimeType) async {
  try {
    final blob = html.Blob([bytes], mimeType);
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.document.createElement('a') as html.AnchorElement
      ..href = url
      ..download = filename
      ..style.display = 'none';
    
    html.document.body!.children.add(anchor);
    anchor.click();
    html.document.body!.children.remove(anchor);
    html.Url.revokeObjectUrl(url);
  } catch (e) {
    throw Exception('Failed to download file: $e');
  }
}

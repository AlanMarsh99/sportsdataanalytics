import 'dart:typed_data';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

/// Downloads a file on Mobile and Desktop platforms.
/// 
/// - [filename]: Name of the file to be downloaded.
/// - [bytes]: Byte data of the file.
/// - [mimeType]: MIME type of the file (e.g., 'application/pdf').
Future<void> downloadFile(String filename, Uint8List bytes, String mimeType) async {
  try {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/$filename';
    final file = File(filePath);
    await file.writeAsBytes(bytes);

    // Share the file using share_plus
    await Share.shareFiles([filePath], text: 'Here is your $filename');
  } catch (e) {
    throw Exception('Failed to download file: $e');
  }
}

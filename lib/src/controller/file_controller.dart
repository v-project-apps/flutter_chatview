import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import "package:universal_html/html.dart" as html;

class FileController {
  static final Dio _dio = Dio();

  static Future<void> downloadAndOpenFile(String url, String fileName) async {
    try {
      // Get the temporary directory
      final tempDir = await getTemporaryDirectory();
      final filePath = '${tempDir.path}/$fileName';

      // Download the file
      await _dio.download(url, filePath);

      // Open the file
      await OpenFilex.open(filePath);
    } catch (e) {
      debugPrint('Error downloading or opening file: $e');
    }
  }

  static void openFileForWeb(String url) {
    html.AnchorElement(href: url)
      ..setAttribute('download', '')
      ..click();
  }

  static Future<String> getLocalFilePath(String fileName) async {
    final tempDir = await getTemporaryDirectory();
    return '${tempDir.path}/$fileName';
  }

  static Future<bool> isFileDownloaded(String filePath) async {
    return File(filePath).existsSync();
  }

  static Future<String> downloadFile(String url, String fileName) async {
    final filePath = await getLocalFilePath(fileName);
    await _dio.download(url, filePath);
    return filePath;
  }
}

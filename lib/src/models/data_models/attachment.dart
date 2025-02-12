import 'dart:io';

import 'package:flutter/foundation.dart';

class Attachment {
  /// Provides name of attachment.
  final String name;

  /// Provides url of attachment.
  final String url;

  /// Provides size of attachment.
  final double size;

  final File? file;

  final Uint8List? fileBytes;

  String get sizeString {
    if (size < 1024) {
      return "${size.toStringAsFixed(2)} B";
    } else if (size < 1024 * 1024) {
      return "${(size / 1024).toStringAsFixed(2)} KB";
    } else if (size < 1024 * 1024 * 1024) {
      return "${(size / (1024 * 1024)).toStringAsFixed(2)} MB";
    } else {
      return "${(size / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB";
    }
  }

  Attachment.fromFile(File mFile)
      : name = mFile.path.split('/').last,
        url = mFile.path,
        size = mFile.lengthSync().toDouble(),
        file = mFile,
        fileBytes = mFile.readAsBytesSync();

  Attachment({
    required this.name,
    required this.url,
    required this.size,
    this.file,
    this.fileBytes,
  });

  factory Attachment.fromJson(Map<String, dynamic> json) {
    return Attachment(
      name: json['name'],
      url: json['url'],
      size: json['size'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'url': url,
      'size': size,
    };
  }

  Attachment copyWith(
      {String? name,
      String? url,
      double? size,
      File? file,
      Uint8List? fileBytes}) {
    return Attachment(
      name: name ?? this.name,
      url: url ?? this.url,
      size: size ?? this.size,
      file: file ?? this.file,
      fileBytes: fileBytes ?? this.fileBytes,
    );
  }
}

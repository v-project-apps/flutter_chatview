/*
 * Copyright (c) 2022 Simform Solutions
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

import 'dart:io';

import 'package:chatview/src/models/config_models/file_message_configuration.dart';
import 'package:chatview/src/models/models.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'reaction_widget.dart';
import 'share_icon.dart';

class FileMessageView extends StatelessWidget {
  const FileMessageView({
    Key? key,
    required this.message,
    required this.isMessageBySender,
    this.fileMessageConfiguration,
    this.messageReactionConfig,
  }) : super(key: key);

  /// Provides message instance of chat.
  final Message message;

  /// Represents current message is sent by current user.
  final bool isMessageBySender;

  /// Provides configuration for image message appearance.
  final FileMessageConfiguration? fileMessageConfiguration;

  /// Provides configuration of reaction appearance in chat bubble.
  final MessageReactionConfiguration? messageReactionConfig;

  String get fileUrl => message.message;

  Widget get iconButton => ShareIcon(
        shareIconConfig: fileMessageConfiguration?.shareIconConfig,
        imageUrl: fileUrl,
      );

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment:
          isMessageBySender ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        if (isMessageBySender &&
            !(fileMessageConfiguration?.hideShareIcon ?? false))
          iconButton,
        Stack(
          children: [
            GestureDetector(
              onTap: () {
                fileMessageConfiguration?.onTap != null
                    ? fileMessageConfiguration?.onTap!(message)
                    : _downloadAndOpenFile(fileUrl);
              },
              child: _getFileIcon(),
            ),
            if (message.reaction.reactions.isNotEmpty)
              ReactionWidget(
                isMessageBySender: isMessageBySender,
                reaction: message.reaction,
                messageReactionConfig: messageReactionConfig,
              ),
          ],
        ),
        if (!isMessageBySender &&
            !(fileMessageConfiguration?.hideShareIcon ?? false))
          iconButton,
      ],
    );
  }

  Future<void> _downloadAndOpenFile(String url) async {
    try {
      // Get the temporary directory
      final tempDir = await getTemporaryDirectory();
      final filePath = '${tempDir.path}/${url.split('/').last}';

      // Download the file
      final Dio dio = Dio();
      await dio.download(url, filePath);

      // Open the file
      await OpenFilex.open(filePath);
    } catch (e) {
      debugPrint('Error downloading or opening file: $e');
    }
  }

  Widget _getFileIcon() {
    const fileIcons = {
      '.pdf': Icons.picture_as_pdf,
      '.doc': Icons.description,
      '.docx': Icons.description,
      '.xls': Icons.table_chart,
      '.xlsx': Icons.table_chart,
      '.ppt': Icons.slideshow,
      '.pptx': Icons.slideshow,
      '.zip': Icons.archive,
      '.rar': Icons.archive,
      '.txt': Icons.text_fields,
    };

    for (var entry in fileIcons.entries) {
      if (message.message.contains(entry.key)) {
        return Icon(entry.value,
            size: fileMessageConfiguration?.iconSize,
            color: fileMessageConfiguration?.iconColor);
      }
    }

    return Icon(Icons.insert_drive_file,
        size: fileMessageConfiguration?.iconSize,
        color: fileMessageConfiguration?.iconColor);
  }
}

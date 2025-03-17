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

import 'package:chatview/src/controller/file_controller.dart';
import 'package:chatview/src/models/config_models/file_message_configuration.dart';
import 'package:chatview/src/models/models.dart';
import 'package:chatview/src/widgets/chat_view_inherited_widget.dart';
import 'package:chatview/src/widgets/horizontal_user_avatars.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'reaction_widget.dart';
import 'share_icon.dart';

class FileMessageView extends StatefulWidget {
  const FileMessageView({
    Key? key,
    required this.message,
    required this.isMessageBySender,
    this.fileMessageConfiguration,
    this.messageReactionConfig,
    this.highlightFile = false,
    this.highlightScale = 1.2,
    this.highlightColor,
  }) : super(key: key);

  /// Provides message instance of chat.
  final Message message;

  /// Represents current message is sent by current user.
  final bool isMessageBySender;

  /// Provides configuration for image message appearance.
  final FileMessageConfiguration? fileMessageConfiguration;

  /// Provides configuration of reaction appearance in chat bubble.
  final MessageReactionConfiguration? messageReactionConfig;

  /// Represents flag of highlighting file when user taps on replied file.
  final bool highlightFile;

  /// Provides scale of highlighted file when user taps on replied file.
  final double highlightScale;

  /// Allow user to set color of highlighted message.
  final Color? highlightColor;

  String get fileUrl => message.attachment?.url ?? "";

  Widget get iconButton => ShareIcon(
        shareIconConfig: fileMessageConfiguration?.shareIconConfig,
        imageUrl: fileUrl,
      );

  @override
  State<FileMessageView> createState() => _FileMessageViewState();
}

class _FileMessageViewState extends State<FileMessageView> {
  bool isDownloading = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: widget.fileMessageConfiguration?.padding ??
              const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
          margin: widget.fileMessageConfiguration?.margin ??
              EdgeInsets.fromLTRB(
                  5,
                  0,
                  6,
                  widget.message.reactions.isNotEmpty ||
                          (widget.message.seenBy?.isNotEmpty ?? false)
                      ? 15
                      : 2),
          decoration: BoxDecoration(
            color: widget.highlightFile
                ? widget.highlightColor
                : widget.fileMessageConfiguration?.messageColor,
            borderRadius: widget.fileMessageConfiguration?.borderRadius,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: widget.isMessageBySender
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            children: [
              if (widget.isMessageBySender &&
                  !(widget.fileMessageConfiguration?.hideShareIcon ?? false))
                widget.iconButton,
              Flexible(
                child: GestureDetector(
                  onTap: _downloadAndOpenFile,
                  child: Transform.scale(
                    scale: widget.highlightFile ? widget.highlightScale : 1.0,
                    alignment: widget.isMessageBySender
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        isDownloading
                            ? SizedBox(
                                width: widget
                                    .fileMessageConfiguration?.loadingSize,
                                height: widget
                                    .fileMessageConfiguration?.loadingSize,
                                child: const CircularProgressIndicator(),
                              )
                            : _getFileIcon(),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.message.attachment?.name ??
                                    widget.message.message,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                widget.message.attachment?.sizeString ?? "",
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (widget.message.seenBy?.isNotEmpty ?? false)
          Positioned(
            bottom: 0,
            right: widget.isMessageBySender ? 0 : null,
            left: widget.isMessageBySender ? null : 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 1.7, horizontal: 6),
              child: HorizontalUserAvatars(
                users: ChatViewInheritedWidget.of(context)
                        ?.chatController
                        .getUsersByIds(widget.message.seenBy!) ??
                    [],
                circleRadius: 8,
              ),
            ),
          ),
        if (widget.message.reactions.isNotEmpty)
          ReactionWidget(
            key: widget.key,
            isMessageBySender: widget.isMessageBySender,
            reactions: widget.message.reactions,
            messageReactionConfig: widget.messageReactionConfig,
          ),
      ],
    );
  }

  void _downloadAndOpenFile() async {
    if (kIsWeb) {
      FileController.openFileForWeb(widget.message.attachment?.url ?? "");
      return;
    }
    setState(() {
      isDownloading = true;
    });

    String filePath = await FileController.getLocalFilePath(
      widget.message.attachment?.name ?? '',
    );

    if (await FileController.isFileDownloaded(filePath)) {
      await OpenFilex.open(filePath);
    } else {
      await FileController.downloadAndOpenFile(
        widget.fileUrl,
        widget.message.attachment?.name ?? "",
      );
    }

    setState(() {
      isDownloading = false;
    });
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
      if (widget.message.message.contains(entry.key)) {
        return Icon(entry.value,
            size: widget.fileMessageConfiguration?.iconSize,
            color: widget.fileMessageConfiguration?.iconColor);
      }
    }

    return Icon(Icons.insert_drive_file,
        size: widget.fileMessageConfiguration?.iconSize,
        color: widget.fileMessageConfiguration?.iconColor);
  }
}

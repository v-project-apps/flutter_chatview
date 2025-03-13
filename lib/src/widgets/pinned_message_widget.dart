import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:chatview/chatview.dart';

class PinnedMessageWidget extends StatelessWidget {
  final Message message;
  final VoidCallback onTap;
  final PinnedMessageConfiguration pinnedMessageConfiguration;
  final VoidCallback onRemove;

  const PinnedMessageWidget({
    Key? key,
    required this.message,
    required this.onTap,
    required this.pinnedMessageConfiguration,
    required this.onRemove,
  }) : super(key: key);

  String get messageText {
    switch (message.messageType) {
      case MessageType.text:
        return message.message;
      case MessageType.imageFromUrl:
      case MessageType.image:
        return 'Image';
      case MessageType.voice:
        return 'Voice message';
      case MessageType.videoFromUrl:
      case MessageType.video:
        return 'Video';
      case MessageType.file:
        return 'File';
      default:
        return 'Message';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: pinnedMessageConfiguration.backgroundColor,
          borderRadius: pinnedMessageConfiguration.borderRadius,
          boxShadow: pinnedMessageConfiguration.boxShadow,
        ),
        padding: pinnedMessageConfiguration.padding,
        margin: pinnedMessageConfiguration.margin,
        child: Row(
          children: [
            Icon(Icons.push_pin_outlined,
                color: pinnedMessageConfiguration.iconColor),
            const SizedBox(width: 8.0),
            if (message.messageType.isImage) ...[
              CachedNetworkImage(
                imageUrl: message.attachment?.url ?? message.message,
                width: 42,
                height: 42,
                fit: BoxFit.cover,
                placeholder: (context, url) =>
                    const CircularProgressIndicator(),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
              const SizedBox(width: 8.0)
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Pinned Message",
                    style: pinnedMessageConfiguration.titleTextStyle,
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    messageText,
                    style: pinnedMessageConfiguration.messageTextStyle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(Icons.close,
                  color: pinnedMessageConfiguration.iconColor),
              onPressed: onRemove,
            ),
          ],
        ),
      ),
    );
  }
}

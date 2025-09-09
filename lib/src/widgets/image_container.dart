import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatview/src/extensions/extensions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ImageContainer extends StatelessWidget {
  const ImageContainer(
      {super.key,
      required this.imageUrl,
      this.height = 720,
      this.fileBytes,
      this.fit = BoxFit.fitHeight});

  final String imageUrl;
  final Uint8List? fileBytes;
  final int height;
  final BoxFit? fit;

  @override
  Widget build(BuildContext context) {
    if (imageUrl.isUrl) {
      // Handle GIFs differently on web
      if (kIsWeb && imageUrl.toLowerCase().endsWith('.gif')) {
        return Image.network(
          imageUrl,
          fit: fit,
          filterQuality: FilterQuality.medium,
        );
      }

      return CachedNetworkImage(
        imageUrl: imageUrl,
        fit: fit,
        imageBuilder: (context, imageProvider) => Image(
          image: ResizeImage(imageProvider, height: height),
          fit: fit,
        ),
        progressIndicatorBuilder: (context, child, downloadProgress) {
          return Center(
            child: CircularProgressIndicator(
              value: downloadProgress.progress,
            ),
          );
        },
      );
    } else if (fileBytes != null) {
      return Image.memory(
        fileBytes!,
        height: height.toDouble(),
        fit: fit,
        filterQuality: FilterQuality.medium,
      );
    } else {
      return Image.file(
        File(imageUrl),
        height: height.toDouble(),
        fit: fit,
        filterQuality: FilterQuality.medium,
      );
    }
  }
}

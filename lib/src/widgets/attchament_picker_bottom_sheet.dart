import 'package:chatview/chatview.dart';
import 'package:chatview/src/values/attachment_source.dart';
import 'package:flutter/material.dart';

class AttchamentPickerBottomSheet {
  Future<void> show(
      {required BuildContext context,
      required AttachmentPickerBottomSheetConfiguration?
          attchamentPickerBottomSheetConfig,
      required AttachmentSourceCallback attachmentSourceCallback}) {
    return showModalBottomSheet<void>(
      context: context,
      useSafeArea: true,
      builder: (BuildContext context) {
        return Container(
          color: attchamentPickerBottomSheetConfig?.backgroundColor,
          child: SafeArea(
            child: ListView(
              shrinkWrap: true,
              padding: attchamentPickerBottomSheetConfig?.bottomSheetPadding ??
                  const EdgeInsets.only(right: 12, left: 12, top: 18),
              children: [
                if (attchamentPickerBottomSheetConfig
                        ?.enableCameraImagePicker ??
                    true)
                  ListTile(
                    leading: const Icon(Icons.camera_alt),
                    title: const Text('Camera'),
                    onTap: () {
                      attachmentSourceCallback(AttachmentSource.camera);
                      Navigator.pop(context);
                    },
                  ),
                if (attchamentPickerBottomSheetConfig
                        ?.enableGalleryImagePicker ??
                    true)
                  ListTile(
                    leading: const Icon(Icons.image),
                    title: const Text('Gallery'),
                    onTap: () {
                      attachmentSourceCallback(AttachmentSource.gallery);
                      Navigator.pop(context);
                    },
                  ),
                if (attchamentPickerBottomSheetConfig
                        ?.enableImageFromUrlPicker ??
                    true)
                  ListTile(
                    leading: const Icon(Icons.add_link),
                    title: const Text('Image from URL'),
                    onTap: () {
                      Navigator.pop(context);
                      attachmentSourceCallback(AttachmentSource.imageFromUrl);
                    },
                  ),
                if (attchamentPickerBottomSheetConfig
                        ?.enableGalleryVideoPicker ??
                    true)
                  ListTile(
                    leading: const Icon(Icons.video_file),
                    title: const Text('Gallery Video'),
                    onTap: () {
                      attachmentSourceCallback(AttachmentSource.video);
                      Navigator.pop(context);
                    },
                  ),
                if (attchamentPickerBottomSheetConfig
                        ?.enableVideoFromUrlPicker ??
                    true)
                  ListTile(
                    leading: const Icon(Icons.missed_video_call),
                    title: const Text('Video from URL'),
                    onTap: () {
                      Navigator.pop(context);
                      attachmentSourceCallback(AttachmentSource.videoFromUrl);
                    },
                  ),
                if (attchamentPickerBottomSheetConfig?.enableFilePicker ?? true)
                  ListTile(
                    leading: const Icon(Icons.insert_drive_file_rounded),
                    title: const Text('File'),
                    onTap: () {
                      attachmentSourceCallback(AttachmentSource.file);
                      Navigator.pop(context);
                    },
                  ),
                if (attchamentPickerBottomSheetConfig
                        ?.enableAudioFromFilePicker ??
                    true)
                  ListTile(
                    leading: const Icon(Icons.audio_file),
                    title: const Text('Audio from file'),
                    onTap: () {
                      Navigator.pop(context);
                      attachmentSourceCallback(AttachmentSource.imageFromUrl);
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

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
                      Navigator.pop(context);
                      attachmentSourceCallback(AttachmentSource.camera);
                    },
                  ),
                if (attchamentPickerBottomSheetConfig
                        ?.enableGalleryImagePicker ??
                    true)
                  ListTile(
                    leading: const Icon(Icons.image),
                    title: const Text('Gallery'),
                    onTap: () {
                      Navigator.pop(context);
                      attachmentSourceCallback(AttachmentSource.gallery);
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
                      Navigator.pop(context);
                      attachmentSourceCallback(AttachmentSource.video);
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
                      Navigator.pop(context);
                      attachmentSourceCallback(AttachmentSource.file);
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
                      attachmentSourceCallback(AttachmentSource.audioFromFile);
                    },
                  ),
                if (attchamentPickerBottomSheetConfig
                        ?.enableAudioFromUrlPicker ??
                    true)
                  ListTile(
                    leading: const Icon(Icons.add_link),
                    title: const Text('Audio from URL'),
                    onTap: () {
                      Navigator.pop(context);
                      attachmentSourceCallback(AttachmentSource.audioFromUrl);
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

import 'package:flutter/material.dart';

class AttachmentPickerBottomSheetConfiguration {
  const AttachmentPickerBottomSheetConfiguration({
    this.bottomSheetPadding,
    this.backgroundColor,
    this.attachmentWidgetPadding,
    this.attachmentWidgetMargin,
    this.attachmentWidgetDecoration,
    this.enableGalleryImagePicker = true,
    this.enableCameraImagePicker = true,
    this.enableFilePicker = true,
    this.enableGalleryVideoPicker = true,
    this.enableVideoFromUrlPicker = true,
    this.enableImageFromUrlPicker = true,
    this.enableAudioFromFilePicker = true,
    this.enableAudioFromUrlPicker = true,
    this.enablePollCreation = true,
    this.enableQuizCreation = true,
    this.enableQuestionCreation = true,
  });

  /// Used for giving padding of bottom sheet.
  final EdgeInsetsGeometry? bottomSheetPadding;

  /// Used for giving padding of reaction widget in bottom sheet.
  final EdgeInsetsGeometry? attachmentWidgetPadding;

  /// Used for giving margin of bottom sheet.
  final EdgeInsetsGeometry? attachmentWidgetMargin;

  final BoxDecoration? attachmentWidgetDecoration;

  /// Enable/disable image picker from gallery. Enabled by default.
  final bool enableGalleryImagePicker;

  /// Enable/disable send image from camera. Enabled by default.
  final bool enableCameraImagePicker;

  /// Enable/disable send file. Enabled by default.
  final bool enableFilePicker;

  /// Enable/disable send video from gallery. Enabled by default.
  final bool enableGalleryVideoPicker;

  /// Enable/disable send video from URL. Enabled by default.
  final bool enableVideoFromUrlPicker;

  /// Enable/disable send image from URL. Enabled by default.
  final bool enableImageFromUrlPicker;

  /// Enable/disable send audio from file. Enabled by default.
  final bool enableAudioFromFilePicker;

  /// Enable/disable send audio from URL. Enabled by default.
  final bool enableAudioFromUrlPicker;

  /// Enable/disable send poll. Enabled by default.
  final bool enablePollCreation;

  /// Enable/disable send quiz. Enabled by default.
  final bool enableQuizCreation;

  /// Enable/disable send question. Enabled by default.
  final bool enableQuestionCreation;

  /// Used for giving background color of bottom sheet.
  final Color? backgroundColor;
}

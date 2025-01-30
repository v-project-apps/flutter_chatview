import 'package:flutter/material.dart';

class AttchamentPickerBottomSheetConfiguration {
  const AttchamentPickerBottomSheetConfiguration({
    this.bottomSheetPadding,
    this.backgroundColor,
    this.attachmentWidgetPadding,
    this.attachmentWidgetMargin,
    this.attachmentWidgetDecoration,
    this.enableGalleryImagePicker = true,
    this.enableCameraImagePicker = true,
    this.enableFilePicker = true,
    this.enableGalleryVideoPicker = true,
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

  /// Used for giving background color of bottom sheet.
  final Color? backgroundColor;
}

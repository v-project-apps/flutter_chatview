import 'package:chatview/chatview.dart';
import 'package:flutter/material.dart';
import 'mention_configuration.dart';

/// Configuration for sending messages in chat
class SendMessageConfiguration {
  const SendMessageConfiguration({
    this.textFieldConfig,
    this.voiceRecordingConfiguration,
    this.imagePickerIconsConfig,
    this.videoPickerConfiguration,
    this.filePickerConfiguration,
    this.cancelRecordConfiguration,
    this.attachmentPickerBottomSheetConfig,
    this.textFieldBackgroundColor,
    this.defaultSendButtonColor,
    this.sendButtonIcon,
    this.enableGalleryImagePicker,
    this.allowRecordingVoice,
    this.mentionConfiguration,
  });

  /// Configuration for text field
  final TextFieldConfiguration? textFieldConfig;

  /// Configuration for voice recording
  final VoiceRecordingConfiguration? voiceRecordingConfiguration;

  /// Configuration for image picker icons
  final ImagePickerIconsConfiguration? imagePickerIconsConfig;

  /// Configuration for video picker
  final VideoPickerConfiguration? videoPickerConfiguration;

  /// Configuration for file picker
  final FilePickerConfiguration? filePickerConfiguration;

  /// Configuration for cancel record
  final CancelRecordConfiguration? cancelRecordConfiguration;

  /// Configuration for attachment picker bottom sheet
  final AttachmentPickerBottomSheetConfiguration?
      attachmentPickerBottomSheetConfig;

  /// Background color of text field
  final Color? textFieldBackgroundColor;

  /// Default color of send button
  final Color? defaultSendButtonColor;

  /// Icon for send button
  final Icon? sendButtonIcon;

  /// Whether to enable gallery image picker
  final bool? enableGalleryImagePicker;

  /// Whether to allow recording voice
  final bool? allowRecordingVoice;

  /// Configuration for mention styling and behavior
  final MentionConfiguration? mentionConfiguration;
}

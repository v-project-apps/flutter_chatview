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
import 'dart:async';
import 'dart:io' show File, Platform;
import 'dart:convert';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:chatview/src/extensions/extensions.dart';
import 'package:chatview/src/models/config_models/pools_picker_bottom_sheet_configuration.dart';
import 'package:chatview/src/utils/constants/constants.dart';
import 'package:chatview/src/values/attachment_source.dart';
import 'package:chatview/src/widgets/audio_url_picker_dialog.dart';
import 'package:chatview/src/widgets/image_url_picker_dialog.dart';
import 'package:chatview/src/widgets/pools_picker_bottom_sheet.dart';
import 'package:chatview/src/widgets/video_url_picker_dialog.dart';
import 'package:chatview/src/widgets/poll_creation_form.dart';
import 'package:chatview/src/widgets/quiz_creation_form.dart';
import 'package:chatview/src/widgets/question_creation_form.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:giphy_get/giphy_get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:waveform_recorder/waveform_recorder.dart'; // new import for web recording
import '../../chatview.dart';
import '../utils/debounce.dart';
import '../utils/package_strings.dart';

class ChatUITextField extends StatefulWidget {
  const ChatUITextField({
    Key? key,
    this.sendMessageConfiguration,
    required this.focusNode,
    required this.controller,
    required this.onRecordingComplete,
    required this.onAttachmentSelected,
    required this.onSendMessage,
  }) : super(key: key);

  /// Provides configuration of default text field in chat.
  final SendMessageConfiguration? sendMessageConfiguration;

  /// Provides focusNode for focusing text field.
  final FocusNode focusNode;

  /// Provides functions which handles text field.
  final MentionTagTextEditingController controller;

  /// Provides callback once voice is recorded.
  final Function(Attachment attachment) onRecordingComplete;

  /// Provides callback when user select images from camera/gallery.
  final AttchmentCallBack onAttachmentSelected;

  /// Callback when message is sent with mentions
  final Function(Message message) onSendMessage;

  @override
  State<ChatUITextField> createState() => _ChatUITextFieldState();
}

class _ChatUITextFieldState extends State<ChatUITextField> {
  final ImagePicker _picker = ImagePicker();

  RecorderController? controller; // for mobile only

  ValueNotifier<bool> isRecording = ValueNotifier(false);

  SendMessageConfiguration? get sendMessageConfig =>
      widget.sendMessageConfiguration;

  VoiceRecordingConfiguration? get voiceRecordingConfig =>
      widget.sendMessageConfiguration?.voiceRecordingConfiguration;

  ImagePickerIconsConfiguration? get imagePickerIconsConfig =>
      sendMessageConfig?.imagePickerIconsConfig;

  VideoPickerConfiguration? get videoPickerConfig =>
      sendMessageConfig?.videoPickerConfiguration;

  FilePickerConfiguration? get filePickerConfig =>
      sendMessageConfig?.filePickerConfiguration;

  TextFieldConfiguration? get textFieldConfig =>
      sendMessageConfig?.textFieldConfig;

  CancelRecordConfiguration? get cancelRecordConfiguration =>
      sendMessageConfig?.cancelRecordConfiguration;

  AttachmentPickerBottomSheetConfiguration?
      get attchamentPickerBottomSheetConfiguration =>
          sendMessageConfig?.attachmentPickerBottomSheetConfig;

  PoolsPickerBottomSheetConfiguration?
      get poolsPickerBottomSheetConfiguration =>
          sendMessageConfig?.poolsPickerBottomSheetConfig;

  OutlineInputBorder get _outLineBorder => OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.transparent),
        borderRadius:
            widget.sendMessageConfiguration?.textFieldConfig?.borderRadius ??
                BorderRadius.circular(textFieldBorderRadius),
      );

  ValueNotifier<TypeWriterStatus> composingStatus =
      ValueNotifier(TypeWriterStatus.typed);

  final WaveformRecorderController _waveformRecorderController =
      WaveformRecorderController();

  late Debouncer debouncer;

  List<ChatUser> _users = []; // Replace with your actual user model
  List<ChatUser> _filteredUsers = [];
  bool _showMentionSuggestions = false;
  bool _initializedUsers = false;

  @override
  void initState() {
    attachListeners();
    debouncer = Debouncer(
        sendMessageConfig?.textFieldConfig?.compositionThresholdTime ??
            const Duration(seconds: 1));

    if (!kIsWeb && (Platform.isIOS || Platform.isAndroid)) {
      controller = RecorderController();
    }

    // Set up mention controller
    final mentionConfig = sendMessageConfig?.mentionConfiguration;
    widget.controller.mentionTagDecoration = MentionTagDecoration(
      mentionStart: mentionConfig?.mentionStart ?? const ['@'],
      mentionBreak: mentionConfig?.mentionBreak ?? ' ',
      allowDecrement: mentionConfig?.allowDecrement ?? true,
      allowEmbedding: mentionConfig?.allowEmbedding ?? true,
      showMentionStartSymbol: mentionConfig?.showMentionStartSymbol ?? true,
      maxWords: mentionConfig?.maxWords ?? 1,
      mentionTextStyle: mentionConfig != null
          ? TextStyle(
              color: mentionConfig.textColor,
              backgroundColor: mentionConfig.backgroundColor,
              fontWeight: mentionConfig.fontWeight,
              height: mentionConfig.height,
              letterSpacing: mentionConfig.letterSpacing,
              fontSize: mentionConfig.fontSize ?? 16,
            )
          : const TextStyle(
              color: Colors.blue,
              backgroundColor: Color(0xFFE3F2FD),
              fontWeight: FontWeight.bold,
              height: 1.5,
              letterSpacing: 0.2,
              fontSize: 16,
            ),
    );
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initializedUsers) {
      // Initialize users
      if (chatViewIW != null) {
        _users = chatViewIW!.chatController.otherUsers;
        _initializedUsers = true;
      }
    }
  }

  @override
  void dispose() {
    debouncer.dispose();
    composingStatus.dispose();
    isRecording.dispose();
    super.dispose();
  }

  void attachListeners() {
    composingStatus.addListener(() {
      widget.sendMessageConfiguration?.textFieldConfig?.onMessageTyping
          ?.call(composingStatus.value);
    });
  }

  void _onSendMessage(String messageText) {
    widget.onSendMessage.call(Message(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      message: messageText,
      messageType: MessageType.text,
      createdAt: DateTime.now(),
      mentions: widget.controller.mentions,
      sentBy: chatViewIW?.chatController.currentUser.id ?? '',
    ));
    setState(() {
      widget.controller.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final outlineBorder = _outLineBorder;
    return Container(
      padding:
          textFieldConfig?.padding ?? const EdgeInsets.symmetric(horizontal: 6),
      margin: textFieldConfig?.margin,
      decoration: BoxDecoration(
        borderRadius: textFieldConfig?.borderRadius ??
            BorderRadius.circular(textFieldBorderRadius),
        color: sendMessageConfig?.textFieldBackgroundColor ?? Colors.white,
      ),
      child: Column(
        children: [
          if (_showMentionSuggestions && _filteredUsers.isNotEmpty)
            Container(
              constraints: const BoxConstraints(maxHeight: 200),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _filteredUsers.length,
                itemBuilder: (context, index) {
                  final user = _filteredUsers[index];
                  return ListTile(
                    title: Text(user.name),
                    onTap: () => _onUserSelected(user),
                  );
                },
              ),
            ),
          ValueListenableBuilder<bool>(
            valueListenable: isRecording,
            builder: (_, isRecordingValue, child) {
              return Row(children: [
                // For mobile recording (iOS/Android)
                if (isRecordingValue && controller != null && !kIsWeb)
                  Expanded(
                    child: AudioWaveforms(
                      size: const Size(double.maxFinite, 50),
                      recorderController: controller!,
                      margin: voiceRecordingConfig?.margin,
                      padding: voiceRecordingConfig?.padding ??
                          const EdgeInsets.symmetric(horizontal: 8),
                      decoration: voiceRecordingConfig?.decoration ??
                          BoxDecoration(
                            color: voiceRecordingConfig?.backgroundColor,
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                      waveStyle: voiceRecordingConfig?.waveStyle ??
                          WaveStyle(
                            extendWaveform: true,
                            showMiddleLine: false,
                            waveColor:
                                voiceRecordingConfig?.waveStyle?.waveColor ??
                                    Colors.black,
                          ),
                    ),
                  )
                // For web recording using waveform_recorder
                else if (isRecordingValue && kIsWeb)
                  Expanded(
                    child: WaveformRecorder(
                      controller: _waveformRecorderController,
                      height: 50,
                      // Optionally configure margins/paddings as needed
                      onRecordingStarted: () {
                        // Called when recording starts
                      },
                      onRecordingStopped: _onWebRecordingStopped,
                    ),
                  )
                else
                  Expanded(
                    child: Focus(
                      onKeyEvent: (node, event) {
                        if (kIsWeb &&
                            event is KeyDownEvent &&
                            event.logicalKey == LogicalKeyboardKey.enter) {
                          if (!HardwareKeyboard.instance.isShiftPressed &&
                              widget.controller.getText.isNotEmpty) {
                            _onSendMessage(widget.controller.getText);
                            return KeyEventResult.handled;
                          }
                        }
                        return KeyEventResult.ignored;
                      },
                      child: MentionTagTextField(
                        controller: widget.controller,
                        focusNode: widget.focusNode,
                        onMention: (value) {
                          if (value != null) {
                            _handleMention(value);
                          }
                        },
                        enableSuggestions: true,
                        mentionTagDecoration:
                            widget.controller.mentionTagDecoration,
                        style: textFieldConfig?.textStyle ??
                            const TextStyle(color: Colors.white),
                        maxLines: textFieldConfig?.maxLines ?? 5,
                        minLines: textFieldConfig?.minLines ?? 1,
                        keyboardType: textFieldConfig?.textInputType,
                        inputFormatters: textFieldConfig?.inputFormatters,
                        onChanged: (text) {
                          setState(() {
                            if (!text.contains("@")) {
                              _showMentionSuggestions = false;
                            }
                          });
                          _onChanged(text);
                        },
                        enabled: textFieldConfig?.enabled,
                        textCapitalization:
                            textFieldConfig?.textCapitalization ??
                                TextCapitalization.sentences,
                        decoration: InputDecoration(
                          hintText: textFieldConfig?.hintText ??
                              PackageStrings.message,
                          fillColor:
                              sendMessageConfig?.textFieldBackgroundColor ??
                                  Colors.white,
                          filled: true,
                          hintStyle: textFieldConfig?.hintStyle ??
                              TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Colors.grey.shade600,
                                letterSpacing: 0.25,
                              ),
                          contentPadding: textFieldConfig?.contentPadding ??
                              const EdgeInsets.symmetric(horizontal: 6),
                          border: outlineBorder,
                          focusedBorder: outlineBorder,
                          enabledBorder: outlineBorder,
                          disabledBorder: outlineBorder,
                        ),
                      ),
                    ),
                  ),

                widget.controller.getText.isNotEmpty
                    ? IconButton(
                        color: sendMessageConfig?.defaultSendButtonColor ??
                            Colors.green,
                        onPressed: (textFieldConfig?.enabled ?? true)
                            ? () {
                                if (widget.controller.getText.isNotEmpty) {
                                  _onSendMessage(widget.controller.getText);
                                }
                              }
                            : null,
                        icon: sendMessageConfig?.sendButtonIcon ??
                            const Icon(Icons.send),
                      )
                    : Row(
                        children: [
                          if (!isRecordingValue) ...[
                            if (sendMessageConfig?.allowGifPicker ?? true)
                              IconButton(
                                constraints: const BoxConstraints(),
                                onPressed: (textFieldConfig?.enabled ?? true)
                                    ? () => _onAttachmentSourcePicked(
                                        AttachmentSource.gif)
                                    : null,
                                icon: Icon(
                                  Icons.gif_box_outlined,
                                  color:
                                      imagePickerIconsConfig?.cameraIconColor,
                                ),
                              ),
                            if (sendMessageConfig?.enablePollsPicker ?? true)
                              IconButton(
                                constraints: const BoxConstraints(),
                                onPressed: (textFieldConfig?.enabled ?? true)
                                    ? () {
                                        PoolsPickerBottomSheet().show(
                                          context: context,
                                          attachmentSourceCallback:
                                              _onAttachmentSourcePicked,
                                          poolsPickerBottomSheetConfig:
                                              poolsPickerBottomSheetConfiguration,
                                        );
                                      }
                                    : null,
                                icon: Icon(
                                  Icons.poll_outlined,
                                  color:
                                      imagePickerIconsConfig?.cameraIconColor,
                                ),
                              ),
                            if (sendMessageConfig?.enableGalleryImagePicker ??
                                true)
                              IconButton(
                                constraints: const BoxConstraints(),
                                onPressed: (textFieldConfig?.enabled ?? true)
                                    ? () {
                                        AttchamentPickerBottomSheet().show(
                                          context: context,
                                          attachmentSourceCallback:
                                              _onAttachmentSourcePicked,
                                          attchamentPickerBottomSheetConfig:
                                              attchamentPickerBottomSheetConfiguration,
                                        );
                                      }
                                    : null,
                                icon: imagePickerIconsConfig
                                        ?.galleryImagePickerIcon ??
                                    Icon(
                                      Icons.attach_file_rounded,
                                      color: imagePickerIconsConfig
                                          ?.galleryIconColor,
                                    ),
                              ),
                          ],
                          if (sendMessageConfig?.allowRecordingVoice ?? false)
                            // Mobile: use _recordOrStop; web: use _toggleWebRecording
                            IconButton(
                              onPressed: (textFieldConfig?.enabled ?? true)
                                  ? () {
                                      if (kIsWeb) {
                                        _toggleWebRecording();
                                      } else if (Platform.isIOS ||
                                          Platform.isAndroid) {
                                        _recordOrStop();
                                      }
                                    }
                                  : null,
                              icon: (isRecordingValue
                                      ? voiceRecordingConfig?.stopIcon
                                      : voiceRecordingConfig?.micIcon) ??
                                  Icon(
                                    isRecordingValue ? Icons.stop : Icons.mic,
                                    color:
                                        voiceRecordingConfig?.recorderIconColor,
                                  ),
                            ),
                          if (isRecordingValue &&
                              cancelRecordConfiguration != null)
                            IconButton(
                              onPressed: () {
                                cancelRecordConfiguration?.onCancel?.call();
                                if (kIsWeb) {
                                  _cancelWebRecording();
                                } else {
                                  _cancelRecording();
                                }
                              },
                              icon: cancelRecordConfiguration?.icon ??
                                  const Icon(Icons.cancel_outlined),
                              color: cancelRecordConfiguration?.iconColor ??
                                  voiceRecordingConfig?.recorderIconColor,
                            ),
                        ],
                      )
              ]);
            },
          ),
        ],
      ),
    );
  }

  FutureOr<void> _cancelRecording() async {
    assert(
      defaultTargetPlatform == TargetPlatform.iOS ||
          defaultTargetPlatform == TargetPlatform.android,
      "Voice messages are only supported with android and ios platform",
    );
    if (!isRecording.value) return;
    final path = await controller?.stop();
    if (path == null) {
      isRecording.value = false;
      return;
    }
    final file = File(path);

    if (await file.exists()) {
      await file.delete();
    }

    isRecording.value = false;
  }

  Future<void> _recordOrStop() async {
    assert(
      defaultTargetPlatform == TargetPlatform.iOS ||
          defaultTargetPlatform == TargetPlatform.android,
      "Voice messages are only supported with android and ios platform",
    );
    if (!isRecording.value) {
      await controller?.record(
        sampleRate: voiceRecordingConfig?.sampleRate,
        bitRate: voiceRecordingConfig?.bitRate,
        androidEncoder: voiceRecordingConfig?.androidEncoder,
        iosEncoder: voiceRecordingConfig?.iosEncoder,
        androidOutputFormat: voiceRecordingConfig?.androidOutputFormat,
      );
      isRecording.value = true;
    } else {
      final path = await controller?.stop();
      isRecording.value = false;
      if (path != null) {
        widget.onRecordingComplete(Attachment(
            name: path,
            url: path,
            size: File(path).lengthSync().toDouble(),
            file: File(path),
            fileBytes: File(path).readAsBytesSync()));
      }
    }
  }

  // New method for toggling web recording using waveform_recorder.
  Future<void> _toggleWebRecording() async {
    try {
      if (_waveformRecorderController.isRecording) {
        isRecording.value = false;
        await _waveformRecorderController.stopRecording();
      } else {
        // Start recording and handle permissions
        await _waveformRecorderController.startRecording();
        // Only set isRecording to true after successful start
        isRecording.value = true;
      }
    } catch (e) {
      debugPrint('Error during web recording: $e');
      // Reset state if there's an error
      isRecording.value = false;
      // Optionally show an error message to the user
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to start recording: ${e.toString()}'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  // Callback invoked by WaveformRecorder when recording stops on web.
  Future<void> _onWebRecordingStopped() async {
    try {
      setState(() {
        isRecording.value = false;
      });
      final file = _waveformRecorderController.file;
      if (file != null) {
        widget.onRecordingComplete(
          Attachment(
            name: file.name,
            url: file.path,
            size: (await file.readAsBytes()).length.toDouble(),
            file: File(file.path),
            fileBytes: await file.readAsBytes(),
          ),
        );
      }
    } catch (e) {
      debugPrint('Error stopping web recording: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to stop recording: ${e.toString()}'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  // Optionally, a method to cancel web recording.
  Future<void> _cancelWebRecording() async {
    try {
      if (_waveformRecorderController.isRecording) {
        await _waveformRecorderController.cancelRecording();
      }
      setState(() {
        isRecording.value = false;
      });
    } catch (e) {
      debugPrint('Error canceling web recording: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to cancel recording: ${e.toString()}'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  void _onAttachmentSourcePicked(AttachmentSource source) {
    switch (source) {
      case AttachmentSource.camera:
        _onImagePicked(ImageSource.camera,
            config: sendMessageConfig?.imagePickerConfiguration);
        break;
      case AttachmentSource.gallery:
        _onImagePicked(ImageSource.gallery,
            config: sendMessageConfig?.imagePickerConfiguration);
        break;
      case AttachmentSource.gif:
        _onGifPicked();
      case AttachmentSource.video:
        _onVideoPicked(ImageSource.gallery,
            config: sendMessageConfig?.videoPickerConfiguration);
        break;
      case AttachmentSource.file:
        _onFilePicked(config: sendMessageConfig?.filePickerConfiguration);
        break;
      case AttachmentSource.imageFromUrl:
        _onImageFromUrlPicked();
        break;
      case AttachmentSource.videoFromUrl:
        _onVideoFromUrlPicked();
        break;
      case AttachmentSource.audioFromFile:
        _onAudioFromFilePicker();
        break;
      case AttachmentSource.audioFromUrl:
        _onAudioFromUrlPicked();
        break;
      case AttachmentSource.poll:
        _onPollCreation();
        break;
      case AttachmentSource.quiz:
        _onQuizCreation();
        break;
      case AttachmentSource.question:
        _onQuestionCreation();
        break;
      case AttachmentSource.dailyReport:
        _onDailyReportCreation();
        break;
      case AttachmentSource.dailyReportStatistics:
        _onDailyReportStatisticsCreation();
        break;
      case AttachmentSource.imageWithText:
        _onImageWithTextCreation();
        break;
      case AttachmentSource.imageCarousel:
        _onImageCarouselCreation();
        break;
    }
  }

  void _onImageWithTextCreation() {
    showDialog(
      context: context,
      builder: (context) => ImageWithTextCreationDialog(
        onSend: (imageFile, text) async {
          // Check if widget is still mounted before accessing context
          if (mounted) {
            // Create a message with the image with text data
            final message = Message(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                message: text,
                messageType: MessageType.imageWithText,
                sentBy: chatViewIW?.chatController.currentUser.id ?? '',
                createdAt: DateTime.now(),
                attachments: [
                  Attachment(
                    name: imageFile.name,
                    url: "",
                    fileBytes: await imageFile.readAsBytes(),
                    size: (await imageFile.readAsBytes()).length.toDouble(),
                    file: File(imageFile.path),
                  ),
                ]);
            widget.onSendMessage(message);
          }
        },
      ),
    );
  }

  void _onImageCarouselCreation() {
    showDialog(
      context: context,
      builder: (context) => ImageCarouselCreationDialog(
        onSend: (images) async {
          // Check if widget is still mounted before accessing context
          if (mounted) {
            List<Attachment> attachments = [];
            for (var image in images) {
              attachments.add(Attachment(
                name: image.name,
                url: "",
                size: (await image.readAsBytes()).length.toDouble(),
                file: File(image.path),
                fileBytes: await image.readAsBytes(),
              ));
            }
            widget.onAttachmentSelected(
                attachments, AttachmentSource.imageCarousel, '');
          }
        },
      ),
    );
  }

  void _onGifPicked() async {
    try {
      GiphyGif? gif = await GiphyGet.getGif(
        context: context,
        apiKey: sendMessageConfig?.gifPickerConfiguration?.apiKey ?? "",
        lang: sendMessageConfig?.gifPickerConfiguration?.lang ??
            GiphyLanguage.english,
        randomID: sendMessageConfig?.gifPickerConfiguration?.randomID ?? "abcd",
        tabColor:
            sendMessageConfig?.gifPickerConfiguration?.tabColor ?? Colors.teal,
        debounceTimeInMilliseconds: sendMessageConfig
                ?.gifPickerConfiguration?.debounceTimeInMilliseconds ??
            350,
      );
      if (gif != null) {
        widget.onAttachmentSelected([
          Attachment(
              name: gif.title ?? "",
              url: gif.images?.original?.url ?? "",
              size: 0,
              file: null,
              fileBytes: null)
        ], AttachmentSource.gif, "");
      }
    } catch (e) {
      debugPrint(e.toString());
      widget.onAttachmentSelected(
          null, AttachmentSource.imageFromUrl, e.toString());
    }
  }

  void _onAudioFromFilePicker() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.audio,
      );

      XFile? file = result?.files.single.xFile;
      String? filePath = file?.path;
      if (file != null && filePath != null) {
        widget.onRecordingComplete(
          Attachment(
            name: file.name,
            url: file.path,
            size: (await file.readAsBytes()).length.toDouble(),
            file: File(file.path),
            fileBytes: await file.readAsBytes(),
          ),
        );
      }
    } catch (e) {
      debugPrint(e.toString());
      widget.onAttachmentSelected(
          null, AttachmentSource.audioFromFile, e.toString());
    }
  }

  void _onAudioFromUrlPicked() {
    showDialog(
      context: context,
      builder: (context) => AudioUrlPickerDialog(onPicked: (audioUrl) {
        widget.onAttachmentSelected(
          [
            Attachment(
              name: audioUrl,
              url: audioUrl,
              size: 0,
            )
          ],
          AttachmentSource.audioFromUrl,
          '',
        );
      }),
    );
  }

  void _onImageFromUrlPicked() {
    showDialog(
        context: context,
        builder: (context) => ImageUrlPickerDialog(onPicked: (imageUrl) {
              widget.onAttachmentSelected(
                [
                  Attachment(
                    name: imageUrl,
                    url: imageUrl,
                    size: 0,
                  )
                ],
                AttachmentSource.imageFromUrl,
                '',
              );
            }));
  }

  void _onVideoFromUrlPicked() {
    showDialog(
        context: context,
        builder: (context) =>
            VideoUrlPickerDialog(onPicked: (videoUrl, thumbnailUrl) {
              widget.onAttachmentSelected(
                [
                  Attachment(
                    name: videoUrl,
                    url: videoUrl,
                    size: 0,
                    thumbnailUrl:
                        thumbnailUrl?.isNotEmpty ?? false ? thumbnailUrl : null,
                  )
                ],
                AttachmentSource.videoFromUrl,
                '',
              );
            }));
  }

  void _onImagePicked(
    ImageSource imageSource, {
    ImagePickerConfiguration? config,
  }) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: imageSource,
        maxHeight: config?.maxHeight,
        maxWidth: config?.maxWidth,
        imageQuality: config?.imageQuality,
        preferredCameraDevice:
            config?.preferredCameraDevice ?? CameraDevice.rear,
      );
      if (image != null) {
        String imagePath = image.path;
        if (config?.onImagePicked != null) {
          String? updatedImagePath = await config?.onImagePicked!(imagePath);
          if (updatedImagePath != null) imagePath = updatedImagePath;
        }

        widget.onAttachmentSelected(
            [
              Attachment(
                  name: image.name,
                  url: imagePath,
                  size: (await image.length()).toDouble(),
                  file: File(imagePath),
                  fileBytes: await image.readAsBytes()),
            ],
            imageSource == ImageSource.camera
                ? AttachmentSource.camera
                : AttachmentSource.gallery,
            '');
      } else {
        throw Exception('Failed to select image');
      }
    } catch (e) {
      widget.onAttachmentSelected(
          null,
          imageSource == ImageSource.camera
              ? AttachmentSource.camera
              : AttachmentSource.gallery,
          e.toString());
    }
  }

  void _onVideoPicked(
    ImageSource imageSource, {
    VideoPickerConfiguration? config,
  }) async {
    try {
      final XFile? video = await _picker.pickVideo(
        source: imageSource,
        maxDuration: config?.maxDuration,
        preferredCameraDevice:
            config?.preferredCameraDevice ?? CameraDevice.rear,
      );
      if (video != null) {
        String videoPath = video.path;
        if (config?.onVideoPicked != null) {
          String? updatedVideoPath = await config?.onVideoPicked!(videoPath);
          if (updatedVideoPath != null) videoPath = updatedVideoPath;
        }
        widget.onAttachmentSelected([
          Attachment(
              name: video.name,
              url: videoPath,
              size: (await video.length()).toDouble(),
              file: File(videoPath),
              fileBytes: await video.readAsBytes())
        ], AttachmentSource.video, '');
      } else {
        throw Exception('Failed to select video');
      }
    } catch (e) {
      widget.onAttachmentSelected(null, AttachmentSource.video, e.toString());
    }
  }

  void _onFilePicked({
    FilePickerConfiguration? config,
  }) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
          allowedExtensions: config?.allowedExtensions,
          allowCompression: config?.allowCompression ?? false);

      XFile? file = result?.files.single.xFile;
      String? filePath = file?.path;
      if (file != null && filePath != null) {
        if (config?.onFilePicked != null) {
          String? updatedFilePath = await config?.onFilePicked!(filePath);
          if (updatedFilePath != null) filePath = updatedFilePath;
        }
        widget.onAttachmentSelected([
          Attachment(
              name: file.name,
              url: filePath,
              size: (await file.readAsBytes()).length.toDouble(),
              file: File(filePath),
              fileBytes: await file.readAsBytes())
        ], AttachmentSource.file, '');
      }
    } catch (e) {
      debugPrint(e.toString());
      widget.onAttachmentSelected(null, AttachmentSource.file, e.toString());
    }
  }

  void _onPollCreation() {
    showDialog(
        context: context,
        builder: (context) {
          return PollCreationForm(
            onPollCreated: (votingMessage) {
              // Create a message with the voting data as JSON
              final message = Message(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                message: jsonEncode(votingMessage.toJson()),
                messageType: MessageType.voting,
                sentBy: chatViewIW?.chatController.currentUser.id ?? '',
                createdAt: DateTime.now(),
              );
              widget.onSendMessage(message);
              Navigator.of(context).pop();
            },
            theme: Theme.of(context),
          );
        });
  }

  void _onQuizCreation() {
    showDialog(
      context: context,
      builder: (context) => QuizCreationForm(
        onQuizCreated: (quizMessage) {
          // Check if widget is still mounted before accessing context
          if (mounted) {
            // Create a message with the quiz data as JSON
            final message = Message(
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              message: jsonEncode(quizMessage.toJson()),
              messageType: MessageType.quiz,
              sentBy: chatViewIW?.chatController.currentUser.id ?? '',
              createdAt: DateTime.now(),
            );
            widget.onSendMessage(message);
            Navigator.of(context).pop();
          }
        },
        theme: Theme.of(context),
      ),
    );
  }

  void _onQuestionCreation() {
    showDialog(
      context: context,
      builder: (context) => QuestionCreationForm(
        onQuestionCreated: (questionMessage) {
          // Check if widget is still mounted before accessing context
          if (mounted) {
            // Create a message with the question data as JSON
            final message = Message(
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              message: jsonEncode(questionMessage.toJson()),
              messageType: MessageType.question,
              sentBy: chatViewIW?.chatController.currentUser.id ?? '',
              createdAt: DateTime.now(),
            );
            widget.onSendMessage(message);
            Navigator.of(context).pop();
          }
        },
        theme: Theme.of(context),
      ),
    );
  }

  void _onDailyReportCreation() {
    showDialog(
      context: context,
      builder: (context) => DailyReportCreationForm(
        onDailyReportCreated: (dailyReportMessage) {
          // Check if widget is still mounted before accessing context
          if (mounted) {
            // Create a message with the daily report data as JSON
            final message = Message(
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              message: jsonEncode(dailyReportMessage.toJson()),
              messageType: MessageType.dailyReport,
              sentBy: chatViewIW?.chatController.currentUser.id ?? '',
              createdAt: DateTime.now(),
            );
            widget.onSendMessage(message);
            Navigator.of(context).pop();
          }
        },
        theme: Theme.of(context),
      ),
    );
  }

  void _onDailyReportStatisticsCreation() {
    if (mounted) {
      // Create a message with the daily report statistics data as JSON
      final message = Message(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        message: "",
        messageType: MessageType.dailyReportStatistics,
        sentBy: chatViewIW?.chatController.currentUser.id ?? '',
        createdAt: DateTime.now(),
      );
      widget.onSendMessage(message);
    }
  }

  void _onChanged(String inputText) {
    debouncer.run(() {
      composingStatus.value = TypeWriterStatus.typed;
    }, () {
      composingStatus.value = TypeWriterStatus.typing;
    });
  }

  void _handleMention(String value) async {
    debugPrint('Handling mention: $value');

    // If value is empty or contains a space, hide suggestions
    if (value.isEmpty || value.contains(' ')) {
      setState(() {
        _showMentionSuggestions = false;
      });
      return;
    }

    // Remove @ symbol and trim whitespace
    final searchValue = value.trim();

    // If there's no text after @, hide suggestions
    if (searchValue.isEmpty) {
      setState(() {
        _showMentionSuggestions = false;
      });
      return;
    }

    setState(() {
      _filteredUsers = _users
          .where((user) => user.name
              .toLowerCase()
              .contains(searchValue.replaceAll('@', '').toLowerCase()))
          .toList();
      _showMentionSuggestions = _filteredUsers.isNotEmpty;
    });
  }

  void _onUserSelected(ChatUser user) {
    widget.controller.addMention(
      label: user.name,
      data: {user.id: user.name},
    );
    setState(() {
      _showMentionSuggestions = false;
    });
  }
}

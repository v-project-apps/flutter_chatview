import 'dart:async';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:chatview/chatview.dart';
import 'package:chatview/src/controller/file_controller.dart';
import 'package:chatview/src/widgets/chat_view_inherited_widget.dart';
import 'package:chatview/src/widgets/horizontal_user_avatars.dart';
import 'package:chatview/src/widgets/reaction_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class VoiceMessageView extends StatefulWidget {
  const VoiceMessageView({
    Key? key,
    required this.screenWidth,
    required this.message,
    required this.isMessageBySender,
    this.inComingChatBubbleConfig,
    this.outgoingChatBubbleConfig,
    this.onMaxDuration,
    this.messageReactionConfig,
    this.config,
  }) : super(key: key);

  /// Provides configuration related to voice message.
  final VoiceMessageConfiguration? config;

  /// Allow user to set width of chat bubble.
  final double screenWidth;

  /// Provides message instance of chat.
  final Message message;
  final Function(int)? onMaxDuration;

  /// Represents current message is sent by current user.
  final bool isMessageBySender;

  /// Provides configuration of reaction appearance in chat bubble.
  final MessageReactionConfiguration? messageReactionConfig;

  /// Provides configuration of chat bubble appearance from other user of chat.
  final ChatBubble? inComingChatBubbleConfig;

  /// Provides configuration of chat bubble appearance from current user of chat.
  final ChatBubble? outgoingChatBubbleConfig;

  @override
  State<VoiceMessageView> createState() => _VoiceMessageViewState();
}

class _VoiceMessageViewState extends State<VoiceMessageView> {
  late PlayerController controller;
  late StreamSubscription<PlayerState> playerStateSubscription;

  final ValueNotifier<PlayerState> _playerState =
      ValueNotifier(PlayerState.stopped);

  PlayerState get playerState => _playerState.value;

  PlayerWaveStyle playerWaveStyle = const PlayerWaveStyle(scaleFactor: 70);

  bool isDownloading = false;

  @override
  void initState() {
    super.initState();
    controller = PlayerController();
    _initializePlayer();
    playerStateSubscription = controller.onPlayerStateChanged
        .listen((state) => _playerState.value = state);
  }

  Future<void> _initializePlayer() async {
    String filePath = await FileController.getLocalFilePath(
      widget.message.attachment?.name ?? '',
    );

    if (!await FileController.isFileDownloaded(filePath) &&
        widget.message.attachment != null) {
      setState(() {
        isDownloading = true;
      });
      filePath = await FileController.downloadFile(
        widget.message.attachment!.url,
        widget.message.attachment!.name,
      );
      setState(() {
        isDownloading = false;
      });
    }

    controller
        .preparePlayer(
          path: filePath,
          noOfSamples: widget.config?.playerWaveStyle
                  ?.getSamplesForWidth(widget.screenWidth * 0.5) ??
              playerWaveStyle.getSamplesForWidth(widget.screenWidth * 0.5),
        )
        .whenComplete(() => widget.onMaxDuration?.call(controller.maxDuration));
  }

  @override
  void dispose() {
    playerStateSubscription.cancel();
    controller.dispose();
    _playerState.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          decoration: widget.config?.decoration ??
              BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: widget.isMessageBySender
                    ? widget.outgoingChatBubbleConfig?.color
                    : widget.inComingChatBubbleConfig?.color,
              ),
          padding: widget.config?.padding ??
              const EdgeInsets.symmetric(horizontal: 8),
          margin: widget.config?.margin ??
              EdgeInsets.symmetric(
                horizontal: 8,
                vertical: widget.message.reactions.isNotEmpty ||
                        (widget.message.seenBy?.isNotEmpty ?? false)
                    ? 15
                    : 0,
              ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ValueListenableBuilder<PlayerState>(
                builder: (context, state, child) {
                  return IconButton(
                    onPressed: _playOrPause,
                    icon: isDownloading
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : state.isStopped ||
                                state.isPaused ||
                                state.isInitialised
                            ? widget.config?.playIcon ??
                                const Icon(
                                  Icons.play_arrow,
                                  color: Colors.white,
                                )
                            : widget.config?.pauseIcon ??
                                const Icon(
                                  Icons.stop,
                                  color: Colors.white,
                                ),
                  );
                },
                valueListenable: _playerState,
              ),
              AudioFileWaveforms(
                size: Size(
                    widget.config?.waveformWidth ?? widget.screenWidth * 0.45,
                    60),
                playerController: controller,
                waveformType: WaveformType.fitWidth,
                playerWaveStyle:
                    widget.config?.playerWaveStyle ?? playerWaveStyle,
                padding: widget.config?.waveformPadding ??
                    const EdgeInsets.only(right: 10),
                margin: widget.config?.waveformMargin,
                animationCurve: widget.config?.animationCurve ?? Curves.easeIn,
                animationDuration: widget.config?.animationDuration ??
                    const Duration(milliseconds: 500),
                enableSeekGesture: widget.config?.enableSeekGesture ?? true,
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
            isMessageBySender: widget.isMessageBySender,
            reactions: widget.message.reactions,
            messageReactionConfig: widget.messageReactionConfig,
          ),
      ],
    );
  }

  void _playOrPause() {
    assert(
      defaultTargetPlatform == TargetPlatform.iOS ||
          defaultTargetPlatform == TargetPlatform.android,
      "Voice messages are only supported with android and ios platform",
    );
    if (playerState.isInitialised ||
        playerState.isPaused ||
        playerState.isStopped) {
      controller.startPlayer();
      controller.setFinishMode(finishMode: FinishMode.pause);
    } else {
      controller.pausePlayer();
    }
  }
}

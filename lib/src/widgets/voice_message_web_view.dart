import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:chatview/chatview.dart';
import 'package:chatview/src/widgets/chat_view_inherited_widget.dart';
import 'package:chatview/src/widgets/horizontal_user_avatars.dart';
import 'package:chatview/src/widgets/reaction_widget.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class VoiceMessageWebView extends StatefulWidget {
  /// Provides message instance of chat.
  final Message message;
  final double screenWidth;
  final VoiceMessageWebConfiguration? config;
  final bool isMessageBySender;
  final MessageReactionConfiguration? messageReactionConfig;
  final ChatBubble? inComingChatBubbleConfig;
  final ChatBubble? outgoingChatBubbleConfig;

  const VoiceMessageWebView({
    Key? key,
    required this.message,
    required this.screenWidth,
    this.config,
    required this.isMessageBySender,
    this.messageReactionConfig,
    this.inComingChatBubbleConfig,
    this.outgoingChatBubbleConfig,
  }) : super(key: key);

  @override
  State<VoiceMessageWebView> createState() => _VoiceMessageWebViewState();
}

class _VoiceMessageWebViewState extends State<VoiceMessageWebView> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  bool isPlaying = false;

  late final audioUrl = widget.message.attachment?.url ?? '';

  @override
  void initState() {
    super.initState();
    getAudioDuration(audioUrl).then((value) {
      setState(() {
        _duration = value ?? Duration.zero;
      });
    });
    _audioPlayer.onPositionChanged.listen((p) {
      setState(() {
        _position = p;
      });
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _togglePlayPause() async {
    if (isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.play(UrlSource(audioUrl));
    }
    setState(() {
      isPlaying = !isPlaying;
    });
  }

  Future<Duration?> getAudioDuration(String url) async {
    final player = AudioPlayer();
    try {
      await player.setSourceUrl(url);
      return player.getDuration();
    } catch (e) {
      debugPrint("Error: $e");
      return null;
    } finally {
      player.dispose();
    }
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
                vertical: widget.message.reaction.reactions.isNotEmpty ||
                        (widget.message.seenBy?.isNotEmpty ?? false)
                    ? 15
                    : 0,
              ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: _togglePlayPause,
                icon: isPlaying
                    ? (widget.config?.pauseIcon ??
                        const Icon(Icons.pause, color: Colors.white))
                    : (widget.config?.playIcon ??
                        const Icon(Icons.play_arrow, color: Colors.white)),
              ),
              Slider(
                value: _position.inSeconds.toDouble(),
                max: _duration.inSeconds.toDouble() > 0
                    ? _duration.inSeconds.toDouble()
                    : 1,
                activeColor: widget.config?.sliderActiveColor ?? Colors.white,
                inactiveColor:
                    widget.config?.sliderInactiveColor ?? Colors.grey,
                onChanged: (value) async {
                  final newPosition = Duration(seconds: value.toInt());
                  await _audioPlayer.seek(newPosition);
                },
              ),
              Text(
                _voiceMessageDurationText(),
                style: const TextStyle(color: Colors.white),
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
        if (widget.message.reaction.reactions.isNotEmpty)
          ReactionWidget(
            isMessageBySender: widget.isMessageBySender,
            reaction: widget.message.reaction,
            messageReactionConfig: widget.messageReactionConfig,
          ),
      ],
    );
  }

  String _voiceMessageDurationText() {
    return "${_position.inSeconds.toMMSS()} / ${_duration.inSeconds.toMMSS()}";
  }
}

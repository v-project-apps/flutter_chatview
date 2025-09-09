import 'package:chatview/chatview.dart';
import 'package:example/cursor_pagination_example.dart';
import 'package:example/data.dart';
import 'package:example/models/theme.dart';
import 'package:example/specialized_messages_example.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const Example());
}

class Example extends StatelessWidget {
  const Example({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Chat UI Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xffEE5366),
        colorScheme:
            ColorScheme.fromSwatch(accentColor: const Color(0xffEE5366)),
      ),
      home: const ExampleHome(),
    );
  }
}

class ExampleHome extends StatelessWidget {
  const ExampleHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter ChatView Examples'),
        backgroundColor: const Color(0xffEE5366),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SpecializedMessagesExample(),
                  ),
                );
              },
              child: const Text('Specialized Messages Example'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CursorPaginationExample(),
                  ),
                );
              },
              child: const Text('Cursor Pagination Example'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ChatScreen(),
                  ),
                );
              },
              child: const Text('Basic Chat Example'),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  AppTheme theme = LightTheme();
  bool isDarkTheme = false;
  final _chatController = ChatController(
    initialMessageList: Data.messageList,
    pinnedMessageList: [
      Message(
        id: '6',
        message: "When to go ?",
        createdAt: DateTime.now(),
        sentBy: '3',
        status: MessageStatus.read,
        seenBy: ['2', '3'],
      ),
    ],
    scrollController: ScrollController(),
    currentUser: ChatUser(
      id: '1',
      name: 'Flutter DEV',
      profilePhoto: Data.profileImage,
    ),
    otherUsers: [
      ChatUser(
        id: '2',
        name: 'Simform Solutions',
        profilePhoto: Data.profileImage,
      ),
      ChatUser(
        id: '3',
        name: 'Jhon Doe',
      ),
      ChatUser(
        id: '4',
        name: 'Mike Doe',
        profilePhoto: Data.profileImage,
      ),
      ChatUser(
        id: '5',
        name: 'Rich Ked',
      ),
      ChatUser(
        id: '6',
        name: 'Rich Medison',
        profilePhoto: Data.profileImage,
      ),
    ],
  );

  void _showHideTypingIndicator() {
    _chatController.setTypingIndicator = !_chatController.showTypingIndicator;
  }

  void receiveMessage() async {
    _chatController.addMessage(
      Message(
        id: DateTime.now().toString(),
        message: 'I will schedule the meeting.',
        createdAt: DateTime.now(),
        sentBy: '2',
      ),
    );
    await Future.delayed(const Duration(milliseconds: 500));
    _chatController.addReplySuggestions([
      const SuggestionItemData(id: '1', text: 'Thanks.'),
      const SuggestionItemData(id: '2', text: 'Thank you very much.'),
      const SuggestionItemData(id: '3', text: 'Great.')
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChatView(
        chatController: _chatController,
        onSendTap: _onSendTap,
        featureActiveConfig: const FeatureActiveConfig(
          lastSeenAgoBuilderVisibility: true,
          receiptsBuilderVisibility: true,
          enablePagination: true,
          enableJumpToMessage: true,
          enableScrollToBottomButton: true,
        ),
        scrollToBottomButtonConfig: ScrollToBottomButtonConfig(
          backgroundColor: theme.textFieldBackgroundColor,
          border: Border.all(
            color: isDarkTheme ? Colors.transparent : Colors.grey,
          ),
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: theme.themeIconColor,
            weight: 10,
            size: 30,
          ),
        ),
        isLastPage: false,
        chatViewState: ChatViewState.hasMessages,
        chatViewStateConfig: ChatViewStateConfiguration(
          loadingWidgetConfig: ChatViewStateWidgetConfiguration(
            loadingIndicatorColor: theme.outgoingChatBubbleColor,
          ),
          onReloadButtonTap: () {},
        ),
        typeIndicatorConfig: TypeIndicatorConfiguration(
          flashingCircleBrightColor: theme.flashingCircleBrightColor,
          flashingCircleDarkColor: theme.flashingCircleDarkColor,
        ),
        appBar: ChatViewAppBar(
          elevation: theme.elevation,
          backGroundColor: theme.appBarColor,
          profilePicture: Data.profileImage,
          backArrowColor: theme.backArrowColor,
          chatTitle: "Chat view",
          chatTitleTextStyle: TextStyle(
            color: theme.appBarTitleTextStyle,
            fontWeight: FontWeight.bold,
            fontSize: 18,
            letterSpacing: 0.25,
          ),
          userStatus: "online",
          userStatusTextStyle: const TextStyle(color: Colors.grey),
          actions: [
            IconButton(
              onPressed: _onThemeIconTap,
              icon: Icon(
                isDarkTheme
                    ? Icons.brightness_4_outlined
                    : Icons.dark_mode_outlined,
                color: theme.themeIconColor,
              ),
            ),
            IconButton(
              tooltip: 'Toggle TypingIndicator',
              onPressed: _showHideTypingIndicator,
              icon: Icon(
                Icons.keyboard,
                color: theme.themeIconColor,
              ),
            ),
            IconButton(
              tooltip: 'Simulate Message receive',
              onPressed: receiveMessage,
              icon: Icon(
                Icons.supervised_user_circle,
                color: theme.themeIconColor,
              ),
            ),
          ],
        ),
        chatBackgroundConfig: ChatBackgroundConfiguration(
          messageTimeIconColor: theme.messageTimeIconColor,
          messageTimeTextStyle: TextStyle(color: theme.messageTimeTextColor),
          defaultGroupSeparatorConfig: DefaultGroupSeparatorConfiguration(
            textStyle: TextStyle(
              color: theme.chatHeaderColor,
              fontSize: 17,
            ),
          ),
          backgroundColor: theme.backgroundColor,
        ),
        sendMessageConfig: SendMessageConfiguration(
          imagePickerIconsConfig: ImagePickerIconsConfiguration(
            cameraIconColor: theme.cameraIconColor,
            galleryIconColor: theme.galleryIconColor,
          ),
          allowGifPicker: true,
          gifPickerConfiguration: const GifPickerConfiguration(
            apiKey: "yecm82d7ivn5Mwtnot2TkgkjNRGdeQQ5",
            lang: "en",
            randomID: "abcd",
            tabColor: Colors.teal,
          ),
          replyMessageColor: theme.replyMessageColor,
          defaultSendButtonColor: theme.sendButtonColor,
          replyDialogColor: theme.replyDialogColor,
          replyTitleColor: theme.replyTitleColor,
          textFieldBackgroundColor: theme.textFieldBackgroundColor,
          closeIconColor: theme.closeIconColor,
          textFieldConfig: TextFieldConfiguration(
            onMessageTyping: (status) {
              /// Do with status
              debugPrint(status.toString());
            },
            compositionThresholdTime: const Duration(seconds: 1),
            textStyle: TextStyle(color: theme.textFieldTextColor),
          ),
          micIconColor: theme.replyMicIconColor,
          voiceRecordingConfiguration: VoiceRecordingConfiguration(
            backgroundColor: theme.waveformBackgroundColor,
            recorderIconColor: theme.recordIconColor,
            waveStyle: WaveStyle(
              showMiddleLine: false,
              waveColor: theme.waveColor ?? Colors.white,
              extendWaveform: true,
            ),
          ),
        ),
        pinnedMessageConfiguration: const PinnedMessageConfiguration(
          allowPinMessage: true,
          allowRemoveMessage: true,
        ),
        chatBubbleConfig: ChatBubbleConfiguration(
          outgoingChatBubbleConfig: ChatBubble(
            linkPreviewConfig: LinkPreviewConfiguration(
              backgroundColor: theme.linkPreviewOutgoingChatColor,
              bodyStyle: theme.outgoingChatLinkBodyStyle,
              titleStyle: theme.outgoingChatLinkTitleStyle,
            ),
            receiptsWidgetConfig:
                const ReceiptsWidgetConfig(showReceiptsIn: ShowReceiptsIn.all),
            color: theme.outgoingChatBubbleColor,
          ),
          inComingChatBubbleConfig: ChatBubble(
            linkPreviewConfig: LinkPreviewConfiguration(
              linkStyle: TextStyle(
                color: theme.inComingChatBubbleTextColor,
                decoration: TextDecoration.underline,
              ),
              backgroundColor: theme.linkPreviewIncomingChatColor,
              bodyStyle: theme.incomingChatLinkBodyStyle,
              titleStyle: theme.incomingChatLinkTitleStyle,
            ),
            textStyle: TextStyle(color: theme.inComingChatBubbleTextColor),
            onMessageRead: (message) {
              /// send your message reciepts to the other client
              debugPrint('Message Read');
            },
            senderNameTextStyle:
                TextStyle(color: theme.inComingChatBubbleTextColor),
            color: theme.inComingChatBubbleColor,
          ),
        ),
        replyPopupConfig: ReplyPopupConfiguration(
            backgroundColor: theme.replyPopupColor,
            buttonTextStyle: TextStyle(color: theme.replyPopupButtonColor),
            topBorderColor: theme.replyPopupTopBorderColor,
            onPinTap: (message) {}),
        reactionPopupConfig: ReactionPopupConfiguration(
          shadow: BoxShadow(
            color: isDarkTheme ? Colors.black54 : Colors.grey.shade400,
            blurRadius: 20,
          ),
          backgroundColor: theme.reactionPopupColor,
        ),
        messageConfig: MessageConfiguration(
            messageReactionConfig: MessageReactionConfiguration(
              backgroundColor: theme.messageReactionBackGroundColor,
              borderColor: theme.messageReactionBackGroundColor,
              reactedUserCountTextStyle:
                  TextStyle(color: theme.inComingChatBubbleTextColor),
              reactionCountTextStyle:
                  TextStyle(color: theme.inComingChatBubbleTextColor),
              reactionsBottomSheetConfig: ReactionsBottomSheetConfiguration(
                backgroundColor: theme.backgroundColor,
                reactedUserTextStyle: TextStyle(
                  color: theme.inComingChatBubbleTextColor,
                ),
                reactionWidgetDecoration: BoxDecoration(
                  color: theme.inComingChatBubbleColor,
                  boxShadow: [
                    BoxShadow(
                      color:
                          isDarkTheme ? Colors.black12 : Colors.grey.shade200,
                      offset: const Offset(0, 20),
                      blurRadius: 40,
                    )
                  ],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            imageMessageConfig: ImageMessageConfiguration(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
              shareIconConfig: ShareIconConfiguration(
                defaultIconBackgroundColor: theme.shareIconBackgroundColor,
                defaultIconColor: theme.shareIconColor,
              ),
            )),
        profileCircleConfig: const ProfileCircleConfiguration(
          profileImageUrl: Data.profileImage,
        ),
        repliedMessageConfig: RepliedMessageConfiguration(
          backgroundColor: theme.repliedMessageColor,
          verticalBarColor: theme.verticalBarColor,
          repliedMsgAutoScrollConfig: RepliedMsgAutoScrollConfig(
            enableHighlightRepliedMsg: true,
            enableScrollToRepliedMsg: true,
            highlightColor: Colors.pinkAccent.shade100,
            highlightScale: 1.1,
          ),
          textStyle: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.25,
          ),
          replyTitleTextStyle: TextStyle(color: theme.repliedTitleTextColor),
        ),
        swipeToReplyConfig: SwipeToReplyConfiguration(
          replyIconColor: theme.swipeToReplyIconColor,
        ),
        replySuggestionsConfig: ReplySuggestionsConfig(
          itemConfig: SuggestionItemConfig(
            decoration: BoxDecoration(
              color: theme.textFieldBackgroundColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: theme.outgoingChatBubbleColor ?? Colors.white,
              ),
            ),
            textStyle: TextStyle(
              color: isDarkTheme ? Colors.white : Colors.black,
            ),
          ),
          onTap: (item) => _onSendTap(Message(
            id: DateTime.now().toString(),
            message: item.text,
            createdAt: DateTime.now(),
            sentBy: _chatController.currentUser.id,
          )),
        ),
      ),
    );
  }

  void _onSendTap(Message message) {
    _chatController.addMessage(message);
    Future.delayed(const Duration(milliseconds: 300), () {
      _chatController.initialMessageList.last.setStatus =
          MessageStatus.undelivered;
    });
    Future.delayed(const Duration(seconds: 1), () {
      _chatController.initialMessageList.last.setStatus = MessageStatus.read;
    });
  }

  void _onThemeIconTap() {
    setState(() {
      if (isDarkTheme) {
        theme = LightTheme();
        isDarkTheme = false;
      } else {
        theme = DarkTheme();
        isDarkTheme = true;
      }
    });
  }
}

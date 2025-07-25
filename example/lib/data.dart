import 'package:chatview/chatview.dart';

class Data {
  static const profileImage =
      "https://raw.githubusercontent.com/SimformSolutionsPvtLtd/flutter_showcaseview/master/example/assets/simform.png";
  static final messageList = [
    Message(
      id: '1',
      message: "Hi!",
      createdAt: DateTime.now(),
      sentBy: '1', // userId of who sends the message
      status: MessageStatus.read,
      seenBy: ['2', '3'],
    ),
    Message(
      id: '2',
      message: "Hi!",
      createdAt: DateTime.now(),
      sentBy: '2',
      status: MessageStatus.read,
      seenBy: ['2', '3'],
    ),
    Message(
      id: '3',
      message: "We can meet?I am free",
      createdAt: DateTime.now(),
      sentBy: '1',
      status: MessageStatus.read,
      seenBy: ['2', '3'],
    ),
    Message(
      id: '4',
      message: "Can you write the time and place of the meeting?",
      createdAt: DateTime.now(),
      sentBy: '1',
      status: MessageStatus.read,
      seenBy: ['2', '3'],
    ),
    Message(
      id: '5',
      message: "That's fine",
      createdAt: DateTime.now(),
      sentBy: '2',
      reactions: [Reaction(emoji: '\u{2764}', reactedUserId: '1')],
      status: MessageStatus.read,
      seenBy: ['2', '3'],
    ),
    Message(
      id: '6',
      message: "When to go ?",
      createdAt: DateTime.now(),
      sentBy: '3',
      status: MessageStatus.read,
      seenBy: ['2', '3'],
    ),
    Message(
      id: '7',
      message: "I guess Simform will reply",
      createdAt: DateTime.now(),
      sentBy: '4',
      status: MessageStatus.read,
      seenBy: ['2', '3'],
    ),
    Message(
      id: '8',
      message: "https://bit.ly/3JHS2Wl",
      createdAt: DateTime.now(),
      sentBy: '2',
      reactions: [
        Reaction(emoji: '\u{2764}', reactedUserId: '2'),
        Reaction(emoji: '\u{1F44D}', reactedUserId: '3'),
        Reaction(emoji: '\u{1F44D}', reactedUserId: '4'),
      ],
      status: MessageStatus.read,
      replyMessage: const ReplyMessage(
        message: "Can you write the time and place of the meeting?",
        replyTo: '1',
        replyBy: '2',
        messageId: '4',
      ),
      seenBy: ['2', '3'],
    ),
    Message(
      id: '9',
      message: "Done",
      createdAt: DateTime.now(),
      sentBy: '1',
      status: MessageStatus.read,
      reactions: [
        Reaction(emoji: '\u{2764}', reactedUserId: '2'),
        Reaction(emoji: '\u{2764}', reactedUserId: '3'),
        Reaction(emoji: '\u{2764}', reactedUserId: '4'),
      ],
      seenBy: ['2', '3'],
    ),
    Message(
      id: '10',
      message: "Thank you!!",
      status: MessageStatus.read,
      createdAt: DateTime.now(),
      sentBy: '1',
      reactions: [
        Reaction(emoji: '\u{2764}', reactedUserId: '2'),
        Reaction(emoji: '\u{2764}', reactedUserId: '4'),
        Reaction(emoji: '\u{2764}', reactedUserId: '3'),
        Reaction(emoji: '\u{2764}', reactedUserId: '1'),
      ],
      seenBy: [
        '2',
      ],
    ),
    Message(
      id: '11',
      message: "User @Jhon Doe has joined the group",
      mentions: [
        {"3": "Jhon Doe"},
      ],
      createdAt: DateTime(2025, 5, 6, 10, 10, 10),
      messageType: MessageType.system,
      sentBy: 't',
      status: MessageStatus.read,
      seenBy: [],
    ),
    Message(
      id: '11',
      message: "https://miro.medium.com/max/1000/0*s7of7kWnf9fDg4XM.jpeg",
      createdAt: DateTime.now(),
      messageType: MessageType.image,
      sentBy: '1',
      attachment: Attachment(
          name: "image",
          url: "https://miro.medium.com/max/1000/0*s7of7kWnf9fDg4XM.jpeg",
          size: 0),
      reactions: [Reaction(emoji: '\u{2764}', reactedUserId: '2')],
      status: MessageStatus.read,
      seenBy: ['2', '3', '4', '5', '6'],
    ),
    Message(
      id: '12',
      message: "🤩🤩",
      createdAt: DateTime.now(),
      sentBy: '2',
      status: MessageStatus.read,
      seenBy: ['2', '3'],
      reactions: [
        Reaction(emoji: '\u{1F60D}', reactedUserId: '2'),
        Reaction(emoji: '\u{1F60D}', reactedUserId: '3'),
      ],
    ),
  ];

  static final List<Message> oldMessages = [
    Message(
      id: '13',
      message: "Old message 1!",
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      sentBy: '1',
      status: MessageStatus.read,
      seenBy: ['2', '3'],
    ),
    Message(
      id: '14',
      message: "Old message 2!",
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      sentBy: '2',
      status: MessageStatus.read,
      seenBy: ['2', '3'],
    ),
    Message(
      id: '15',
      message: "Old message 3!",
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
      sentBy: '3',
      status: MessageStatus.read,
      seenBy: ['2', '3'],
    ),
    Message(
      id: '16',
      message: "Old message 4!",
      createdAt: DateTime.now().subtract(const Duration(days: 4)),
      sentBy: '4',
      status: MessageStatus.read,
      seenBy: ['2', '3'],
    ),
    Message(
      id: '17',
      message:
          "https://as2.ftcdn.net/v2/jpg/09/10/93/65/1000_F_910936564_QYSuokwKpGfd5U84U3JdlpwBj2dG1Pek.jpg",
      createdAt: DateTime.now(),
      messageType: MessageType.image,
      sentBy: '1',
      attachment: Attachment(
          name: "image",
          url:
              "https://as2.ftcdn.net/v2/jpg/09/10/93/65/1000_F_910936564_QYSuokwKpGfd5U84U3JdlpwBj2dG1Pek.jpg",
          size: 0),
      reactions: [Reaction(emoji: '\u{2764}', reactedUserId: '2')],
      status: MessageStatus.read,
      seenBy: ['2', '3', '4', '5', '6'],
    ),
    Message(
      id: '18',
      message:
          "https://as2.ftcdn.net/v2/jpg/01/77/45/71/1000_F_177457140_LymBSZj98h3QRdl8ETxXM6Zq3QWbVc4g.jpg",
      createdAt: DateTime.now(),
      messageType: MessageType.image,
      sentBy: '1',
      attachment: Attachment(
          name: "image",
          url:
              "https://as2.ftcdn.net/v2/jpg/01/77/45/71/1000_F_177457140_LymBSZj98h3QRdl8ETxXM6Zq3QWbVc4g.jpg",
          size: 0),
      reactions: [Reaction(emoji: '\u{2764}', reactedUserId: '2')],
      status: MessageStatus.read,
      seenBy: ['2', '3', '4', '5', '6'],
    ),
  ];
}

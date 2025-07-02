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

import 'package:chatview/chatview.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

class SpecializedMessagesExample extends StatefulWidget {
  const SpecializedMessagesExample({Key? key}) : super(key: key);

  @override
  State<SpecializedMessagesExample> createState() =>
      _SpecializedMessagesExampleState();
}

class _SpecializedMessagesExampleState
    extends State<SpecializedMessagesExample> {
  late ChatController chatController;
  final List<Message> messages = [];

  @override
  void initState() {
    super.initState();
    _initializeMessages();
  }

  void _initializeMessages() {
    // Sample voting message
    const votingMessage = VotingMessage(
      question: "What's your favorite programming language?",
      options: [
        VotingOption(id: "1", text: "Dart/Flutter", votes: 15, voters: []),
        VotingOption(id: "2", text: "JavaScript", votes: 12, voters: []),
        VotingOption(id: "3", text: "Python", votes: 18, voters: []),
        VotingOption(id: "4", text: "Java", votes: 8, voters: []),
      ],
      isVotingClosed: false,
      totalVotes: 53,
    );

    // Sample quiz message
    const quizMessage = QuizMessage(
      question: "What is Flutter?",
      options: [
        QuizOption(id: "1", text: "A programming language", isCorrect: false),
        QuizOption(id: "2", text: "A UI framework", isCorrect: true),
        QuizOption(id: "3", text: "A database", isCorrect: false),
        QuizOption(id: "4", text: "An operating system", isCorrect: false),
      ],
      explanation:
          "Flutter is Google's UI toolkit for building natively compiled applications.",
    );

    // Sample question message
    const questionMessage = QuestionMessage(
      prompt: "What's your experience with Flutter?",
      submissions: [],
    );

    // Add sample messages to the chat
    messages.addAll([
      Message(
        id: "1",
        message: jsonEncode(votingMessage.toJson()),
        messageType: MessageType.voting,
        sentBy: "user1",
        createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
      ),
      Message(
        id: "2",
        message: jsonEncode(quizMessage.toJson()),
        messageType: MessageType.quiz,
        sentBy: "user2",
        createdAt: DateTime.now().subtract(const Duration(minutes: 20)),
      ),
      Message(
        id: "3",
        message: jsonEncode(questionMessage.toJson()),
        messageType: MessageType.question,
        sentBy: "user3",
        createdAt: DateTime.now().subtract(const Duration(minutes: 10)),
      ),
    ]);

    // Set up chat controller
    final currentUser = ChatUser(
      id: "current_user",
      name: "Current User",
      profilePhoto: "https://via.placeholder.com/150",
    );

    final otherUsers = [
      ChatUser(
        id: "user1",
        name: "Alice",
        profilePhoto: "https://via.placeholder.com/150/FF6B6B/FFFFFF?text=A",
      ),
      ChatUser(
        id: "user2",
        name: "Bob",
        profilePhoto: "https://via.placeholder.com/150/4ECDC4/FFFFFF?text=B",
      ),
      ChatUser(
        id: "user3",
        name: "Charlie",
        profilePhoto: "https://via.placeholder.com/150/45B7D1/FFFFFF?text=C",
      ),
    ];

    chatController = ChatController(
      initialMessageList: messages,
      pinnedMessageList: [],
      scrollController: ScrollController(),
      currentUser: currentUser,
      otherUsers: otherUsers,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Specialized Messages Example'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: ChatView(
        chatController: chatController,
        chatViewState: ChatViewState.hasMessages,
        messageConfig: MessageConfiguration(
          // Configuration for voting messages
          votingMessageConfig: VotingMessageConfiguration(
            backgroundColor: Colors.blue[50],
            borderRadius: BorderRadius.circular(12),
            padding: const EdgeInsets.all(16),
            questionTextStyle: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
            optionTextStyle: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
            ),
            selectedOptionTextStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.blue,
            ),
            pollIconColor: Colors.blue[600],
            selectedOptionBackgroundColor: Colors.blue[100],
            selectedOptionBorderColor: Colors.blue,
            selectedRadioColor: Colors.blue,
            onVoteSubmitted: (messageId, optionId) {
              // Handle voting logic
              _handleVote(messageId, optionId);
            },
          ),
          // Configuration for quiz messages
          quizMessageConfig: QuizMessageConfiguration(
            backgroundColor: Colors.orange[50],
            borderRadius: BorderRadius.circular(12),
            padding: const EdgeInsets.all(16),
            questionTextStyle: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
            optionTextStyle: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
            ),
            selectedOptionTextStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.orange,
            ),
            correctOptionTextStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.green,
            ),
            incorrectOptionTextStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.red,
            ),
            explanationTextStyle: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
            ),
            quizIconColor: Colors.orange[600],
            selectedOptionBackgroundColor: Colors.orange[100],
            selectedOptionBorderColor: Colors.orange,
            selectedRadioColor: Colors.orange,
            correctOptionBackgroundColor: Colors.green[100],
            correctOptionBorderColor: Colors.green,
            correctCheckIconColor: Colors.green,
            incorrectOptionBackgroundColor: Colors.red[100],
            incorrectOptionBorderColor: Colors.red,
            incorrectXIconColor: Colors.red,
            explanationBackgroundColor: Colors.blue[50],
            onAnswerSubmitted: (messageId, optionId, isCorrect) {
              // Handle quiz answering logic
              _handleQuizAnswer(messageId, optionId, isCorrect);
            },
            onQuizCompleted: () {
              // Handle quiz completion
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Quiz completed!'),
                  backgroundColor: Colors.green,
                ),
              );
            },
          ),
          // Configuration for question messages
          questionMessageConfig: QuestionMessageConfiguration(
            backgroundColor: Colors.purple[50],
            borderRadius: BorderRadius.circular(12),
            padding: const EdgeInsets.all(16),
            promptTextStyle: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
            userQuestionTextStyle: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
            ),
            submitButtonTextStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
            submittedTimeTextStyle: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
            questionIconColor: Colors.purple[600],
            textFieldBackgroundColor: Colors.white,
            textFieldBorderColor: Colors.grey[300],
            textFieldFocusedBorderColor: Colors.purple,
            submitButtonBackgroundColor: Colors.purple,
            submitButtonTextColor: Colors.white,
            submitButtonDisabledBackgroundColor: Colors.grey[300],
            submitButtonDisabledTextColor: Colors.grey[600],
            textFieldHintText: 'Type your answer here...',
            textFieldMaxLines: 3,
            onQuestionSubmitted: (messageId, question) {
              // Handle question answering logic
              _handleQuestionAnswer(messageId, question);
            },
            onQuestionCancelled: () {
              // Handle question cancellation
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Question cancelled'),
                  backgroundColor: Colors.orange,
                ),
              );
            },
          ),
        ),
        sendMessageConfig: const SendMessageConfiguration(
          // Enable attachment picker with specialized message options
          attachmentPickerBottomSheetConfig:
              AttachmentPickerBottomSheetConfiguration(
            backgroundColor: Colors.white,
            bottomSheetPadding: EdgeInsets.all(16),
            enableCameraImagePicker: true,
            enableGalleryImagePicker: true,
            enableFilePicker: true,
            enableGalleryVideoPicker: true,
            enableAudioFromFilePicker: true,
            enableAudioFromUrlPicker: true,
            enableImageFromUrlPicker: true,
            enableVideoFromUrlPicker: true,
          ),
          // Customize the attachment picker icons
          imagePickerIconsConfig: ImagePickerIconsConfiguration(
            galleryImagePickerIcon: Icon(Icons.attach_file_rounded),
            galleryIconColor: Colors.blue,
          ),
        ),
        onSendTap: (message) {
          chatController.addMessage(message);
        },
      ),
    );
  }

  void _handleVote(String messageId, String optionId) {
    // Parse the voting message
    final data =
        jsonDecode(messages.firstWhere((m) => m.id == messageId).message);
    final votingMessage = VotingMessage.fromJson(data);

    // Update the voting message with the new vote
    final updatedOptions = votingMessage.options.map((option) {
      if (option.id == optionId) {
        return option.copyWith(
          votes: option.votes + 1,
          voters: [...option.voters, chatController.currentUser.id],
        );
      }
      return option;
    }).toList();

    final updatedVotingMessage = votingMessage.copyWith(
      options: updatedOptions,
      totalVotes: votingMessage.totalVotes + 1,
    );

    // Update the message
    final updatedMessage =
        messages.firstWhere((m) => m.id == messageId).copyWith(
              message: jsonEncode(updatedVotingMessage.toJson()),
            );

    chatController.replaceMessage(updatedMessage);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            'Voted for: ${updatedOptions.firstWhere((o) => o.id == optionId).text}'),
        backgroundColor: Colors.blue,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _handleQuizAnswer(String messageId, String optionId, bool isCorrect) {
    // Parse the quiz message
    debugPrint('messageId: $messageId');
    debugPrint('messages: ${messages.map((m) => m.id).toList().join(', ')}');
    final data =
        jsonDecode(messages.firstWhere((m) => m.id == messageId).message);
    final quizMessage = QuizMessage.fromJson(data);

    // Update the quiz message with the answer
    final updatedQuizMessage = quizMessage.copyWith(
      options: quizMessage.options.map((option) {
        if (option.id == optionId) {
          return option.copyWith(
              voters: [...option.voters, chatController.currentUser.id]);
        }
        return option;
      }).toList(),
    );

    // Update the message
    final updatedMessage =
        messages.firstWhere((m) => m.id == messageId).copyWith(
              message: jsonEncode(updatedQuizMessage.toJson()),
            );

    chatController.replaceMessage(updatedMessage);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isCorrect ? 'Correct! 🎉' : 'Incorrect. Try again!'),
        backgroundColor: isCorrect ? Colors.green : Colors.red,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _handleQuestionAnswer(String messageId, QuestionSubmission submission) {
    // Parse the question message

    final data =
        jsonDecode(messages.firstWhere((m) => m.id == messageId).message);
    final questionMessage = QuestionMessage.fromJson(data);

    // Update the question message with the answer
    final updatedQuestionMessage = questionMessage.copyWith(
      submissions: [
        ...questionMessage.submissions,
        submission,
      ],
    );

    // Update the message
    final updatedMessage =
        messages.firstWhere((m) => m.id == messageId).copyWith(
              message: jsonEncode(updatedQuestionMessage.toJson()),
            );

    chatController.replaceMessage(updatedMessage);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Answer submitted: ${submission.userQuestion}'),
        backgroundColor: Colors.orange,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

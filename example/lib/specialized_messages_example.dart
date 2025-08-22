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
        VotingOption(id: "1", text: "Dart/Flutter", votes: 0, voters: []),
        VotingOption(id: "2", text: "JavaScript", votes: 0, voters: [
          "user9",
          "user10",
        ]),
        VotingOption(id: "3", text: "Python", votes: 0, voters: [
          "user4",
          "user5",
          "user6",
          "user7",
          "user8",
        ]),
        VotingOption(
            id: "4",
            text: "Java",
            votes: 3,
            voters: ["user1", "user2", "user3"]),
      ],
      isVotingClosed: false,
      totalVotes: 53,
    );

    // Sample quiz message
    const quizMessage = QuizMessage(
      question: "What is Flutter?",
      options: [
        QuizOption(
            id: "1",
            text: "A programming language",
            isCorrect: false,
            voters: ["user1", "user2", "user3"]),
        QuizOption(
            id: "2",
            text: "A UI framework",
            isCorrect: true,
            voters: ["user4", "user5", "user6"]),
        QuizOption(
            id: "3",
            text: "A database",
            isCorrect: false,
            voters: ["user7", "user8", "user9"]),
        QuizOption(
            id: "4",
            text: "An operating system",
            isCorrect: false,
            voters: ["user10"]),
      ],
      explanation:
          "Flutter is Google's UI toolkit for building natively compiled applications.",
    );

    // Sample question message
    final questionMessage = QuestionMessage(
      prompt: "What's your experience with Flutter?",
      submissions: [
        QuestionSubmission(
          userId: "user1",
          userQuestion: "What's your experience with Flutter?",
        ),
        QuestionSubmission(
          userId: "user2",
          userQuestion: "What's your experience with Flutter?",
        ),
        QuestionSubmission(
          userId: "user3",
          userQuestion: "What's your experience with Flutter?",
        ),
        QuestionSubmission(
          userId: "user4",
          userQuestion: "What's your experience with Flutter?",
        ),
      ],
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
      Message(
        id: '4',
        message: jsonEncode(const QuestionMessage(
          prompt: 'What is your favorite programming language?',
          submissions: [],
        ).toJson()),
        messageType: MessageType.question,
        sentBy: 'user1',
        createdAt: DateTime.now().subtract(const Duration(minutes: 2)),
      ),
      Message(
        id: '5',
        message: jsonEncode(DailyReportMessage(
          checkboxes: [
            const DailyReportCheckbox(text: 'Complete morning tasks', id: '1'),
            const DailyReportCheckbox(text: 'Send daily report', id: '2'),
            const DailyReportCheckbox(text: 'Review pending items', id: '3'),
          ],
          userData: [
            UserDailyReportData(
              userId: 'user1',
              dailyIncome: '1200',
              packagesSent: '15',
              additionalComments: 'Good progress today',
              selectedCheckboxes: {'1': true, '2': true, '3': false},
              isSubmitted: true,
              submittedAt: DateTime.now().subtract(const Duration(hours: 2)),
            ),
            UserDailyReportData(
              userId: 'user2',
              dailyIncome: '800',
              packagesSent: '12',
              additionalComments: 'Standard day',
              selectedCheckboxes: {'1': true, '2': false, '3': true},
              isSubmitted: true,
              submittedAt: DateTime.now().subtract(const Duration(hours: 1)),
            ),
            const UserDailyReportData(
              userId: 'user3',
              dailyIncome: '',
              packagesSent: '',
              additionalComments: null,
              selectedCheckboxes: {},
              isSubmitted: false,
              submittedAt: null,
            ),
          ],
          customTitle: 'Morning Tasks Report',
          customSectionText: 'Tasks to Complete:',
          maxCompletionTime: DateTime.now().add(
              const Duration(hours: 2)), // Set to 2 hours from now for testing
        ).toJson()),
        messageType: MessageType.dailyReport,
        sentBy: 'user1',
        createdAt: DateTime.now().subtract(const Duration(minutes: 45)),
      ),
      Message(
        id: '6',
        message: jsonEncode(DailyReportStatisticsMessage(
          userStatistics: [
            UserDailyReportStatistics(
              userId: 'user1',
              dailyStats: [
                DailyReportDayStats(
                  date: DateTime.now().subtract(const Duration(days: 4)),
                  dailyIncome: '1000',
                  packagesSent: '10',
                  completedTasks: 5,
                  totalTasks: 7,
                ),
                DailyReportDayStats(
                  date: DateTime.now().subtract(const Duration(days: 3)),
                  dailyIncome: '500',
                  packagesSent: '7',
                  completedTasks: 6,
                  totalTasks: 10,
                ),
                DailyReportDayStats(
                  date: DateTime.now().subtract(const Duration(days: 2)),
                  dailyIncome: '800',
                  packagesSent: '12',
                  completedTasks: 8,
                  totalTasks: 8,
                ),
                DailyReportDayStats(
                  date: DateTime.now().subtract(const Duration(days: 1)),
                  dailyIncome: '1200',
                  packagesSent: '15',
                  completedTasks: 9,
                  totalTasks: 10,
                ),
                DailyReportDayStats(
                  date: DateTime.now(),
                  dailyIncome: '900',
                  packagesSent: '11',
                  completedTasks: 7,
                  totalTasks: 9,
                ),
              ],
              summaryStats: const DailyReportSummaryStats(
                totalIncome: '4400',
                totalPackages: '55',
                totalCompletedTasks: 35,
                totalTasks: 44,
              ),
            ),
            UserDailyReportStatistics(
              userId: 'user2',
              dailyStats: [
                DailyReportDayStats(
                  date: DateTime.now().subtract(const Duration(days: 4)),
                  dailyIncome: '800',
                  packagesSent: '8',
                  completedTasks: 4,
                  totalTasks: 6,
                ),
                DailyReportDayStats(
                  date: DateTime.now().subtract(const Duration(days: 3)),
                  dailyIncome: '600',
                  packagesSent: '6',
                  completedTasks: 5,
                  totalTasks: 8,
                ),
                DailyReportDayStats(
                  date: DateTime.now().subtract(const Duration(days: 2)),
                  dailyIncome: '700',
                  packagesSent: '9',
                  completedTasks: 6,
                  totalTasks: 7,
                ),
                DailyReportDayStats(
                  date: DateTime.now().subtract(const Duration(days: 1)),
                  dailyIncome: '900',
                  packagesSent: '11',
                  completedTasks: 7,
                  totalTasks: 9,
                ),
                DailyReportDayStats(
                  date: DateTime.now(),
                  dailyIncome: '750',
                  packagesSent: '8',
                  completedTasks: 5,
                  totalTasks: 8,
                ),
              ],
              summaryStats: const DailyReportSummaryStats(
                totalIncome: '3750',
                totalPackages: '42',
                totalCompletedTasks: 27,
                totalTasks: 38,
              ),
            ),
            UserDailyReportStatistics(
              userId: 'user3',
              dailyStats: [
                DailyReportDayStats(
                  date: DateTime.now().subtract(const Duration(days: 4)),
                  dailyIncome: '1200',
                  packagesSent: '12',
                  completedTasks: 6,
                  totalTasks: 8,
                ),
                DailyReportDayStats(
                  date: DateTime.now().subtract(const Duration(days: 3)),
                  dailyIncome: '1100',
                  packagesSent: '10',
                  completedTasks: 7,
                  totalTasks: 9,
                ),
                DailyReportDayStats(
                  date: DateTime.now().subtract(const Duration(days: 2)),
                  dailyIncome: '1300',
                  packagesSent: '14',
                  completedTasks: 8,
                  totalTasks: 10,
                ),
                DailyReportDayStats(
                  date: DateTime.now().subtract(const Duration(days: 1)),
                  dailyIncome: '1400',
                  packagesSent: '16',
                  completedTasks: 9,
                  totalTasks: 11,
                ),
                DailyReportDayStats(
                  date: DateTime.now(),
                  dailyIncome: '1250',
                  packagesSent: '13',
                  completedTasks: 8,
                  totalTasks: 10,
                ),
              ],
              summaryStats: const DailyReportSummaryStats(
                totalIncome: '6250',
                totalPackages: '65',
                totalCompletedTasks: 38,
                totalTasks: 48,
              ),
            ),
          ],
          customTitle: 'Weekly Performance Report',
          customSubtitle: 'Statistics for all team members',
          generatedAt: DateTime.now(),
        ).toJson()),
        messageType: MessageType.dailyReportStatistics,
        sentBy: 'user1',
        createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
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
      ChatUser(
        id: "user4",
        name: "David",
        profilePhoto: "https://via.placeholder.com/150/45B7D1/FFFFFF?text=D",
      ),
      ChatUser(
        id: "user5",
        name: "Eve",
        profilePhoto: "https://via.placeholder.com/150/45B7D1/FFFFFF?text=E",
      ),
      ChatUser(
        id: "user6",
        name: "Frank",
        profilePhoto: "https://via.placeholder.com/150/45B7D1/FFFFFF?text=F",
      ),
      ChatUser(
        id: "user7",
        name: "George",
        profilePhoto: "https://via.placeholder.com/150/45B7D1/FFFFFF?text=G",
      ),
      ChatUser(
        id: "user8",
        name: "Henry",
        profilePhoto: "https://via.placeholder.com/150/45B7D1/FFFFFF?text=H",
      ),
      ChatUser(
        id: "user9",
        name: "Ivy",
        profilePhoto: "https://via.placeholder.com/150/45B7D1/FFFFFF?text=I",
      ),
      ChatUser(
        id: "user10",
        name: "Jack",
        profilePhoto: "https://via.placeholder.com/150/45B7D1/FFFFFF?text=J",
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
        actions: [
          IconButton(
            onPressed: () {
              chatController.setReplySuggestionsDirection(Axis.vertical);
              chatController.addReplySuggestions(
                [
                  const SuggestionItemData(
                    id: "1",
                    text: "Option 1",
                  ),
                  const SuggestionItemData(
                    id: "2",
                    text:
                        "Very long text that should be wrapped in the suggestion list and should be aligned to the left and right",
                  ),
                  const SuggestionItemData(
                    id: "3",
                    text: "Option 3",
                  )
                ],
              );
            },
            icon: const Icon(Icons.chair),
          ),
        ],
      ),
      body: ChatView(
        chatController: chatController,
        chatViewState: ChatViewState.hasMessages,
        pinnedMessageConfiguration: const PinnedMessageConfiguration(
          allowPinMessage: true,
          allowRemoveMessage: true,
        ),
        messageConfig: MessageConfiguration(
          // Configuration for voting messages
          votingMessageConfig: VotingMessageConfiguration(
            backgroundColor: Colors.blue[50],
            borderRadius: BorderRadius.circular(12),
            padding: const EdgeInsets.all(16),
            showDetailsButton: true,
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
            showDetailsButton: true,
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
          dailyReportMessageConfig: DailyReportMessageConfiguration(
            backgroundColor: Colors.teal[50],
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.teal[200]!, width: 2),
            maxWidth: 350,
            iconColor: Colors.teal[800],
            titleTextStyle: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.teal[900],
            ),
            sectionTitleTextStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.teal[800],
            ),
            fieldBackgroundColor: Colors.white,
            submitButtonText: 'Submit Report',
            onReportSubmitted: ({
              required String messageId,
              required UserDailyReportData userDailyReportData,
            }) {
              _handleDailyReport(messageId, userDailyReportData);
            },
          ),
          dailyReportStatisticsMessageConfig:
              DailyReportStatisticsMessageConfiguration(
            backgroundColor: Colors.indigo[50],
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.indigo[200]!, width: 2),
            maxWidth: 400,
            headerBackgroundColor: Colors.indigo[100],
            headerIconColor: Colors.indigo[700],
            headerTitleTextStyle: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.indigo[900],
            ),
            headerSubtitleTextStyle: TextStyle(
              fontSize: 14,
              color: Colors.indigo[700],
            ),
            dayStatsBackgroundColor: Colors.white,
            dayStatsBorderRadius: BorderRadius.circular(12),
            dayStatsBorder: Border.all(color: Colors.indigo[100]!),
            dayStatsTitleTextStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.indigo[800],
            ),
            dayStatsValueTextStyle: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.indigo[700],
            ),
            dayStatsLabelTextStyle: TextStyle(
              fontSize: 12,
              color: Colors.indigo[600],
            ),
            summaryBackgroundColor: Colors.green[50],
            summaryBorderRadius: BorderRadius.circular(12),
            summaryBorder: Border.all(color: Colors.green[200]!),
            summaryTitleTextStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.green[800],
            ),
            summaryValueTextStyle: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.green[700],
            ),
            summaryLabelTextStyle: TextStyle(
              fontSize: 12,
              color: Colors.green[600],
            ),
            taskCompletionColor: Colors.green[600],
            taskIncompleteColor: Colors.orange[600],
            taskCompletionTextStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            onStatsTapped: () {},
          ),
          // Current user ID for filtering user-specific data
          currentUserId: 'user1', // This will show statistics for user1
          // Change to 'user2' to see user2's statistics, or 'user3' for user3's statistics
        ),
        sendMessageConfig: const SendMessageConfiguration(
          // Enable attachment picker with specialized message options
          gifPickerConfiguration: GifPickerConfiguration(
            apiKey: 'yecm82d7ivn5Mwtnot2TkgkjNRGdeQQ5',
            lang: "pl",
            randomID: "123",
            tabColor: Colors.blue,
            debounceTimeInMilliseconds: 350,
          ),
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
          debugPrint('message: ${message.toJson()}');
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

  void _handleDailyReport(
    String messageId,
    UserDailyReportData userDailyReportData,
  ) {
    // Parse the daily report message
    final data = jsonDecode(messages
        .firstWhere((m) => m.messageType == MessageType.dailyReport)
        .message);
    final dailyReportMessage = DailyReportMessage.fromJson(data);

    // Create or update the current user's data
    final currentUserId = chatController.currentUser.id;
    final existingUserData = dailyReportMessage.getUserData(currentUserId);

    final newUserData = UserDailyReportData(
      userId: currentUserId,
      dailyIncome: userDailyReportData.dailyIncome,
      packagesSent: userDailyReportData.packagesSent,
      additionalComments: userDailyReportData.additionalComments,
      selectedCheckboxes: userDailyReportData.selectedCheckboxes,
      isSubmitted: true,
      submittedAt: DateTime.now(),
    );

    // Update the daily report message with the new user data
    List<UserDailyReportData> updatedUserData;
    if (existingUserData != null) {
      // Update existing user data
      updatedUserData = dailyReportMessage.userData.map((data) {
        if (data.userId == currentUserId) {
          return newUserData;
        }
        return data;
      }).toList();
    } else {
      // Add new user data
      updatedUserData = [...dailyReportMessage.userData, newUserData];
    }

    final updatedDailyReportMessage = dailyReportMessage.copyWith(
      userData: updatedUserData,
    );

    // Update the message
    final updatedMessage = messages
        .firstWhere((m) => m.messageType == MessageType.dailyReport)
        .copyWith(
          message: jsonEncode(updatedDailyReportMessage.toJson()),
        );

    chatController.replaceMessage(updatedMessage);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text('Daily report submitted: ${userDailyReportData.toJson()}'),
        backgroundColor: Colors.teal,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

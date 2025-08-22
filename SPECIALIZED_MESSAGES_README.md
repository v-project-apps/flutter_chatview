# Specialized Messages Feature

This Flutter chatview package now supports three types of specialized messages: **Polls (Voting)**, **Quizzes**, and **Ask-a-Question** messages. These messages provide interactive functionality within the chat interface.

## Features

### 🗳️ Poll/Voting Messages
- Create polls with multiple options
- Real-time voting with visual feedback
- Progress bars showing vote distribution
- Vote count display
- Configurable colors, styles, and callbacks

### 🧠 Quiz Messages
- Multiple choice questions with correct/incorrect answers
- Immediate feedback on answer selection
- Explanation display after answering
- Score tracking
- Configurable colors, styles, and callbacks

### ❓ Question Messages
- Interactive question prompts
- Text input for user responses
- Submit/cancel functionality
- Timestamp display
- Configurable colors, styles, and callbacks

## Configuration System

Each specialized message type has its own configuration class that allows you to customize:

### Colors
- Background colors
- Border colors
- Text colors
- Icon colors
- Progress bar colors

### Styles
- Text styles for different elements
- Border radius
- Padding
- Button styles

### Callbacks
- Event handlers for user interactions
- Custom logic for vote submission
- Quiz answer validation
- Question submission handling

## Usage

### 1. Basic Setup

```dart
import 'package:chatview/chatview.dart';

ChatView(
  chatController: chatController,
  messageConfig: MessageConfiguration(
    // Configure specialized messages here
    votingMessageConfig: VotingMessageConfiguration(...),
    quizMessageConfig: QuizMessageConfiguration(...),
    questionMessageConfig: QuestionMessageConfiguration(...),
  ),
)
```

### 2. Voting Message Configuration

```dart
VotingMessageConfiguration(
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
  onVoteSubmitted: (optionId) {
    // Handle vote submission
    print('Vote submitted for option: $optionId');
  },
)
```

### 3. Quiz Message Configuration

```dart
QuizMessageConfiguration(
  backgroundColor: Colors.orange[50],
  borderRadius: BorderRadius.circular(12),
  padding: const EdgeInsets.all(16),
  questionTextStyle: const TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: Colors.black87,
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
  correctOptionBackgroundColor: Colors.green[100],
  correctOptionBorderColor: Colors.green,
  correctCheckIconColor: Colors.green,
  incorrectOptionBackgroundColor: Colors.red[100],
  incorrectOptionBorderColor: Colors.red,
  incorrectXIconColor: Colors.red,
  explanationBackgroundColor: Colors.blue[50],
  onAnswerSubmitted: (optionId, isCorrect) {
    // Handle quiz answer
    print('Quiz answer: $optionId, Correct: $isCorrect');
  },
  onQuizCompleted: () {
    // Handle quiz completion
    print('Quiz completed!');
  },
)
```

### 4. Question Message Configuration

```dart
QuestionMessageConfiguration(
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
  onQuestionSubmitted: (question) {
    // Handle question submission
    print('Question submitted: $question');
  },
  onQuestionCancelled: () {
    // Handle question cancellation
    print('Question cancelled');
  },
)
```

## Data Models

### VotingMessage
```dart
VotingMessage(
  question: "What's your favorite color?",
  options: [
    VotingOption(id: "1", text: "Red", votes: 5),
    VotingOption(id: "2", text: "Blue", votes: 8),
    VotingOption(id: "3", text: "Green", votes: 3),
  ],
  selectedOptionId: "2", // User's vote
  isVotingClosed: false,
  totalVotes: 16,
)
```

### QuizMessage
```dart
QuizMessage(
  question: "What is Flutter?",
  options: [
    QuizOption(id: "1", text: "A programming language", isCorrect: false),
    QuizOption(id: "2", text: "A UI framework", isCorrect: true),
    QuizOption(id: "3", text: "A database", isCorrect: false),
  ],
  selectedOptionId: "2", // User's answer
  isAnswered: true,
  explanation: "Flutter is Google's UI toolkit for building natively compiled applications.",
)
```

### QuestionMessage
```dart
QuestionMessage(
  prompt: "What's your experience with Flutter?",
  userQuestion: "I've been using Flutter for 2 years and love it!",
  isSubmitted: true,
  submittedAt: DateTime.now(),
)
```

## Creating Specialized Messages

### Using Attachment Picker

1. Tap the attachment icon in the chat input
2. Select "Poll", "Quiz", or "Question" from the specialized message options
3. Fill out the form with your content
4. Tap "Send" to create the message

### Programmatically

```dart
// Create a voting message
final votingMessage = VotingMessage(
  question: "What's your favorite color?",
  options: [
    VotingOption(id: "1", text: "Red"),
    VotingOption(id: "2", text: "Blue"),
    VotingOption(id: "3", text: "Green"),
  ],
);

final message = Message(
  id: DateTime.now().millisecondsSinceEpoch.toString(),
  message: jsonEncode(votingMessage.toJson()),
  messageType: MessageType.voting,
  sentBy: currentUser.id,
  createdAt: DateTime.now(),
);

chatController.addMessage(message);
```

## Event Handling

### Voting Events
```dart
onVoteSubmitted: (optionId) {
  // Handle vote submission
  // Update vote counts, close voting, etc.
}
```

### Quiz Events
```dart
onAnswerSubmitted: (optionId, isCorrect) {
  // Handle quiz answer
  // Show results, update scores, etc.
}

onQuizCompleted: () {
  // Handle quiz completion
  // Show final results, award points, etc.
}
```

### Question Events
```dart
onQuestionSubmitted: (question) {
  // Handle question submission
  // Save answer, notify others, etc.
}

onQuestionCancelled: () {
  // Handle question cancellation
  // Reset form, show message, etc.
}
```

## Best Practices

1. **Consistent Styling**: Use consistent colors and styles across all specialized message types
2. **Clear Callbacks**: Implement meaningful callback functions for user interactions
3. **Error Handling**: Handle edge cases like network errors or invalid data
4. **Accessibility**: Ensure proper contrast ratios and readable text sizes
5. **Performance**: Avoid heavy computations in callback functions

## Troubleshooting

### Messages Not Appearing
- Ensure the message type is correctly set (`MessageType.voting`, `MessageType.quiz`, `MessageType.question`)
- Check that the JSON data is properly formatted
- Verify that the configuration is properly set in `MessageConfiguration`

### Callbacks Not Working
- Ensure callback functions are properly defined
- Check that the configuration is passed to the correct message type
- Verify that the callback signature matches the expected parameters

### Styling Issues
- Check that all required configuration properties are set
- Ensure colors have proper contrast ratios
- Verify that text styles are properly defined

### Context Unmounted Error
If you encounter the error "This widget has been unmounted, so the State no longer has a context", this typically happens when:

1. **Creation Forms**: The error occurs in the specialized message creation forms (poll, quiz, question)
2. **Async Operations**: The form tries to access context after being closed
3. **Navigation**: The widget is unmounted before async operations complete

**Solution**: The issue has been fixed by adding `mounted` checks before accessing context:

```dart
// Before (causing error)
ScaffoldMessenger.of(context).showSnackBar(...);

// After (fixed)
if (mounted) {
  ScaffoldMessenger.of(context).showSnackBar(...);
}
```

**Prevention**: Always check if the widget is still mounted before accessing context in async operations or callbacks.

## Example Implementation

See `example/lib/specialized_messages_example.dart` for a complete implementation example showing all three message types with full configuration and event handling. 
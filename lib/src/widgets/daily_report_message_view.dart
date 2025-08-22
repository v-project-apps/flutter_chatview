import 'dart:developer';

import 'package:chatview/src/extensions/extensions.dart';
import 'package:flutter/material.dart';
import 'package:chatview/chatview.dart';
import 'dart:convert';

class DailyReportMessageView extends StatefulWidget {
  final Message message;
  final bool isMessageBySender;
  final ChatBubble? inComingChatBubbleConfig;
  final ChatBubble? outgoingChatBubbleConfig;
  final double? chatBubbleMaxWidth;
  final MessageReactionConfiguration? messageReactionConfig;
  final DailyReportMessageConfiguration? dailyReportMessageConfiguration;

  const DailyReportMessageView({
    Key? key,
    required this.message,
    required this.isMessageBySender,
    this.inComingChatBubbleConfig,
    this.outgoingChatBubbleConfig,
    this.chatBubbleMaxWidth,
    this.messageReactionConfig,
    this.dailyReportMessageConfiguration,
  }) : super(key: key);

  @override
  State<DailyReportMessageView> createState() => _DailyReportMessageViewState();
}

class _DailyReportMessageViewState extends State<DailyReportMessageView> {
  DailyReportMessage? _dailyReportMessage;
  UserDailyReportData? _currentUserData;
  final TextEditingController _incomeController = TextEditingController();
  final TextEditingController _packagesController = TextEditingController();
  final TextEditingController _commentsController = TextEditingController();
  bool _isSubmitted = false;

  @override
  void initState() {
    super.initState();

    // Log callback configuration
    final config = widget.dailyReportMessageConfiguration;
    log('DailyReportMessageView initialized');
    log('  onReportSubmitted callback: ${config?.onReportSubmitted != null}');
    log('  message ID: ${widget.message.id}');

    // Try to parse immediately in initState as well
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_dailyReportMessage == null) {
        _parseDailyReportMessage();
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Parse immediately if not already parsed
    if (_dailyReportMessage == null) {
      _parseDailyReportMessage();
    }
  }

  @override
  void dispose() {
    _incomeController.dispose();
    _packagesController.dispose();
    _commentsController.dispose();
    super.dispose();
  }

  void _parseDailyReportMessage() {
    try {
      log('Parsing daily report message');

      // Validate message structure first
      if (widget.message.message.isEmpty) {
        throw Exception('Message content is empty');
      }

      final messageData = jsonDecode(widget.message.message);

      // Validate that we have the expected structure
      if (messageData is! Map<String, dynamic>) {
        throw Exception('Message data is not a valid JSON object');
      }

      if (!messageData.containsKey('checkboxes')) {
        throw Exception('Message data missing required field: checkboxes');
      }

      // userData can be empty when no users have submitted yet
      if (!messageData.containsKey('userData')) {
        throw Exception('Message data missing required field: userData');
      }

      final parsedMessage = DailyReportMessage.fromJson(messageData);

      // Validate parsed message - checkboxes are required, userData can be empty
      if (parsedMessage.checkboxes.isEmpty) {
        throw Exception('Parsed message has no checkboxes');
      }

      if (mounted) {
        setState(() {
          _dailyReportMessage = parsedMessage;
          final currentUserId = chatViewIW?.chatController.currentUser.id;
          // Get data for the current user
          if (currentUserId != null) {
            _currentUserData = parsedMessage.getUserData(currentUserId);
            if (_currentUserData != null) {
              _incomeController.text = _currentUserData!.dailyIncome;
              _packagesController.text = _currentUserData!.packagesSent;
              _commentsController.text =
                  _currentUserData!.additionalComments ?? '';
              _isSubmitted = _currentUserData!.isSubmitted;
            } else {
              // Create default user data if not found
              // This happens when no users have submitted yet or when this is a new user
              _currentUserData = UserDailyReportData(
                userId: currentUserId,
                dailyIncome: '',
                packagesSent: '',
                additionalComments: null,
                selectedCheckboxes: {},
                isSubmitted: false,
                submittedAt: null,
              );
              _incomeController.text = '';
              _packagesController.text = '';
              _commentsController.text = '';
              _isSubmitted = false;
            }
          }
        });
      }
      log('Parsing completed - _dailyReportMessage: ${_dailyReportMessage != null}');
    } catch (e) {
      log('Error parsing DailyReportMessage: $e');
      if (mounted) {
        setState(() {
          _dailyReportMessage = null;
          _currentUserData = null;
          _isSubmitted = false;
        });
      }
    }
  }

  void _submitReport() {
    // Allow submission if at least one checkbox is selected or if required fields are filled
    final hasCheckboxSelections =
        _currentUserData?.selectedCheckboxes.values.any((checked) => checked) ??
            false;
    final hasRequiredFields = _incomeController.text.trim().isNotEmpty &&
        _packagesController.text.trim().isNotEmpty;

    if (!hasCheckboxSelections && !hasRequiredFields) {
      log('Submit blocked: no checkbox selections and no required fields');
      return;
    }

    log('Submitting report...');

    // Ensure we have the latest checkbox selections in the current user data
    if (_currentUserData != null) {
      setState(() {
        _currentUserData = _currentUserData!.copyWith(
          dailyIncome: _incomeController.text.trim(),
          packagesSent: _packagesController.text.trim(),
          additionalComments: _commentsController.text.trim().isEmpty
              ? null
              : _commentsController.text.trim(),
          isSubmitted: true,
          submittedAt: DateTime.now(),
        );
        _isSubmitted = true;
      });
    }

    // Call the callback with the submitted data
    final config = widget.dailyReportMessageConfiguration;
    if (config?.onReportSubmitted != null && _currentUserData != null) {
      log('Calling onReportSubmitted callback with complete data');
      log('  Checkboxes: ${_currentUserData!.selectedCheckboxes}');
      log('  Income: ${_currentUserData!.dailyIncome}');
      log('  Packages: ${_currentUserData!.packagesSent}');

      config!.onReportSubmitted!.call(
        messageId: widget.message.id,
        userDailyReportData: _currentUserData!,
      );
    } else {
      log('Warning: Cannot submit report - callback or user data is null');
      log('  config?.onReportSubmitted: ${config?.onReportSubmitted != null}');
      log('  _currentUserData: ${_currentUserData != null}');
    }
  }

  void _logCurrentState(String action) {
    log('=== $action ===');
    log('  _isSubmitted: $_isSubmitted');
    log('  _currentUserData exists: ${_currentUserData != null}');
    if (_currentUserData != null) {
      log('  userId: ${_currentUserData!.userId}');
      log('  selectedCheckboxes: ${_currentUserData!.selectedCheckboxes}');
      log('  isSubmitted: ${_currentUserData!.isSubmitted}');
    }
    log('  callback exists: ${widget.dailyReportMessageConfiguration?.onReportSubmitted != null}');
    log('================');
  }

  /// Save checkbox changes incrementally without creating a full submission
  /// This prevents duplicate user data entries while allowing real-time updates
  void _saveCheckboxChanges() {
    if (_currentUserData == null) return;

    final config = widget.dailyReportMessageConfiguration;
    if (config?.onReportSubmitted != null) {
      log('Saving incremental checkbox changes to Firebase');
      log('  Current checkboxes: ${_currentUserData!.selectedCheckboxes}');
      log('  User ID: ${_currentUserData!.userId}');
      log('  Is submitted: ${_currentUserData!.isSubmitted}');

      // Create a copy with current checkbox state but maintain submission status
      final incrementalData = _currentUserData!.copyWith(
        // Keep existing form data
        dailyIncome: _incomeController.text.trim(),
        packagesSent: _packagesController.text.trim(),
        additionalComments: _commentsController.text.trim().isEmpty
            ? null
            : _commentsController.text.trim(),
        // Don't change submission status for incremental saves
        isSubmitted: _isSubmitted,
        submittedAt: _isSubmitted ? _currentUserData!.submittedAt : null,
      );

      log('Sending incremental update to Firebase with data: ${incrementalData.toJson()}');
      log('  This is an UPDATE operation, not a new submission');

      config!.onReportSubmitted!.call(
        messageId: widget.message.id,
        userDailyReportData: incrementalData,
      );
    } else {
      log('Warning: onReportSubmitted callback is null - cannot save checkbox changes');
    }
  }

  void _onCheckboxChanged(String checkboxId, bool? value) {
    if (value == null) return;

    _logCurrentState('Before checkbox change: $checkboxId = $value');

    setState(() {
      // Create user data if it doesn't exist
      if (_currentUserData == null) {
        _currentUserData = UserDailyReportData(
          userId: chatViewIW?.chatController.currentUser.id ?? '',
          dailyIncome: _incomeController.text.trim(),
          packagesSent: _packagesController.text.trim(),
          additionalComments: _commentsController.text.trim().isEmpty
              ? null
              : _commentsController.text.trim(),
          selectedCheckboxes: {checkboxId: value},
          isSubmitted: _isSubmitted, // Keep current submission status
          submittedAt: _isSubmitted ? DateTime.now() : null,
        );
      } else {
        // Update the current user's checkbox selections
        final currentUserData = _currentUserData!;
        final updatedSelectedCheckboxes =
            Map<String, bool>.from(currentUserData.selectedCheckboxes);
        updatedSelectedCheckboxes[checkboxId] = value;

        // Create updated user data
        _currentUserData = currentUserData.copyWith(
          selectedCheckboxes: updatedSelectedCheckboxes,
          // Don't change submission status here, just update checkboxes
        );
      }
    });

    _logCurrentState('After checkbox change: $checkboxId = $value');

    // Save checkbox changes immediately to Firebase
    // This will update the existing user data entry, not create a new one
    _saveCheckboxChanges();
  }

  bool _isDataValid() {
    if (_dailyReportMessage == null) return false;

    // Check if we have the minimum required data
    if (_dailyReportMessage!.checkboxes.isEmpty) return false;

    return true;
  }

  UserDailyReportData? _getCurrentUserData() {
    if (_currentUserData == null && _dailyReportMessage != null) {
      final currentUserId = chatViewIW?.chatController.currentUser.id;
      if (currentUserId != null) {
        _currentUserData = _dailyReportMessage!.getUserData(currentUserId);
      }
    }
    return _currentUserData;
  }

  @override
  Widget build(BuildContext context) {
    if (!_isDataValid()) {
      log('Data is invalid, returning SizedBox.shrink()');
      return const SizedBox.shrink();
    }

    // Ensure we have current user data
    _getCurrentUserData();

    final config = widget.dailyReportMessageConfiguration;
    final isSender = widget.isMessageBySender;

    return Container(
      constraints: BoxConstraints(
        maxWidth: widget.chatBubbleMaxWidth ??
            MediaQuery.of(context).size.width * 0.35,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 10,
      ),
      child: Container(
        padding: config?.padding ?? const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: config?.backgroundColor ??
              (isSender ? Colors.blue[50] : Colors.grey[50]),
          borderRadius: config?.borderRadius ?? BorderRadius.circular(12),
          border: config?.border ??
              Border.all(
                color: isSender ? Colors.blue[200]! : Colors.grey[300]!,
                width: 1,
              ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(config),
            const SizedBox(height: 16),
            _buildCheckboxesSection(config),
            const SizedBox(height: 16),
            _buildUserDataFields(config),
            if (!_isSubmitted) ...[
              const SizedBox(height: 16),
              _buildSubmitButton(config),
            ],
            if (_isSubmitted) ...[
              const SizedBox(height: 8),
              _buildSubmittedIndicator(config),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(DailyReportMessageConfiguration? config) {
    final title = _dailyReportMessage?.customTitle ?? 'Daily Report';
    return Row(
      children: [
        Icon(
          Icons.assignment,
          color: config?.iconColor ?? Colors.blue[600],
          size: 24,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            title,
            style: config?.titleTextStyle ??
                const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
          ),
        ),
      ],
    );
  }

  Widget _buildUserDataFields(DailyReportMessageConfiguration? config) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your Daily Data',
          style: config?.sectionTitleTextStyle ??
              const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: TextFormField(
            controller: _incomeController,
            enabled: !_isSubmitted,
            decoration: InputDecoration(
              labelText: 'Twój przychód z dzisiejszego dnia [zł]:',
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              filled: true,
              fillColor: config?.fieldBackgroundColor ?? Colors.white,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            style: config?.fieldValueTextStyle ??
                const TextStyle(fontSize: 14, color: Colors.black87),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: TextFormField(
            controller: _packagesController,
            enabled: !_isSubmitted,
            decoration: InputDecoration(
              labelText: 'Ilość wysłanych paczek:',
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              filled: true,
              fillColor: config?.fieldBackgroundColor ?? Colors.white,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            style: config?.fieldValueTextStyle ??
                const TextStyle(fontSize: 14, color: Colors.black87),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: TextFormField(
            controller: _commentsController,
            enabled: !_isSubmitted,
            maxLines: 3,
            decoration: InputDecoration(
              labelText: 'Dodatkowe komentarze:',
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              filled: true,
              fillColor: config?.fieldBackgroundColor ?? Colors.white,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            style: config?.fieldValueTextStyle ??
                const TextStyle(fontSize: 14, color: Colors.black87),
          ),
        ),
      ],
    );
  }

  Widget _buildCheckboxesSection(DailyReportMessageConfiguration? config) {
    final checkboxes = _dailyReportMessage?.checkboxes ?? [];
    final sectionText =
        _dailyReportMessage?.customSectionText ?? 'Tasks to Complete:';

    if (checkboxes.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          sectionText,
          style: config?.sectionTitleTextStyle ??
              const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
        ),
        const SizedBox(height: 12),
        ...checkboxes.map((checkbox) {
          final isChecked =
              _currentUserData?.selectedCheckboxes[checkbox.id] ?? false;
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Checkbox(
                  value: isChecked,
                  onChanged: (value) => _onCheckboxChanged(checkbox.id, value),
                  activeColor: config?.checkboxActiveColor ?? Colors.blue[600],
                  checkColor: config?.checkboxCheckColor ?? Colors.white,
                ),
                Expanded(
                  child: Text(
                    checkbox.text,
                    style: (config?.checkboxTextStyle ??
                            const TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                            ))
                        .copyWith(
                      decoration: isChecked ? TextDecoration.lineThrough : null,
                      decorationColor: Colors.grey[600],
                      decorationThickness: 2,
                      color: isChecked ? Colors.grey[600] : null,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildSubmitButton(DailyReportMessageConfiguration? config) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _submitReport,
        style: ElevatedButton.styleFrom(
          backgroundColor: config?.submitButtonColor ?? Colors.blue[600],
          foregroundColor: config?.submitButtonTextColor ?? Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          config?.submitButtonText ?? 'Submit Report',
          style: config?.submitButtonTextStyle ??
              const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
        ),
      ),
    );
  }

  Widget _buildSubmittedIndicator(DailyReportMessageConfiguration? config) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.blue[200]!),
      ),
      child: Row(
        children: [
          Icon(
            Icons.check_circle,
            color: Colors.blue[600],
            size: 16,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Report submitted. Fields are locked but checkboxes remain active.',
              style: TextStyle(
                fontSize: 12,
                color: Colors.blue[700],
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

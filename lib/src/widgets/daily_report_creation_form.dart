import 'package:chatview/chatview.dart';
import 'package:flutter/material.dart';
import 'dart:developer';

class DailyReportCreationForm extends StatefulWidget {
  const DailyReportCreationForm({
    Key? key,
    required this.onDailyReportCreated,
    this.theme,
  }) : super(key: key);

  final Function(DailyReportMessage) onDailyReportCreated;
  final ThemeData? theme;

  @override
  State<DailyReportCreationForm> createState() =>
      _DailyReportCreationFormState();
}

class _DailyReportCreationFormState extends State<DailyReportCreationForm>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final List<TextEditingController> _checkboxControllers = [];
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _sectionTextController = TextEditingController();
  DateTime? _maxCompletionTime;
  final List<AnimationController> _animationControllers = [];
  final List<Animation<Offset>> _animations = [];

  @override
  void initState() {
    super.initState();
    // Start with 2 default checkboxes
    _addCheckbox();
    _addCheckbox();

    // Set default values
    _titleController.text = 'Daily Report';
    _sectionTextController.text = 'Tasks to Complete:';

    // Set default max completion time to end of current day
    _maxCompletionTime = DateTime.now().copyWith(
      hour: 23,
      minute: 59,
      second: 59,
      millisecond: 0,
      microsecond: 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        constraints: const BoxConstraints(maxWidth: 500),
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 24),
                _buildCustomizationFields(),
                const SizedBox(height: 16),
                _buildCheckboxesSection(),
                const SizedBox(height: 24),
                _buildSubmitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Icon(
          Icons.assessment,
          color: widget.theme?.primaryColor ?? Colors.blue,
          size: 28,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Create Daily Report',
                style: widget.theme?.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ) ??
                    const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Text(
                'Configure checkboxes for users to select',
                style: widget.theme?.textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ) ??
                    TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.close),
        ),
      ],
    );
  }

  Widget _buildCustomizationFields() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Customization',
            style: widget.theme?.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ) ??
                const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _titleController,
            decoration: InputDecoration(
              labelText: 'Report Title',
              hintText: 'Enter custom report title',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Report title is required';
              }
              return null;
            },
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _sectionTextController,
            decoration: InputDecoration(
              labelText: 'Section Header Text',
              hintText: 'Enter custom section header text',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Section header text is required';
              }
              return null;
            },
          ),
          const SizedBox(height: 12),
          InkWell(
            onTap: () => _selectMaxCompletionTime(),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(6),
                color: Colors.white,
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.access_time,
                    color: Colors.grey[600],
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Max Completion Time',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        Text(
                          _maxCompletionTime != null
                              ? _formatDateTime(_maxCompletionTime!)
                              : 'Select time',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_drop_down,
                    color: Colors.grey[600],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckboxesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Checkboxes',
              style: widget.theme?.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ) ??
                  const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            TextButton.icon(
              onPressed: _addCheckbox,
              icon: const Icon(Icons.add),
              label: const Text('Add Checkbox'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...List.generate(
            _checkboxControllers.length, (index) => _buildCheckboxField(index)),
      ],
    );
  }

  Widget _buildCheckboxField(int index) {
    return AnimatedBuilder(
      animation: _animationControllers[index],
      builder: (context, child) {
        return SlideTransition(
          position: _animations[index],
          child: FadeTransition(
            opacity: _animationControllers[index],
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _checkboxControllers[index],
                      decoration: InputDecoration(
                        hintText: 'Enter checkbox description',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Checkbox description is required';
                        }
                        return null;
                      },
                    ),
                  ),
                  if (_checkboxControllers.length > 2)
                    IconButton(
                      onPressed: () => _removeCheckbox(index),
                      icon: const Icon(Icons.remove_circle_outline),
                      color: Colors.red[400],
                      iconSize: 20,
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _submitDailyReport,
        style: ElevatedButton.styleFrom(
          backgroundColor: widget.theme?.primaryColor ?? Colors.blue,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: const Text(
          'Create Daily Report',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  void _addCheckbox() {
    setState(() {
      _checkboxControllers.add(TextEditingController());
      _animationControllers.add(AnimationController(
        duration: const Duration(milliseconds: 300),
        vsync: this,
      ));
      _animations.add(Tween<Offset>(
        begin: const Offset(-0.5, 0.0),
        end: const Offset(0.0, 0.0),
      ).animate(CurvedAnimation(
        parent: _animationControllers.last,
        curve: Curves.easeOut,
      )));
    });
    _animationControllers.last.forward();
  }

  void _removeCheckbox(int index) {
    setState(() {
      _checkboxControllers[index].dispose();
      _checkboxControllers.removeAt(index);
      _animationControllers[index].dispose();
      _animationControllers.removeAt(index);
      _animations.removeAt(index);
    });
  }

  void _selectMaxCompletionTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _maxCompletionTime != null
          ? TimeOfDay.fromDateTime(_maxCompletionTime!)
          : TimeOfDay.now(),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        // Convert TimeOfDay to DateTime for today
        final now = DateTime.now();
        _maxCompletionTime = DateTime(
          now.year,
          now.month,
          now.day,
          picked.hour,
          picked.minute,
        );
      });
    }
  }

  String _formatDateTime(DateTime dateTime) {
    final timeOfDay = TimeOfDay.fromDateTime(dateTime);
    return '${timeOfDay.hour.toString().padLeft(2, '0')}:${timeOfDay.minute.toString().padLeft(2, '0')}';
  }

  void _submitDailyReport() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      final checkboxes = <DailyReportCheckbox>[];
      for (int i = 0; i < _checkboxControllers.length; i++) {
        checkboxes.add(DailyReportCheckbox(
          id: (i + 1).toString(),
          text: _checkboxControllers[i].text.trim(),
        ));
      }

      final dailyReportMessage = DailyReportMessage(
        checkboxes: checkboxes,
        userData: [], // Empty list - users will add their data when they interact with the message
        customTitle: _titleController.text.trim(),
        customSectionText: _sectionTextController.text.trim(),
        maxCompletionTime: _maxCompletionTime,
      );

      widget.onDailyReportCreated(dailyReportMessage);
    } catch (e) {
      log('Error creating daily report: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error creating daily report: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _sectionTextController.dispose();
    for (final controller in _checkboxControllers) {
      controller.dispose();
    }
    for (final controller in _animationControllers) {
      controller.dispose();
    }
    super.dispose();
  }
}

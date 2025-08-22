/// Represents a single user's daily report data
class UserDailyReportData {
  final String userId;
  final String dailyIncome;
  final String packagesSent;
  final String? additionalComments;
  final Map<String, bool> selectedCheckboxes;
  final bool isSubmitted;
  final DateTime? submittedAt;

  const UserDailyReportData({
    required this.userId,
    required this.dailyIncome,
    required this.packagesSent,
    this.additionalComments,
    required this.selectedCheckboxes,
    required this.isSubmitted,
    this.submittedAt,
  });

  UserDailyReportData copyWith({
    String? userId,
    String? dailyIncome,
    String? packagesSent,
    String? additionalComments,
    Map<String, bool>? selectedCheckboxes,
    bool? isSubmitted,
    DateTime? submittedAt,
  }) {
    return UserDailyReportData(
      userId: userId ?? this.userId,
      dailyIncome: dailyIncome ?? this.dailyIncome,
      packagesSent: packagesSent ?? this.packagesSent,
      additionalComments: additionalComments ?? this.additionalComments,
      selectedCheckboxes: selectedCheckboxes ?? this.selectedCheckboxes,
      isSubmitted: isSubmitted ?? this.isSubmitted,
      submittedAt: submittedAt ?? this.submittedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'dailyIncome': dailyIncome,
      'packagesSent': packagesSent,
      'additionalComments': additionalComments,
      'selectedCheckboxes': selectedCheckboxes,
      'isSubmitted': isSubmitted,
      'submittedAt': submittedAt?.toIso8601String(),
    };
  }

  factory UserDailyReportData.fromJson(Map<String, dynamic> json) {
    return UserDailyReportData(
      userId: json['userId'] ?? '',
      dailyIncome: json['dailyIncome'] ?? '',
      packagesSent: json['packagesSent'] ?? '',
      additionalComments: json['additionalComments'],
      selectedCheckboxes:
          Map<String, bool>.from(json['selectedCheckboxes'] ?? {}),
      isSubmitted: json['isSubmitted'] ?? false,
      submittedAt: json['submittedAt'] != null
          ? DateTime.parse(json['submittedAt'])
          : null,
    );
  }
}

/// Represents a checkbox item in the daily report
class DailyReportCheckbox {
  final String id;
  final String text;

  const DailyReportCheckbox({
    required this.id,
    required this.text,
  });

  DailyReportCheckbox copyWith({
    String? id,
    String? text,
  }) {
    return DailyReportCheckbox(
      id: id ?? this.id,
      text: text ?? this.text,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
    };
  }

  factory DailyReportCheckbox.fromJson(Map<String, dynamic> json) {
    return DailyReportCheckbox(
      id: json['id'] ?? '',
      text: json['text'] ?? '',
    );
  }
}

/// Main daily report message model (multi-user)
class DailyReportMessage {
  final List<DailyReportCheckbox> checkboxes;
  final List<UserDailyReportData> userData;
  final String? customTitle;
  final String? customSectionText;
  final DateTime? maxCompletionTime;

  const DailyReportMessage({
    required this.checkboxes,
    required this.userData,
    this.customTitle,
    this.customSectionText,
    this.maxCompletionTime,
  });

  DailyReportMessage copyWith({
    List<DailyReportCheckbox>? checkboxes,
    List<UserDailyReportData>? userData,
    String? customTitle,
    String? customSectionText,
    DateTime? maxCompletionTime,
  }) {
    return DailyReportMessage(
      checkboxes: checkboxes ?? this.checkboxes,
      userData: userData ?? this.userData,
      customTitle: customTitle ?? this.customTitle,
      customSectionText: customSectionText ?? this.customSectionText,
      maxCompletionTime: maxCompletionTime ?? this.maxCompletionTime,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'checkboxes': checkboxes.map((checkbox) => checkbox.toJson()).toList(),
      'userData': userData.map((data) => data.toJson()).toList(),
      'customTitle': customTitle,
      'customSectionText': customSectionText,
      'maxCompletionTime': maxCompletionTime?.toIso8601String(),
    };
  }

  factory DailyReportMessage.fromJson(Map<String, dynamic> json) {
    return DailyReportMessage(
      checkboxes: (json['checkboxes'] as List<dynamic>?)
              ?.map((checkbox) => DailyReportCheckbox.fromJson(checkbox))
              .toList() ??
          [],
      userData: (json['userData'] as List<dynamic>?)
              ?.map((data) => UserDailyReportData.fromJson(data))
              .toList() ??
          [],
      customTitle: json['customTitle'],
      customSectionText: json['customSectionText'],
      maxCompletionTime: json['maxCompletionTime'] != null
          ? DateTime.parse(json['maxCompletionTime'])
          : null,
    );
  }

  /// Get data for a specific user
  UserDailyReportData? getUserData(String userId) {
    try {
      return userData.firstWhere((data) => data.userId == userId);
    } catch (e) {
      return null;
    }
  }

  /// Check if a user has submitted their report
  bool hasUserSubmitted(String userId) {
    final userData = getUserData(userId);
    return userData?.isSubmitted ?? false;
  }

  /// Get the number of users who have submitted
  int get submittedUsersCount {
    return userData.where((data) => data.isSubmitted).length;
  }

  /// Get the total number of users
  int get totalUsersCount {
    return userData.length;
  }
}

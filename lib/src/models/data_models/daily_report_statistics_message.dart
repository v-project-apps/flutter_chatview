/// Represents statistics for a single day from daily reports
class DailyReportDayStats {
  final DateTime date;
  final String dailyIncome;
  final String packagesSent;
  final int completedTasks;
  final int totalTasks;

  const DailyReportDayStats({
    required this.date,
    required this.dailyIncome,
    required this.packagesSent,
    required this.completedTasks,
    required this.totalTasks,
  });

  DailyReportDayStats copyWith({
    DateTime? date,
    String? dailyIncome,
    String? packagesSent,
    int? completedTasks,
    int? totalTasks,
  }) {
    return DailyReportDayStats(
      date: date ?? this.date,
      dailyIncome: dailyIncome ?? this.dailyIncome,
      packagesSent: packagesSent ?? this.packagesSent,
      completedTasks: completedTasks ?? this.completedTasks,
      totalTasks: totalTasks ?? this.totalTasks,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'dailyIncome': dailyIncome,
      'packagesSent': packagesSent,
      'completedTasks': completedTasks,
      'totalTasks': totalTasks,
    };
  }

  factory DailyReportDayStats.fromJson(Map<String, dynamic> json) {
    return DailyReportDayStats(
      date: DateTime.parse(json['date']),
      dailyIncome: json['dailyIncome'] ?? '',
      packagesSent: json['packagesSent'] ?? '',
      completedTasks: json['completedTasks'] ?? 0,
      totalTasks: json['totalTasks'] ?? 0,
    );
  }
}

/// Represents overall statistics summary across all days
class DailyReportSummaryStats {
  final String totalIncome;
  final String totalPackages;
  final int totalCompletedTasks;
  final int totalTasks;

  const DailyReportSummaryStats({
    required this.totalIncome,
    required this.totalPackages,
    required this.totalCompletedTasks,
    required this.totalTasks,
  });

  DailyReportSummaryStats copyWith({
    String? totalIncome,
    String? totalPackages,
    int? totalCompletedTasks,
    int? totalTasks,
  }) {
    return DailyReportSummaryStats(
      totalIncome: totalIncome ?? this.totalIncome,
      totalPackages: totalPackages ?? this.totalPackages,
      totalCompletedTasks: totalCompletedTasks ?? this.totalCompletedTasks,
      totalTasks: totalTasks ?? this.totalTasks,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalIncome': totalIncome,
      'totalPackages': totalPackages,
      'totalCompletedTasks': totalCompletedTasks,
      'totalTasks': totalTasks,
    };
  }

  factory DailyReportSummaryStats.fromJson(Map<String, dynamic> json) {
    return DailyReportSummaryStats(
      totalIncome: json['totalIncome'] ?? '',
      totalPackages: json['totalPackages'] ?? '',
      totalCompletedTasks: json['totalCompletedTasks'] ?? 0,
      totalTasks: json['totalTasks'] ?? 0,
    );
  }
}

/// Represents statistics for a single user
class UserDailyReportStatistics {
  final String userId;
  final List<DailyReportDayStats> dailyStats;
  final DailyReportSummaryStats summaryStats;

  const UserDailyReportStatistics({
    required this.userId,
    required this.dailyStats,
    required this.summaryStats,
  });

  UserDailyReportStatistics copyWith({
    String? userId,
    List<DailyReportDayStats>? dailyStats,
    DailyReportSummaryStats? summaryStats,
  }) {
    return UserDailyReportStatistics(
      userId: userId ?? this.userId,
      dailyStats: dailyStats ?? this.dailyStats,
      summaryStats: summaryStats ?? this.summaryStats,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'dailyStats': dailyStats.map((stat) => stat.toJson()).toList(),
      'summaryStats': summaryStats.toJson(),
    };
  }

  factory UserDailyReportStatistics.fromJson(Map<String, dynamic> json) {
    return UserDailyReportStatistics(
      userId: json['userId'] ?? '',
      dailyStats: (json['dailyStats'] as List<dynamic>?)
              ?.map((stat) => DailyReportDayStats.fromJson(stat))
              .toList() ??
          [],
      summaryStats:
          DailyReportSummaryStats.fromJson(json['summaryStats'] ?? {}),
    );
  }
}

/// Main message model for daily report statistics (multi-user)
class DailyReportStatisticsMessage {
  final List<UserDailyReportStatistics> userStatistics;
  final String? customTitle;
  final String? customSubtitle;
  final DateTime? generatedAt;

  const DailyReportStatisticsMessage({
    required this.userStatistics,
    this.customTitle,
    this.customSubtitle,
    this.generatedAt,
  });

  DailyReportStatisticsMessage copyWith({
    List<UserDailyReportStatistics>? userStatistics,
    String? customTitle,
    String? customSubtitle,
    DateTime? generatedAt,
  }) {
    return DailyReportStatisticsMessage(
      userStatistics: userStatistics ?? this.userStatistics,
      customTitle: customTitle ?? this.customTitle,
      customSubtitle: customSubtitle ?? this.customSubtitle,
      generatedAt: generatedAt ?? this.generatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userStatistics': userStatistics.map((stat) => stat.toJson()).toList(),
      'customTitle': customTitle,
      'customSubtitle': customSubtitle,
      'generatedAt': generatedAt?.toIso8601String(),
    };
  }

  factory DailyReportStatisticsMessage.fromJson(Map<String, dynamic> json) {
    return DailyReportStatisticsMessage(
      userStatistics: (json['userStatistics'] as List<dynamic>?)
              ?.map((stat) => UserDailyReportStatistics.fromJson(stat))
              .toList() ??
          [],
      customTitle: json['customTitle'],
      customSubtitle: json['customSubtitle'],
      generatedAt: json['generatedAt'] != null
          ? DateTime.parse(json['generatedAt'])
          : null,
    );
  }

  /// Get statistics for a specific user
  UserDailyReportStatistics? getUserStatistics(String userId) {
    try {
      return userStatistics.firstWhere((stat) => stat.userId == userId);
    } catch (e) {
      return null;
    }
  }
}

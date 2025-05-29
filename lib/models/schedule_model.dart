import 'dart:convert';

class Schedule {
  String subject;
  List<String> topics;
  DateTime examDate;
  int daysToComplete;
  List<Map<String, List<String>>> dailyPlan;

  Schedule({
    required this.subject,
    required this.topics,
    required this.examDate,
    required this.daysToComplete,
    required this.dailyPlan,
  });

  Map<String, dynamic> toJson() => {
    'subject': subject,
    'topics': topics,
    'examDate': examDate.toIso8601String(),
    'daysToComplete': daysToComplete,
    'dailyPlan': dailyPlan,
  };

  static Schedule fromJson(Map<String, dynamic> json) => Schedule(
    subject: json['subject'] ?? 'No Subject',
    topics: List<String>.from(json['topics'] ?? []),
    examDate: DateTime.parse(json['examDate']),
    daysToComplete: json['daysToComplete'] ?? 0,
    dailyPlan: List<Map<String, List<String>>>.from(
      (json['dailyPlan'] ?? []).map(
            (dayMap) => Map<String, List<String>>.from(
          (dayMap as Map).map(
                (key, value) =>
                MapEntry(key as String, List<String>.from(value)),
          ),
        ),
      ),
    ),
  );
}

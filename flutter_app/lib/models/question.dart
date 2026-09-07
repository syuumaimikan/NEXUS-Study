class Question {
  final String id;
  final String subjectId;
  final String subjectName;
  final String course;
  final String unit;
  final String difficulty;
  final int estimatedDeviation;
  final String questionBody;
  final List<String> choices;
  final int correctAnswerIndex;
  final String explanation;
  final List<String> hints;
  final List<String> tags;
  final int baseXp;

  Question({
    required this.id,
    required this.subjectId,
    required this.subjectName,
    required this.course,
    required this.unit,
    required this.difficulty,
    required this.estimatedDeviation,
    required this.questionBody,
    required this.choices,
    required this.correctAnswerIndex,
    required this.explanation,
    required this.hints,
    required this.tags,
    required this.baseXp,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'] as String? ?? '',
      subjectId: json['subjectId'] as String? ?? '',
      subjectName: json['subjectName'] as String? ?? '',
      course: json['course'] as String? ?? '',
      unit: json['unit'] as String? ?? '',
      difficulty: json['difficulty'] as String? ?? 'C',
      estimatedDeviation: (json['estimatedDeviation'] as num?)?.toInt() ?? 50,
      questionBody: json['questionBody'] as String? ?? '',
      choices: (json['choices'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      correctAnswerIndex: (json['correctAnswerIndex'] as num?)?.toInt() ?? 0,
      explanation: json['explanation'] as String? ?? '',
      hints: (json['hints'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      baseXp: (json['baseXp'] as num?)?.toInt() ?? 100,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'subjectId': subjectId,
      'subjectName': subjectName,
      'course': course,
      'unit': unit,
      'difficulty': difficulty,
      'estimatedDeviation': estimatedDeviation,
      'questionBody': questionBody,
      'choices': choices,
      'correctAnswerIndex': correctAnswerIndex,
      'explanation': explanation,
      'hints': hints,
      'tags': tags,
      'baseXp': baseXp,
    };
  }
}

class TargetWord {
  final int id;
  final String word;
  final String meaning;
  final String partOfSpeech;
  final int section;
  final String sectionName;
  final String subSection;
  final String example;

  const TargetWord({
    required this.id,
    required this.word,
    required this.meaning,
    required this.partOfSpeech,
    required this.section,
    required this.sectionName,
    required this.subSection,
    required this.example,
  });

  factory TargetWord.fromJson(Map<String, dynamic> json) {
    return TargetWord(
      id: (json['id'] as num?)?.toInt() ?? 0,
      word: json['word'] as String? ?? '',
      meaning: json['meaning'] as String? ?? '',
      partOfSpeech: json['partOfSpeech'] as String? ?? '名詞',
      section: (json['section'] as num?)?.toInt() ?? 1,
      sectionName: json['sectionName'] as String? ?? '基本単語',
      subSection: json['subSection'] as String? ?? '1-100',
      example: json['example'] as String? ?? '',
    );
  }
}

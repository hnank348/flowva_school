enum ExamTypeOption {
  monthly(id: 1, nameAr: 'شهري', nameEn: 'Monthly'),
  midterm(id: 2, nameAr: 'نصفي', nameEn: 'Midterm'),
  finalExam(id: 3, nameAr: 'نهائي', nameEn: 'Final');

  final int id;
  final String nameAr;
  final String nameEn;

  const ExamTypeOption({
    required this.id,
    required this.nameAr,
    required this.nameEn,
  });

  static ExamTypeOption? fromId(int id) {
    for (final type in ExamTypeOption.values) {
      if (type.id == id) return type;
    }
    return null;
  }
}
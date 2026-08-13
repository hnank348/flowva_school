class AddExamRequest {
  final String name;
  final String nameAr;
  final int examTypeId;
  final int subjectId;
  final int sectionId;
  final int academicYearId;
  final int semesterId;
  final int teacherId;
  final String examDate;   // yyyy-M-d
  final String startTime;  // HH:mm
  final String endTime;    // HH:mm
  final String room;
  final double totalMarks;
  final double passMarks;
  final String? instructions;

  const AddExamRequest({
    required this.name,
    required this.nameAr,
    required this.examTypeId,
    required this.subjectId,
    required this.sectionId,
    required this.academicYearId,
    required this.semesterId,
    required this.teacherId,
    required this.examDate,
    required this.startTime,
    required this.endTime,
    required this.room,
    required this.totalMarks,
    required this.passMarks,
    this.instructions,
  });

  Map<String, dynamic> toFormMap() => {
    'name':             name,
    'name_ar':          nameAr,
    'exam_type_id':     examTypeId.toString(),
    'subject_id':       subjectId.toString(),
    'section_id':       sectionId.toString(),
    'academic_year_id': academicYearId.toString(),
    'semester_id':      semesterId.toString(),
    'teacher_id':       teacherId.toString(),
    'exam_date':        examDate,
    'start_time':       startTime,
    'end_time':         endTime,
    'room':             room,
    'total_marks':      totalMarks.toString(),
    'pass_marks':       passMarks.toString(),
    if (instructions != null && instructions!.isNotEmpty)
      'instructions': instructions!,
  };
}
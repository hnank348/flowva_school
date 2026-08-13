class UpdateExamRequest {
  final String? name;
  final String? nameAr;
  final int? examTypeId;
  final int? subjectId;
  final int? sectionId;
  final int? academicYearId;
  final int? semesterId;
  final int? teacherId;
  final String? examDate;
  final String? startTime;
  final String? endTime;
  final String? room;
  final double? totalMarks;
  final double? passMarks;
  final String? instructions;

  const UpdateExamRequest({
    this.name,
    this.nameAr,
    this.examTypeId,
    this.subjectId,
    this.sectionId,
    this.academicYearId,
    this.semesterId,
    this.teacherId,
    this.examDate,
    this.startTime,
    this.endTime,
    this.room,
    this.totalMarks,
    this.passMarks,
    this.instructions,
  });

  Map<String, dynamic> toFormMap() {
    final Map<String, dynamic> map = {};
    if (name != null) map['name'] = name;
    if (nameAr != null) map['name_ar'] = nameAr;
    if (examTypeId != null) map['exam_type_id'] = examTypeId.toString();
    if (subjectId != null) map['subject_id'] = subjectId.toString();
    if (sectionId != null) map['section_id'] = sectionId.toString();
    if (academicYearId != null) map['academic_year_id'] = academicYearId.toString();
    if (semesterId != null) map['semester_id'] = semesterId.toString();
    if (teacherId != null) map['teacher_id'] = teacherId.toString();
    if (examDate != null) map['exam_date'] = examDate;
    if (startTime != null) map['start_time'] = startTime;
    if (endTime != null) map['end_time'] = endTime;
    if (room != null) map['room'] = room;
    if (totalMarks != null) map['total_marks'] = totalMarks.toString();
    if (passMarks != null) map['pass_marks'] = passMarks.toString();
    if (instructions != null) map['instructions'] = instructions;
    return map;
  }
}
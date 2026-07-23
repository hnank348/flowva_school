import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../cubit/supervisor/classes/classes_cubit.dart';
import '../../../cubit/supervisor/classes/classes_state.dart';
import '../../../cubit/supervisor/schedule/schedule_cubit.dart';
import '../../../cubit/supervisor/subjects/subjects_cubit.dart';
import '../../../cubit/supervisor/teachers/teachers_cubit.dart';
import '../../../cubit/locale/locale_cubit.dart';
import '../../../cubit/locale/locale_state.dart';
import '../../../models/supervisor/schedule_session_model.dart';
import '../../../app_localizations.dart';
import '../../../widget/custom_confirmation_dialog.dart';
import 'session_form_fields.dart';

class EditSessionBottomSheet {
  static void show(
      BuildContext context, {
        required int? sessionId,
        required int? currentSubjectId,
        required int? currentTeacherId,
        required String currentSubject,
        required String currentTeacher,
        required String currentRoom,
        required int sectionId,
        required String className,
        required String dayOfWeek,
        required int periodNumber,
        required int semesterId,
      }) {
    final subjectsCubit  = BlocProvider.of<SubjectsCubit>(context);
    final teachersCubit  = BlocProvider.of<TeachersCubit>(context);
    final scheduleCubit  = BlocProvider.of<ScheduleCubit>(context);
    final classesCubit   = BlocProvider.of<ClassesCubit>(context);
    final localeCubit    = BlocProvider.of<LocaleCubit>(context);
    final colorScheme    = Theme.of(context).colorScheme;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.55),
      builder: (sheetCtx) => MultiBlocProvider(
        providers: [
          BlocProvider.value(value: subjectsCubit),
          BlocProvider.value(value: teachersCubit),
          BlocProvider.value(value: scheduleCubit),
          BlocProvider.value(value: classesCubit),
          BlocProvider.value(value: localeCubit),
        ],
        child: BlocBuilder<LocaleCubit, LocaleState>(
          builder: (ctx, localeState) => Directionality(
            textDirection: localeState.textDirection,
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 550),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerLow,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(32), topRight: Radius.circular(32),
                  ),
                ),
                padding: EdgeInsets.only(
                  top: 16, left: 24, right: 24,
                  bottom: MediaQuery.of(sheetCtx).viewInsets.bottom + 24,
                ),
                child: _SessionForm(
                  sessionId:        sessionId,
                  currentSubjectId: currentSubjectId,
                  currentTeacherId: currentTeacherId,
                  currentRoom:      currentRoom,
                  sectionId:        sectionId,
                  className:        className,
                  dayOfWeek:        dayOfWeek,
                  periodNumber:     periodNumber,
                  semesterId:       semesterId,
                  isArabic:         localeState.currentLanguage == 'AR',
                  sheetContext:     sheetCtx,
                  scheduleCubit:    scheduleCubit,
                  classesCubit:     classesCubit,
                  colorScheme:      colorScheme,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SessionForm extends StatefulWidget {
  final int? sessionId;
  final int? currentSubjectId;
  final int? currentTeacherId;
  final String currentRoom;
  final int sectionId;
  final String className;
  final String dayOfWeek;
  final int periodNumber;
  final int semesterId;
  final bool isArabic;
  final BuildContext sheetContext;
  final ScheduleCubit scheduleCubit;
  final ClassesCubit classesCubit;
  final ColorScheme colorScheme;

  const _SessionForm({
    required this.sessionId,
    required this.currentSubjectId,
    required this.currentTeacherId,
    required this.currentRoom,
    required this.sectionId,
    required this.className,
    required this.dayOfWeek,
    required this.periodNumber,
    required this.semesterId,
    required this.isArabic,
    required this.sheetContext,
    required this.scheduleCubit,
    required this.classesCubit,
    required this.colorScheme,
  });

  @override
  State<_SessionForm> createState() => _SessionFormState();
}

class _SessionFormState extends State<_SessionForm> {
  late int? _subjectId;
  late int? _teacherId;
  late TextEditingController _roomCtrl;

  @override
  void initState() {
    super.initState();
    _subjectId = widget.currentSubjectId;
    _teacherId = widget.currentTeacherId;
    _roomCtrl  = TextEditingController(text: widget.currentRoom);
  }

  @override
  void dispose() {
    _roomCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (_subjectId == null || _teacherId == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(context.tr('session_required_error'),
            style: const TextStyle(fontFamily: 'Cairo')),
      ));
      return;
    }

    int academicYearId = 2;
    final classState = widget.classesCubit.state;
    if (classState is ClassesLoaded) {
      academicYearId = classState.classDetails.academicYearId;
    }

    final times = _periodTimes(widget.periodNumber);
    final newSession = ScheduleSessionModel(
      id:           widget.sessionId ?? 0,
      roomNumber:   _roomCtrl.text,
      dayOfWeek:    widget.dayOfWeek,
      periodNumber: widget.periodNumber,
      startTime:    times.$1,
      endTime:      times.$2,
    );

    if (widget.sessionId == null) {
      widget.scheduleCubit.uploadNewSession(
        sectionId: widget.sectionId, className: widget.className,
        updatedSession: newSession, subjectId: _subjectId!,
        teacherId: _teacherId!, academicYearId: academicYearId,
        semesterId: widget.semesterId,
      );
    } else {
      widget.scheduleCubit.updateSession(
        timetableId: widget.sessionId!, sectionId: widget.sectionId,
        className: widget.className, updatedSession: newSession,
        subjectId: _subjectId!, teacherId: _teacherId!,
        academicYearId: academicYearId, semesterId: widget.semesterId,
      );
    }

    Navigator.pop(widget.sheetContext);
  }

  void _deleteSession() async {
    if (widget.sessionId == null) return;

    final confirmed = await CustomConfirmationDialog.show(
      context,
      titleKey: 'session_delete_dialog_title',
      bodyKey: 'session_delete_dialog_body',
      confirmBtnKey: 'session_delete_confirm',
      cancelBtnKey: 'session_btn_cancel',
      isDanger: true,
    );

    if (confirmed == true && mounted) {
      widget.scheduleCubit.deleteSession(
        timetableId: widget.sessionId!,
        sectionId: widget.sectionId,
        className: widget.className,
        semesterId: widget.semesterId,
      );
      Navigator.pop(widget.sheetContext);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(context.tr('session_delete_success'), style: const TextStyle(fontFamily: 'Cairo')),
        backgroundColor: const Color(0xFF0F766E),
        behavior: SnackBarBehavior.floating,
      ));
    }
  }

  (String, String) _periodTimes(int period) {
    const times = {
      1: ('07:30:00', '08:15:00'),
      2: ('08:20:00', '09:05:00'),
      3: ('09:35:00', '10:20:00'),
      4: ('10:20:00', '11:05:00'),
      5: ('11:30:00', '12:15:00'),
      6: ('12:15:00', '13:00:00'),
    };
    return times[period] ?? ('07:30:00', '08:15:00');
  }

  @override
  Widget build(BuildContext context) {
    final cs        = widget.colorScheme;
    final isNew     = widget.sessionId == null;
    final titleKey  = isNew ? 'session_add_title' : 'session_edit_title';

    return SafeArea(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(child: Container(
              width: 45, height: 4.5,
              decoration: BoxDecoration(color: cs.outlineVariant, borderRadius: BorderRadius.circular(10)),
            )),
            const SizedBox(height: 24),

            Row(children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: cs.primary.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(isNew ? Icons.add_box_rounded : Icons.edit_calendar_rounded,
                    color: cs.primary, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(child: Text(
                '${context.tr(titleKey)} ${widget.periodNumber} - ${context.tr('session_semester')} ${widget.semesterId}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Cairo'),
                maxLines: 1, overflow: TextOverflow.ellipsis,
              )),
              if (!isNew)
                IconButton(
                  onPressed: _deleteSession,
                  icon: Icon(Icons.delete_outline_rounded, color: cs.error, size: 22),
                  tooltip: context.tr('session_btn_delete'),
                ),
            ]),
            const SizedBox(height: 24),

            SubjectDropdownField(
              selectedSubjectId: _subjectId,
              isArabic: widget.isArabic,
              onChanged: (v) => setState(() => _subjectId = v),
            ),
            const SizedBox(height: 16),
            TeacherDropdownField(
              selectedTeacherId: _teacherId,
              isArabic: widget.isArabic,
              onChanged: (v) => setState(() => _teacherId = v),
            ),
            const SizedBox(height: 16),
            RoomTextField(controller: _roomCtrl),
            const SizedBox(height: 28),

            Row(children: [
              Expanded(flex: 2, child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: cs.primary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                onPressed: _submit,
                child: Text(
                  context.tr(isNew ? 'session_btn_add' : 'session_btn_save'),
                  style: const TextStyle(color: Colors.white, fontSize: 15,
                      fontWeight: FontWeight.bold, fontFamily: 'Cairo'),
                ),
              )),
              const SizedBox(width: 12),
              Expanded(child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: cs.outlineVariant, width: 1.5),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                onPressed: () => Navigator.pop(widget.sheetContext),
                child: Text(context.tr('session_btn_cancel'),
                    style: TextStyle(color: cs.onSurfaceVariant, fontSize: 15, fontFamily: 'Cairo')),
              )),
            ]),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubit/supervisor/state_supervisor/exam_schedule_state.dart';
import 'cubit/supervisor/cubit_supervisor/navigation_cubit.dart';
import 'cubit/supervisor/cubit_supervisor/schedule_cubit_screen.dart';

class AppProviders {
  static List<BlocProvider> get providers => [
    BlocProvider<NavigationCubit>(create: (context) => NavigationCubit()),
    BlocProvider<ScheduleCubitScreen>(create: (context) => ScheduleCubitScreen()),
    BlocProvider<ExamScheduleCubit>(create: (context) => ExamScheduleCubit()),
  ];
}
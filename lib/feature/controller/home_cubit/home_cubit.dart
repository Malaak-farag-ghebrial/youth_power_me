import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../view/activity/screens/activity_screen.dart';
import '../../view/setting/screens/setting_screen.dart';
import '../../view/student/screens/student_screen.dart';
import '../../view/week/screens/main_screen.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  static HomeCubit get(context) => BlocProvider.of(context);

  List<Widget> screens = [
    const MainScreen(),
    StudentScreen(),
    ActivityScreen(),
    SettingScreen(),
  ];
  int currentIndex = 0;



  void btmNavBar(int index) {
    currentIndex = index;
    emit(BtmNavBar());
  }
}

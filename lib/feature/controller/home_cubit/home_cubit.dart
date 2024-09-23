import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:youth_power/core/constants/api_keyword.dart';
import 'package:youth_power/core/errors/exceptions.dart';
import 'package:youth_power/core/functions/global_variable.dart';

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


  Future<void> createDatabase() async {
   final response = await openDatabase(ApiKey.databasePath, version: 1,
        onCreate: (Database data, int version) async {
      emit(CreateDatabaseLoading());
      Batch batch = data.batch();
      batch.execute('''
        CREATE TABLE ${ApiKey.activityTable}
        (
        ${ApiKey.id} INTEGER PRIMARY KEY,
        ${ApiKey.name} TEXT,
        ${ApiKey.servantId} TEXT,
        ${ApiKey.points} INTEGER,
        ${ApiKey.times} TEXT,
        ${ApiKey.available} INTEGER,
        ${ApiKey.repeated} INTEGER,
        ${ApiKey.attendance} TEXT)
        ''');
      batch.execute('''
        CREATE TABLE ${ApiKey.studentTable} 
        (
        ${ApiKey.id} INTEGER PRIMARY KEY,
        ${ApiKey.code} TEXT,
        ${ApiKey.name} TEXT,
        ${ApiKey.phone} TEXT,
        ${ApiKey.points} TEXT,
        ${ApiKey.attendance} TEXT,
        ${ApiKey.birthDate} TEXT,
        ${ApiKey.academicYear} INTEGER,
        ${ApiKey.activityIds} TEXT)
        ''');
      batch.execute('''
        CREATE TABLE ${ApiKey.weekTable} 
        (
        ${ApiKey.id} INTEGER PRIMARY KEY,
        ${ApiKey.date} TEXT,
        ${ApiKey.day} TEXT,
        ${ApiKey.activityIds} TEXT,
        ${ApiKey.attendance} TEXT)
        ''');
      batch.execute('''
      CREATE TABLE ${ApiKey.servantTable}
      (
      ${ApiKey.id} INTEGER PRIMARY KEY,
      ${ApiKey.code} TEXT,
      ${ApiKey.phone} TEXT,
      ${ApiKey.name} TEXT,
      ${ApiKey.attendance} TEXT,
      ${ApiKey.activityIds} TEXT)
      ''');
      batch.execute('''
        CREATE TABLE ${ApiKey.timeTable}
        (
        ${ApiKey.id} INTEGER PRIMARY KEY,
        ${ApiKey.times} TEXT,
        ${ApiKey.lastTimeAttend} TEXT,
        ${ApiKey.day} TEXT,
        ${ApiKey.date} TEXT)
        ''');
      batch.execute('''
        CREATE TABLE ${ApiKey.pointTable}
        (
        ${ApiKey.id} INTEGER PRIMARY KEY,
        ${ApiKey.activityId} TEXT,
        ${ApiKey.week} TEXT,
        ${ApiKey.value} INTEGER)
        ''');
      batch.execute('''
        CREATE TABLE ${ApiKey.attendanceTable} 
        (
        ${ApiKey.id} INTEGER PRIMARY KEY,
        ${ApiKey.studentId} INTEGER,
        ${ApiKey.activityId} INTEGER,
        ${ApiKey.date} TEXT,
        ${ApiKey.attendTime} TEXT)
        ''');

      await batch.commit().then((value) {
        GlobalFunction.print('database created');
        emit(CreateDatabaseSuccess());
      }).catchError((error) {
        GlobalFunction.errorPrint(error, 'create database error');
        emit(CreateDatabaseFailed());
      });
    },
      onOpen: (Database? database){
        GlobalFunction.print('database opened');
        emit(OpenDatabaseSuccess());
      }
    );
   try{
     database = response;
   }on MyDatabaseException catch(error){
     GlobalFunction.errorPrint(error, 'create database');
   }
  }

  void btmNavBar(int index) {
    currentIndex = index;
    emit(BtmNavBar());
  }
}

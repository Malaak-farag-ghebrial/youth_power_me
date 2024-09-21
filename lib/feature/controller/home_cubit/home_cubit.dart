
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:youth_power/core/constants/api_keyword.dart';
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

  void createDatabase() async{
    await openDatabase(
      ApiKey.databasePath,version: 1,
        onCreate: (Database data, int version) async {
        emit(CreateDatabaseLoading());
        Batch batch = data.batch();
        batch.execute('''
        CREATE TABLE ${ApiKey.activityTable}
        (
        ${ApiKey.id} INTEGER PRIMARY KEY,
        ${ApiKey.name} TEXT,
        ${ApiKey.servant} TEXT,
        ${ApiKey.points} INTEGER,
        ${ApiKey.times} ARRAY,
        ${ApiKey.available} INTEGER,
        ${ApiKey.repeated} INTEGER,
        ${ApiKey.attendance} ARRAY)
        ''');
        batch.execute('''
        CREATE TABLE ${ApiKey.studentTable} 
        (
        ${ApiKey.id} INTEGER PRIMARY KEY,
        ${ApiKey.code} INTEGER,
        ${ApiKey.name} TEXT,
        ${ApiKey.phone} TEXT,
        ${ApiKey.points} ARRAY,
        ${ApiKey.attendance} ARRAY,
        ${ApiKey.activity} ARRAY)
        ''');
        batch.execute('''
        CREATE TABLE ${ApiKey.weekTable} 
        (
        ${ApiKey.id} INTEGER PRIMARY KEY,
        ${ApiKey.date} TEXT,
        ${ApiKey.day} TEXT,
        ${ApiKey.activity} ARRAY,
        ${ApiKey.attendance} ARRAY)
        ''');
        batch.execute('''
        CREATE TABLE ${ApiKey.timeTable}
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
        ${ApiKey.activityId} ARRAY,
        ${ApiKey.week} ARRAY,
        ${ApiKey.value} INTEGER)
        ''');
        batch.execute('''
        CREATE TABLE ${ApiKey.attendance} 
        (
        ${ApiKey.id} INTEGER PRIMARY KEY,
        ${ApiKey.studentId} INTEGER,
        ${ApiKey.activityId} INTEGER,
        ${ApiKey.date} TEXT,
        ${ApiKey.attendTime} TEXT)
        ''');
        await batch.commit().then((value){
          GlobalFunction.print('database created');
          emit(CreateDatabaseSuccess());
        }).catchError((error){
          GlobalFunction.errorPrint(error, 'create database error');
          emit(CreateDatabaseFailed());
        });
        }

    );
  }



  void btmNavBar(int index){
    currentIndex = index;
    emit(BtmNavBar());
  }



}

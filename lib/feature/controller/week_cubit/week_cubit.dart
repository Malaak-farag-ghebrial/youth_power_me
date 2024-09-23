import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:excel/excel.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:youth_power/core/errors/exceptions.dart';

import '../../../core/constants/api_keyword.dart';
import '../../../core/functions/arabic_to_english_number.dart';
import '../../../core/functions/date_format.dart';
import '../../../core/functions/global_variable.dart';
import '../../../core/services/excel_service.dart';
import '../../model/activity.dart';
import '../../model/student.dart';
import '../../model/week.dart';

part 'week_state.dart';

class WeekCubit extends Cubit<WeekState> {
  WeekCubit() : super(WeekInitial());

  static WeekCubit get(context) => BlocProvider.of(context);
  final _fireStore = FirebaseFirestore.instance;
  List<WeekModel> weekModel = [];

  Future<void> addWeek({
    required DateTime dateTime,
  }) async {
    emit(AddActivityWeekLoading());
    if (database != null) {
      Batch batch = database!.batch();
      try {
        batch.insert(
            ApiKey.weekTable,
            WeekModel(
                date: dateFormat(
                    DateTime.parse(arabicToEnglish(dateTime.toString()))),
                day: DateFormat('EEEE').format(
                    DateTime.parse(arabicToEnglish(dateTime.toString()))),
                activityID: [],
                attendance: []).toJson());
        await batch.commit();
        emit(AddActivityWeekSuccess());
        getWeek();
      } on MyDatabaseException catch (error) {
        GlobalFunction.errorPrint(error, 'add week');
        emit(AddActivityWeekFailed());
      }
    } else {
      GlobalFunction.errorPrint('$database', 'database is null');
      emit(DatabaseFailed());
    }
  }

  Future<void> getWeek() async {
    emit(GetWeekLoading());
    if (database != null) {
      try {
        final response = await database!.query(ApiKey.weekTable);
        weekModel =
            List<WeekModel>.from(response.map((e) => WeekModel.fromJson(e)));
        GlobalFunction.print(weekModel.toString());
        emit(GetWeekSuccess());
      } on MyDatabaseException catch (error) {
        GlobalFunction.errorPrint(error, 'get week');
        emit(GetWeekFailed());
      }
    } else {
      GlobalFunction.errorPrint('$database', 'database is null');
      emit(DatabaseFailed());
    }
  }

  Future<void> deleteWeek({required int id})async {
    emit(DeleteWeekLoading());
    if(database != null){
    try{
      await database!.delete(ApiKey.weekTable,
      where: '${ApiKey.id}=?',
        whereArgs: [id],
      );
      weekModel.removeWhere((e)=> e.id == id);
      emit(DeleteWeekSuccess());
    } on MyDatabaseException catch(error){
      GlobalFunction.errorPrint(error, 'delete week');
      emit(DeleteWeekFailed());
    }
    }else{
      GlobalFunction.errorPrint('$database', 'database is null');
      emit(DatabaseFailed());
    }
  }

  Future<void> downloadWeek() async {
    try {
      final response = await _fireStore.collection(ApiKey.weekTable).get();
      weekModel = List<WeekModel>.from(response.docs
          .map((e) => e.data()[ApiKey.week])
          .toList()[0]
          .map((e) => WeekModel.fromJson(e))).toList();
      weekModel.sort((a, b) {
        return DateTime.parse('${b.date} 00:00:00')
            .compareTo(DateTime.parse('${a.date} 00:00:00'));
      });
    } catch (error) {
      GlobalFunction.errorPrint(error, 'download week');
    }
  }

// todo excel export
void exportTOExcel({
  required WeekModel week,
  required List<ActivityModel> activity,
  required List<StudentModel> student,
  required BuildContext context,
}) async
{
  // var directory = Directory(await getExternalStorageDirectory())
  String sheetName = 'Mahragan ${DateTime
      .now()
      .year}';
  emit(ExcelLoading());
  final excel = ExcelService().exportToExcel(
      week: week,
      activity: activity,
      student: student,
      sheetName: sheetName,
      context: context);
  // var excel = Excel.createExcel();
  // Sheet sheet = excel[sheetName];
  // excel.setDefaultSheet(sheetName);
  // sheet.isRTL = true;
  // // excel.delete('Sheet1');
  // List header = [
  //   'Name',
  //   'Phone',
  //   'Year',
  //   'Total points',
  // ];
  // CellStyle style1 = CellStyle(
  //   fontSize: 18,
  //   bold: true,
  //   horizontalAlign: HorizontalAlign.Center,
  //   verticalAlign: VerticalAlign.Center,
  //   backgroundColorHex: '#1AFF1A',
  //   rotation: 90,
  //
  // );
  // CellStyle style2 = CellStyle(
  //   fontSize: 16,
  //   bold: false,
  //   horizontalAlign: HorizontalAlign.Left,
  //   verticalAlign: VerticalAlign.Center,
  // );
  //
  // var cell = sheet.cell(CellIndex.indexByColumnRow(rowIndex: 0,columnIndex: 0));
  // cell.value = const TextCellValue('Week ');
  // cell.cellStyle = style1.copyWith(rotationVal: 0);
  // cell = sheet.cell(CellIndex.indexByColumnRow(rowIndex: 0,columnIndex: 1));
  // cell.value = TextCellValue(week.date);
  // cell.cellStyle = style1.copyWith(rotationVal: 0);
  //
  // for(int col = 0;col < header.length + activity.length;col++){
  //   var cell = sheet.cell(CellIndex.indexByColumnRow(rowIndex: 1,columnIndex: col));
  //   cell.value = col < header.length ? TextCellValue(header[col]) : TextCellValue(activity[col - header.length].name);
  //   sheet.setColumnAutoFit(col);
  //   if(col == 0 || col == 1){
  //     cell.cellStyle = style1.copyWith(rotationVal: 0);
  //   }else{
  //     cell.cellStyle = style1;
  //   }
  // }
  // for(int col = 0;col < header.length + activity.length;col++){
  //   sheet.setColumnAutoFit(col);
  //   for(int row = 2;row <= student.length +1;row++){
  //     var cell = sheet.cell(CellIndex.indexByColumnRow(rowIndex: row,columnIndex: col));
  //     if(col == 0) {
  //       cell.value = TextCellValue(student[row - 2].name);
  //       sheet.setColumnWidth(col,40);
  //       cell.cellStyle = style2.copyWith(boldVal: true);
  //     }else if(col == 1){
  //       cell.value = TextCellValue(student[row - 2].phone);
  //       sheet.setColumnWidth(col,30);
  //       cell.cellStyle = style2.copyWith(horizontalAlignVal: HorizontalAlign.Center);
  //     }  else if(col == 2){
  //       cell.value = TextCellValue(student[row - 2].academicYear.toString());
  //       cell.cellStyle = style2.copyWith(horizontalAlignVal: HorizontalAlign.Center);
  //     }else if(col == 3){
  //       cell.value = TextCellValue(StudentCubit.get(context).studentPoints(student[row - 2].points).toString());
  //       cell.cellStyle = style2.copyWith(horizontalAlignVal: HorizontalAlign.Center,boldVal: true,fontSizeVal: 20);
  //     }else {
  //      cell.value = TextCellValue(week.attendance.firstWhereOrNull((e)=> e.activityId == activity[col - header.length].id && e.studentId == student[row - 2].id) != null ? '1' : '0') ;
  //       cell.cellStyle = style2.copyWith(horizontalAlignVal: HorizontalAlign.Center);
  //     }
  //   }
  // }

  String? dir;
  var fileBytes = excel.save(fileName: '${week.date}.xlsx');
  if (!kIsWeb) {
    var directory = await getApplicationDocumentsDirectory();
    if ((await directory.exists())) {
      dir = directory.path;
    } else {
      directory.create();
      dir = directory.path;
    }

    File('$dir/${week.date}.xlsx')
      ..createSync(recursive: true)
      ..writeAsBytesSync(fileBytes!);

    await OpenFile.open('$dir/${week.date}.xlsx');
  }

  emit(ExcelSuccess());
}
}

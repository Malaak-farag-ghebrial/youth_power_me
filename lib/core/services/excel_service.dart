import 'dart:async';
import 'dart:developer';
import 'package:collection/collection.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:youth_power/core/functions/global_variable.dart';

import '../../feature/controller/student_cubit/student_cubit.dart';
import '../../feature/model/activity.dart';
import '../../feature/model/student.dart';
import '../../feature/model/week.dart';

// todo excel services under work and update

class ExcelService {
  Future<List<StudentModel>> convertExcelToStudent({
    required int firstRowNum,
    required String sheetKey,
    required String nameKey,
    required String phoneKey,
    required String acdYKey,
    required String numKey,
    required String birthDate,
  }) async {
    final Excel? excel = await _getFile();

    if (excel != null) {
      final List<String> sheets = _getSheets(excel);

      int index = 0;
      final Map<String, dynamic> json = {};
     // GlobalFunction.print(excel.tables[sheets[0]]?.rows.first.toString() ?? '',name: 'jjjjj');
      for (final String sheet in sheets) {
        List<Data?> keys = [];
        json.addAll({sheet: []});
        //GlobalFunction.print(excel.tables[sheet]?.rows[3][1]?.value.toString()?? '' , name: 'tryyyy');
        for (final List<Data?> col in excel.tables[sheet]?.rows.skip(firstRowNum) ?? []) {
          try {
            if (index == 0) {
              keys = col;
             // GlobalFunction.print(keys[1]?.value.toString() ?? '',name: 'hiiiii');
              index++;
            }
            /*else {*/
            if (col.isNotEmpty) {
              final Map<String, dynamic> temp = _getRows(keys, col);

              if (temp[nameKey] != 'null' &&
                  temp[nameKey] != null &&
                  temp[nameKey] != '') {
                json[sheet].add(temp);
              }
              // if(temp['الأسم (ربـاعــياً) بالغة العربية'] != 'null' && temp['الأسم (ربـاعــياً) بالغة العربية'] != null && temp['الأسم (ربـاعــياً) بالغة العربية'] != ''){
              //   json[table].add(temp);
              // }
            }

            // }
          } on Exception catch (ex) {
            log(ex.toString());

            rethrow;
          }
        }
        index = 0;
      }

      GlobalFunction.print(json[sheetKey].skip(1).toString());
      /*GlobalFunction.print(List<StudentModel>.from(
          json[sheetKey].map((e) => StudentModel.fromExcel(
            json: e,
            name: nameKey,
            acdY: acdYKey,
            num: numKey,
            phone: phoneKey,
          ))).toString());*/
      return List<StudentModel>.from(
          json[sheetKey].skip(1).map((e) => StudentModel.fromExcel(
            json: e,
            name: nameKey,
            acdY: acdYKey,
            num: numKey,
            phone: phoneKey,
            birthDate: birthDate,
              )));

      //   StudentModel.fromExcel(
      //   json: json,
      //   name: nameKey,
      //   acdY: acdYKey,
      //   num: numKey,
      //   phone: phoneKey,
      // );
    }

    return [];
  }

  Excel exportToExcel({
    required WeekModel week,
    required List<ActivityModel> activity,
    required List<StudentModel> student,
    required String sheetName,
    required BuildContext context,
}){
    var excel = Excel.createExcel();
    Sheet sheet = excel[sheetName];
    excel.setDefaultSheet(sheetName);
    sheet.isRTL = true;
    // excel.delete('Sheet1');
    List header = [
      'Name',
      'Phone',
      'Year',
      'Total points',
    ];
    CellStyle style1 = CellStyle(
      fontSize: 18,
      bold: true,
      horizontalAlign: HorizontalAlign.Center,
      verticalAlign: VerticalAlign.Center,
      backgroundColorHex: ExcelColor.green,//'#1AFF1A',
      rotation: 90,

    );
    CellStyle style2 = CellStyle(
      fontSize: 16,
      bold: false,
      horizontalAlign: HorizontalAlign.Left,
      verticalAlign: VerticalAlign.Center,
    );

    var cell = sheet.cell(CellIndex.indexByColumnRow(rowIndex: 0,columnIndex: 0));
    cell.value =  TextCellValue('Week ');
    cell.cellStyle = style1.copyWith(rotationVal: 0);
    cell = sheet.cell(CellIndex.indexByColumnRow(rowIndex: 0,columnIndex: 1));
    cell.value = TextCellValue(week.date);
    cell.cellStyle = style1.copyWith(rotationVal: 0);

    for(int col = 0;col < header.length + activity.length;col++){
      var cell = sheet.cell(CellIndex.indexByColumnRow(rowIndex: 1,columnIndex: col));
      cell.value = col < header.length ? TextCellValue(header[col]) : TextCellValue(activity[col - header.length].name);
      sheet.setColumnAutoFit(col);
      if(col == 0 || col == 1){
        cell.cellStyle = style1.copyWith(rotationVal: 0);
      }else{
        cell.cellStyle = style1;
      }
    }
    for(int col = 0;col < header.length + activity.length;col++){
      sheet.setColumnAutoFit(col);
      for(int row = 2;row <= student.length +1;row++){
        var cell = sheet.cell(CellIndex.indexByColumnRow(rowIndex: row,columnIndex: col));
        if(col == 0) {
          cell.value = TextCellValue(student[row - 2].name);
          sheet.setColumnWidth(col,40);
          cell.cellStyle = style2.copyWith(boldVal: true);
        }else if(col == 1){
          cell.value = TextCellValue(student[row - 2].phone ?? '');
          sheet.setColumnWidth(col,30);
          cell.cellStyle = style2.copyWith(horizontalAlignVal: HorizontalAlign.Center);
        }  else if(col == 2){
          cell.value = TextCellValue(student[row - 2].academicYear.toString());
          cell.cellStyle = style2.copyWith(horizontalAlignVal: HorizontalAlign.Center);
        }else if(col == 3){
          // cell.value = TextCellValue(StudentCubit.get(context).studentPoints(student[row - 2].points).toString());
          // cell.cellStyle = style2.copyWith(horizontalAlignVal: HorizontalAlign.Center,boldVal: true,fontSizeVal: 20);
        }else {
          cell.value = TextCellValue(week.attendance.firstWhereOrNull((e)=> e.activityId == activity[col - header.length].id && e.studentId == student[row - 2].id) != null ? '1' : '0') ;
          cell.cellStyle = style2.copyWith(horizontalAlignVal: HorizontalAlign.Center);
        }
      }
    }
    return excel;
  }

  Map<String, dynamic> _getRows(final List<Data?> keys, final List<Data?> column) {
    final Map<String, dynamic> temp = {};
    int index = 0;
    String tk = '';
   // GlobalFunction.print(column[1]?.value.toString() ?? '',name: 'taa');
    for (final Data? key in keys) {
      if (key != null && key.value != null && key.value.toString() != 'null' && key.value.toString() != '') {
        tk = key.value.toString().replaceAll('\n', ' ');
        if(index > 3){
          break;
        }
       // GlobalFunction.print(key.value.toString().replaceAll('\n', ' '),name: 'tk');

        if (column[index] is String ||
            column[index] is int ||
            column[index] is double ||
            column[index] is bool) {
          if (column[index]?.value == 'true') {
            temp[tk] = true;
          } else if (column[index]?.value == 'false') {
            temp[tk] = false;
          } else {
            temp[tk] = column[index]?.value.toString().replaceAll('\n', '');
         //  GlobalFunction.print(column[index]?.value.toString().replaceAll('\n', '') ?? '',name: 'Row1');
          }
        } else {

          temp[tk] = column[index]?.value.toString().replaceAll('\n', '');
         // GlobalFunction.print(row[index]?.value.toString().replaceAll('\n', '') ?? '',name: 'Row2');
        }

        index++;
      }
    }

    return temp;
  }

  List<String> _getSheets(final Excel excel) {
    final List<String> keys = [];

    for (final String table in excel.tables.keys) {
      keys.add(table);
    }
    print(keys.toString() + 'get table');
    return keys;
  }

  Future<Excel?> _getFile() async {
    final FilePickerResult? file = await FilePicker.platform.pickFiles(
      withData: true,
      type: FileType.custom,
      allowedExtensions: ['xlsx', 'csv', 'xls'],
    );
    if (file != null && file.files.isNotEmpty) {
      final Uint8List bytes = file.files.first.bytes!;

      return Excel.decodeBytes(bytes);
    } else {
      return null;
    }
  }
}

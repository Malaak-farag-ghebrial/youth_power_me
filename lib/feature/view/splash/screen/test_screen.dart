import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/component/my_indicator.dart';
import '../../../../core/component/my_toast.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../controller/student_cubit/student_cubit.dart';

class BulkUpload extends StatefulWidget {
  const BulkUpload({Key? key}) : super(key: key);

  @override
  State<BulkUpload> createState() => _BulkUploadState();
}

class _BulkUploadState extends State<BulkUpload> {
  // String? filePath;

  // This function is triggered when the  button is pressed

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StudentCubit, StudentState>(
      builder: (context, state) {
        var studentCubit = StudentCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title: const Text("Bulk Upload",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                )),
          ),
          body: Column(
            children: [
              ElevatedButton(
                child: const Text("Upload FIle"),
                onPressed: () {
                  // if (SettingCubit.get(context).keysModel.isNotEmpty) {
                  //   StudentCubit.get(context).getStudentFromExcel(
                  //     firstRowNum: SettingCubit.get(context)
                  //         .keysModel
                  //         .firstWhere((element) => element.active)
                  //         .firstRowIndex,
                  //     sheetKey: SettingCubit.get(context)
                  //         .keysModel
                  //         .firstWhere((element) => element.active)
                  //         .sheetName,
                  //     nameKey: SettingCubit.get(context)
                  //         .keysModel
                  //         .firstWhere((element) => element.active)
                  //         .name,
                  //     phoneKey: SettingCubit.get(context)
                  //         .keysModel
                  //         .firstWhere((element) => element.active)
                  //         .phone,
                  //     acdYKey: SettingCubit.get(context)
                  //         .keysModel
                  //         .firstWhere((element) => element.active)
                  //         .academicYear,
                  //     numKey: SettingCubit.get(context)
                  //         .keysModel
                  //         .firstWhere((element) => element.active)
                  //         .numberKey,
                  //     birthDate: SettingCubit.get(context)
                  //         .keysModel
                  //         .firstWhere((element) => element.active)
                  //         .birthDate
                  //   );
                  // } else {
                  //   MyToast(
                  //       msg: AppString.add_key_first,
                  //       state: ToastStates.FAILED);
                  // }
                },
              ),
              const SizedBox(
                height: 20,
              ),
              state is GetStudentFromExcelLoading
                  ? const MyIndicator(
                      small: false,
                    )
                  : Expanded(
                      child: ListView.builder(
                        itemCount: studentCubit.studentModel.length,
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemBuilder: (_, index) {
                          return Card(
                            margin: const EdgeInsets.all(3),
                            color: index == 0 ? Colors.amber : Colors.white,
                            child: ListTile(
                              leading: Text(
                                studentCubit.studentModel[index].id
                                    .toString(), //['#'],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: index == 0 ? 18 : 15,
                                    fontWeight: index == 0
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    color:
                                        index == 0 ? Colors.red : Colors.black),
                              ),
                              title: Text(
                                studentCubit.studentModel[index].name,
                                //['الأسم (ربـاعــياً) بالغة العربية'],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: index == 0 ? 18 : 15,
                                    fontWeight: index == 0
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    color:
                                        index == 0 ? Colors.red : Colors.black),
                              ),
                              trailing: Text(
                                studentCubit.studentModel[index].phone ?? AppString.not_found,
                                //['رقم المحمول  (واتس آب)'],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: index == 0 ? 18 : 15,
                                    fontWeight: index == 0
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    color:
                                        index == 0 ? Colors.red : Colors.black),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
              // Container(
              //   child:  ElevatedButton(
              //     onPressed: ()async{
              //       // set loading to true here
              //
              //       for (var element in _data)  // for skip first value bcs its contain name
              //           {
              //         // var mydata = {
              //         //   "data": {
              //         //     "certificateType": "ProofOfEducation",
              //         //     "membershipNum": element[0],   if you want to iterate only name then use element[0]
              //         //     "registrationNum": element[1],
              //         //     "serialNum": element[2],
              //         //     "bcName": element[3],
              //         //     "bcExam": element[4],
              //         //     "date":element[5]
              //         //   },
              //         //
              //         // };
              //         ScaffoldMessenger.of(context).showSnackBar(  SnackBar(
              //           content: Text(element.toString()),
              //         ));
              //       }
              //
              //     }, child: const Text("Iterate Data"),
              //
              //   ),
              // ),
            ],
          ),
        );
      },
    );
  }
}
//   void _pickFile() async {
//     final List<StudentModel> excel =
//         await ExcelService().convertExcelToStudent(
//           firstRowNum: 1,
//           sheetKey: 'مهرجان 2023',
//           nameKey: 'الأسم (ربـاعــياً) بالغة العربية',
//         acdYKey: 'العام الجامعى',
//           numKey: '#',
//           phoneKey: 'رقم المحمول  (واتس آب)',
//         );
//     GlobalFunction.print(excel.toString());
//     // GlobalFunction.print(excel.academicYear.toString());
//     // GlobalFunction.print(excel.phone.toString());
//
//     // final result = await FilePicker.platform.pickFiles(allowMultiple: false);
//     //
//     // // if no file is picked
//     // if (result == null) return;
//     // // we will log the name, size and path of the
//     // // first picked file (if multiple are selected)
//     // print(result.files.first.name);
//     // filePath = result.files.first.path!;
//     //
//     // var bytes = File(filePath!).readAsBytesSync();
//     // var excel = Excel.decodeBytes(bytes);
//     //
//     // for (var table in excel.tables.keys) {
//     //   print(table); //sheet Name
//     //   if(excel.tables[table]!.rows[1][1]!.value.toString().contains('الأسم'))
//     //   print(excel.tables[table]!.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 0))); //sheet Name
//     //  // print(excel.tables[table]!.rows.toString());
//     //  // print(excel.tables[table]!.cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: 2)));
//     // }
//     // final input = File(filePath!).openRead();
//     // print(input.toString());
//     // final fields = await input
//     //     .transform(utf8.decoder)
//     //     .transform(const CsvToListConverter())
//     //     .toList();
//     // print(fields);
//
//   //   setState(() {
//   //     _data = List<StudentModel>.from(excel);
//   //   });
//   //   print(_data.length);
//   // }
// }

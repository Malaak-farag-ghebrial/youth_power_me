import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/component/my_input_field.dart';
import '../../../../core/component/my_navigator.dart';
import '../../../../core/component/my_text.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../controller/student_cubit/student_cubit.dart';
import '../widgets/add_student_dialog.dart';
import '../widgets/student_card.dart';
import 'student_detail.dart';

class StudentScreen extends StatelessWidget {
   StudentScreen({super.key});
final searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return  BlocBuilder<StudentCubit,StudentState>(
      builder: (context,state) {
        var studentCubit = StudentCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title: MyText(
              AppString.student,
              style: Theme
                  .of(context)
                  .textTheme
                  .titleMedium,
            ),
            actions: [
              IconButton(
                onPressed: () async {
                  await showDialog(
                      context: context,
                      builder: (context) {
                        return AddStudentDialog();
                      });
                },
                icon: const Icon(AppIcons.add),
              )
            ],
          ),
          body: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              MyInputField(
                controller: searchController,
                onChanged: (value){
                  StudentCubit.get(context).searchStudent(searchWord: value);
                },
                hintText: AppString.search,
              ),
              ListView.builder(
                  itemCount: studentCubit.searchStudentModel.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: (){
                        navigateTo(context, StudentDetail(studentModel: studentCubit.searchStudentModel[index],));
                      },
                      child: StudentCard(
                        student: studentCubit.searchStudentModel[index],
                        onDeletePressed: (){
                          studentCubit.deleteStudent(id: studentCubit.searchStudentModel[index].id ?? 0);
                        },
                        onEditPressed: ()async{
                          await showDialog(context: context,
                              builder: (context){
                                return AddStudentDialog(edit: true,student: studentCubit.searchStudentModel[index],);
                              },);
                        },
                      ),
                    );
                  }),
            ],
          ),
        );
      }
    );
  }
}

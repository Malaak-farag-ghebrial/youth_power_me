import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:youth_power/core/component/my_indicator.dart';
import '../../../../core/component/my_button.dart';
import '../../../../core/component/my_input_field.dart';
import '../../../../core/component/my_navigator.dart';
import '../../../../core/component/my_text.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../controller/student_cubit/student_cubit.dart';
import '../widgets/add_student_dialog.dart';
import '../widgets/student_card.dart';
import 'nearest_birth_date_list.dart';
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
              MyOutlinedButton(
                textWord: AppString.birth_date,
                hasBorder: true,
                borderColor: AppColors.primaryColor,
                fontSize: 15,
                borderWidth: 2,
                buttonHeight: 40,
                buttonWidth: 120,
                margin: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 5),
                padding: const EdgeInsets.symmetric(vertical: 5),
                borderRadius: BorderRadius.circular(10),
                onTap: () {
                  StudentCubit.get(context).filterBirthDateStudent(
                      startTime:
                      DateTime.now()
                          .subtract(const Duration(days: 7)),
                      endTime: DateTime.now()
                          .add(const Duration(days: 7)));

                  navigateTo(context, NearestBirthDateStudent());
                },
              ),
             state is GetStudentLoading ? const MyIndicator() : Expanded(
               child: ListView.builder(
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
             ),
            ],
          ),
        );
      }
    );
  }
}

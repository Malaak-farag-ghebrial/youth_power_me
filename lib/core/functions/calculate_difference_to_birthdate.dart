

import 'package:youth_power/core/functions/global_variable.dart';

int difference(String birthdate) {
 int days = DateTime(DateTime.now().year, DateTime.parse(birthdate).month, DateTime.parse(birthdate).day)
        .difference(DateTime.now())
        .inDays;

 int daysToNewYear =  DateTime.now().difference(
       DateTime(DateTime.now().year + 1, DateTime.parse(birthdate).month,
           DateTime.parse(birthdate).day)
   ).inDays;
 if(days.abs() <= daysToNewYear.abs()){
   GlobalFunction.print(days.toString());
   return days;
 }else{
   GlobalFunction.print(daysToNewYear.toString());
   return daysToNewYear;
 }

  // if (DateTime(DateTime.now().year, DateTime.parse(birthdate).month,
  //         DateTime.parse(birthdate).day)
  //     .isAfter(DateTime.now())) {
  //   return DateTime(DateTime.now().year, DateTime.parse(birthdate).month,
  //           DateTime.parse(birthdate).day)
  //       .difference(
  //         DateTime.now(),
  //       )
  //       .inDays;
  // } else {
  //   return
  //   DateTime.now().difference(
  //       DateTime(DateTime.now().year + 1, DateTime.parse(birthdate).month,
  //           DateTime.parse(birthdate).day)
  //   ).inDays;
  // }
}

bool isAfterDate(String date) {
  return DateTime(DateTime.now().year, DateTime.parse(date).month,
          DateTime.parse(date).day)
      .isAfter(DateTime.now());
}

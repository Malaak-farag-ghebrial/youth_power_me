part of 'week_cubit.dart';

abstract class WeekState {}

class WeekInitial extends WeekState {}

class AddWeekLoading extends WeekState {}
class AddWeekSuccess extends WeekState {}
class AddWeekFailed extends WeekState {}

class AddActivityWeekLoading extends WeekState {}
class AddActivityWeekSuccess extends WeekState {}
class AddActivityWeekFailed extends WeekState {}
class PreAdded extends WeekState {}

class AttendActivityStudentLoading extends WeekState {}
class AttendActivityStudentSuccess extends WeekState {}
class AttendActivityStudentFailed extends WeekState {}

class IsStudentAttendLoading extends WeekState {}
class IsStudentAttendSuccess extends WeekState {}
class IsStudentAttendFailed extends WeekState {}

class GetPoints extends WeekState {}


class GetWeekLoading extends WeekState {}
class GetWeekSuccess extends WeekState {}
class GetWeekFailed extends WeekState {}

class DeleteWeekLoading extends WeekState {}
class DeleteWeekSuccess extends WeekState {}
class DeleteWeekFailed extends WeekState {}

class ExcelLoading extends WeekState {}
class ExcelSuccess extends WeekState {}

part of 'student_cubit.dart';

abstract class StudentState {}

class StudentInitial extends StudentState {}

class AddStudentLoading extends StudentState {}
class AddStudentSuccess extends StudentState {}
class AddStudentFailed extends StudentState {}

class DatabaseFailed extends StudentState {}

class AttendStudentLoading extends StudentState {}
class AttendStudentSuccess extends StudentState {}
class AttendStudentFailed extends StudentState {}

class FilterAbsentStudentLoading extends StudentState {}
class FilterAbsentStudentSuccess extends StudentState {}

class FilterBirthDateStudentLoading extends StudentState {}
class FilterBirthDateStudentSuccess extends StudentState {}

class RemoveAttendStudentLoading extends StudentState {}
class RemoveAttendStudentSuccess extends StudentState {}
class RemoveAttendStudentFailed extends StudentState {}

class AddPointStudentLoading extends StudentState {}
class AddPointStudentSuccess extends StudentState {}
class AddPointStudentFailed extends StudentState {}

class EditStudentLoading extends StudentState {}
class EditStudentSuccess extends StudentState {}
class EditStudentFailed extends StudentState {}

class GetStudentLoading extends StudentState {}
class GetStudentSuccess extends StudentState {}
class GetStudentFailed extends StudentState {}

class SearchStudentLoading extends StudentState {}
class SearchStudentSuccess extends StudentState {}

class ScanStudentCodeLoading extends StudentState {}
class ScanStudentCodeSuccess extends StudentState {}

class DeleteStudentLoading extends StudentState {}
class DeleteStudentSuccess extends StudentState {}
class DeleteStudentFailed extends StudentState {}

class GetStudentFromExcelLoading extends StudentState {}
class GetStudentFromExcelSuccess extends StudentState {}
class GetStudentFromExcelFailed extends StudentState {}
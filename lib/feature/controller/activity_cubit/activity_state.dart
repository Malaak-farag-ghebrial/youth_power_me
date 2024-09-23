part of 'activity_cubit.dart';

abstract class ActivityState {}

class ActivityInitial extends ActivityState {}

class AddActivityLoading extends ActivityState {}
class AddActivitySuccess extends ActivityState {}
class AddActivityFailed extends ActivityState {}

class DatabaseFailed extends ActivityState {}

class EditActivityLoading extends ActivityState {}
class EditActivitySuccess extends ActivityState {}
class EditActivityFailed extends ActivityState {}

class GetActivityLoading extends ActivityState {}
class GetActivitySuccess extends ActivityState {}
class GetActivityFailed extends ActivityState {}

class DeleteActivityLoading extends ActivityState {}
class DeleteActivitySuccess extends ActivityState {}
class DeleteActivityFailed extends ActivityState {}

class AddTimeField extends ActivityState {}
class EditAvailability extends ActivityState {}
class EditRepeatability extends ActivityState {}

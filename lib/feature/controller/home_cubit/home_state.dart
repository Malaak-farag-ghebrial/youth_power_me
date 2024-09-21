part of 'home_cubit.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class BtmNavBar extends HomeState {}

class CreateDatabaseLoading extends HomeState {}
class CreateDatabaseSuccess extends HomeState {}
class CreateDatabaseFailed extends HomeState {}




import 'package:equatable/equatable.dart';
import 'package:youth_power/core/constants/api_keyword.dart';

class ErrorMessageModel extends Equatable {

  final String? statusCode;
  final String? message;

 const ErrorMessageModel({
    this.statusCode,
    this.message,
});

 // factory ErrorMessageModel.fromJson(Map<String,dynamic> json){
 //   // return ErrorMessageModel(
 //   //   statusCode: json[ApiKey.errors],
 //   //   message: json[ApiKey.errors],
 //   // );
 // }

  @override
  List<Object?> get props => [
 statusCode,
    message,
  ];






}
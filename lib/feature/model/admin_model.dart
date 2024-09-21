import 'package:equatable/equatable.dart';

import '../../core/constants/api_keyword.dart';


class AdminModel extends Equatable {
  final int id;
  final String email;
  final String password;

  const AdminModel({
    required this.id,
    required this.email,
    required this.password,
  });

  factory AdminModel.fromJson(Map<String, dynamic> json) {
    return AdminModel(
      id: json[ApiKey.id],
      email: json[ApiKey.email],
      password: json[ApiKey.password],
    );
  }

  Map<String,dynamic> toJson(){
    final Map<String,dynamic> data = <String,dynamic>{};
    data[ApiKey.id] = id;
    data[ApiKey.email] = email;
    data[ApiKey.password] = password;
    return data;
  }

  @override
  List<Object?> get props => [
    id,
    email,
    password,
  ];

}

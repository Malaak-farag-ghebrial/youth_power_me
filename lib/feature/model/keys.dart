

import 'package:equatable/equatable.dart';

import '../../core/constants/api_keyword.dart';

class KeysModel extends Equatable {
  final int id;
  final String name;
  final bool active;
  final String phone;
  final String academicYear;
  final int firstRowIndex;
  final String sheetName;
  final String numberKey;
  final String birthDate;

   const KeysModel({
    required this.id,
    required this.name,
    required this.active,
    required this.phone,
    required this.academicYear,
    required this.firstRowIndex,
    required this.sheetName,
    required this.numberKey,
     required this.birthDate,
  });

  // KeysModel decrementIndexAtDataBase() {
  //   return KeysModel(
  //     indexAtDatabase: indexAtDatabase - 1,
  //     name: name,
  //     active: active,
  //     phone: phone,
  //     academicYear: academicYear,
  //     firstRowIndex: firstRowIndex,
  //     sheetName: sheetName,
  //     numberKey: numberKey,
  //     birthDate: birthDate,
  //   );
  // }
  //
  // KeysModel activate() {
  //   return KeysModel(
  //       indexAtDatabase: indexAtDatabase,
  //       name: name,
  //       active: true,
  //       phone: phone,
  //       academicYear: academicYear,
  //       firstRowIndex: firstRowIndex,
  //     sheetName: sheetName,
  //     numberKey: numberKey,
  //     birthDate: birthDate,
  //   );
  // }
  //
  // KeysModel deactivate() {
  //   return KeysModel(
  //       indexAtDatabase: indexAtDatabase,
  //       name: name,
  //       active: false,
  //       phone: phone,
  //       academicYear: academicYear,
  //       firstRowIndex: firstRowIndex,
  //   sheetName: sheetName,
  //     numberKey: numberKey,
  //     birthDate: birthDate
  //   );
  // }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data[ApiKey.name] = name;
    data[ApiKey.active] = active;
    data[ApiKey.phone] = phone;
    data[ApiKey.academicYear] = academicYear;
    data[ApiKey.firstRowIndex] = firstRowIndex;
    data[ApiKey.sheetName] = sheetName;
    data[ApiKey.numberKey] = numberKey;
    data[ApiKey.birthDate] = birthDate;
    return data;
  }

  factory KeysModel.fromJson(Map<String, dynamic> json) {
    return KeysModel(
      id: json[ApiKey.id],
      name: json[ApiKey.name],
      active: json[ApiKey.active],
      phone: json[ApiKey.phone],
      academicYear: json[ApiKey.academicYear],
      firstRowIndex: json[ApiKey.firstRowIndex],
      sheetName: json[ApiKey.sheetName],
      numberKey: json[ApiKey.numberKey],
      birthDate: json[ApiKey.birthDate],
    );
  }

  @override
  List<Object?> get props => [
    id,
  ];
}

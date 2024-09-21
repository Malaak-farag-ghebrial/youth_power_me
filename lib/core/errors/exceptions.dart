
import 'package:youth_power/core/errors/error_message_model.dart';

class ServerException implements Exception {

  final ErrorMessageModel errorMessageModel;

  const ServerException({required this.errorMessageModel});

}
//
// class FirebaseServerException implements FirebaseAuthException{
//   final ErrorMessageModel errorMessageModel;
//
//  const FirebaseServerException({required this.errorMessageModel});
//
//   @override
//   String get code => throw UnimplementedError();
//
//   @override
//   AuthCredential? get credential => throw UnimplementedError();
//
//   @override
//   String? get email => throw UnimplementedError();
//
//   @override
//
//   String? get message => throw UnimplementedError();
//
//   @override
//
//   String? get phoneNumber => throw UnimplementedError();
//
//   @override
//
//   String get plugin => throw UnimplementedError();
//
//   @override
//
//   StackTrace? get stackTrace => throw UnimplementedError();
//
//   @override
//   String? get tenantId => throw UnimplementedError();
//
//
//
// }

class MyDatabaseException implements Exception {

  final ErrorMessageModel errorMessageModel;

  const MyDatabaseException({required this.errorMessageModel});

}
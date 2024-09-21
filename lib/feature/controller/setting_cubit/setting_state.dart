part of 'setting_cubit.dart';

abstract class SettingState {}

class SettingInitial extends SettingState {}

class AddToDatabaseLoading extends SettingState {}
class AddToDatabaseSuccess extends SettingState {}
class AddToDatabaseFailed extends SettingState {}

class GetKeysLoading extends SettingState {}
class GetKeysSuccess extends SettingState {}
class GetKeysFailed extends SettingState {}

class DeleteKeysLoading extends SettingState {}
class DeleteKeysSuccess extends SettingState {}
class DeleteKeysFailed extends SettingState {}

class ActivateKeysLoading extends SettingState {}
class ActivateKeysFailed extends SettingState {}
class ActivateKeysSuccess extends SettingState {}

class UploadBackupLoading extends SettingState {}
class UploadBackupFailed extends SettingState {}
class UploadBackupSuccess extends SettingState {}

class DownloadBackupLoading extends SettingState {}
class DownloadBackupFailed extends SettingState {}
class DownloadBackupSuccess extends SettingState {}

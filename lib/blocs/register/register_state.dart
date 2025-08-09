part of 'register_bloc.dart';

class RegisterState {}

final class RegisterInitial extends RegisterState {}

final class PasswordWeakSTate extends RegisterState {}

final class EmailAlreadyInUseState extends RegisterState {}

final class RegistrationFailedState extends RegisterState {
  String error;
  RegistrationFailedState({required this.error});
}

final class RegistrationSuccess extends RegisterState {}

part of 'register_bloc.dart';

class RegisterEvent {}

class RegistrationEvent extends RegisterEvent {
  String email;
  String password;
  RegistrationEvent({required this.email, required this.password});
}

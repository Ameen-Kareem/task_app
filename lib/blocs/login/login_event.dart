part of 'login_bloc.dart';

class LoginEvent {}

class LoginAttemptEvent extends LoginEvent {
  String email;
  String password;
  LoginAttemptEvent({required this.email, required this.password});
}

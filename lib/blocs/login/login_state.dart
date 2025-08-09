part of 'login_bloc.dart';

class LoginState {}

final class LoginInitial extends LoginState {}

final class LoginSuccessState extends LoginState {}

final class LoginFailedState extends LoginState {
  String error;
  LoginFailedState({required this.error});
}

final class EmailNotFoundState extends LoginState {}

final class WrongPasswordState extends LoginState {}

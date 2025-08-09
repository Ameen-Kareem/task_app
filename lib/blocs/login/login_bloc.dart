import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    on<LoginAttemptEvent>((event, emit) async {
      try {
        final credential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
              email: event.email,
              password: event.password,
            );
        if (credential.user != null) {
          emit(LoginSuccessState());
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          emit(EmailNotFoundState());
        } else if (e.code == 'wrong-password') {
          emit(WrongPasswordState());
        } else {
          emit(LoginFailedState(error: e.toString()));
        }
      }
    });
  }
}

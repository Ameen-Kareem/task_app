import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc() : super(RegisterInitial()) {
    on<RegistrationEvent>((event, emit) async {
      try {
        final credential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
              email: event.email,
              password: event.password,
            );
        if (credential.user != null) {
          emit(RegistrationSuccess());
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          emit(PasswordWeakSTate());
        } else if (e.code == 'email-already-in-use') {
          emit(EmailAlreadyInUseState());
        }
      } catch (e) {
        emit(RegistrationFailedState(error: e.toString()));
      }
    });
  }
}

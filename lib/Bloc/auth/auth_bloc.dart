import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:email_validator/email_validator.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  SignInBloc() : super(SignInInitialState()) {
    on<SignInTextChangedEvent>((event, state) {
      if (!EmailValidator.validate(event.emailValue)) {
        emit(SignInErrorState("Pls enter a valid email address."));
      } else if (event.passwordValue.length < 6) {
        emit(SignInErrorState("Please enter a valid password"));
      } else {
        emit(SignInValidState());
      }
    });
    on<SignInSubmittedEvent>((event, state) => emit(SignInLoadingState()));
  }
}

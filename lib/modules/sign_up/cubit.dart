import 'package:bloc/bloc.dart';
import 'package:salla/modules/sign_up/sign_up_states.dart';
import 'package:salla/shared/network/local/salla_States.dart';

class SignUp extends Cubit<SallaStates> {
  SignUp() : super(InitialSignUpState());
}

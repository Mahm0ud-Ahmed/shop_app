import 'package:salla/shared/network/local/salla_States.dart';

class InitialSignUpState extends SallaStates {}

class SuccessSignUpState extends SallaStates {}

class ErrorSignUpState extends SallaStates {
  final _error;

  ErrorSignUpState(this._error);
}

class LoadingSignUpState extends SallaStates {}

class ChangeVisibilityPasswordSignUpState extends SallaStates {}

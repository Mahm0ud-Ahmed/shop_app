import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salla/model/user_model.dart';
import 'package:salla/modules/product/cubit.dart';
import 'package:salla/modules/sign_in/sign_in.dart';
import 'package:salla/modules/sign_in/sign_in_states.dart';
import 'package:salla/modules/sign_up/sign_up.dart';
import 'package:salla/modules/sign_up/sign_up_states.dart';
import 'package:salla/shared/component/constants.dart';
import 'package:salla/shared/network/local/storage_pref.dart';
import 'package:salla/shared/network/remot/dio_helper.dart';
import 'package:salla/shared/network/local/salla_States.dart';

class LoginCubit extends Cubit<SallaStates> {
  LoginCubit() : super(InitialSignInState());

  bool isSecure = true;
  Icon icon = Icon(Icons.visibility_off_outlined);

  UserModel userList;

  static LoginCubit get(context) => BlocProvider.of<LoginCubit>(context);

  void changeVisibilityIcon(SallaStates state) {
    isSecure = !isSecure;
    isSecure
        ? icon = Icon(Icons.visibility_off_outlined)
        : icon = Icon(Icons.visibility_outlined);
    if (state is ChangeVisibilityPasswordSignInState) {
      emit(ChangeVisibilityPasswordSignInState());
    } else {
      emit(ChangeVisibilityPasswordSignUpState());
    }
  }

  // بسبب مشابهة ال 2 Screen لبعضهم
  // قمنا بعمل باراميتر وهو ال route ومهمته هي
  // معرفة ال screen القادمة لل cubit ليقوم بعمل emit لل state المحدده فقط
  void postUserLogin({
    @required BuildContext context,
    @required String route,
    @required String email,
    @required String password,
    @required String url,
    String phone,
    String userName,
  }) {
    if (route == SignIn.SIGN_IN_SCREEN)
      emit(LoadingSignInState());
    else if (route == SignUp.SIGN_UP_SCREEN) emit(LoadingSignUpState());

    SallaDioHelper.postData(endPointUrl: url, data: {
      'email': email,
      'password': password,
      'name': userName,
      'phone': phone,
    }).then((value) {
      if (route == SignIn.SIGN_IN_SCREEN) {
        userList = UserModel.fromJsonLogin(value.data);
        if (userList.status) {
          StoragePref.setValue('token', userList.dataLogin.token).then((value) {
            if (value) {
              String key = StoragePref.getValue('token');
              print('Shared Pref: ---> ${key}');
            }
          });
          token = userList.dataLogin.token;
          print(userList.dataLogin.token);
        }
        emit(SuccessSignInState());
      } else if (route == SignUp.SIGN_UP_SCREEN) {
        userList = UserModel.fromJsonRegister(value.data);
        if (userList.status) {
          StoragePref.setValue('token', userList.dataRegister.token);
          token = userList.dataRegister.token;
          /*.then((value) => pushAndReplace(context, SignIn.SIGN_IN_SCREEN));*/
        }
        emit(SuccessSignUpState());
      }
    }).catchError((error) {
      if (route == SignIn.SIGN_IN_SCREEN)
        emit(ErrorSignInState(error.toString()));
      else if (route == SignUp.SIGN_UP_SCREEN)
        emit(ErrorSignUpState(error.toString()));
      print(error.toString());
    });
  }
}

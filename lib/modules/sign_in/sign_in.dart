import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salla/layout/navigation_bar/navigation_bar.dart';
import 'package:salla/model/user_model.dart';
import 'package:salla/modules/product/cubit.dart';
import 'package:salla/modules/product/product.dart';
import 'package:salla/modules/sign_in/cubit.dart';
import 'package:salla/modules/sign_in/sign_in_states.dart';
import 'package:salla/modules/sign_up/sign_up.dart';
import 'package:salla/shared/component/components.dart';
import 'package:salla/shared/component/constants.dart';
import 'package:salla/shared/network/local/salla_States.dart';
import 'package:salla/shared/style/colors.dart';

class SignIn extends StatefulWidget {
  static const String SIGN_IN_SCREEN = 'sign_in';

  const SignIn({Key key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController _userController = TextEditingController();
  TextEditingController _passController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _passController.dispose();
    _userController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    UserModel user;
    var currentState;
    return BlocConsumer<LoginCubit, SallaStates>(
      listener: (context, state) {
        currentState = state;
        user = LoginCubit.get(context).userList;
        if (state is SuccessSignInState) {
          if (user.status) {
            pushAndReplace(context, NavigationBar.NAVIGATION_BAR_SCREEN);
            Flushbar(
              title: 'Alert!',
              message: user.message,
              duration: Duration(seconds: 3),
            )..show(context);
          } else {
            Flushbar(
              title: 'Alert!',
              message: user.message,
              duration: Duration(seconds: 3),
            )..show(context);
          }
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: Center(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // SizedBox(
                        //   height: MediaQuery.of(context).size.height * 0.15,
                        // ),
                        Text(
                          'Log In',
                          style: Theme.of(context).textTheme.headline3.copyWith(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        customTextEditing(
                          label: 'Email Address',
                          controller: _userController,
                          icon: Icon(Icons.email_outlined),
                          valid: (String value) {
                            if (value.isEmpty) {
                              return 'This field should not be empty';
                            }
                            return null;
                          },
                          keyboard: TextInputType.emailAddress,
                        ),
                        SizedBox(
                          height: 14,
                        ),
                        customTextEditing(
                          label: 'Password',
                          controller: _passController,
                          icon: Icon(Icons.vpn_key_outlined),
                          valid: (String value) {
                            if (value.isEmpty) {
                              return 'This field should not be empty';
                            }
                            return null;
                          },
                          keyboard: TextInputType.text,
                          obscureText: LoginCubit.get(context).isSecure,
                          suffixIcon: IconButton(
                            icon: LoginCubit.get(context).icon,
                            onPressed: () {
                              LoginCubit.get(context)
                                  .changeVisibilityIcon(currentState);
                            },
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: state is! LoadingSignInState
                              ? ElevatedButton(
                                  onPressed: () async {
                                    if (formKey.currentState.validate()) {
                                      LoginCubit.get(context).postUserLogin(
                                          route: SignIn.SIGN_IN_SCREEN,
                                          email: _userController.text,
                                          password: _passController.text,
                                          url: END_POINT_SIGN_IN,
                                          context: context);
                                      print(
                                          '${_userController.text}\n ${_passController.text}');
                                    }
                                  },
                                  child: Text(
                                    'LOGIN',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline6
                                        .copyWith(
                                          color: Colors.white,
                                        ),
                                  ),
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all(Colors.green),
                                  ),
                                )
                              : Center(child: CircularProgressIndicator()),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Don\'t have an account?',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6
                                  .copyWith(
                                    color: Colors.black,
                                    fontSize: 16,
                                  ),
                            ),
                            TextButton(
                                onPressed: () {
                                  pushInStack(context, SignUp.SIGN_UP_SCREEN);
                                },
                                child: Text(
                                  'REGISTER',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline6
                                      .copyWith(
                                        color: colorAcc,
                                        fontSize: 16,
                                      ),
                                )),
                          ],
                        ),
                        SizedBox(
                          height: 30,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

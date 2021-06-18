import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salla/model/user_model.dart';
import 'package:salla/modules/settings/cubit.dart';
import 'package:salla/modules/settings/setting_state.dart';
import 'package:salla/shared/component/components.dart';
import 'package:salla/shared/network/local/salla_States.dart';

class ProfileInformation extends StatefulWidget {
  const ProfileInformation({Key key}) : super(key: key);

  @override
  _ProfileInformationState createState() => _ProfileInformationState();
}

class _ProfileInformationState extends State<ProfileInformation> {
  GlobalKey<FormState> formState = GlobalKey<FormState>();

  TextEditingController userController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    userController.dispose();
    phoneController.dispose();
    emailController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    UserDataLogin userInfoModel;
    UserModel userModel;

    return Form(
      key: formState,
      child: Container(
        padding: EdgeInsets.all(12),
        child: Center(
          child: BlocConsumer<SettingCubit, SallaStates>(
            listener: (context, state) {
              if (state is SuccessSettingState) {
                userInfoModel = SettingCubit.get(context).userInfoModel;
                userController.text = userInfoModel.name;
                phoneController.text = userInfoModel.phone;
                emailController.text = userInfoModel.email;
              } else if (state is SuccessUpdateSettingState) {
                userModel = SettingCubit.get(context).userModel;
                if (userModel != null) {
                  Flushbar(
                    title: 'Alert!',
                    message: userModel.message,
                    duration: Duration(seconds: 3),
                  )..show(context);
                }
              }
            },
            builder: (context, state) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  customTextEditing(
                    label: 'User Name',
                    controller: userController,
                    icon: Icon(Icons.account_circle_outlined),
                    valid: (String value) {
                      if (value.isEmpty) {
                        return 'This field should not be empty';
                      }
                      return null;
                    },
                    keyboard: TextInputType.text,
                  ),
                  SizedBox(
                    height: 14,
                  ),
                  customTextEditing(
                    label: 'Phone Number',
                    controller: phoneController,
                    icon: Icon(Icons.phone_android_outlined),
                    valid: (String value) {
                      if (value.isEmpty) {
                        return 'This field should not be empty';
                      }
                      return null;
                    },
                    keyboard: TextInputType.phone,
                  ),
                  SizedBox(
                    height: 14,
                  ),
                  customTextEditing(
                    label: 'Email Address',
                    controller: emailController,
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
                  state is! LoadingUpdateSettingState
                      ? ElevatedButton(
                          onPressed: () {
                            if (formState.currentState.validate()) {
                              SettingCubit.get(context).updateProfile(
                                  name: userController.text,
                                  phone: phoneController.text,
                                  email: emailController.text);
                            }
                          },
                          child: Text(
                            'Update Data',
                          ),
                          style: ButtonStyle(
                            minimumSize: MaterialStateProperty.all(
                              Size(140, 40),
                            ),
                            backgroundColor:
                                MaterialStateProperty.all(Colors.green),
                          ),
                        )
                      : Center(child: CircularProgressIndicator()),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

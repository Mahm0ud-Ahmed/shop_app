import 'package:another_flushbar/flushbar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
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
              if (state is SuccessSettingState ||
                  state is ChangeStateExpansionSettingState) {
                userInfoModel = SettingCubit.get(context).userInfoModel;
                userController.text = userInfoModel.name;
                phoneController.text = userInfoModel.phone;
                emailController.text = userInfoModel.email;
              } else if (state is SuccessUpdateSettingState) {
                // SettingCubit.get(context).getUserInfo();
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
              userInfoModel = SettingCubit.get(context).userInfoModel;
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ListTile(
                                  title: Text('Photo Gallery'),
                                  leading: Icon(
                                    Icons.photo,
                                    size: 24,
                                  ),
                                  onTap: () {
                                    SettingCubit.get(context)
                                        .getImage(ImageSource.gallery);
                                    Navigator.of(context).pop();
                                  },
                                  minLeadingWidth: 5,
                                ),
                                ListTile(
                                  title: Text('take a picture'),
                                  leading: Icon(
                                    Icons.camera_alt,
                                    size: 24,
                                  ),
                                  onTap: () {
                                    SettingCubit.get(context)
                                        .getImage(ImageSource.camera);
                                    Navigator.of(context).pop();
                                  },
                                  minLeadingWidth: 5,
                                ),
                              ],
                            );
                          });
                    },
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: SettingCubit.get(context).image != null
                              ? Image(
                                  image: FileImage(
                                      SettingCubit.get(context).image),
                                  width: 120,
                                  height: 120,
                                  fit: BoxFit.cover,
                                )
                              : CachedNetworkImage(
                                  width: 120,
                                  height: 120,
                                  fit: BoxFit.cover,
                                  imageUrl: userInfoModel != null
                                      ? userInfoModel.image
                                      : 'https://www.pngitem.com/pimgs/m/24-248235_user-profile-avatar-login-account-fa-user-circle.png',
                                  placeholder: (context, url) => Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 12,
                          child: Icon(
                            Icons.add_a_photo,
                            size: 28,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 14,
                  ),
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
                              if (SettingCubit.get(context).base64 != null)
                                SettingCubit.get(context).updateProfile(
                                    image: SettingCubit.get(context).base64,
                                    name: userController.text,
                                    phone: phoneController.text,
                                    email: emailController.text);
                              else if (SettingCubit.get(context).base64 ==
                                  null) {
                                SettingCubit.get(context).updateProfile(
                                    name: userController.text,
                                    phone: phoneController.text,
                                    email: emailController.text);
                              }
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

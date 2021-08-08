import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salla/model/user_model.dart';
import 'package:salla/modules/settings/component/address_details.dart';
import 'package:salla/modules/settings/component/address_screen.dart';
import 'package:salla/modules/settings/cubit.dart';
import 'package:salla/modules/settings/setting_state.dart';
import 'package:salla/modules/sign_in/sign_in.dart';
import 'package:salla/shared/component/components.dart';
import 'package:salla/shared/component/constants.dart';
import 'package:salla/shared/network/local/salla_States.dart';
import 'package:salla/shared/network/local/storage_pref.dart';

class Setting extends StatelessWidget {
  static const String SETTING_SCREEN = 'setting_layout';

  @override
  Widget build(BuildContext context) {
    // SettingCubit.get(context).getUserInfo();
    UserDataLogin dataLogin;
    return Scaffold(
      appBar: AppBar(
        title: Text('Salla'),
        actions: [
          IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {
                StoragePref.removeValue('token').then((value) {
                  if (value) pushAndReplace(context, SignIn.SIGN_IN_SCREEN);
                });
              })
        ],
      ),
      body: BlocConsumer<SettingCubit, SallaStates>(
        listener: (context, state) {
          if (state is SuccessUpdateSettingState) {
            // SettingCubit.get(context).getUserInfo();
            dataLogin = SettingCubit.get(context).userInfoModel;
          }
        },
        builder: (context, state) {
          dataLogin = SettingCubit.get(context).userInfoModel;
          return SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 12,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(200),
                            child: CachedNetworkImage(
                              width: 75,
                              height: 75,
                              fit: BoxFit.cover,
                              imageUrl: dataLogin != null
                                  ? dataLogin.image
                                  : 'https://www.pngitem.com/pimgs/m/24-248235_user-profile-avatar-login-account-fa-user-circle.png',
                              placeholder: (context, url) => Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      if (dataLogin != null)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Welcome, ${dataLogin.name}'),
                            Text('${dataLogin.email}'),
                          ],
                        ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 6,
                ),
                ListView(
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  children: [
                    Container(
                      padding: EdgeInsets.all(6),
                      child: Card(
                        elevation: 2,
                        child: ExpansionPanelList(
                          expansionCallback: (position, expanded) {
                            SettingCubit.get(context)
                                .changeExpanded(position, !expanded);
                            print(expanded);
                          },
                          children: SettingCubit.get(context)
                              .itemExpansion
                              .map<ExpansionPanel>((item) {
                            return ExpansionPanel(
                              headerBuilder: (context, isExpanded) {
                                return Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 6),
                                  child: Text(
                                    item.title,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline6
                                        .copyWith(
                                          color: Colors.black,
                                          fontSize: 18,
                                        ),
                                  ),
                                );
                              },
                              isExpanded: item.isExpanded,
                              body: item.body,
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
                ListTile(
                  title: Text(
                    'Address',
                    style: Theme.of(context).textTheme.headline6.copyWith(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                  ),
                  leading: Icon(
                    Icons.location_on,
                    size: 22,
                  ),
                  subtitle: Text('Product Shipping Address'),
                  onTap: () {
                    pushInStack(context, AddressScreen.ADDRESS_SCREEN);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

Widget itemLang() {
  return Container(
    padding: EdgeInsets.all(12),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Builder(
          builder: (BuildContext context) {
            return OutlinedButton(
              onPressed: () {
                language = 'en';
                StoragePref.setValue('lang', language).then((value) {
                  if (value) {
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.SUCCES,
                      animType: AnimType.BOTTOMSLIDE,
                      title: 'Success Process',
                      desc:
                          'To implement the settings, restart the application',
                      btnOkOnPress: () {},
                    )..show();
                  }
                });
              },
              child: Text('English'),
              style: ButtonStyle(
                side: MaterialStateProperty.all(
                  BorderSide(color: Colors.black, width: 1.5),
                ),
                minimumSize: MaterialStateProperty.all(
                  Size(100, 40),
                ),
              ),
            );
          },
        ),
        Builder(
          builder: (BuildContext context) {
            return OutlinedButton(
              onPressed: () {
                language = 'ar';
                StoragePref.setValue('lang', language).then((value) {
                  if (value) {
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.SUCCES,
                      animType: AnimType.BOTTOMSLIDE,
                      title: 'Success Process',
                      desc:
                          'To implement the settings, restart the application',
                      btnOkOnPress: () {},
                    )..show();
                  }
                });
              },
              child: Text('عربي'),
              style: ButtonStyle(
                side: MaterialStateProperty.all(
                  BorderSide(color: Colors.black, width: 1.5),
                ),
                minimumSize: MaterialStateProperty.all(
                  Size(100, 40),
                ),
              ),
            );
          },
        ),
      ],
    ),
  );
}

Widget itemTheme() {
  return Container(
    padding: EdgeInsets.all(12),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Builder(
          builder: (BuildContext context) {
            return OutlinedButton(
              onPressed: () {
                isDark = true;
                StoragePref.setValue('isDark', isDark).then((value) {
                  if (value) {
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.SUCCES,
                      animType: AnimType.BOTTOMSLIDE,
                      title: 'Success Process',
                      desc:
                          'To implement the settings, restart the application',
                      btnOkOnPress: () {},
                    )..show();
                  }
                });
              },
              child: Text(
                'Dark',
                style: TextStyle(color: Colors.white),
              ),
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(Color.fromRGBO(38, 38, 38, 1)),
                side: MaterialStateProperty.all(
                  BorderSide(color: Colors.white, width: 1.5),
                ),
                minimumSize: MaterialStateProperty.all(
                  Size(100, 40),
                ),
              ),
            );
          },
        ),
        Builder(
          builder: (BuildContext context) {
            return OutlinedButton(
              onPressed: () {
                isDark = false;
                StoragePref.setValue('isDark', isDark).then((value) {
                  if (value) {
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.SUCCES,
                      animType: AnimType.BOTTOMSLIDE,
                      title: 'Success Process',
                      desc:
                          'To implement the settings, restart the application',
                      btnOkOnPress: () {},
                    )..show();
                  }
                });
              },
              child: Text('Light'),
              style: ButtonStyle(
                side: MaterialStateProperty.all(
                  BorderSide(color: Colors.black, width: 1.5),
                ),
                minimumSize: MaterialStateProperty.all(
                  Size(100, 40),
                ),
              ),
            );
          },
        ),
      ],
    ),
  );
}

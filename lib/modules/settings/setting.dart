import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salla/modules/settings/cubit.dart';
import 'package:salla/modules/sign_in/sign_in.dart';
import 'package:salla/shared/component/components.dart';
import 'package:salla/shared/component/constants.dart';
import 'package:salla/shared/network/local/salla_States.dart';
import 'package:salla/shared/network/local/storage_pref.dart';

class Setting extends StatelessWidget {
  static const String SETTING_SCREEN = 'setting_layout';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Salla'),
        actions: [
          IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {
                StoragePref.removeValue('token');
                pushAndReplace(context, SignIn.SIGN_IN_SCREEN);
              })
        ],
      ),
      body: BlocConsumer<SettingCubit, SallaStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return ListView(
            physics: BouncingScrollPhysics(),
            children: [
              Container(
                padding: EdgeInsets.all(6),
                child: Card(
                  elevation: 4,
                  child: ExpansionPanelList(
                    expansionCallback: (position, expanded) {
                      SettingCubit.get(context)
                          .changeExpanded(position, !expanded);
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

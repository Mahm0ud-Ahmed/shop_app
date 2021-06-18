import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salla/layout/navigation_bar/navigation_states.dart';
import 'package:salla/modules/category/category.dart';
import 'package:salla/modules/favorits/favorite.dart';
import 'package:salla/modules/product/product.dart';
import 'package:salla/modules/settings/setting.dart';
import 'package:salla/shared/network/local/salla_States.dart';

class NavigationCubit extends Cubit<SallaStates> {
  NavigationCubit() : super(InitialNavigationStates());

  static NavigationCubit get(BuildContext context) =>
      BlocProvider.of<NavigationCubit>(context);

  int currentIndex = 0;

  List<Widget> navigationScreens = [
    Category(),
    Product(),
    Favorite(),
    Setting()
  ];
  List<TabData> item = [
    TabData(iconData: Icons.category, title: ''),
    TabData(iconData: Icons.shopping_basket_rounded, title: ''),
    TabData(iconData: Icons.favorite, title: ''),
    TabData(iconData: Icons.settings, title: ''),
  ];

  void changeIndex(int index) {
    currentIndex = index;
    emit(ChangePageNavigationStates());
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salla/modules/cart/cart.dart';
import 'package:salla/modules/category/category_details/category_details.dart';
import 'package:salla/modules/favorits/favorite.dart';
import 'package:salla/modules/item_details/item_details.dart';
import 'package:salla/modules/search/search.dart';
import 'package:salla/modules/settings/component/address_details.dart';
import 'package:salla/modules/settings/component/address_screen.dart';
import 'package:salla/modules/settings/setting.dart';
import 'package:salla/modules/sign_in/cubit.dart';
import 'package:salla/shared/component/constants.dart';
import 'layout/navigation_bar/cubit.dart';
import 'layout/navigation_bar/navigation_bar.dart';
import 'modules/category/category.dart';
import 'modules/item_details/cubit.dart';
import 'modules/product/cubit.dart';
import 'modules/product/product.dart';
import 'modules/salla_boarding.dart';
import 'modules/settings/cubit.dart';
import 'modules/sign_in/sign_in.dart';
import 'modules/sign_up/sign_up.dart';
import 'shared/network/local/observer.dart';
import 'shared/network/local/storage_pref.dart';
import 'shared/network/remot/dio_helper.dart';
import 'shared/style/style.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StoragePref.getInstance();
  SallaDioHelper.initialDio();
  Bloc.observer = MyBlocObserver();
  String _routName = SallaBoarding.BOARDING_SCREEN;
  bool status = StoragePref.getValue('seeBoarding');
  // StoragePref.removeValue('token');
  token = StoragePref.getValue('token');
  language = StoragePref.getValue('lang') ?? 'en';
  isDark = StoragePref.getValue('isDark') ?? false;
  print('token: ${token.toString()}');
  if (status == true) {
    if (token != null) {
      _routName = NavigationBar.NAVIGATION_BAR_SCREEN;
    } else {
      _routName = SignIn.SIGN_IN_SCREEN;
    }
  } else {
    _routName = SallaBoarding.BOARDING_SCREEN;
  }

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<SettingCubit>(
          create: (context) => SettingCubit()..getUserInfo(),
        ),
        BlocProvider<ProductCubit>(
          create: (context) => ProductCubit()
            ..getCategory()
            ..getHomeProductData()
            ..getFavoriteData()
            ..getCartData(),
        ),
        BlocProvider<LoginCubit>(
          create: (BuildContext context) => LoginCubit(),
        ),
        BlocProvider<NavigationCubit>(
          create: (BuildContext context) => NavigationCubit(),
        ),
        BlocProvider<ItemDetailsCubit>(
          create: (BuildContext context) => ItemDetailsCubit(),
        ),
      ],
      child: MyApp(_routName),
    ),
  );
}

class MyApp extends StatelessWidget {
  final String _routeName;

  MyApp(this._routeName);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: _routeName,
      routes: {
        SallaBoarding.BOARDING_SCREEN: (_) => SallaBoarding(),
        SignIn.SIGN_IN_SCREEN: (_) => SignIn(),
        SignUp.SIGN_UP_SCREEN: (_) => SignUp(),
        NavigationBar.NAVIGATION_BAR_SCREEN: (_) => NavigationBar(),
        Product.PRODUCT_SCREEN: (_) => Product(),
        Category.CATEGORY_SCREEN: (_) => Category(),
        Favorite.FAVORITE_SCREEN: (_) => Favorite(),
        Setting.SETTING_SCREEN: (_) => Setting(),
        Cart.CART_SCREEN: (_) => Cart(),
        Search.SEARCH_SCREEN: (_) => Search(),
        // ItemDetails.ITEM_DETAILS_SCREEN: (_) => ItemDetails(),
        CategoryDetails.CATEGORY_SCREEN: (_) => CategoryDetails(),
        AddressDetails.ADDRESS_DETAILS: (_) => AddressDetails(),
        AddressScreen.ADDRESS_SCREEN: (_) => AddressScreen(),
      },
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      theme: themeLight,
      darkTheme: themeDark,
    );
  }
}

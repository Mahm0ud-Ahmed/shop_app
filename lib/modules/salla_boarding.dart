import 'package:flutter/material.dart';
import 'package:salla/modules/sign_in/sign_in.dart';
import 'package:salla/shared/component/components.dart';
import 'package:salla/shared/network/local/storage_pref.dart';
import 'package:salla/shared/style/colors.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class BoardingModel {
  final String title;
  final String discreption;
  final String image;

  BoardingModel({this.title, this.discreption, this.image});
}

class SallaBoarding extends StatefulWidget {
  static const String BOARDING_SCREEN = 'boarding';

  @override
  _SallaBoardingState createState() => _SallaBoardingState();
}

class _SallaBoardingState extends State<SallaBoarding> {
  PageController _pageController = PageController();

  List<BoardingModel> dataBoarding = [
    new BoardingModel(
      title: 'First Screen',
      discreption: 'First Screen First Screen First Screen',
      image: 'assets/images/undraw_add_to_cart_vkjp.png',
    ),
    new BoardingModel(
      title: 'Second Screen',
      discreption: 'Second Screen Second Screen',
      image: 'assets/images/undraw_shopping_app_flsj.png',
    ),
    new BoardingModel(
      title: 'Third Screen',
      discreption: 'Third Screen Third Screen Third Screen',
      image: 'assets/images/undraw_order_confirmed_re_g0if.png',
    ),
  ];

  bool seeBoard = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          TextButton(
              onPressed: () {
                seeBoard = true;
                StoragePref.setValue('seeBoarding', seeBoard).then(
                  (value) {
                    if (value) {
                      pushAndReplace(context, SignIn.SIGN_IN_SCREEN);
                    }
                  },
                );
              },
              child: Text(
                'SKIP',
                style: Theme.of(context).textTheme.headline6.copyWith(
                      color: colorAcc,
                    ),
              )),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemBuilder: (context, index) {
                  if (index == dataBoarding.length - 1)
                    seeBoard = true;
                  else
                    seeBoard = false;
                  return buildBoarding(context, dataBoarding[index]);
                },
                itemCount: dataBoarding.length,
                physics: BouncingScrollPhysics(),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Row(
              children: [
                SmoothPageIndicator(
                  controller: _pageController,
                  count: dataBoarding.length,
                  effect: ExpandingDotsEffect(
                    spacing: 5.0,
                    dotWidth: 10,
                    dotHeight: 10,
                    dotColor: Colors.grey,
                    // expansionFactor: 3,
                  ),
                ),
                Spacer(),
                FloatingActionButton(
                  onPressed: () {
                    if (!seeBoard) {
                      _pageController.nextPage(
                        duration: Duration(milliseconds: 750),
                        curve: Curves.fastLinearToSlowEaseIn,
                      );
                    } else {
                      StoragePref.setValue('seeBoarding', seeBoard)
                          .then((value) {
                        if (value) {
                          pushAndReplace(context, SignIn.SIGN_IN_SCREEN);
                        }
                      });
                    }
                  },
                  child: Icon(
                    Icons.arrow_forward_ios,
                    size: 20,
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildBoarding(BuildContext context, BoardingModel boardingModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image(
          image: AssetImage(boardingModel.image),
          fit: BoxFit.fill,
        ),
        SizedBox(
          height: 50,
        ),
        Text(
          boardingModel.title,
          style: Theme.of(context).textTheme.headline4,
        ),
        SizedBox(
          height: 25,
        ),
        Text(
          boardingModel.discreption,
          style: Theme.of(context).textTheme.headline6,
        ),
      ],
    );
  }
}

/*
    NAME         SIZE  WEIGHT  SPACING
/// headline1    96.0  light   -1.5
/// headline2    60.0  light   -0.5
/// headline3    48.0  regular  0.0
/// headline4    34.0  regular  0.25
/// headline5    24.0  regular  0.0
/// headline6    20.0  medium   0.15
/// subtitle1    16.0  regular  0.15
/// subtitle2    14.0  medium   0.1
/// body1        16.0  regular  0.5   (bodyText1)
/// body2        14.0  regular  0.25  (bodyText2)
/// button       14.0  medium   1.25
/// caption      12.0  regular  0.4
/// overline     10.0  regular  1.5
*/

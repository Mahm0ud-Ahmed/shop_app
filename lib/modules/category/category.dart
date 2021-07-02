import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salla/model/category_model.dart';
import 'package:salla/model/home_model.dart';
import 'package:salla/modules/product/cubit.dart';
import 'package:salla/modules/search/search.dart';
import 'package:salla/shared/component/components.dart';
import 'package:salla/shared/network/local/salla_States.dart';
import 'package:salla/shared/style/colors.dart';

class Category extends StatelessWidget {
  static const String CATEGORY_SCREEN = 'home_layout';

  @override
  Widget build(BuildContext context) {
    HomeModel model;
    CategoryModel categoryModel;
    return BlocConsumer<ProductCubit, SallaStates>(
      listener: (BuildContext context, state) {},
      builder: (BuildContext context, state) {
        model = ProductCubit.get(context).homeModel;
        categoryModel = ProductCubit.get(context).categoryModel;
        // print('Mooooooooooodel ${model.data.products[0].name}');
        return Scaffold(
          appBar: AppBar(
            title: Text('Salla'),
            actions: [
              IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    pushInStack(context, Search.SEARCH_SCREEN);
                  }),
            ],
          ),
          body: categoryModel != null && model != null
              ? SafeArea(
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                          child: Text(
                            'Banners',
                            style: Theme.of(context).textTheme.headline4,
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          height: MediaQuery.of(context).orientation ==
                                  Orientation.portrait
                              ? MediaQuery.of(context).size.height / 4
                              : MediaQuery.of(context).size.height * 0.45,
                          child: CarouselSlider.builder(
                            itemCount: model.data.banners.length,
                            itemBuilder: (context, index, _) =>
                                CachedNetworkImage(
                              imageUrl:
                                  model.data.banners[index].image.toString(),
                              width: double.infinity,
                              fit: BoxFit.fill,
                              placeholder: (context, url) =>
                                  Center(child: CircularProgressIndicator()),
                            ),
                            options: CarouselOptions(
                              autoPlay: true,
                              enableInfiniteScroll: true,
                              height: double.infinity,
                              initialPage: 0,
                              viewportFraction: 1,
                            ),
                          ),
                        ),
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                          child: Text(
                            'Category',
                            style: Theme.of(context).textTheme.headline4,
                          ),
                        ),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) {
                            return buildItem(
                                context, categoryModel.data.data[index]);
                          },
                          gridDelegate:
                              SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 140,
                            childAspectRatio: 2.5 / 3.24,
                          ),
                          itemCount: categoryModel.data.data.length,
                        ),
                        SizedBox(
                          height: 25,
                        ),
                      ],
                    ),
                  ),
                )
              : Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  Widget buildItem(context, CategoryData model) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(20),
          width: 100,
          height: 100,
          decoration: BoxDecoration(
              // borderRadius: BorderRadius.circular(150),
              shape: BoxShape.circle,
              border: Border.all(width: 4.0, color: colorPrim)),
          child: CircleAvatar(
            maxRadius: 100,
            child: CachedNetworkImage(
              imageUrl: model.image.toString(),
              width: double.infinity,
              fit: BoxFit.cover,
              placeholder: (context, url) =>
                  Center(child: CircularProgressIndicator()),
            ),
            backgroundColor: Colors.white,
          ),
        ),
        Text(
          model.name,
          style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 16),
          textAlign: TextAlign.center,
        )
      ],
    );
  }
}

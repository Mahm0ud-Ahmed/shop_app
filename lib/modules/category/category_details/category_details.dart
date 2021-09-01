import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salla/model/category_details_model.dart';
import 'package:salla/model/category_model.dart';
import 'package:salla/model/home_model.dart';
import 'package:salla/modules/item_details/item_details.dart';
import 'package:salla/modules/product/cubit.dart';
import 'package:salla/modules/product/product_states.dart';
import 'package:salla/modules/search/search.dart';
import 'package:salla/shared/component/components.dart';
import 'package:salla/shared/network/local/salla_States.dart';
import 'package:salla/shared/style/colors.dart';

class CategoryDetails extends StatelessWidget {
  static const String CATEGORY_SCREEN = 'category_details';
  CategoryDetailsModel category;

  CategoryDetails({this.category});

  // category.data.products.clear();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProductCubit, SallaStates>(
      listener: (BuildContext context, state) {
        if (state is SuccessCategoryDetailsState) {
          category = ProductCubit.get(context).categoryDetails;
        }
      },
      builder: (BuildContext context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Salla'),
          ),
          body: state is! LoadingCategoryDetailsState
              ? category.data.products.isNotEmpty
                  ? GridView.builder(
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        return customGridItem(
                          context: context,
                          image: category.data.products[index].image,
                          nameProduct: category.data.products[index].name,
                          price: category.data.products[index].price,
                          oldPrice: category.data.products[index].oldPrice,
                          discount: category.data.products[index].discount,
                          favoriteIcon:
                              ProductCubit.get(context).favoriteCategoryDetails[
                                      category.data.products[index].productId]
                                  ? Icon(
                                      Icons.favorite,
                                      color: Colors.red,
                                    )
                                  : Icon(
                                      Icons.favorite_border,
                                      color: Colors.grey,
                                    ),
                          isCart: ProductCubit.get(context).cartCategoryDetails[
                              category.data.products[index].productId],
                          addCart: () {
                            ProductCubit.get(context).addOrRemoveCart(
                                ProductCubit.get(context).cartCategoryDetails,
                                category.data.products[index].productId);
                          },
                          addFavorite: () {
                            ProductCubit.get(context).addOrRemoveFavorite(
                                ProductCubit.get(context)
                                    .favoriteCategoryDetails,
                                category.data.products[index].productId);
                          },
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) {
                                return ItemDetails(
                                  id: category.data.products[index].productId,
                                );
                              }),
                            );
                          },
                          showAddCart: true,
                        );
                      },
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 200,
                        childAspectRatio: 2 / 3.10,
                      ),
                      itemCount: category.data.products.isNotEmpty
                          ? category.data.products.length
                          : 0,
                    )
                  : Center(
                      child: Text(
                      'Data Not Found',
                      style: Theme.of(context).textTheme.headline4,
                    ))
              : Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}

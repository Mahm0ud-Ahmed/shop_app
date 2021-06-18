import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salla/model/favorite_model.dart';
import 'package:salla/model/favorite_state_model.dart';
import 'package:salla/modules/favorits/favorite_states.dart';
import 'package:salla/modules/product/cubit.dart';
import 'package:salla/shared/component/components.dart';
import 'package:salla/shared/network/local/salla_States.dart';

class Favorite extends StatelessWidget {
  static const String FAVORITE_SCREEN = 'fav_layout';

  @override
  Widget build(BuildContext context) {
    FavoriteModel favoriteModel;
    FavoriteStateModel favoriteStateModel;
    return BlocConsumer<ProductCubit, SallaStates>(
      listener: (BuildContext context, state) {
        if (state is ChangeFavoriteState) {
          favoriteStateModel = ProductCubit.get(context).favoriteStateModel;
          if (favoriteStateModel != null) {
            Flushbar(
              title: 'Alert!',
              message: favoriteStateModel.message,
              duration: Duration(seconds: 3),
            )..show(context);
          }
        }
      },
      builder: (BuildContext context, state) {
        favoriteModel = ProductCubit.get(context).favoriteModel;

        return Scaffold(
          appBar: AppBar(
            title: Text('Salla'),
            centerTitle: true,
          ),
          body: favoriteModel != null
              ? GridView.builder(
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    return customItem(
                      context: context,
                      image:
                          favoriteModel.data.products[index].productInfo.image,
                      nameProduct:
                          favoriteModel.data.products[index].productInfo.name,
                      price:
                          favoriteModel.data.products[index].productInfo.price,
                      oldPrice: favoriteModel
                          .data.products[index].productInfo.oldPrice,
                      discount: favoriteModel
                          .data.products[index].productInfo.discount,
                      favoriteIcon: ProductCubit.get(context).favoriteProduct[
                              favoriteModel.data.products[index].productInfo.id]
                          ? Icon(
                              Icons.favorite,
                              color: Colors.red,
                            )
                          : Icon(
                              Icons.favorite_border,
                              color: Colors.grey,
                            ),
                      addCart: () {
                        ProductCubit.get(context).addOrRemoveCart(
                            favoriteModel.data.products[index].productInfo.id);
                      },
                      addFavorite: () {
                        ProductCubit.get(context).addOrRemoveFavorite(
                            favoriteModel.data.products[index].productInfo.id);
                      },
                      isCart: ProductCubit.get(context).cartProduct[
                          favoriteModel.data.products[index].productInfo.id],
                    );
                  },
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200,
                    childAspectRatio: 2 / 3.10,
                  ),
                  itemCount: favoriteModel.data.products.length,
                )
              : Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}

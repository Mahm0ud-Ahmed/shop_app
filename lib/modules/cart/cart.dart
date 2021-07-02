import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salla/model/cart_model.dart';
import 'package:salla/model/favorite_state_model.dart';
import 'package:salla/modules/favorits/favorite_states.dart';
import 'package:salla/modules/item_details/item_details.dart';
import 'package:salla/modules/product/cubit.dart';
import 'package:salla/shared/component/components.dart';
import 'package:salla/shared/network/local/salla_States.dart';

class Cart extends StatelessWidget {
  static const String CART_SCREEN = 'cart_layout';

  @override
  Widget build(BuildContext context) {
    CartModel cartModel;
    return BlocConsumer<ProductCubit, SallaStates>(
      listener: (BuildContext context, state) {
/*        if (state is ChangeFavoriteState) {
          favoriteStateModel = ProductCubit.get(context).favoriteStateModel;
          if (favoriteStateModel != null) {
            Flushbar(
              title: 'Alert!',
              message: favoriteStateModel.message,
              duration: Duration(seconds: 3),
            )..show(context);
          }
        }*/
      },
      builder: (BuildContext context, state) {
        cartModel = ProductCubit.get(context).cartModel;
        return Scaffold(
          appBar: AppBar(
            title: Text('Salla'),
            centerTitle: true,
          ),
          body: ProductCubit.get(context).cartModel != null
              ? GridView.builder(
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    return customItem(
                      context: context,
                      image: cartModel
                          .data.productsCart[index].productCartInfo.image,
                      nameProduct: cartModel
                          .data.productsCart[index].productCartInfo.name,
                      price: cartModel
                          .data.productsCart[index].productCartInfo.price,
                      oldPrice: cartModel
                          .data.productsCart[index].productCartInfo.oldPrice,
                      discount: cartModel
                          .data.productsCart[index].productCartInfo.discount,
                      favoriteIcon: ProductCubit.get(context).favoriteProduct[
                              cartModel
                                  .data.productsCart[index].productCartInfo.id]
                          ? Icon(
                              Icons.favorite,
                              color: Colors.red,
                            )
                          : Icon(
                              Icons.favorite_border,
                              color: Colors.grey,
                            ),
                      addCart: () {
                        ProductCubit.get(context).addOrRemoveCart(cartModel
                            .data.productsCart[index].productCartInfo.id);
                      },
                      addFavorite: () {
                        ProductCubit.get(context).addOrRemoveFavorite(cartModel
                            .data.productsCart[index].productCartInfo.id);
                      },
                      isCart: ProductCubit.get(context).cartProduct[cartModel
                          .data.productsCart[index].productCartInfo.id],
                      onPressed: () {
                        Navigator.of(context).pushNamed(
                          ItemDetails.ITEM_DETAILS_SCREEN,
                          arguments: cartModel
                              .data.productsCart[index].productCartInfo,
                        );
                      },
                    );
                  },
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200,
                    childAspectRatio: 2 / 3.10,
                  ),
                  itemCount: cartModel.data.productsCart.length,
                )
              : Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}

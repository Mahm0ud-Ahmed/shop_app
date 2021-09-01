import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salla/model/cart_model.dart';
import 'package:salla/model/favorite_state_model.dart';
import 'package:salla/model/home_model.dart';
import 'package:salla/modules/cart/cart.dart';
import 'package:salla/modules/favorits/favorite_states.dart';
import 'package:salla/modules/item_details/item_details.dart';
import 'package:salla/modules/product/cubit.dart';
import 'package:salla/shared/component/components.dart';
import 'package:salla/shared/network/local/salla_States.dart';
import 'package:salla/shared/style/colors.dart';

class Product extends StatefulWidget {
  static const String PRODUCT_SCREEN = 'product_layout';

  @override
  _ProductState createState() => _ProductState();
}

class _ProductState extends State<Product> {
  @override
  void initState() {
    super.initState();
    ProductCubit.get(context).getHomeProductData();
  }

  @override
  Widget build(BuildContext context) {
    HomeModel homeModel;
    CartModel cartModel;
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
        homeModel = ProductCubit.get(context).homeModel;
        cartModel = ProductCubit.get(context).cartModel;
        // print('hoooooooooooooooooome ${homeModel.data.products[0].name}');
        return Scaffold(
          appBar: AppBar(
            title: Text('Salla'),
            centerTitle: true,
            actions: [
              Stack(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.shopping_cart_outlined,
                      color: colorAcc,
                      size: 30,
                    ),
                    onPressed: () {
                      pushInStack(context, Cart.CART_SCREEN);
                    },
                  ),
                  if (cartModel != null)
                    Positioned(
                      top: 1,
                      right: 4,
                      child: cartModel.data.productsCart.length > 0
                          ? Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.red,
                              ),
                              child: Text(
                                cartModel.data.productsCart.length.toString(),
                                style: TextStyle(height: 1.5),
                                textAlign: TextAlign.center,
                              ),
                            )
                          : Container(),
                    ),
                ],
              ),
            ],
          ),
          body: ProductCubit.get(context).homeModel != null
              ? GridView.builder(
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    return customGridItem(
                      context: context,
                      image: homeModel.data.products[index].image,
                      nameProduct: homeModel.data.products[index].name,
                      price: homeModel.data.products[index].price,
                      oldPrice: homeModel.data.products[index].oldPrice,
                      discount: homeModel.data.products[index].discount,
                      favoriteIcon:
                          ProductCubit.get(context).favoriteHomeProduct[
                                  homeModel.data.products[index].productId]
                              ? Icon(
                                  Icons.favorite,
                                  color: Colors.red,
                                )
                              : Icon(
                                  Icons.favorite_border,
                                  color: Colors.grey,
                                ),
                      isCart: ProductCubit.get(context).cartHomeProduct[
                          homeModel.data.products[index].productId],
                      addCart: () {
                        ProductCubit.get(context).addOrRemoveCart(
                            ProductCubit.get(context).cartHomeProduct,
                            homeModel.data.products[index].productId);
                      },
                      addFavorite: () {
                        ProductCubit.get(context).addOrRemoveFavorite(
                            ProductCubit.get(context).favoriteHomeProduct,
                            homeModel.data.products[index].productId);
                      },
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) {
                            return ItemDetails(
                              id: homeModel.data.products[index].productId,
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
                  itemCount: homeModel.data.products.length,
                  /*crossAxisCount: 2,
                  childAspectRatio: 2 / 4,
                  children: List.generate(
                    homeModel.data.products.length,
                    (index) =>
                        buildItem(context, homeModel.data.products[index]),
                  ),*/
                )
              : Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salla/model/cart_model.dart';
import 'package:salla/model/home_model.dart';
import 'package:salla/modules/item_details/item_details.dart';
import 'package:salla/modules/product/cubit.dart';
import 'package:salla/shared/network/local/salla_States.dart';
import 'package:salla/shared/style/colors.dart';

class Cart extends StatefulWidget {
  static const String CART_SCREEN = 'cart_layout';

  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  ProductCubit cubit;
  @override
  void initState() {
    super.initState();
    cubit = ProductCubit.get(context)..getCartData();
  }

  @override
  Widget build(BuildContext context) {
    ProductModel product;
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
        // print(cubit.quantity);

        return Scaffold(
          appBar: AppBar(
            title: Text('Salla'),
            centerTitle: true,
          ),
          body: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    product =
                        cartModel.data.productsCart[index].productCartInfo;
                    // print(cartModel.data.productsCart[index].cartId);
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) {
                              return ItemDetails(
                                id: product.productId,
                              );
                            },
                          ),
                        );
                      },
                      child: Card(
                        margin:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        elevation: 3,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 3, vertical: 12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 1,
                                child: Column(
                                  children: [
                                    SizedBox(
                                      child: CachedNetworkImage(
                                        imageUrl: product.image,
                                        placeholder: (context, url) => Center(
                                            child: CircularProgressIndicator()),
                                      ),
                                      height: 60,
                                    ),
                                    if (product.discount != 0)
                                      Container(
                                        child: Text(
                                          'Sale: ${product.discount} %',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                        padding:
                                            EdgeInsets.symmetric(horizontal: 6),
                                      ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 12,
                              ),
                              Expanded(
                                child: Column(
                                  children: [
                                    Text(
                                      product.name,
                                      style: TextStyle(
                                        height: 1.2,
                                      ),
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          ('${product.price.toString()} EGP'),
                                          style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            color: colorPrim,
                                          ),
                                        ),
                                        Spacer(),
                                        if (product.discount != 0)
                                          Text(
                                            '${product.oldPrice} EGP',
                                            style: TextStyle(
                                              decoration:
                                                  TextDecoration.lineThrough,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        Spacer(),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Spacer(),
                                        IconButton(
                                          onPressed: () {
                                            cubit
                                                .quantityDecrement(cartModel
                                                    .data
                                                    .productsCart[index]
                                                    .cartId)
                                                .then((value) {
                                              if (value) cubit.getCartData();
                                            });
                                          },
                                          icon:
                                              Icon(Icons.remove_circle_outline),
                                          padding: EdgeInsets.zero,
                                        ),
                                        Text(
                                          cubit.quantity[cartModel.data
                                                  .productsCart[index].cartId]
                                              .toString(),
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            cubit
                                                .quantityIncrement(cartModel
                                                    .data
                                                    .productsCart[index]
                                                    .cartId)
                                                .then((value) {
                                              if (value) cubit.getCartData();
                                            });
                                          },
                                          icon: Icon(Icons.add_circle_outline),
                                          padding: EdgeInsets.zero,
                                        ),
                                        Spacer(),
                                        IconButton(
                                          onPressed: () {
                                            ProductCubit.get(context)
                                                .addOrRemoveCart(
                                                    ProductCubit.get(context)
                                                        .cartScreenProduct,
                                                    cartModel
                                                        .data
                                                        .productsCart[index]
                                                        .productCartInfo
                                                        .productId);
                                          },
                                          icon: Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                          ),
                                          padding: EdgeInsets.zero,
                                        ),
                                      ],
                                    ),
                                  ],
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                ),
                                flex: 3,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  itemCount: cartModel.data.productsCart.length,
                ),
              ),
              if (cartModel.data.productsCart.length > 0)
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 6),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                      topLeft: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Initial Price: \t\t ${cartModel.data.total} EGP',
                        style: Theme.of(context).textTheme.headline6.copyWith(
                              color: Colors.black,
                              fontWeight: FontWeight.normal,
                            ),
                      ),
                      MaterialButton(
                        minWidth: double.infinity,
                        child: Text(
                          'Continue Buy',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                        color: Colors.green.shade400,
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

/*Scaffold(
          appBar: AppBar(
            title: Text('Salla'),
            centerTitle: true,
          ),
          body: ProductCubit.get(context).cartModel != null
              ? GridView.builder(
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    return customGridItem(
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
                      favoriteIcon:
                          ProductCubit.get(context).favoriteCartScreen[cartModel
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
                        ProductCubit.get(context).addOrRemoveCart(
                            ProductCubit.get(context).cartScreenProduct,
                            cartModel
                                .data.productsCart[index].productCartInfo.id);
                      },
                      addFavorite: () {
                        ProductCubit.get(context).addOrRemoveFavorite(
                            ProductCubit.get(context).favoriteHomeProduct,
                            cartModel
                                .data.productsCart[index].productCartInfo.id);
                      },
                      isCart: ProductCubit.get(context).cartScreenProduct[
                          cartModel
                              .data.productsCart[index].productCartInfo.id],
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) {
                            return ItemDetails(
                              id: cartModel
                                  .data.productsCart[index].productCartInfo.id,
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
                  itemCount: cartModel.data.productsCart.length,
                )
              : Center(child: CircularProgressIndicator()),
        );*/

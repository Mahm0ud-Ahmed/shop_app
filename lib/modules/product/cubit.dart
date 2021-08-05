import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salla/model/cart_model.dart';
import 'package:salla/model/cart_state_model.dart';
import 'package:salla/model/category_details_model.dart';
import 'package:salla/model/category_model.dart';
import 'package:salla/model/favorite_model.dart';
import 'package:salla/model/favorite_state_model.dart';
import 'package:salla/model/home_model.dart';
import 'package:salla/modules/cart/cart_states.dart';
import 'package:salla/modules/favorits/favorite_states.dart';
import 'package:salla/modules/product/product_states.dart';
import 'package:salla/shared/component/constants.dart';
import 'package:salla/shared/network/local/salla_States.dart';
import 'package:salla/shared/network/remot/dio_helper.dart';

class ProductCubit extends Cubit<SallaStates> {
  ProductCubit() : super(InitialProductState());

  static ProductCubit get(context) => BlocProvider.of<ProductCubit>(context);

  HomeModel homeModel;

  CategoryDetailsModel categoryDetails;
  CategoryModel categoryModel;

  FavoriteModel favoriteModel;
  FavoriteStateModel favoriteStateModel;

  CartStateModel cartStateModel;
  CartModel cartModel;

  Map<dynamic, bool> favoriteHomeProduct = {};
  Map<dynamic, bool> favoriteScreenProduct = {};
  Map<dynamic, bool> favoriteCategoryDetails = {};
  Map<dynamic, bool> favoriteCartScreen = {};

  Map<dynamic, bool> cartHomeProduct = {};
  Map<dynamic, bool> cartScreenProduct = {};
  Map<dynamic, bool> cartCategoryDetails = {};

  void getHomeProductData() {
    emit(LoadingProductState());
    SallaDioHelper.getData(endPointUrl: END_POINT_HOME, token: token)
        .then((value) {
      homeModel = HomeModel.fromJson(value.data);
      // extractFavoriteAndCartFromProducts(homeModel);
      homeModel.data.products.forEach((element) {
        favoriteHomeProduct.addAll({element.id: element.inFavorites});
      });
      homeModel.data.products.forEach((element) {
        cartHomeProduct.addAll({element.id: element.inCart});
        // print(homeModel.data.products[0].name);
      });
      emit(SuccessProductState());
    }).catchError((error) {
      emit(ErrorProductState());
      print(error.toString());
    });
  }

  void getCategory() {
    emit(LoadingCategoryState());
    SallaDioHelper.getData(endPointUrl: END_POINT_CATEGORY).then((value) {
      categoryModel = CategoryModel.fromJson(value.data);
      // print(categoryModel.data.data[0].id);

      emit(SuccessCategoryState());
    }).catchError((error) {
      emit(ErrorCategoryState());
      print(error.toString());
    });
  }

  void getFavoriteData() {
    emit(LoadingFavoriteState());
    SallaDioHelper.getData(endPointUrl: END_POINT_FAVORITE, token: token)
        .then((value) {
      favoriteModel = FavoriteModel.fromJson(value.data);
      favoriteModel.data.products.forEach((element) {
        favoriteScreenProduct.addAll({element.productInfo.id: true});
      });
      // print(favoriteModel.data.products[0].productInfo.discount);
      emit(SuccessFavoriteState());
    }).catchError((error) {
      print(error.toString());
      emit(ErrorFavoriteState());
    });
  }

  void changeStateFavItem(Map<dynamic, bool> favorite, int id) {
    favorite[id] = !favorite[id];
  }

  void addOrRemoveFavorite(Map<dynamic, bool> favorite, int modelId) {
    changeStateFavItem(favorite, modelId);
    emit(SuccessProductState());
    SallaDioHelper.postData(
            endPointUrl: END_POINT_FAVORITE,
            data: {'product_id': modelId},
            token: token)
        .then((value) {
      favoriteStateModel = FavoriteStateModel.fromJson(value.data);
      emit(ChangeFavoriteState());
      if (!favoriteStateModel.status) {
        changeStateFavItem(favorite, modelId);
        emit(SuccessFavoriteState());
      } else {
        getFavoriteData();
      }
    }).catchError((error) {
      changeStateFavItem(favorite, modelId);
      print(error.toString());
      emit(ErrorFavoriteState());
    });
  }

  void getCartData() {
    emit(LoadingCartState());
    SallaDioHelper.getData(endPointUrl: END_POINT_CART, token: token)
        .then((value) {
      cartModel = CartModel.fromJson(value.data);
      cartModel.data.productsCart.forEach((element) {
        favoriteCartScreen.addAll(
            {element.productCartInfo.id: element.productCartInfo.inFavorites});
      });
      cartModel.data.productsCart.forEach((element) {
        cartScreenProduct.addAll(
            {element.productCartInfo.id: element.productCartInfo.inCart});
      });
      // print(cartModel.data.productsCart[0].productCartInfo.price);
      emit(SuccessCartState());
    }).catchError((error) {
      print(error.toString());
      emit(ErrorCartState());
    });
  }

  void changeStateCartItem(Map<dynamic, bool> cart, int id) {
    cart[id] = !cart[id];
  }

  void addOrRemoveCart(Map<dynamic, bool> cart, int modelId) {
    changeStateCartItem(cart, modelId);
    emit(SuccessProductState());
    SallaDioHelper.postData(
            endPointUrl: END_POINT_CART,
            data: {'product_id': modelId},
            token: token)
        .then((value) {
      cartStateModel = CartStateModel.fromJson(value.data);
      emit(ChangeCartState());
      if (!cartStateModel.status) {
        changeStateCartItem(cart, modelId);
        emit(SuccessCartState());
      } else {
        getCartData();
      }
    }).catchError((error) {
      changeStateCartItem(cart, modelId);
      print(error.toString());
      emit(ErrorCartState());
    });
  }

  getCategoryDetails({@required int categoryId}) {
    emit(LoadingCategoryDetailsState());
    // categoryDetails.data.products.clear();
    String endPoint = END_POINT_CATEGORY + categoryId.toString();
    SallaDioHelper.getData(endPointUrl: endPoint, token: token).then((value) {
      if (value != null) {
        // print(value.data);
        categoryDetails = CategoryDetailsModel.fromJson(value.data);
        categoryDetails.data.products.forEach((element) {
          favoriteCategoryDetails.addAll({element.id: element.inFavorites});
        });
        categoryDetails.data.products.forEach((element) {
          cartCategoryDetails.addAll({element.id: element.inCart});
        });
        emit(SuccessCategoryDetailsState());
      }
    }).catchError((error) {
      print(error.toString());
      emit(ErrorCategoryDetailsState());
    });
  }

/*extractFavoriteAndCartFromProducts(allProduct) {
    if (allProduct != null) {
      allProduct.data.products.forEach((element) {
        // print(element.id);
        favoriteCategoryDetails.addAll({element.id: element.inFavorites});
        favoriteHomeProduct.addAll({element.id: element.inFavorites});
        cartProduct.add({element.id: element.inCart});
      });
      print(favoriteCategoryDetails.length);
    }
  }*/

}

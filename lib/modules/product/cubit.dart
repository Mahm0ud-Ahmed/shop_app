import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salla/model/cart_model.dart';
import 'package:salla/model/cart_state_model.dart';
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

  CategoryModel categoryModel;

  FavoriteModel favoriteModel;
  FavoriteStateModel favoriteStateModel;
  Map<dynamic, bool> favoriteProduct = {};

  CartModel cartModel;
  CartStateModel cartStateModel;
  Map<dynamic, bool> cartProduct = {};

  void getProductData() {
    emit(LoadingProductState());
    SallaDioHelper.getData(endPointUrl: END_POINT_HOME, token: token)
        .then((value) {
      homeModel = HomeModel.fromJson(value.data);
      homeModel.data.products.forEach((element) {
        favoriteProduct.addAll({element.id: element.inFavorites});
      });
      homeModel.data.products.forEach((element) {
        cartProduct.addAll({element.id: element.inCart});
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
      // print(favoriteModel.data.products[0].productInfo.discount);
      emit(SuccessFavoriteState());
    }).catchError((error) {
      print(error.toString());
      emit(ErrorFavoriteState());
    });
  }

  void changeStateFavItem(int id) {
    favoriteProduct[id] = !favoriteProduct[id];
  }

  void addOrRemoveFavorite(int modelId) {
    changeStateFavItem(modelId);
    emit(SuccessProductState());
    SallaDioHelper.postData(
            endPointUrl: END_POINT_FAVORITE,
            data: {'product_id': modelId},
            token: token)
        .then((value) {
      favoriteStateModel = FavoriteStateModel.fromJson(value.data);
      emit(ChangeFavoriteState());
      if (!favoriteStateModel.status) {
        changeStateFavItem(modelId);
        emit(SuccessFavoriteState());
      } else {
        getFavoriteData();
      }
    }).catchError((error) {
      changeStateFavItem(modelId);
      print(error.toString());
      emit(ErrorFavoriteState());
    });
  }

  void getCartData() {
    emit(LoadingCartState());
    SallaDioHelper.getData(endPointUrl: END_POINT_CART, token: token)
        .then((value) {
      cartModel = CartModel.fromJson(value.data);
      // print(cartModel.data.productsCart[0].productCartInfo.price);

      emit(SuccessCartState());
    }).catchError((error) {
      print(error.toString());
      emit(ErrorCartState());
    });
  }

  void changeStateCartItem(int id) {
    cartProduct[id] = !cartProduct[id];
  }

  void addOrRemoveCart(int modelId) {
    changeStateCartItem(modelId);
    emit(SuccessProductState());
    SallaDioHelper.postData(
            endPointUrl: END_POINT_CART,
            data: {'product_id': modelId},
            token: token)
        .then((value) {
      cartStateModel = CartStateModel.fromJson(value.data);
      emit(ChangeCartState());
      if (!cartStateModel.status) {
        changeStateCartItem(modelId);
        emit(SuccessCartState());
      } else {
        getCartData();
      }
    }).catchError((error) {
      changeStateCartItem(modelId);
      print(error.toString());
      emit(ErrorCartState());
    });
  }
}

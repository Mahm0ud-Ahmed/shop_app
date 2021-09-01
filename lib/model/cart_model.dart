import 'package:salla/model/favorite_model.dart';
import 'package:salla/model/home_model.dart';

class CartModel {
  bool status;
  CartData data;

  CartModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = CartData.fromJson(json['data']);
  }
}

class CartData {
  List<Data> productsCart = [];
  dynamic total;

  CartData.fromJson(Map<String, dynamic> json) {
    json['cart_items'].forEach((element) {
      productsCart.add(Data.fromJson(element));
    });
    total = json['total'];
  }
}

class Data {
  dynamic quantity;
  int cartId;
  ProductModel productCartInfo;

  Data.fromJson(Map<String, dynamic> json) {
    quantity = json['quantity'];
    cartId = json['id'];
    productCartInfo = ProductModel.fromJson(json['product']);
  }
}

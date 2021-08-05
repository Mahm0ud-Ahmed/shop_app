import 'package:salla/model/home_model.dart';

class CategoryDetailsModel {
  bool status;
  _CategoryData data;

  CategoryDetailsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = _CategoryData.fromJson(json['data']);
  }
}

class _CategoryData {
  List<ProductModel> products = [];

  _CategoryData.fromJson(Map<String, dynamic> json) {
    json['data'].forEach((element) {
      products.add(ProductModel.fromJson(element));
    });
  }
}

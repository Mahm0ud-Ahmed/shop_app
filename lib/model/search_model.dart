import 'package:salla/model/home_model.dart';

class SearchModel {
  bool status;
  SearchData data;

  SearchModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = SearchData.fromJson(json['data']);
  }
}

class SearchData {
  List<ProductModel> searchItemData = [];
  int total;

  SearchData.fromJson(Map<String, dynamic> json) {
    json['data'].forEach((item) {
      searchItemData.add(ProductModel.fromJson(item));
    });
    total = json['total'];
  }
}

/*class SearchItemData {
  ProductModel item;
  int id;
  dynamic price;
  String image;
  String name;
  String description;

  SearchItemData.fromJson(Map<String, dynamic> json) {
    item = ProductModel.fromJson(json);
    id = json['id'];
    price = json['price'];
    image = json['image'];
    name = json['name'];
    description = json['description'];
  }
}*/

class HomeModel {
  bool status;
  HomeData data;

  HomeModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = HomeData.fromJson(json['data']);
  }
}

class HomeData {
  List<BannersModel> banners = [];

  List<ProductModel> products = [];

  HomeData.fromJson(Map<String, dynamic> json) {
    json['banners'].forEach((element) {
      banners.add(BannersModel.fromJson(element));
    });

    json['products'].forEach((element) {
      products.add(ProductModel.fromJson(element));
    });
  }
}

class BannersModel {
  int id;
  String image;

  BannersModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
  }
}

class ProductModel {
  int id;
  dynamic price;
  dynamic oldPrice;
  dynamic discount;
  String image;
  String name;
  String description;
  List<String> images = [];
  bool inFavorites;
  bool inCart;

  ProductModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    price = json['price'];
    oldPrice = json['old_price'];
    discount = json['discount'];
    image = json['image'];
    name = json['name'];
    description = json['description'];
    json['images'].forEach((element) {
      images.add(element);
    });
    inFavorites = json['in_favorites'];
    inCart = json['in_cart'];
  }
}

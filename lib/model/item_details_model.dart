class ItemDetailsModel {
  bool status;
  String message;
  DataItemDetails data;

  ItemDetailsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = DataItemDetails.fromJson(json['data']);
  }
}

class DataItemDetails {
  int id;
  dynamic price;
  dynamic oldPrice;
  dynamic discount;
  String image;
  String name;
  String description;
  List<dynamic> images = [];
  bool inFavorites;
  bool inCart;

  DataItemDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    price = json['price'];
    oldPrice = json['old_price'];
    discount = json['discount'];
    image = json['image'];
    name = json['name'];
    description = json['description'];
    images = json['images'];
    inFavorites = json['in_favorites'];
    inCart = json['in_cart'];
  }
}

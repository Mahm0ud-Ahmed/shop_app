class CartStateModel {
  bool status;
  String message;
  CartStateModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
  }
}

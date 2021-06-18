class FavoriteStateModel {
  bool status;
  String message;
  FavoriteStateModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
  }
}

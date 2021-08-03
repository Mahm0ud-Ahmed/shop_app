class UserModel {
  bool status;
  String message;
  UserDataLogin dataLogin;
  UserDataRegister dataRegister;

  UserModel.fromJsonLogin(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    dataLogin =
        json['data'] != null ? UserDataLogin.fromJson(json['data']) : null;
  }

  UserModel.fromJsonRegister(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    dataRegister =
        json['data'] != null ? UserDataRegister.fromJson(json['data']) : null;
  }
}

class UserDataLogin {
  int id;
  String name;
  String email;
  String phone;
  String image;
  int points;
  double credit;
  String token;

  UserDataLogin.fromJson(Map<String, dynamic> data) {
    id = data['id'];
    name = data['name'];
    email = data['email'];
    phone = data['phone'];
    image = data['image'];
    points = data['points'];
    credit = data['credit'];
    token = data['token'];
  }
}

class UserDataRegister {
  int id;
  String name;
  String email;
  String phone;
  String image;
  String token;

  UserDataRegister.fromJson(Map<String, dynamic> data) {
    id = data['id'];
    name = data['name'];
    email = data['email'];
    phone = data['phone'];
    image = data['image'];
    token = data['token'];
  }
}

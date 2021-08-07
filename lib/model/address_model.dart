class AddressModel {
  bool status;
  String message;
  AddressData data;
  AddressModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = AddressData.fromJson(json['data']);
  }
}

class AddressData {
  List<Data> data = [];
  AddressData.fromJson(Map<String, dynamic> json) {
    // data = json['data'];
    json['data'].forEach((element) {
      data.add(Data.fromJson(element));
    });
  }
}

class Data {
  int id;
  String name;
  String city;
  String region;
  String details;
  String notes;
  double lat;
  double mag;

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    city = json['city'];
    region = json['region'];
    details = json['details'];
    notes = json['notes'];
    lat = json['latitude'];
    mag = json['longitude'];
  }
}

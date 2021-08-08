class AllAddress {
  bool status;
  String message;
  AddressData data;
  AllAddress.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = AddressData.fromJson(json['data']);
  }
}

class AddressData {
  List<AllAddressData> data = [];
  AddressData.fromJson(Map<String, dynamic> json) {
    json['data'].forEach((element) {
      data.add(AllAddressData.fromJson(element));
    });
  }
}

class AllAddressData {
  int id;
  String name;
  String city;
  String region;
  String details;
  String notes;
  double lat;
  double mag;

  AllAddressData.fromJson(Map<String, dynamic> json) {
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

class AddressUpdateAndDelete {
  bool status;
  String message;
  UpdateAndDeleteDataInfo data;

  AddressUpdateAndDelete.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = UpdateAndDeleteDataInfo.fromJson(json['data']);
  }
}

class UpdateAndDeleteDataInfo {
  int id;
  String name;
  String city;
  String region;
  String details;
  String notes;
  double lat;
  double mag;

  UpdateAndDeleteDataInfo.fromJson(Map<String, dynamic> json) {
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

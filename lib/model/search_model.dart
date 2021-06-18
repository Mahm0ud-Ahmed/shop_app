class SearchModel {
  bool status;
  SearchData data;

  SearchModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = SearchData.fromJson(json['data']);
  }
}

class SearchData {
  List<SearchItemData> searchItemData = [];
  int total;

  SearchData.fromJson(Map<String, dynamic> json) {
    json['data'].forEach((item) {
      searchItemData.add(SearchItemData.fromJson(item));
    });
    total = json['total'];
  }
}

class SearchItemData {
  int id;
  dynamic price;
  String image;
  String name;
  String description;

  SearchItemData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    price = json['price'];
    image = json['image'];
    name = json['name'];
    description = json['description'];
  }
}

class CategoryModel {
  bool status;
  CategoryList data;

  CategoryModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = CategoryList.fromJson(json['data']);
  }
}

class CategoryList {
  List<CategoryData> data = [];

  CategoryList.fromJson(Map<String, dynamic> json) {
    json['data'].forEach(
      (element) => data.add(CategoryData.fromJson(element)),
    );
  }
}

class CategoryData {
  int id;
  String name;
  String image;

  CategoryData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
  }
}

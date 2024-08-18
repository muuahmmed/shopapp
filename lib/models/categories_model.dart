class CategoriesModel {
  bool? status;
  CategoriesDataModel? data;

  CategoriesModel.fromJson(Map<String, dynamic> json) {
    status = json["status"];
    data = json["data"] != null ? CategoriesDataModel.fromJson(json["data"]) : null; // Check for null
  }
}

class CategoriesDataModel {
  int? currentPage;
  List<DataModel>? data;

  CategoriesDataModel.fromJson(Map<String, dynamic> json) {
    currentPage = json["current_page"];
    data = (json['data'] as List).map((e) => DataModel.fromJson(e)).toList();
  }
}


class DataModel {
  int? id;
  String? name;
  String? image;

  DataModel.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"];
    image = json["image"];
  }
}

